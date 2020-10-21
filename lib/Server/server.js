const express = require("express");

const mongoose = require("mongoose");

const bodyParser = require("body-parser");
const jwt = require("jsonwebtoken");

const app = express()

const PORT = 3000

app.listen(PORT, () => {

  console.log(`app is listening to PORT ${PORT}`)

})


mongoose.connect("mongodb://localhost:27017/mero", {
useCreateIndex: "true",
  useNewUrlParser: "true",
  useUnifiedTopology: "true"

})

mongoose.connection.on("error", err => {

  console.log("err", err)

})

mongoose.connection.on("connected", (err, res) => {

  console.log("mongoose is connected")

})

//this takes the post body
app.use(express.json({extended: false}))
//default route
app.get("/",(req,res)=>res.send("Default api route"));



//model

var uniqueValidator = require('mongoose-unique-validator');
var schema= new mongoose.Schema({
email:
{
type: String,
require: true,
},
password:{
type: String,
 require:true
 }
 });
var User = mongoose.model("User",schema);
//signup route api
app.post("/signup",async (req,res)=>{
const{email,password}=req.body;

let user = await User.findOne({email});
if(user){
return res.json({msg: "Email already taken !"});
}

user = new User({
email,
password
});
console.log(user);
await user.save();
var token =jwt.sign({id: user.id},"password");
res.json({token: token});
//token



//check db for email of email say email is already taken
//return res.send("Email already taken");
});
//


//
// login route api
app.post("/login", async (req, res) => {
  const { email, password } = req.body;
  console.log(email);

  let user = await User.findOne({ email });
  console.log(user);
  if(!user){
  return res.json({msg: "Email doesn't exist"});
  }
  if (user.password !== password) {
    return res.json({ msg: "password is not correct" });
  }
var token = jwt.sign({id: user.id},"password");
  return res.json({ token: token });
});
