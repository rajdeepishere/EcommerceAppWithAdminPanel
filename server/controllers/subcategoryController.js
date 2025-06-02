import SubCategory from '../models/subCategoryModel.js';
import Brand from '../models/brandModel.js';
import Product from '../models/productModel.js';
import asyncHandler from 'express-async-handler';

// Get all sub-categories
const getAllSubCategories = asyncHandler(async (req, res) => {
    const subCategories = await SubCategory.find()
        .populate('categoryId')
        .sort({ categoryId: 1 });
    res.json({ success: true, message: "Sub-categories retrieved successfully.", data: subCategories });
});

// Get sub-category by ID
const getSubCategoryById = asyncHandler(async (req, res) => {
    const subCategory = await SubCategory.findById(req.params.id).populate('categoryId');
    if (!subCategory) {
        return res.status(404).json({ success: false, message: "Sub-category not found." });
    }
    res.json({ success: true, message: "Sub-category retrieved successfully.", data: subCategory });
});

// Create sub-category
const createSubCategory = asyncHandler(async (req, res) => {
    const { name, categoryId } = req.body;

    if (!name || !categoryId) {
        return res.status(400).json({ success: false, message: "Name and category ID are required." });
    }

    const subCategory = new SubCategory({ name, categoryId });
    await subCategory.save();
    res.json({ success: true, message: "Sub-category created successfully.", data: null });
});

// Update sub-category
const updateSubCategory = asyncHandler(async (req, res) => {
    const { name, categoryId } = req.body;
    const subCategoryID = req.params.id;

    if (!name || !categoryId) {
        return res.status(400).json({ success: false, message: "Name and category ID are required." });
    }

    const updatedSubCategory = await SubCategory.findByIdAndUpdate(
        subCategoryID,
        { name, categoryId },
        { new: true }
    );

    if (!updatedSubCategory) {
        return res.status(404).json({ success: false, message: "Sub-category not found." });
    }

    res.json({ success: true, message: "Sub-category updated successfully.", data: null });
});

// Delete sub-category
const deleteSubCategory = asyncHandler(async (req, res) => {
    const subCategoryID = req.params.id;

    const brandCount = await Brand.countDocuments({ subcategoryId: subCategoryID });
    if (brandCount > 0) {
        return res.status(400).json({ success: false, message: "Cannot delete sub-category. It is associated with one or more brands." });
    }

    const productCount = await Product.countDocuments({ proSubCategoryId: subCategoryID });
    if (productCount > 0) {
        return res.status(400).json({ success: false, message: "Cannot delete sub-category. Products are referencing it." });
    }

    const deleted = await SubCategory.findByIdAndDelete(subCategoryID);
    if (!deleted) {
        return res.status(404).json({ success: false, message: "Sub-category not found." });
    }

    res.json({ success: true, message: "Sub-category deleted successfully." });
});

export {
    getAllSubCategories,
    getSubCategoryById,
    createSubCategory,
    updateSubCategory,
    deleteSubCategory
};
