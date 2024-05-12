import express from 'express'
import { DBconnection } from './DB/connection.js';
import * as routers from './Modules/index.routes.js';

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
DBconnection();

app.use('/user' , routers.userRouter);
app.use('/restaurant' , routers.restaurantRouter);
app.use('/product' , routers.productRouter);

app.all('*', (req , res , next)=>{  //or app.use
  res.status(404).send('<h3> 404 NOT FOUND </h3>')
})

app.use((err,req , res , next)=>{
  if(err){
      // cause --> carry status
      res.status(err['cause']||500).json({Message: err.message});
  }
})

app.listen(PORT, "0.0.0.0", () => {
  console.log(`App listening on port ${PORT}`);
});
