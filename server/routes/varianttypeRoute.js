import express from 'express';
import {
    getAllVariantTypes,
    getVariantTypeById,
    createVariantType,
    updateVariantType,
    deleteVariantType
} from '../controllers/varianttypeController.js';

const router = express.Router();

router.get('/', getAllVariantTypes);
router.get('/:id', getVariantTypeById);
router.post('/', createVariantType);
router.put('/:id', updateVariantType);
router.delete('/:id', deleteVariantType);

export default router;
