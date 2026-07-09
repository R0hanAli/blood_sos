import { Router } from 'express';
import { getMyDonations, logDonation } from '../controllers/donation.controller';
import { requireAuth, requireRoles } from '../middlewares/auth';

const router = Router();


router.get('/me', requireAuth, requireRoles(['DONOR']), getMyDonations);


router.post('/', requireAuth, requireRoles(['HOSPITAL', 'ADMIN']), logDonation);

export default router;
