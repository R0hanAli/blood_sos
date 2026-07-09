import { Router } from 'express';
import { registerUser, getMe, updateProfile } from '../controllers/auth.controller';
import { requireAuth, verifyFirebaseToken } from '../middlewares/auth';

const router = Router();


router.post('/register', verifyFirebaseToken, registerUser);


router.get('/me', requireAuth, getMe);
router.put('/profile', requireAuth, updateProfile);

export default router;
