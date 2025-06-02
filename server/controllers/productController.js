import Product from '../models/productModel.js';
import multer from 'multer';
import { uploadProduct } from '../utils/uploadFile.js';
import asyncHandler from 'express-async-handler';
import dotenv from 'dotenv';
dotenv.config();

// Get all Products
const getAllProducts = asyncHandler(async (req, res) => {
    const products = await Product.find()
        .populate('proCategoryId', 'id name')
        .populate('proSubCategoryId', 'id name')
        .populate('proBrandId', 'id name')
        .populate('proVariantTypeId', 'id type')
        .populate('proVariantId', 'id name');
    res.json({ success: true, message: "Products retrieved successfully.", data: products });
});

// Get individual product by ID
const getProductById = asyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id)
        .populate('proCategoryId', 'id name')
        .populate('proSubCategoryId', 'id name')
        .populate('proBrandId', 'id name')
        .populate('proVariantTypeId', 'id name')
        .populate('proVariantId', 'id name');
    if (!product) {
        return res.status(404).json({ success: false, message: "Product not found." });
    }
    res.json({ success: true, message: "Product retrieved successfully.", data: product });
});

// Create a product
const createProduct = asyncHandler(async (req, res) => {
    uploadProduct.fields([
        { name: 'image1', maxCount: 1 },
        { name: 'image2', maxCount: 1 },
        { name: 'image3', maxCount: 1 },
        { name: 'image4', maxCount: 1 },
        { name: 'image5', maxCount: 1 }
    ])(req, res, async function (err) {
        if (err instanceof multer.MulterError || err) {
            return res.status(400).json({ success: false, message: err.message });
        }

        const { name, description, quantity, price, offerPrice, proCategoryId, proSubCategoryId, proBrandId, proVariantTypeId, proVariantId } = req.body;

        if (!name || !quantity || !price || !proCategoryId || !proSubCategoryId) {
            return res.status(400).json({ success: false, message: "Required fields are missing." });
        }

        const imageUrls = [];
        const fields = ['image1', 'image2', 'image3', 'image4', 'image5'];
        fields.forEach((field, index) => {
            if (req.files[field]?.length > 0) {
                const file = req.files[field][0];
                const imageUrl = `${process.env.SERVER_IP}/image/products/${file.filename}`;
                imageUrls.push({ image: index + 1, url: imageUrl });
            }
        });

        const newProduct = new Product({ name, description, quantity, price, offerPrice, proCategoryId, proSubCategoryId, proBrandId, proVariantTypeId, proVariantId, images: imageUrls });
        await newProduct.save();
        res.json({ success: true, message: "Product created successfully.", data: null });
    });
});

//Update a Product
const updateProduct = asyncHandler(async (req, res) => {
    const productId = req.params.id;

    uploadProduct.fields([
        { name: 'image1', maxCount: 1 },
        { name: 'image2', maxCount: 1 },
        { name: 'image3', maxCount: 1 },
        { name: 'image4', maxCount: 1 },
        { name: 'image5', maxCount: 1 }
    ])(req, res, async function (err) {
        if (err) {
            return res.status(400).json({ success: false, message: err.message });
        }

        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ success: false, message: "Product not found." });
        }

        const { name, description, quantity, price, offerPrice, proCategoryId, proSubCategoryId, proBrandId, proVariantTypeId, proVariantId } = req.body;

        Object.assign(product, {
            name, description, quantity, price, offerPrice,
            proCategoryId, proSubCategoryId, proBrandId, proVariantTypeId, proVariantId
        });

        const fields = ['image1', 'image2', 'image3', 'image4', 'image5'];
        fields.forEach((field, index) => {
            if (req.files[field]?.length > 0) {
                const file = req.files[field][0];
                const imageUrl = `${process.env.SERVER_IP}/image/products/${file.filename}`;
                const imageIndex = product.images.findIndex(img => img.image === index + 1);
                if (imageIndex >= 0) {
                    product.images[imageIndex].url = imageUrl;
                } else {
                    product.images.push({ image: index + 1, url: imageUrl });
                }
            }
        });

        await product.save();
        res.json({ success: true, message: "Product updated successfully." });
    });
});

// Delete a product
const deleteProduct = asyncHandler(async (req, res) => {
    const product = await Product.findByIdAndDelete(req.params.id);
    if (!product) {
        return res.status(404).json({ success: false, message: "Product not found." });
    }
    res.json({ success: true, message: "Product deleted successfully." });
});

export {
    getAllProducts,
    getProductById,
    createProduct,
    updateProduct,
    deleteProduct
};
