import { Response } from 'express';
import { db } from '../config/firebase';
import { AuthenticatedRequest } from '../middlewares/auth';
import { io } from '../index';


export const createBloodRequest = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user) {
    res.status(401).json({ status: 'error', message: 'Unauthorized' });
    return;
  }

  const { patientName, hospitalName, bloodType, unitsRequired, latitude, longitude, patientPhone, urgency } = req.body;
  const createdById = req.user.uid;

  if (!patientName || !hospitalName || !bloodType || !unitsRequired || !latitude || !longitude || !patientPhone) {
    res.status(400).json({
      status: 'error',
      message: 'Missing required request parameters.'
    });
    return;
  }

  try {
    const requestData = {
      patientName,
      hospitalName,
      bloodType,
      unitsRequired: Number(unitsRequired),
      latitude: Number(latitude),
      longitude: Number(longitude),
      patientPhone,
      urgency: urgency || 'NORMAL',
      status: 'OPEN',
      createdById,
      createdAt: new Date(),
      acceptedById: null,
      acceptedAt: null,
    };

    const docRef = await db.collection('blood_requests').add(requestData);
    const savedData = { id: docRef.id, ...requestData };


    io.emit('new_emergency_request', savedData);

    res.status(201).json({
      status: 'success',
      data: savedData
    });
  } catch (error: any) {
    console.error('Create Request Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to create blood request.'
    });
  }
};


export const getBloodRequests = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  const status = req.query.status as string || 'OPEN';
  const bloodType = req.query.bloodType as string;

  try {
    let query: any = db.collection('blood_requests');

    if (status !== 'ALL') {
      query = query.where('status', '==', status);
    }

    // bloodType filtered in-memory to avoid composite Firestore index requirement
    const snapshot = await query.orderBy('createdAt', 'desc').get();
    let requests: any[] = [];

    snapshot.forEach((doc: any) => {
      requests.push({ id: doc.id, ...doc.data() });
    });

    if (bloodType) {
      requests = requests.filter((r: any) => r.bloodType === bloodType);
    }

    res.status(200).json({
      status: 'success',
      data: requests
    });
  } catch (error: any) {
    console.error('Fetch Requests Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to query blood requests.'
    });
  }

};


export const acceptBloodRequest = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user || req.user.role !== 'DONOR') {
    res.status(403).json({
      status: 'error',
      message: 'Forbidden: Only active donors can accept emergency requests.'
    });
    return;
  }

  const { id } = req.params;
  const donorId = req.user.uid;

  try {
    const requestRef = db.collection('blood_requests').doc(id);
    const requestDoc = await requestRef.get();

    if (!requestDoc.exists) {
      res.status(404).json({
        status: 'error',
        message: 'Blood request not found.'
      });
      return;
    }

    const requestData = requestDoc.data()!;
    if (requestData.status !== 'OPEN') {
      res.status(400).json({
        status: 'error',
        message: 'Blood request is no longer open.'
      });
      return;
    }

    const updateData = {
      status: 'IN_PROGRESS',
      acceptedById: donorId,
      acceptedAt: new Date()
    };

    await requestRef.update(updateData);

    const updatedResponse = { id, ...requestData, ...updateData };


    io.to(requestData.createdById).emit('request_accepted', {
      requestId: id,
      donorId,
      status: 'IN_PROGRESS'
    });

    res.status(200).json({
      status: 'success',
      message: 'Request accepted successfully.',
      data: updatedResponse
    });
  } catch (error: any) {
    console.error('Accept Request Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to accept blood request.'
    });
  }
};


export const updateRequestStatus = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  if (!req.user) {
    res.status(401).json({ status: 'error', message: 'Unauthorized' });
    return;
  }

  const { id } = req.params;
  const { status } = req.body;

  if (!status || !['OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'].includes(status)) {
    res.status(400).json({
      status: 'error',
      message: 'Invalid request status code.'
    });
    return;
  }

  try {
    const requestRef = db.collection('blood_requests').doc(id);
    const requestDoc = await requestRef.get();

    if (!requestDoc.exists) {
      res.status(404).json({
        status: 'error',
        message: 'Blood request not found.'
      });
      return;
    }

    const requestData = requestDoc.data()!;

    if (requestData.createdById !== req.user.uid && requestData.acceptedById !== req.user.uid && req.user.role !== 'ADMIN') {
      res.status(403).json({
        status: 'error',
        message: 'Forbidden: Unauthorized update attempt.'
      });
      return;
    }

    await requestRef.update({ status });

    const updatedResponse = { id, ...requestData, status };


    io.to(requestData.createdById).emit('request_status_updated', updatedResponse);
    if (requestData.acceptedById) {
      io.to(requestData.acceptedById).emit('request_status_updated', updatedResponse);
    }

    res.status(200).json({
      status: 'success',
      data: updatedResponse
    });
  } catch (error: any) {
    console.error('Update Request Status Failed:', error.message);
    res.status(500).json({
      status: 'error',
      message: 'Failed to update request status.'
    });
  }
};
