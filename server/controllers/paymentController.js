import dotenv from 'dotenv';
dotenv.config();

export const getRazorpayKey = async (req, res) => {
  try {
    console.log('razorpay');
    const razorpayKey = process.env.RAZORPAY_KEY_TEST;
    res.json({ key: razorpayKey });
  } catch (error) {
    console.log(error.message);
    res.status(500).json({ error: true, message: error.message, data: null });
  }
};
