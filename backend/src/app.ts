import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import * as dotenv from 'dotenv';
import authRouter from './routes/auth.routes';
import donorRouter from './routes/donor.routes';
import requestRouter from './routes/request.routes';
import donationRouter from './routes/donation.routes';
import adminRouter from './routes/admin.routes';

dotenv.config();

const app = express();


app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());


app.use('/api/auth', authRouter);
app.use('/api/donors', donorRouter);
app.use('/api/requests', requestRouter);
app.use('/api/donations', donationRouter);
app.use('/api/admin', adminRouter);


app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    status: 'success',
    message: 'BloodSOS Backend is healthy and running.',
    timestamp: new Date().toISOString()
  });
});


app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
  console.error('Express Error Handler:', err);
  res.status(err.status || 500).json({
    status: 'error',
    message: err.message || 'Internal Server Error',
  });
});

export default app;
