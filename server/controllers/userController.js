import User from '../models/userModel.js';
import asyncHandler from 'express-async-handler';

// Get all users
const getAllUsers = asyncHandler(async (req, res) => {
    const users = await User.find();
    res.json({ success: true, message: "Users retrieved successfully.", data: users });
});

// Get user by ID
const getUserById = asyncHandler(async (req, res) => {
    const user = await User.findById(req.params.id);
    if (!user) {
        return res.status(404).json({ success: false, message: "User not found." });
    }
    res.json({ success: true, message: "User retrieved successfully.", data: user });
});

// Register user
const registerUser = asyncHandler(async (req, res) => {
    const {email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, message: "Name and password are required." });
    }

    const user = new User({ email, password });
    await user.save();

    res.json({ success: true, message: "User created successfully.", data: null });
});

// Login user
const loginUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user || user.password !== password) {
        return res.status(401).json({ success: false, message: "Invalid name or password." });
    }

    res.status(200).json({ success: true, message: "Login successful.", data: user });
});

// Update user
const updateUser = asyncHandler(async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, message: "Name and password are required." });
    }

    const updatedUser = await User.findByIdAndUpdate(
        req.params.id,
        { email, password },
        { new: true }
    );

    if (!updatedUser) {
        return res.status(404).json({ success: false, message: "User not found." });
    }

    res.json({ success: true, message: "User updated successfully.", data: updatedUser });
});

// Delete user
const deleteUser = asyncHandler(async (req, res) => {
    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser) {
        return res.status(404).json({ success: false, message: "User not found." });
    }

    res.json({ success: true, message: "User deleted successfully." });
});

export {
    getAllUsers,
    getUserById,
    registerUser,
    loginUser,
    updateUser,
    deleteUser
};
