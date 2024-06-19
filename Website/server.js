const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const app = express();
const port = 3001;

app.use(cors());
mongoose.connect('mongodb://127.0.0.1:27017/mentphysique', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const userSchema = new mongoose.Schema({
fullName: String,
  email: String,
  password: String,
  age: Number,
  country: String,
  weight: Number,
  height: Number,
});

const User = mongoose.model('User', userSchema);



const workoutDataSchema = new mongoose.Schema({
    name: String,
    duration_minutes: Number,
    calories_per_hour: Number,
    total_calories: Number,
    date: String,
    email: String,
  });
  const WorkoutData = mongoose.model('WorkoutData', workoutDataSchema);



const calorieDataSchema = new mongoose.Schema({
    description: String,
    calories: Number,
    carbs: Number,
    fat: Number,
    protein: Number,
    quantity: Number,
    verified: Boolean,
    standardServingSize: String,
    date: String,
    email: String,
  });
  
  const CalorieData = mongoose.model('CalorieData', calorieDataSchema);


 
  const depressionDataSchema = new mongoose.Schema({
    totalScore: Number,
    severity: String,
    date: String,
    email: String,
  });
  const DepressionData = mongoose.model('DepressionData', depressionDataSchema);


  const anxietyDataSchema = new mongoose.Schema({
    totalScore: Number,
    severity: String,
    date: String,
    email: String,
  });
  const AnxietyData = mongoose.model('AnxietyData', anxietyDataSchema);


app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Check email availability
app.post('/check-email', async (req, res) => {
  const { email } = req.body;
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    res.status(400).send('Email already exists');
  } else {
    res.status(200).send('Email is available');
  }
});

// Registration endpoint
app.post('/api/register', async (req, res) => {
  console.log("neha");  
  const {
    fullName,
    email,
    password,
    age,
    country,
    weight,
    height,
  } = req.body;

  // Check if email is already registered
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    res.status(400).json({ success: false, message: 'Email already exists' });
    return;
  }

  // Hash the password before saving it in the database
  const hashedPassword = await bcrypt.hash(password, 10);

  // Hash the security question answers before saving them
  //const hashedSecurityQuestion1 = await bcrypt.hash(securityQuestion1, 10);
  //const hashedSecurityQuestion2 = await bcrypt.hash(securityQuestion2, 10);

  const newUser = new User({
    fullName,
    email,
    password: hashedPassword,
    age,
    country,
    weight,
    height,
  });

  try {
    await newUser.save();
    res.status(200).json({ success: true, message: 'User registered successfully' });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Error registering user' });
  }
});




// Login endpoint
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
  
    const user = await User.findOne({ email });
  
    if (user) {
      
       

      // Compare the provided password with the hashed password in the database
      const isPasswordMatch = await bcrypt.compare(password, user.password);
       
  
      if (isPasswordMatch) {
        // Password is correct
        res.status(200).json({ success: true, message: 'Login successful' });
      } else {
        // Password is incorrect
        res.status(401).json({ success: false, message: 'Invalid email or password' });
      }
    } else {
      // User not found
      res.status(401).json({ success: false, message: 'Invalid email or password' });
    }
    
  });
  


 // Fetch user profile by email
app.get('/api/user-profile/:email', async (req, res) => {
    const { email } = req.params;
  
    try {
      const user = await User.findOne({ email });
  
      if (!user) {
        return res.status(404).json({ success: false, message: 'User not found' });
      }
  
      res.status(200).json({ success: true, user });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error fetching user profile' });
    }
  });
  
  // Update user profile by email
  app.put('/api/user-profile/:email', async (req, res) => {
    const { email } = req.params;
   // console.log(email);
    const { fullName, age, country, weight, height, password } = req.body;
  
    try {
      const user = await User.findOne({ email });
  
      if (!user) {
        return res.status(404).json({ success: false, message: 'User not found' });
      }
  
      if (fullName) user.fullName = fullName;
      if (age) user.age = age;
      if (country) user.country = country;
      if (weight) user.weight = weight;
      if (height) user.height = height;
      if (password) user.password = await bcrypt.hash(password, 10);
  
      await user.save();
      res.status(200).json({ success: true, message: 'Profile updated successfully' });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error updating user profile' });
    }
  });
  
   



 
// Endpoint to save calorie data
app.post('/save-calorie-data', async (req, res) => {
    const calorieData = new CalorieData(req.body);
  
    try {
      await calorieData.save();
      res.status(200).json({ success: true, message: 'Calorie data saved successfully' });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error saving calorie data' });
    }
  });


  app.delete('/delete-calorie-data', async (req, res) => {
    const { description, email } = req.body;
  
    try {
      await CalorieData.deleteOne({ description, email });
      res.status(200).json({ success: true, message: 'Calorie data deleted successfully' });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error deleting calorie data' });
    }
  });
  



  app.post('/save-workout-data', async (req, res) => {
    const workoutData = new WorkoutData(req.body);
  
    try {
      await workoutData.save();
      res.status(200).json({ success: true, message: 'Workout data saved successfully' });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error saving workout data' });
    }
  });
  
  app.delete('/delete-workout-data', async (req, res) => {
    const { name, email } = req.body;
  
    try {
      await WorkoutData.deleteOne({ name, email });
      res.status(200).json({ success: true, message: 'Workout data deleted successfully' });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error deleting workout data' });
    }
  });




 // New endpoint to save depression level data
app.post('/save-depression-level', async (req, res) => {
    const depressionData = new DepressionData(req.body);
  
    try {
      await depressionData.save();
      res.status(200).json({ success: true, message: 'Depression level data saved successfully' });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error saving depression level data' });
    }
  });
  
  // New endpoint to get the latest depression level data
  app.get('/latest-depression-level/:email', async (req, res) => {
    const { email } = req.params;
  
    try {
      const latestDepressionData = await DepressionData.findOne({ email }).sort({ date: -1 }).limit(1);
      if (!latestDepressionData) {
        return res.status(404).json({ success: false, message: 'No depression level data found' });
      }
      res.status(200).json({ success: true, data: latestDepressionData });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error fetching latest depression level data' });
    }
  });
   



// New endpoint to save anxiety level data
app.post('/save-anxiety-level', async (req, res) => {
    const anxietyData = new AnxietyData(req.body);
  
    try {
      await anxietyData.save();
      res.status(200).json({ success: true, message: 'Anxiety level data saved successfully' });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error saving anxiety level data' });
    }
  });
  
  // New endpoint to get the latest anxiety level data
  app.get('/latest-anxiety-level/:email', async (req, res) => {
    const { email } = req.params;
  
    try {
      const latestAnxietyData = await AnxietyData.findOne({ email }).sort({ date: -1 }).limit(1);
      if (!latestAnxietyData) {
        return res.status(404).json({ success: false, message: 'No anxiety level data found' });
      }
      res.status(200).json({ success: true, data: latestAnxietyData });
    } catch (error) {
      res.status(500).json({ success: false, message: 'Error fetching latest anxiety level data' });
    }
  });

  


app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
