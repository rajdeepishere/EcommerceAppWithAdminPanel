import mongoose from "mongoose";

const variantSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    variantTypeId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'VariantType',
        required: true
    }
},{ timestamps: true });

const varaint =  mongoose.model('Variant', variantSchema);
export default varaint
