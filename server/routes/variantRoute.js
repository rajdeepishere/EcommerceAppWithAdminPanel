import express from 'express';
import {
    getAllVariants,
    getVariantById,
    createVariant,
    updateVariant,
    deleteVariant
} from '../controllers/variantController.js';

const router = express.Router();

router.get('/', getAllVariants);
router.get('/:id', getVariantById);
router.post('/', createVariant);
router.put('/:id', updateVariant);
router.delete('/:id', deleteVariant);

export default router;
