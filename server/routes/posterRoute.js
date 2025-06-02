import express from 'express';
import asyncHandler from 'express-async-handler';
import {
    getAllPosters,
    getPosterById,
    createPoster,
    updatePoster,
    deletePoster
} from '../controllers/posterController.js';

const router = express.Router();

router.get('/', asyncHandler(getAllPosters));
router.get('/:id', asyncHandler(getPosterById));
router.post('/', asyncHandler(createPoster));
router.put('/:id', asyncHandler(updatePoster));
router.delete('/:id', asyncHandler(deletePoster));

export default router;
