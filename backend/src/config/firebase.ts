import * as admin from 'firebase-admin';
import * as dotenv from 'dotenv';
import * as path from 'path';
import * as fs from 'fs';

dotenv.config();

let db: admin.firestore.Firestore;
let auth: admin.auth.Auth;
let messaging: admin.messaging.Messaging;
let isFirebaseInitialized = false;

try {
  
  const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
  
  if (serviceAccountPath && fs.existsSync(serviceAccountPath)) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccountPath),
    });
    isFirebaseInitialized = true;
    console.log('Firebase Admin initialized successfully using service account key file.');
  } else {
    
    
    const defaultLocalKey = path.join(__dirname, '..', '..', 'firebase-service-account.json');
    if (fs.existsSync(defaultLocalKey)) {
      admin.initializeApp({
        credential: admin.credential.cert(defaultLocalKey),
      });
      isFirebaseInitialized = true;
      console.log(`Firebase Admin initialized using default local key at: ${defaultLocalKey}`);
    } else {
      
      admin.initializeApp();
      isFirebaseInitialized = true;
      console.log('Firebase Admin initialized using Google Application Default Credentials.');
    }
  }
} catch (error: any) {
  console.error('================================================================');
  console.error('WARNING: Firebase Admin failed to initialize.');
  console.error('To run the backend properly, please set the FIREBASE_SERVICE_ACCOUNT_PATH');
  console.error('environment variable or place firebase-service-account.json in the backend root.');
  console.error('Detailed Error:', error.message);
  console.error('================================================================');
  
  
  isFirebaseInitialized = false;
}

if (isFirebaseInitialized) {
  db = admin.firestore();
  auth = admin.auth();
  messaging = admin.messaging();
} else {
  
  db = {} as any;
  auth = {} as any;
  messaging = {} as any;
}

export { db, auth, messaging, isFirebaseInitialized };
