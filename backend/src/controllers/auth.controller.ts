import { Request, Response } from 'express';
import { db } from '../config/firebase';
import { AuthenticatedRequest } from '../middlewares/auth';

export const registerUser = async (req: Request, res: Response) => {
  const { firebaseUser, role, fullName, phone, ...extraDetails } = req.body;

  if (!firebaseUser) {
    return res.status(400).json({
      status: 'error',
      message: 'Invalid registration state: Firebase user token missing.'
    });
  }

  const { uid, email } = firebaseUser;

  if (!role || !['DONOR', 'PATIENT', 'HOSPITAL', 'ADMIN'].includes(role)) {
    return res.status(400).json({
      status: 'error',
      message: 'Invalid registration: Role must be DONOR, PATIENT, HOSPITAL, or ADMIN.'
    });
  }

  try {
    const userRef = db.collection('users').doc(uid);
    const userDoc = await userRef.get();

    if (userDoc.exists) {
      return res.status(409).json({
        status: 'error',
        message: 'Conflict: User record already registered.'
      });
    }

    
    const status = role === 'HOSPITAL' ? 'PENDING_VERIFICATION' : 'ACTIVE';

    
    await db.runTransaction(async (transaction) => {
      
      transaction.set(userRef, {
        id: uid,
        email: email,
        role: role,
        status: status,
        createdAt: new Date(),
        updatedAt: new Date()
      });

      
      if (role === 'DONOR') {
        const donorRef = db.collection('donors').doc(uid);
        transaction.set(donorRef, {
          id: uid,
          userId: uid,
          fullName: fullName || 'Anonymous Donor',
          phone: phone || '',
          bloodGroup: extraDetails.bloodGroup || 'O+',
          age: Number(extraDetails.age) || 18,
          gender: extraDetails.gender || 'Unknown',
          weight: Number(extraDetails.weight) || 60,
          city: extraDetails.city || '',
          latitude: Number(extraDetails.latitude) || 0.0,
          longitude: Number(extraDetails.longitude) || 0.0,
          medicalEligibility: true,
          lastDonationDate: null,
          availabilityStatus: true,
          profilePhoto: extraDetails.profilePhoto || '',
          donationCount: 0,
          nextEligibleDate: null
        });
      } else if (role === 'HOSPITAL') {
        const hospitalRef = db.collection('hospitals').doc(uid);
        transaction.set(hospitalRef, {
          id: uid,
          userId: uid,
          hospitalName: extraDetails.hospitalName || 'Unnamed Hospital',
          address: extraDetails.address || '',
          licenseNumber: extraDetails.licenseNumber || '',
          isVerified: false,
          phone: phone || '',
          latitude: Number(extraDetails.latitude) || 0.0,
          longitude: Number(extraDetails.longitude) || 0.0
        });
      } else if (role === 'PATIENT') {
        const patientRef = db.collection('patients').doc(uid);
        transaction.set(patientRef, {
          id: uid,
          userId: uid,
          fullName: fullName || 'Emergency Requester',
          phone: phone || '',
          address: extraDetails.address || '',
          latitude: Number(extraDetails.latitude) || 0.0,
          longitude: Number(extraDetails.longitude) || 0.0
        });
      } else if (role === 'ADMIN') {
        const adminRef = db.collection('admins').doc(uid);
        transaction.set(adminRef, {
          id: uid,
          userId: uid,
          fullName: fullName || 'System Administrator'
        });
      }
    });

    return res.status(201).json({
      status: 'success',
      message: 'User profile registered successfully.',
      data: {
        uid,
        email,
        role,
        status
      }
    });

  } catch (error: any) {
    console.error('Registration Transaction Failed:', error);
    return res.status(500).json({
      status: 'error',
      message: 'Failed to record user details. Transaction aborted.'
    });
  }
};

export const getMe = async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      status: 'error',
      message: 'Unauthorized: Session missing.'
    });
  }

  const { uid, role, email, status } = req.user;

  try {
    let roleDetails = {};
    
    
    if (role === 'DONOR') {
      const donorDoc = await db.collection('donors').doc(uid).get();
      roleDetails = donorDoc.exists ? donorDoc.data() || {} : {};
    } else if (role === 'HOSPITAL') {
      const hospitalDoc = await db.collection('hospitals').doc(uid).get();
      roleDetails = hospitalDoc.exists ? hospitalDoc.data() || {} : {};
    } else if (role === 'PATIENT') {
      const patientDoc = await db.collection('patients').doc(uid).get();
      roleDetails = patientDoc.exists ? patientDoc.data() || {} : {};
    } else if (role === 'ADMIN') {
      const adminDoc = await db.collection('admins').doc(uid).get();
      roleDetails = adminDoc.exists ? adminDoc.data() || {} : {};
    }

    return res.status(200).json({
      status: 'success',
      data: {
        uid,
        email,
        role,
        status,
        profile: roleDetails
      }
    });
  } catch (error: any) {
    console.error('Fetch Profile Details Failed:', error.message);
    return res.status(500).json({
      status: 'error',
      message: 'Failed to fetch user metadata.'
    });
  }
};

export const updateProfile = async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      status: 'error',
      message: 'Unauthorized: Session invalid.'
    });
  }

  const { uid, role } = req.user;
  const updateData = req.body;

  try {
    
    await db.collection('users').doc(uid).update({
      updatedAt: new Date()
    });

    if (role === 'DONOR') {
      
      const cleanUpdate: any = {};
      if (updateData.fullName) cleanUpdate.fullName = updateData.fullName;
      if (updateData.phone) cleanUpdate.phone = updateData.phone;
      if (updateData.age) cleanUpdate.age = Number(updateData.age);
      if (updateData.weight) cleanUpdate.weight = Number(updateData.weight);
      if (updateData.city) cleanUpdate.city = updateData.city;
      if (updateData.latitude) cleanUpdate.latitude = Number(updateData.latitude);
      if (updateData.longitude) cleanUpdate.longitude = Number(updateData.longitude);
      if (updateData.availabilityStatus !== undefined) {
        cleanUpdate.availabilityStatus = Boolean(updateData.availabilityStatus);
      }
      if (updateData.profilePhoto) cleanUpdate.profilePhoto = updateData.profilePhoto;

      await db.collection('donors').doc(uid).update(cleanUpdate);
    } else if (role === 'HOSPITAL') {
      const cleanUpdate: any = {};
      if (updateData.hospitalName) cleanUpdate.hospitalName = updateData.hospitalName;
      if (updateData.address) cleanUpdate.address = updateData.address;
      if (updateData.phone) cleanUpdate.phone = updateData.phone;
      if (updateData.latitude) cleanUpdate.latitude = Number(updateData.latitude);
      if (updateData.longitude) cleanUpdate.longitude = Number(updateData.longitude);

      await db.collection('hospitals').doc(uid).update(cleanUpdate);
    } else if (role === 'PATIENT') {
      const cleanUpdate: any = {};
      if (updateData.fullName) cleanUpdate.fullName = updateData.fullName;
      if (updateData.phone) cleanUpdate.phone = updateData.phone;
      if (updateData.address) cleanUpdate.address = updateData.address;
      if (updateData.latitude) cleanUpdate.latitude = Number(updateData.latitude);
      if (updateData.longitude) cleanUpdate.longitude = Number(updateData.longitude);

      await db.collection('patients').doc(uid).update(cleanUpdate);
    }

    return res.status(200).json({
      status: 'success',
      message: 'Profile updated successfully.'
    });
  } catch (error: any) {
    console.error('Update Profile Failed:', error.message);
    return res.status(500).json({
      status: 'error',
      message: 'Failed to update profile.'
    });
  }
};
