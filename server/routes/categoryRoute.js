import express from 'express';
import asyncHandler from 'express-async-handler';
import {
    getAllCategories,
    getCategoryById,
    createCategory,
    updateCategory,
    deleteCategory
} from '../controllers/categoryController.js';

const router = express.Router();

router.get('/', asyncHandler(getAllCategories));
router.get('/:id', asyncHandler(getCategoryById));
router.post('/', asyncHandler(createCategory));
router.put('/:id', asyncHandler(updateCategory));
router.delete('/:id', asyncHandler(deleteCategory));

export default router;