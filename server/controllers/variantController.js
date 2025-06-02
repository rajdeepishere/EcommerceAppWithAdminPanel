import asyncHandler from 'express-async-handler';
import Variant from '../models/variantModel.js';
import Product from '../models/productModel.js';

//Get all variants
export const getAllVariants = asyncHandler(async (req, res) => {
    const variants = await Variant.find().populate('variantTypeId').sort({ variantTypeId: 1 });
    res.json({ success: true, message: "Variants retrieved successfully.", data: variants });
});

//Get variant by ID
export const getVariantById = asyncHandler(async (req, res) => {
    const variant = await Variant.findById(req.params.id).populate('variantTypeId');
    if (!variant) {
        return res.status(404).json({ success: false, message: "Variant not found." });
    }
    res.json({ success: true, message: "Variant retrieved successfully.", data: variant });
});

//Create a new variant
export const createVariant = asyncHandler(async (req, res) => {
    const { name, variantTypeId } = req.body;
    if (!name || !variantTypeId) {
        return res.status(400).json({ success: false, message: "Name and VariantType ID are required." });
    }

    const newVariant = new Variant({ name, variantTypeId });
    await newVariant.save();
    res.json({ success: true, message: "Variant created successfully.", data: null });
});

// Update a variant
export const updateVariant = asyncHandler(async (req, res) => {
    const { name, variantTypeId } = req.body;
    if (!name || !variantTypeId) {
        return res.status(400).json({ success: false, message: "Name and VariantType ID are required." });
    }

    const updatedVariant = await Variant.findByIdAndUpdate(req.params.id, { name, variantTypeId }, { new: true });
    if (!updatedVariant) {
        return res.status(404).json({ success: false, message: "Variant not found." });
    }
    res.json({ success: true, message: "Variant updated successfully.", data: null });
});

// Delete a variant
export const deleteVariant = asyncHandler(async (req, res) => {
    const variantID = req.params.id;

    const products = await Product.find({ proVariantId: variantID });
    if (products.length > 0) {
        return res.status(400).json({ success: false, message: "Cannot delete variant. Products are referencing it." });
    }

    const variant = await Variant.findByIdAndDelete(variantID);
    if (!variant) {
        return res.status(404).json({ success: false, message: "Variant not found." });
    }

    res.json({ success: true, message: "Variant deleted successfully." });
});
