import express, { Request, Response, NextFunction } from 'express';
import proofRouter from './routes/prover';

const app = express();

// Middleware
app.use(express.json());

// Create an async handler wrapper to properly handle promise rejections
const asyncHandler = (fn: (req: Request, res: Response, next: NextFunction) => Promise<any>) => 
  (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch((error) => next(error));
  };

// Routes
app.use('/api/prove', proofRouter);

// Health check endpoint with asyncHandler (example usage)
app.get('/health', asyncHandler(async (_req: Request, res: Response) => {
  res.status(200).json({ status: 'ok' });
}));

// Error handling middleware
app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error', message: err.message });
});

const PORT = process.env.PORT || 3002;
app.listen(PORT, () => console.log(`ZK-Prover running on ${PORT}`));