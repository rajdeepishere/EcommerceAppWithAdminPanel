import Coupon from '../models/couponCodeModel.js';
import Product from '../models/productModel.js';

export const getAllCoupons = async (req, res) => {
  const coupons = await Coupon.find()
    .populate('applicableCategory', 'id name')
    .populate('applicableSubCategory', 'id name')
    .populate('applicableProduct', 'id name');
  res.json({ success: true, message: "Coupons retrieved successfully.", data: coupons });
};

export const getCouponById = async (req, res) => {
  const couponID = req.params.id;
  const coupon = await Coupon.findById(couponID)
    .populate('applicableCategory', 'id name')
    .populate('applicableSubCategory', 'id name')
    .populate('applicableProduct', 'id name');
  if (!coupon) {
    return res.status(404).json({ success: false, message: "Coupon not found." });
  }
  res.json({ success: true, message: "Coupon retrieved successfully.", data: coupon });
};

export const createCoupon = async (req, res) => {
  const {
    couponCode, discountType, discountAmount, minimumPurchaseAmount,
    endDate, status, applicableCategory, applicableSubCategory, applicableProduct
  } = req.body;

  if (!couponCode || !discountType || !discountAmount || !endDate || !status) {
    return res.status(400).json({ success: false, message: "Code, discountType, discountAmount, endDate, and status are required." });
  }

  const coupon = new Coupon({
    couponCode, discountType, discountAmount, minimumPurchaseAmount,
    endDate, status, applicableCategory, applicableSubCategory, applicableProduct
  });

  await coupon.save();
  res.json({ success: true, message: "Coupon created successfully.", data: null });
};

export const updateCoupon = async (req, res) => {
  const couponID = req.params.id;
  const {
    couponCode, discountType, discountAmount, minimumPurchaseAmount,
    endDate, status, applicableCategory, applicableSubCategory, applicableProduct
  } = req.body;

  if (!couponCode || !discountType || !discountAmount || !endDate || !status) {
    return res.status(400).json({ success: false, message: "CouponCode, discountType, discountAmount, endDate, and status are required." });
  }

  const updatedCoupon = await Coupon.findByIdAndUpdate(
    couponID,
    { couponCode, discountType, discountAmount, minimumPurchaseAmount, endDate, status, applicableCategory, applicableSubCategory, applicableProduct },
    { new: true }
  );

  if (!updatedCoupon) {
    return res.status(404).json({ success: false, message: "Coupon not found." });
  }

  res.json({ success: true, message: "Coupon updated successfully.", data: null });
};

export const deleteCoupon = async (req, res) => {
  const couponID = req.params.id;
  const deletedCoupon = await Coupon.findByIdAndDelete(couponID);

  if (!deletedCoupon) {
    return res.status(404).json({ success: false, message: "Coupon not found." });
  }

  res.json({ success: true, message: "Coupon deleted successfully." });
};

export const checkCoupon = async (req, res) => {
  const { couponCode, productIds, purchaseAmount } = req.body;

  const coupon = await Coupon.findOne({ couponCode });

  if (!coupon) {
    return res.json({ success: false, message: "Coupon not found." });
  }

  const currentDate = new Date();
  if (coupon.endDate < currentDate) {
    return res.json({ success: false, message: "Coupon is expired." });
  }

  if (coupon.status !== 'active') {
    return res.json({ success: false, message: "Coupon is inactive." });
  }

  if (coupon.minimumPurchaseAmount && purchaseAmount < coupon.minimumPurchaseAmount) {
    return res.json({ success: false, message: "Minimum purchase amount not met." });
  }

  if (!coupon.applicableCategory && !coupon.applicableSubCategory && !coupon.applicableProduct) {
    return res.json({ success: true, message: "Coupon is applicable for all orders.", data: coupon });
  }

  const products = await Product.find({ _id: { $in: productIds } });

  const isValid = products.every(product => {
    if (coupon.applicableCategory && coupon.applicableCategory.toString() !== product.proCategoryId.toString()) return false;
    if (coupon.applicableSubCategory && coupon.applicableSubCategory.toString() !== product.proSubCategoryId.toString()) return false;
    if (coupon.applicableProduct && !product.proVariantId.includes(coupon.applicableProduct.toString())) return false;
    return true;
  });

  if (isValid) {
    return res.json({ success: true, message: "Coupon is applicable for the provided products.", data: coupon });
  } else {
    return res.json({ success: false, message: "Coupon is not applicable for the provided products." });
  }
};
