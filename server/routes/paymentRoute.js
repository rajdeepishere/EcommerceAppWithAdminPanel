import express from 'express';
import asyncHandler from 'express-async-handler';
import { getRazorpayKey } from '../controllers/paymentController.js';

const router = express.Router();

router.post('/razorpay', asyncHandler(getRazorpayKey));

export default router;
