import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import mongoose from 'mongoose';
import expressAsyncHandler from 'express-async-handler';
import dotenv from 'dotenv';
import categoryRoutes from './routes/categoryRoute.js';
import subCategoryRoutes from './routes/subcategoryRoute.js';
import brandRoutes from './routes/brandRoute.js';
import variantTypeRoutes from './routes/varianttypeRoute.js';
import variantRoutes from './routes/variantRoute.js';
import productRoutes from './routes/productRoute.js';
import couponCodeRoutes from './routes/couponCodeRoute.js';
import posterRoutes from './routes/posterRoute.js';
import userRoutes from './routes/userRoute.js';
import orderRoutes from './routes/orderRoute.js';
import paymentRoutes from './routes/paymentRoute.js';
import notificationRoutes from './routes/notificationRoute.js';
dotenv.config();

const app = express();
//Middle ware
app.use(cors({ origin: '*' }))
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));

//? setting static folder path
app.use('/image/products', express.static('public/products'));
app.use('/image/category', express.static('public/category'));
app.use('/image/poster', express.static('public/posters'));

const URL = process.env.MONGO_URL;
mongoose.connect(URL);
const db = mongoose.connection;
db.on('error', (error) => console.error(error));
db.once('open', () => console.log('Connected to Database'));

// Routes
app.use('/categories', categoryRoutes);
app.use('/subCategories', subCategoryRoutes);
app.use('/brands', brandRoutes);
app.use('/variantTypes', variantTypeRoutes);
app.use('/variants', variantRoutes);
app.use('/products', productRoutes);
app.use('/couponCodes', couponCodeRoutes);
app.use('/posters', posterRoutes);
app.use('/users', userRoutes);
app.use('/orders', orderRoutes);
app.use('/payment', paymentRoutes);
app.use('/notification', notificationRoutes);


// Example route using asyncHandler directly in app.js
app.get('/', expressAsyncHandler(async (req, res) => {
    res.json({ success: true, message: 'API working successfully', data: null });
}));

// Global error handler
app.use((error, req, res, next) => {
    res.status(500).json({ success: false, message: error.message, data: null });
});


app.listen(process.env.PORT, () => {
    console.log(`Server running on port ${process.env.PORT}`);
});


