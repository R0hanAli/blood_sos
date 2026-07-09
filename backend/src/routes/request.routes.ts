import { Router } from 'express';
import { createBloodRequest, getBloodRequests, acceptBloodRequest, updateRequestStatus } from '../controllers/request.controller';
import { requireAuth, requireRoles } from '../middlewares/auth';

const router = Router();


router.post('/', requireAuth, createBloodRequest);


router.get('/', requireAuth, getBloodRequests);


router.post('/:id/accept', requireAuth, requireRoles(['DONOR']), acceptBloodRequest);


router.put('/:id/status', requireAuth, updateRequestStatus);

export default router;
