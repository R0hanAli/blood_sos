import { Router } from 'express';
import { getMyDonorProfile, updateMyDonorProfile, evaluateEligibility, searchNearbyDonors } from '../controllers/donor.controller';
import { requireAuth, requireRoles } from '../middlewares/auth';

const router = Router();


router.get('/me', requireAuth, requireRoles(['DONOR']), getMyDonorProfile);


router.put('/me', requireAuth, requireRoles(['DONOR']), updateMyDonorProfile);


router.post('/me/eligibility', requireAuth, requireRoles(['DONOR']), evaluateEligibility);


router.get('/search', requireAuth, searchNearbyDonors);

export default router;
