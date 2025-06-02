import Poster from '../models/posterModel.js';
import { uploadPosters } from '../utils/uploadFile.js';
import multer from 'multer';
import dotenv from 'dotenv';
dotenv.config();

export const getAllPosters = async (req, res) => {
    try {
        const posters = await Poster.find({});
        res.json({ success: true, message: "Posters retrieved successfully.", data: posters });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

export const getPosterById = async (req, res) => {
    try {
        const posterID = req.params.id;
        const poster = await Poster.findById(posterID);
        if (!poster) {
            return res.status(404).json({ success: false, message: "Poster not found." });
        }
        res.json({ success: true, message: "Poster retrieved successfully.", data: poster });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

export const createPoster = async (req, res) => {
    try {
        uploadPosters.single('img')(req, res, async function (err) {
            if (err instanceof multer.MulterError) {
                if (err.code === 'LIMIT_FILE_SIZE') {
                    err.message = 'File size is too large. Maximum filesize is 5MB.';
                }
                return res.json({ success: false, message: err });
            } else if (err) {
                return res.json({ success: false, message: err });
            }

            const { posterName } = req.body;
            let imageUrl = 'no_url';
            if (req.file) {
                imageUrl = `${process.env.SERVER_IP}/image/poster/${req.file.filename}`;
            }

            if (!posterName) {
                return res.status(400).json({ success: false, message: "Name is required." });
            }

            const newPoster = new Poster({ posterName, imageUrl });
            await newPoster.save();
            res.json({ success: true, message: "Poster created successfully.", data: null });
        });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
};

export const updatePoster = async (req, res) => {
    try {
        const posterID = req.params.id;
        uploadPosters.single('img')(req, res, async function (err) {
            if (err instanceof multer.MulterError) {
                if (err.code === 'LIMIT_FILE_SIZE') {
                    err.message = 'File size is too large. Maximum filesize is 5MB.';
                }
                return res.json({ success: false, message: err.message });
            } else if (err) {
                return res.json({ success: false, message: err.message });
            }

            const { posterName } = req.body;
            let image = req.body.image;

            if (req.file) {
                image = `${process.env.SERVER_IP}/image/poster/${req.file.filename}`;
            }

            if (!posterName || !image) {
                return res.status(400).json({ success: false, message: "Name and image are required." });
            }

            const updatedPoster = await Poster.findByIdAndUpdate(
                posterID,
                { posterName, imageUrl: image },
                { new: true }
            );

            if (!updatedPoster) {
                return res.status(404).json({ success: false, message: "Poster not found." });
            }

            res.json({ success: true, message: "Poster updated successfully.", data: null });
        });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
};

export const deletePoster = async (req, res) => {
    const posterID = req.params.id;
    try {
        const deletedPoster = await Poster.findByIdAndDelete(posterID);
        if (!deletedPoster) {
            return res.status(404).json({ success: false, message: "Poster not found." });
        }
        res.json({ success: true, message: "Poster deleted successfully." });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};
