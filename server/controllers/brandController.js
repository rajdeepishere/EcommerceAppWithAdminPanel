import asyncHandler from 'express-async-handler';
import Brand from '../models/brandModel.js';
import Product from '../models/productModel.js';

// Get all brands
export const getAllBrands = asyncHandler(async (req, res) => {
  const brands = await Brand.find().populate('subcategoryId').sort({ subcategoryId: 1 });
  res.json({ success: true, message: "Brands retrieved successfully.", data: brands });
});

// Get a brand by ID
export const getBrandById = asyncHandler(async (req, res) => {
  const brandID = req.params.id;
  const brand = await Brand.findById(brandID).populate('subcategoryId');
  if (!brand) {
    return res.status(404).json({ success: false, message: "Brand not found." });
  }
  res.json({ success: true, message: "Brand retrieved successfully.", data: brand });
});

// Create a new brand
export const createBrand = asyncHandler(async (req, res) => {
  const { name, subcategoryId } = req.body;
  if (!name || !subcategoryId) {
    return res.status(400).json({ success: false, message: "Name and subcategory ID are required." });
  }
  const brand = new Brand({ name, subcategoryId });
  await brand.save();
  res.json({ success: true, message: "Brand created successfully.", data: null });
});

// Update a brand
export const updateBrand = asyncHandler(async (req, res) => {
  const brandID = req.params.id;
  const { name, subcategoryId } = req.body;
  if (!name || !subcategoryId) {
    return res.status(400).json({ success: false, message: "Name and subcategory ID are required." });
  }
  const updatedBrand = await Brand.findByIdAndUpdate(brandID, { name, subcategoryId }, { new: true });
  if (!updatedBrand) {
    return res.status(404).json({ success: false, message: "Brand not found." });
  }
  res.json({ success: true, message: "Brand updated successfully.", data: null });
});

// Delete a brand
export const deleteBrand = asyncHandler(async (req, res) => {
  const brandID = req.params.id;
  const products = await Product.find({ proBrandId: brandID });
  if (products.length > 0) {
    return res.status(400).json({ success: false, message: "Cannot delete brand. Products are referencing it." });
  }
  const brand = await Brand.findByIdAndDelete(brandID);
  if (!brand) {
    return res.status(404).json({ success: false, message: "Brand not found." });
  }
  res.json({ success: true, message: "Brand deleted successfully." });
});
