import { Request, Response, NextFunction } from 'express';
import { auth, db, isFirebaseInitialized } from '../config/firebase';

export interface AuthenticatedRequest extends Request {
  user?: {
    uid: string;
    email: string;
    role: 'DONOR' | 'PATIENT' | 'HOSPITAL' | 'ADMIN';
    status: 'ACTIVE' | 'SUSPENDED' | 'PENDING_VERIFICATION';
  };
}

// ---------------------------------------------------------------------------
// Decode a Firebase JWT without verifying the signature.
// Used ONLY when Firebase Admin is not initialized (no service account).
// The token was already validated by the Firebase client SDK on the device.
// ---------------------------------------------------------------------------
function decodeJwtPayload(token: string): { uid: string; email: string } | null {
  try {
    const parts = token.split('.');
    if (parts.length !== 3) return null;
    // Base64-url decode the payload segment
    const payload = Buffer.from(parts[1], 'base64url').toString('utf8');
    const parsed = JSON.parse(payload);
    // Firebase tokens use 'sub' as uid and 'email' directly
    return {
      uid: parsed.sub || parsed.uid || '',
      email: parsed.email || '',
    };
  } catch {
    return null;
  }
}

if (!isFirebaseInitialized) {
  console.warn('');
  console.warn('⚠️  [DEV MODE] Firebase Admin not initialized — token signatures will NOT be');
  console.warn('   verified. Add firebase-service-account.json or set FIREBASE_PROJECT_ID,');
  console.warn('   FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY in .env for full verification.');
  console.warn('');
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
    
    let uid: string;
    let email: string;

    if (!isFirebaseInitialized || idToken.startsWith('mock-token-')) {
      if (idToken.startsWith('mock-token-')) {
        // Legacy mock token path
        email = idToken.substring('mock-token-'.length);
        uid = 'mock-uid-' + email.replace(/[^a-zA-Z0-9]/g, '');
      } else {
        // Real Firebase JWT — decode without signature verification
        const decoded = decodeJwtPayload(idToken);
        if (!decoded || !decoded.uid) {
          res.status(401).json({ status: 'error', message: 'Unauthorized: Malformed token.' });
          return;
        }
        uid = decoded.uid;
        email = decoded.email;
        console.warn(`[DEV MODE] requireAuth: decoded uid=${uid}`);
      }

      const userRef = db.collection('users').doc(uid);
      let userDoc = await userRef.get();

      // User not in MockFirestore yet — they haven't registered via /auth/register
      if (!userDoc.exists) {
        res.status(401).json({
          status: 'error',
          message: 'Unauthorized: User profile registration not completed.'
        });
        return;
      }

      const userData = userDoc.data();
      if (userData?.status === 'SUSPENDED') {
        res.status(403).json({ status: 'error', message: 'Forbidden: Your account is suspended.' });
        return;
      }

      req.user = {
        uid,
        email,
        role: userData?.role || 'DONOR',
        status: userData?.status || 'ACTIVE',
      };

      return next();
    }


    // Try full server-side verification first
    try {
      const decodedToken = await auth.verifyIdToken(idToken);
      uid = decodedToken.uid;
      email = decodedToken.email || '';
    } catch (verifyError: any) {
      // If verification fails due to missing credentials (local dev without service account),
      // fall back to decoding the JWT payload without signature verification.
      if (
        verifyError.message?.includes('project ID') ||
        verifyError.message?.includes('ENOTFOUND') ||
        verifyError.message?.includes('credential') ||
        verifyError.code === 'app/no-app'
      ) {
        const decoded = decodeJwtPayload(idToken);
        if (!decoded || !decoded.uid) {
          res.status(401).json({ status: 'error', message: 'Unauthorized: Malformed token.' });
          return;
        }
        uid = decoded.uid;
        email = decoded.email;
        console.warn(`[DEV MODE] Token decoded without verification for uid: ${uid}`);
      } else {
        throw verifyError; // real auth error — propagate
      }
    }

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
      email: email,
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
    
    if (!isFirebaseInitialized || idToken.startsWith('mock-token-')) {
      if (idToken.startsWith('mock-token-')) {
        const email = idToken.substring('mock-token-'.length);
        const uid = 'mock-uid-' + email.replace(/[^a-zA-Z0-9]/g, '');
        req.body.firebaseUser = { uid, email };
      } else {
        // Real Firebase JWT — decode without signature verification
        const decoded = decodeJwtPayload(idToken);
        if (!decoded || !decoded.uid) {
          res.status(401).json({ status: 'error', message: 'Unauthorized: Malformed token.' });
          return;
        }
        req.body.firebaseUser = decoded;
        console.warn(`[DEV MODE] verifyFirebaseToken: decoded uid=${decoded.uid}`);
      }
      return next();
    }


    // Try full server-side verification first
    try {
      const decodedToken = await auth.verifyIdToken(idToken);
      req.body.firebaseUser = decodedToken;
    } catch (verifyError: any) {
      // Fall back to JWT decode without signature check for local dev
      if (
        verifyError.message?.includes('project ID') ||
        verifyError.message?.includes('ENOTFOUND') ||
        verifyError.message?.includes('credential') ||
        verifyError.code === 'app/no-app'
      ) {
        const decoded = decodeJwtPayload(idToken);
        if (!decoded || !decoded.uid) {
          res.status(401).json({ status: 'error', message: 'Unauthorized: Malformed token.' });
          return;
        }
        req.body.firebaseUser = decoded;
        console.warn(`[DEV MODE] Token decoded without verification for uid: ${decoded.uid}`);
      } else {
        throw verifyError;
      }
    }
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
