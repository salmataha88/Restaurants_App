import mongoose from 'mongoose';

// Connect MongoDB at default port 27017.
export const DBconnection = async()=> {
    return await mongoose.connect('mongodb://localhost:27017/RestaurantsDB')
    .then((res)=> console.log("DB CONNECTION SUCCESS"))
    .catch((err)=> console.log("DB CONNECTION FAIL" , err))
}
