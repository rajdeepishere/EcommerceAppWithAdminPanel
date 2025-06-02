import express from 'express';
import asyncHandler from 'express-async-handler';
import {
  getAllCoupons,
  getCouponById,
  createCoupon,
  updateCoupon,
  deleteCoupon,
  checkCoupon
} from '../controllers/couponcodeController.js';

const router = express.Router();

router.get('/', asyncHandler(getAllCoupons));
router.get('/:id', asyncHandler(getCouponById));
router.post('/', asyncHandler(createCoupon));
router.put('/:id', asyncHandler(updateCoupon));
router.delete('/:id', asyncHandler(deleteCoupon));
router.post('/check-coupon', asyncHandler(checkCoupon));

export default router;
