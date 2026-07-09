import { Router } from 'express';
import { getUsers, toggleUserSuspension, verifyHospital, broadcastAnnouncement } from '../controllers/admin.controller';
import { requireAuth, requireRoles } from '../middlewares/auth';

const router = Router();


router.get('/users', requireAuth, requireRoles(['ADMIN']), getUsers);


router.post('/users/:id/suspend', requireAuth, requireRoles(['ADMIN']), toggleUserSuspension);


router.post('/hospitals/:id/verify', requireAuth, requireRoles(['ADMIN']), verifyHospital);


router.post('/broadcast', requireAuth, requireRoles(['ADMIN']), broadcastAnnouncement);

export default router;
