import * as admin from 'firebase-admin';
import * as dotenv from 'dotenv';
import * as path from 'path';
import * as fs from 'fs';

dotenv.config();

// ---------------------------------------------------------------------------
// Mock implementations — defined FIRST so they can be used in the assignment
// block right after the try-catch without any hoisting issues.
// ---------------------------------------------------------------------------

function wrapFirestoreValue(val: any): any {
  if (val instanceof Date) {
    return { toDate: () => val };
  }
  if (Array.isArray(val)) return val.map(wrapFirestoreValue);
  if (val && typeof val === 'object' && val.constructor === Object) {
    const res: any = {};
    for (const k of Object.keys(val)) res[k] = wrapFirestoreValue(val[k]);
    return res;
  }
  return val;
}

class MockDoc {
  constructor(private collectionName: string, public id: string, private dbData: any) {}
  async get() {
    const data = this.dbData[this.collectionName]?.[this.id];
    return { exists: !!data, data: () => data ? { ...data } : undefined };
  }
  async set(data: any) {
    if (!this.dbData[this.collectionName]) this.dbData[this.collectionName] = {};
    this.dbData[this.collectionName][this.id] = wrapFirestoreValue({ ...data });
  }
  async update(data: any) {
    if (!this.dbData[this.collectionName]) this.dbData[this.collectionName] = {};
    if (!this.dbData[this.collectionName][this.id]) this.dbData[this.collectionName][this.id] = {};
    this.dbData[this.collectionName][this.id] = wrapFirestoreValue({
      ...this.dbData[this.collectionName][this.id], ...data,
    });
  }
  async delete() {
    if (this.dbData[this.collectionName]) delete this.dbData[this.collectionName][this.id];
  }
}

class MockQuery {
  constructor(
    private collectionName: string,
    private dbData: any,
    private filters: Array<{ field: string; op: string; value: any }> = [],
    private orderField = '',
    private orderDirection: 'asc' | 'desc' = 'asc',
    private limitVal = 0
  ) {}
  where(field: string, op: string, value: any) {
    return new MockQuery(this.collectionName, this.dbData, [...this.filters, { field, op, value }], this.orderField, this.orderDirection, this.limitVal);
  }
  orderBy(field: string, direction: 'asc' | 'desc' = 'asc') {
    return new MockQuery(this.collectionName, this.dbData, this.filters, field, direction, this.limitVal);
  }
  limit(limit: number) {
    return new MockQuery(this.collectionName, this.dbData, this.filters, this.orderField, this.orderDirection, limit);
  }
  async get() {
    const collection = this.dbData[this.collectionName] || {};
    let docs = Object.keys(collection).map(id => ({ id, data: () => ({ ...collection[id] }) }));
    for (const f of this.filters) {
      docs = docs.filter(doc => f.op === '==' ? doc.data()[f.field] === f.value : true);
    }
    if (this.orderField) {
      docs.sort((a, b) => {
        let valA = a.data()[this.orderField]; let valB = b.data()[this.orderField];
        if (valA?.toDate) valA = valA.toDate(); if (valB?.toDate) valB = valB.toDate();
        if (valA instanceof Date && valB instanceof Date)
          return this.orderDirection === 'asc' ? valA.getTime() - valB.getTime() : valB.getTime() - valA.getTime();
        if (typeof valA === 'string' && typeof valB === 'string')
          return this.orderDirection === 'asc' ? valA.localeCompare(valB) : valB.localeCompare(valA);
        return this.orderDirection === 'asc' ? valA - valB : valB - valA;
      });
    }
    if (this.limitVal > 0) docs = docs.slice(0, this.limitVal);
    return { empty: docs.length === 0, docs, forEach: (cb: (d: any) => void) => docs.forEach(cb) };
  }
}

class MockCollection {
  constructor(private collectionName: string, private dbData: any) {}
  doc(id: string) { return new MockDoc(this.collectionName, id, this.dbData); }
  where(field: string, op: string, value: any) { return new MockQuery(this.collectionName, this.dbData).where(field, op, value); }
  orderBy(field: string, direction: 'asc' | 'desc' = 'asc') { return new MockQuery(this.collectionName, this.dbData).orderBy(field, direction); }
  limit(v: number) { return new MockQuery(this.collectionName, this.dbData).limit(v); }
  async add(data: any) {
    const id = 'mock-id-' + Math.random().toString(36).substr(2, 9);
    if (!this.dbData[this.collectionName]) this.dbData[this.collectionName] = {};
    this.dbData[this.collectionName][id] = wrapFirestoreValue({ ...data });
    return { id };
  }
  async get() { return new MockQuery(this.collectionName, this.dbData).get(); }
}

class MockFirestore {
  private dbData: any = {};
  collection(name: string) { return new MockCollection(name, this.dbData); }
  async runTransaction(callback: (t: any) => Promise<any>) {
    const t = {
      set: async (ref: MockDoc, data: any) => ref.set(data),
      update: async (ref: MockDoc, data: any) => ref.update(data),
      delete: async (ref: MockDoc) => ref.delete(),
      get: async (ref: MockDoc) => ref.get(),
    };
    return callback(t);
  }
}

class MockAuth {
  async verifyIdToken(idToken: string) {
    if (idToken.startsWith('mock-token-')) {
      const email = idToken.substring('mock-token-'.length);
      return { uid: 'mock-uid-' + email.replace(/[^a-zA-Z0-9]/g, ''), email };
    }
    throw new Error('Invalid mock token signature');
  }
}

// ---------------------------------------------------------------------------
// Single declarations — exported, assigned once right after the try-catch.
// ---------------------------------------------------------------------------
export let db: admin.firestore.Firestore;
export let auth: admin.auth.Auth;
export let messaging: admin.messaging.Messaging;
export let isFirebaseInitialized = false;

try {
  const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH;

  if (serviceAccountPath && fs.existsSync(serviceAccountPath)) {
    // Option 1: service account JSON file path
    admin.initializeApp({ credential: admin.credential.cert(serviceAccountPath) });
    isFirebaseInitialized = true;
    console.log('Firebase Admin initialized successfully using service account key file.');

  } else if (process.env.FIREBASE_PROJECT_ID && process.env.FIREBASE_CLIENT_EMAIL && process.env.FIREBASE_PRIVATE_KEY) {
    // Option 2: inline env-var credentials
    admin.initializeApp({
      credential: admin.credential.cert({
        projectId:   process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey:  process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
      }),
    });
    isFirebaseInitialized = true;
    console.log('Firebase Admin initialized using inline env-var credentials.');

  } else {
    const defaultLocalKey = path.join(__dirname, '..', '..', 'firebase-service-account.json');
    if (fs.existsSync(defaultLocalKey)) {
      // Option 3: JSON file in backend root
      admin.initializeApp({ credential: admin.credential.cert(defaultLocalKey) });
      isFirebaseInitialized = true;
      console.log(`Firebase Admin initialized using default local key at: ${defaultLocalKey}`);
    } else {
      // Option 4: No credentials — use MockFirestore for local dev
      console.warn('================================================================');
      console.warn('[LOCAL DEV MODE] No Firebase service account found.');
      console.warn('Running with MockFirestore. Token signatures will NOT be verified.');
      console.warn('To enable full Firebase: add firebase-service-account.json to backend/');
      console.warn('================================================================');
    }
  }
} catch (error: any) {
  console.error('WARNING: Firebase Admin failed to initialize. Error:', error.message);
  isFirebaseInitialized = false;
}

// Assign immediately after try-catch — Mock classes are defined above so no hoisting issue.
if (isFirebaseInitialized) {
  db = admin.firestore();
  auth = admin.auth();
  messaging = admin.messaging();
} else {
  db = new MockFirestore() as any;
  auth = new MockAuth() as any;
  messaging = {} as any;
}

