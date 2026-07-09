import { Response } from 'express';
import { db } from '../config/firebase';
import { AuthenticatedRequest } from '../middlewares/auth';


export const getUsers = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'ADMIN') {
    res.status(403).json({ status: 'error', message: 'Forbidden: Admin access required.' });
    return;
  }

  try {
    const snapshot = await db.collection('users').get();
    const users: any[] = [];
    snapshot.forEach((doc: any) => {
      users.push({ id: doc.id, ...doc.data() });
    });

    res.status(200).json({
      status: 'success',
      data: users
    });
  } catch (error: any) {
    console.error('Fetch Admin Users Failed:', error.message);
    res.status(500).json({ status: 'error', message: 'Failed to fetch users.' });
  }
};


export const toggleUserSuspension = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'ADMIN') {
    res.status(403).json({ status: 'error', message: 'Forbidden: Admin access required.' });
    return;
  }

  const { id } = req.params;
  const { suspended } = req.body;

  if (suspended === undefined) {
    res.status(400).json({ status: 'error', message: 'Missing suspension status in body.' });
    return;
  }

  try {
    const userRef = db.collection('users').doc(id);
    const doc = await userRef.get();

    if (!doc.exists) {
      res.status(404).json({ status: 'error', message: 'User not found.' });
      return;
    }

    await userRef.update({
      isSuspended: !!suspended,
      updatedAt: new Date(),
    });

    res.status(200).json({
      status: 'success',
      message: `User suspension status updated to ${suspended}.`
    });
  } catch (error: any) {
    console.error('Toggle Suspension Failed:', error.message);
    res.status(500).json({ status: 'error', message: 'Failed to update suspension.' });
  }
};


export const verifyHospital = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'ADMIN') {
    res.status(403).json({ status: 'error', message: 'Forbidden: Admin access required.' });
    return;
  }

  const { id } = req.params;
  const { verified } = req.body;

  if (verified === undefined) {
    res.status(400).json({ status: 'error', message: 'Missing verification status in body.' });
    return;
  }

  try {
    const hospitalRef = db.collection('hospitals').doc(id);
    const doc = await hospitalRef.get();

    if (!doc.exists) {
      res.status(404).json({ status: 'error', message: 'Hospital not found.' });
      return;
    }

    await hospitalRef.update({
      isVerified: !!verified,
      updatedAt: new Date(),
    });

    
    const userRef = db.collection('users').doc(id);
    const userDoc = await userRef.get();
    if (userDoc.exists) {
      await userRef.update({
        isVerified: !!verified,
        updatedAt: new Date(),
      });
    }

    res.status(200).json({
      status: 'success',
      message: `Hospital verification status updated to ${verified}.`
    });
  } catch (error: any) {
    console.error('Verify Hospital Failed:', error.message);
    res.status(500).json({ status: 'error', message: 'Failed to verify hospital.' });
  }
};


export const broadcastAnnouncement = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'ADMIN') {
    res.status(403).json({ status: 'error', message: 'Forbidden: Admin access required.' });
    return;
  }

  const { message } = req.body;

  if (!message) {
    res.status(400).json({ status: 'error', message: 'Missing broadcast message.' });
    return;
  }

  try {
    
    const broadcastRef = await db.collection('broadcasts').add({
      message,
      senderId: req.user.uid,
      createdAt: new Date()
    });

    
    const io = req.app.get('io');
    if (io) {
      io.emit('system_broadcast', {
        id: broadcastRef.id,
        message,
        date: new Date().toISOString()
      });
    }

    res.status(200).json({
      status: 'success',
      message: 'System-wide notification broadcast successfully.'
    });
  } catch (error: any) {
    console.error('System Broadcast Failed:', error.message);
    res.status(500).json({ status: 'error', message: 'Failed to transmit broadcast.' });
  }
};
