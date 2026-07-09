import { Response } from 'express';
import { db } from '../config/firebase';
import { AuthenticatedRequest } from '../middlewares/auth';


export const getMyDonorProfile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'DONOR') {
    res.status(403).json({
      status: 'error',
      message: 'Forbidden: User is not a registered blood donor.'
    });
    return;
  }

  const { uid } = req.user;

  try {
    const donorDoc = await db.collection('donors').doc(uid).get();
    if (!donorDoc.exists) {
      res.status(404).json({
        status: 'error',
        message: 'Donor profile record not found.'
      });
      return;
    }

    res.status(200).json({
      status: 'success',
      data: donorDoc.data()
    });
  } catch (error: any) {
    console.error('Fetch Donor Profile Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve donor profile.'
    });
  }
};


export const updateMyDonorProfile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'DONOR') {
    res.status(403).json({
      status: 'error',
      message: 'Forbidden: User is not a registered blood donor.'
    });
    return;
  }

  const { uid } = req.user;
  const updateData = req.body;

  try {
    const donorRef = db.collection('donors').doc(uid);
    const donorDoc = await donorRef.get();

    if (!donorDoc.exists) {
      res.status(404).json({
        status: 'error',
        message: 'Donor profile record not found.'
      });
      return;
    }

    const cleanUpdate: any = {};
    if (updateData.fullName) cleanUpdate.fullName = updateData.fullName;
    if (updateData.phone) cleanUpdate.phone = updateData.phone;
    if (updateData.age) cleanUpdate.age = Number(updateData.age);
    if (updateData.weight) cleanUpdate.weight = Number(updateData.weight);
    if (updateData.city) cleanUpdate.city = updateData.city;
    if (updateData.latitude) cleanUpdate.latitude = Number(updateData.latitude);
    if (updateData.longitude) cleanUpdate.longitude = Number(updateData.longitude);
    if (updateData.profilePhoto) cleanUpdate.profilePhoto = updateData.profilePhoto;
    
    if (updateData.availabilityStatus !== undefined) {
      cleanUpdate.availabilityStatus = Boolean(updateData.availabilityStatus);
    }

    
    if (updateData.lastDonationDate) {
      const lastDate = new Date(updateData.lastDonationDate);
      cleanUpdate.lastDonationDate = lastDate;
      
      
      const nextEligible = new Date(lastDate.getTime() + 90 * 24 * 60 * 60 * 1000);
      cleanUpdate.nextEligibleDate = nextEligible;

      
      const currentCount = donorDoc.data()?.donationCount || 0;
      cleanUpdate.donationCount = currentCount + 1;
    }

    await donorRef.update(cleanUpdate);

    
    const updatedDoc = await donorRef.get();

    res.status(200).json({
      status: 'success',
      message: 'Donor profile updated successfully.',
      data: updatedDoc.data()
    });
  } catch (error: any) {
    console.error('Update Donor Profile Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to update donor profile.'
    });
  }
};


export const evaluateEligibility = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'DONOR') {
    res.status(403).json({
      status: 'error',
      message: 'Forbidden: User is not a registered blood donor.'
    });
    return;
  }

  const { uid } = req.user;
  const { hasDiseases, hasTattoosRecent, hasTravelHistory, hasMedications } = req.body;

  try {
    const donorRef = db.collection('donors').doc(uid);
    const donorDoc = await donorRef.get();

    if (!donorDoc.exists) {
      res.status(404).json({
        status: 'error',
        message: 'Donor profile record not found.'
      });
      return;
    }

    const donorData = donorDoc.data()!;
    const age = donorData.age || 18;
    const weight = donorData.weight || 60;
    const nextEligibleDate = donorData.nextEligibleDate ? new Date(donorData.nextEligibleDate.toDate()) : null;

    const reasons: string[] = [];
    let eligible = true;

    
    if (age < 18 || age > 65) {
      eligible = false;
      reasons.push('Age must be between 18 and 65 years.');
    }
    if (weight < 50) {
      eligible = false;
      reasons.push('Weight must be at least 50 kg.');
    }
    if (hasDiseases) {
      eligible = false;
      reasons.push('Chronic medical conditions or infectious disease flags detected.');
    }
    if (hasTattoosRecent) {
      eligible = false;
      reasons.push('Tattoo or body piercing within the last 6 months.');
    }
    if (hasTravelHistory) {
      eligible = false;
      reasons.push('Recent travel to high-risk malaria/dengue regions.');
    }
    if (hasMedications) {
      eligible = false;
      reasons.push('Active heavy antibiotics or prescription medication cycles.');
    }
    if (nextEligibleDate && nextEligibleDate.getTime() > Date.now()) {
      eligible = false;
      const daysLeft = Math.ceil((nextEligibleDate.getTime() - Date.now()) / (24 * 60 * 60 * 1000));
      reasons.push(`Minimum 90-day cooldown period active. Eligible in ${daysLeft} days.`);
    }

    
    await donorRef.update({
      medicalEligibility: eligible,
      updatedAt: new Date()
    });

    res.status(200).json({
      status: 'success',
      data: {
        eligible,
        reasons,
        nextEligibleDate: nextEligibleDate ? nextEligibleDate.toISOString() : null
      }
    });
  } catch (error: any) {
    console.error('Eligibility Check Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to execute medical eligibility assessment.'
    });
  }
};


export const searchNearbyDonors = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  const { latitude, longitude, radius, bloodType } = req.query;

  if (!latitude || !longitude) {
    res.status(400).json({
      status: 'error',
      message: 'Missing latitude and longitude query parameters.'
    });
    return;
  }

  const userLat = Number(latitude);
  const userLon = Number(longitude);
  const searchRadius = Number(radius) || 10; 

  try {
    let query: any = db.collection('donors')
      .where('availabilityStatus', '==', true)
      .where('medicalEligibility', '==', true);

    if (bloodType) {
      query = query.where('bloodType', '==', bloodType);
    }

    const snapshot = await query.get();
    const matches: any[] = [];

    const R = 6371; 
    snapshot.forEach((doc: any) => {
      const data = doc.data();
      if (data.latitude !== undefined && data.longitude !== undefined) {
        const donorLat = Number(data.latitude);
        const donorLon = Number(data.longitude);

        const dLat = (donorLat - userLat) * Math.PI / 180;
        const dLon = (donorLon - userLon) * Math.PI / 180;
        const a = 
          Math.sin(dLat / 2) * Math.sin(dLat / 2) +
          Math.cos(userLat * Math.PI / 180) * Math.cos(donorLat * Math.PI / 180) *
          Math.sin(dLon / 2) * Math.sin(dLon / 2);
        
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        const distance = R * c; 

        if (distance <= searchRadius) {
          matches.push({
            id: doc.id,
            ...data,
            distance: Number(distance.toFixed(2)) 
          });
        }
      }
    });

    
    matches.sort((a, b) => a.distance - b.distance);

    res.status(200).json({
      status: 'success',
      data: matches
    });
  } catch (error: any) {
    console.error('Nearby Donor Search Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to search nearby blood donors.'
    });
  }
};

