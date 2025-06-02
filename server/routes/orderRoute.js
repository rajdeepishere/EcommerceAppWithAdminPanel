import express from 'express';
import asyncHandler from 'express-async-handler';
import {
  getAllOrders,
  getOrdersByUserId,
  getOrderById,
  createOrder,
  updateOrder,
  deleteOrder
} from '../controllers/orderController.js';

const router = express.Router();

router.get('/', asyncHandler(getAllOrders));
router.get('/orderByUserId/:userId', asyncHandler(getOrdersByUserId));
router.get('/:id', asyncHandler(getOrderById));
router.post('/', asyncHandler(createOrder));
router.put('/:id', asyncHandler(updateOrder));
router.delete('/:id', asyncHandler(deleteOrder));

export default router;
