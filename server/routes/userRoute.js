import express from 'express';
import {
    getAllUsers,
    getUserById,
    registerUser,
    loginUser,
    updateUser,
    deleteUser
} from '../controllers/userController.js';

const router = express.Router();

router.get('/', getAllUsers);
router.get('/:id', getUserById);
router.post('/register', registerUser);
router.post('/login', loginUser);
router.put('/:id', updateUser);
router.delete('/:id', deleteUser);

export default router;
