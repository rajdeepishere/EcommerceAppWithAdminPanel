import express from 'express';
import asyncHandler from 'express-async-handler';
import {
  sendNotification,
  trackNotification,
  getAllNotifications,
  deleteNotification
} from '../controllers/notificationController.js';

const router = express.Router();

router.post('/send-notification', asyncHandler(sendNotification));
router.get('/track-notification/:id', asyncHandler(trackNotification));
router.get('/all-notification', asyncHandler(getAllNotifications));
router.delete('/delete-notification/:id', asyncHandler(deleteNotification));

export default router;