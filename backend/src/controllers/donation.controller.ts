import { Response } from 'express';
import crypto from 'crypto';
import { db } from '../config/firebase';
import { AuthenticatedRequest } from '../middlewares/auth';


export const getMyDonations = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'DONOR') {
    res.status(403).json({
      status: 'error',
      message: 'Forbidden: Only donors can query donation histories.'
    });
    return;
  }

  const { uid } = req.user;

  try {
    const snapshot = await db.collection('donations')
      .where('donorId', '==', uid)
      .orderBy('date', 'desc')
      .get();

    const donations: any[] = [];
    snapshot.forEach((doc: any) => {
      donations.push({ id: doc.id, ...doc.data() });
    });

    res.status(200).json({
      status: 'success',
      data: donations
    });
  } catch (error: any) {
    console.error('Fetch Donations Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve donation history.'
    });
  }
};


export const logDonation = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || (req.user.role !== 'HOSPITAL' && req.user.role !== 'ADMIN')) {
    res.status(403).json({
      status: 'error',
      message: 'Forbidden: Only hospital facilities or administrators can log verified donations.'
    });
    return;
  }

  const { donorPhone, units, patientName, date } = req.body;
  const hospitalId = req.user.uid;

  if (!donorPhone || !units) {
    res.status(400).json({
      status: 'error',
      message: 'Missing donor contact or units properties.'
    });
    return;
  }

  try {
    
    const donorQuery = await db.collection('donors')
      .where('phone', '==', donorPhone.trim())
      .limit(1)
      .get();

    if (donorQuery.empty) {
      res.status(404).json({
        status: 'error',
        message: 'No registered blood donor found with specified phone number.'
      });
      return;
    }

    const donorDoc = donorQuery.docs[0];
    const donorId = donorDoc.id;
    const donorData = donorDoc.data();

    
    const hospitalDoc = await db.collection('hospitals').doc(hospitalId).get();
    const hospitalName = hospitalDoc.exists 
        ? (hospitalDoc.data()?.fullName || 'Affiliate Hospital') 
        : 'Affiliate Hospital';

    const donationDate = date ? new Date(date) : new Date();

    
    const signaturePayload = `${donorId}-${donationDate.getTime()}-${hospitalId}-${units}`;
    const certificateHash = crypto
      .createHash('sha256')
      .update(signaturePayload)
      .digest('hex')
      .substring(0, 16)
      .toUpperCase();

    const donationRecord = {
      donorId,
      donorName: donorData.fullName,
      bloodType: donorData.bloodGroup,
      units: Number(units),
      hospitalId,
      hospitalName,
      patientName: patientName || 'General Bank',
      date: donationDate,
      certificateCode: `CERT-SOS-${certificateHash}`,
      status: 'VERIFIED',
      createdAt: new Date(),
    };

    
    const docRef = await db.collection('donations').add(donationRecord);

    
    const nextEligible = new Date(donationDate.getTime() + 90 * 24 * 60 * 60 * 1000);
    const updatedCount = (donorData.donationCount || 0) + 1;

    await db.collection('donors').doc(donorId).update({
      lastDonationDate: donationDate,
      nextEligibleDate: nextEligible,
      donationCount: updatedCount,
      medicalEligibility: false, 
      updatedAt: new Date(),
    });

    res.status(201).json({
      status: 'success',
      message: 'Verified donation logged and certificate generated successfully.',
      data: {
        id: docRef.id,
        ...donationRecord,
        nextEligibleDate: nextEligible.toISOString()
      }
    });
  } catch (error: any) {
    console.error('Log Donation Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to record donation.'
    });
  }
};
