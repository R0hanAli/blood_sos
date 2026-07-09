import { Request, Response, NextFunction } from 'express';
import { auth, db } from '../config/firebase';

export interface AuthenticatedRequest extends Request {
  user?: {
    uid: string;
    email: string;
    role: 'DONOR' | 'PATIENT' | 'HOSPITAL' | 'ADMIN';
    status: 'ACTIVE' | 'SUSPENDED' | 'PENDING_VERIFICATION';
  };
}

export const requireAuth = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({
        status: 'error',
        message: 'Unauthorized: Missing or invalid token format.'
      });
      return;
    }

    const idToken = authHeader.split('Bearer ')[1];
    
    
    const decodedToken = await auth.verifyIdToken(idToken);
    const uid = decodedToken.uid;

    
    const userDoc = await db.collection('users').doc(uid).get();
    if (!userDoc.exists) {
      res.status(401).json({
        status: 'error',
        message: 'Unauthorized: User profile registration not completed.'
      });
      return;
    }

    const userData = userDoc.data();
    if (userData?.status === 'SUSPENDED') {
      res.status(403).json({
        status: 'error',
        message: 'Forbidden: Your account is suspended.'
      });
      return;
    }

    
    req.user = {
      uid: uid,
      email: decodedToken.email || '',
      role: userData?.role || 'DONOR',
      status: userData?.status || 'ACTIVE',
    };

    next();
  } catch (error: any) {
    console.error('Authentication Error:', error.message);
    res.status(401).json({
      status: 'error',
      message: 'Unauthorized: Invalid or expired credentials.'
    });
    return;
  }
};


export const requireRoles = (roles: Array<'DONOR' | 'PATIENT' | 'HOSPITAL' | 'ADMIN'>) => {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        status: 'error',
        message: 'Unauthorized: Session invalid.'
      });
      return;
    }

    if (!roles.includes(req.user.role)) {
      res.status(403).json({
        status: 'error',
        message: 'Forbidden: Insufficient account permissions.'
      });
      return;
    }

    next();
  };
};

export const verifyFirebaseToken = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({
        status: 'error',
        message: 'Unauthorized: Missing or invalid token format.'
      });
      return;
    }

    const idToken = authHeader.split('Bearer ')[1];
    const decodedToken = await auth.verifyIdToken(idToken);
    
    
    req.body.firebaseUser = decodedToken;
    next();
  } catch (error: any) {
    console.error('Firebase Token Verify Failed:', error.message);
    res.status(401).json({
      status: 'error',
      message: 'Unauthorized: Token signature verification failed.'
    });
    return;
  }
};
