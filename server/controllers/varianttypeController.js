import asyncHandler from 'express-async-handler';
import VariantType from '../models/variantTypeModel.js';
import Variant from '../models/variantModel.js';
import Product from '../models/productModel.js';

// Get all variant types
export const getAllVariantTypes = asyncHandler(async (req, res) => {
    const variantTypes = await VariantType.find();
    res.json({ success: true, message: "VariantTypes retrieved successfully.", data: variantTypes });
});

//Get a variant type by ID
export const getVariantTypeById = asyncHandler(async (req, res) => {
    const variantType = await VariantType.findById(req.params.id);
    if (!variantType) {
        return res.status(404).json({ success: false, message: "VariantType not found." });
    }
    res.json({ success: true, message: "VariantType retrieved successfully.", data: variantType });
});

//Create a new variant type
export const createVariantType = asyncHandler(async (req, res) => {
    const { name, type } = req.body;
    if (!name) {
        return res.status(400).json({ success: false, message: "Name is required." });
    }

    const variantType = new VariantType({ name, type });
    await variantType.save();
    res.json({ success: true, message: "VariantType created successfully.", data: null });
});

//Update a variant type
export const updateVariantType = asyncHandler(async (req, res) => {
    const { name, type } = req.body;
    if (!name) {
        return res.status(400).json({ success: false, message: "Name is required." });
    }

    const updatedVariantType = await VariantType.findByIdAndUpdate(req.params.id, { name, type }, { new: true });
    if (!updatedVariantType) {
        return res.status(404).json({ success: false, message: "VariantType not found." });
    }
    res.json({ success: true, message: "VariantType updated successfully.", data: null });
});

// Delete a variant type
export const deleteVariantType = asyncHandler(async (req, res) => {
    const variantTypeID = req.params.id;

    const variantCount = await Variant.countDocuments({ variantTypeId: variantTypeID });
    if (variantCount > 0) {
        return res.status(400).json({ success: false, message: "Cannot delete variant type. It is associated with one or more variants." });
    }

    const products = await Product.find({ proVariantTypeId: variantTypeID });
    if (products.length > 0) {
        return res.status(400).json({ success: false, message: "Cannot delete variant type. Products are referencing it." });
    }

    const variantType = await VariantType.findByIdAndDelete(variantTypeID);
    if (!variantType) {
        return res.status(404).json({ success: false, message: "Variant type not found." });
    }
    res.json({ success: true, message: "Variant type deleted successfully." });
});
