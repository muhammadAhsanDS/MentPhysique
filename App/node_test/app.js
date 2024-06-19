const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const multer = require('multer');
const bcrypt = require('bcrypt'); // Import the bcrypt library
const fs = require('fs');
const path = require('path');
const app = express();
const audioConverter = require('audio-converter'); 
const port = 3000;

app.use(cors());
mongoose.connect('mongodb://127.0.0.1:27017/mentphysique', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
const workoutSchema = new mongoose.Schema({
  
  rowData: mongoose.Schema.Types.Mixed, // Use Mixed type for dynamic data
});

// Define the model for workout data based on the schema
const avatarSchema = new mongoose.Schema({
  email: String,
  avatarUrl: String
});

// Define the model for avatar data
const Avatar = mongoose.model('Avatar', avatarSchema);
const Workout = mongoose.model('Workout', workoutSchema);
const calorieSchema = new mongoose.Schema({
  rowData: mongoose.Schema.Types.Mixed, // Use Mixed type for dynamic data
});

// Define the model for workout data based on the schema
const Calorie = mongoose.model('Calorie', calorieSchema);
const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
  age: Number,
  country: String,
  gender:String,
  weight: Number,
  height: Number,
  securityQuestion1: String,
  securityQuestion2: String,
});

const User = mongoose.model('User', userSchema);
const feedbackSchema = new mongoose.Schema({
  email: String,
  experience: String,
  satisfactionLevel: String,
  signUpNavigation: String,
  additionalComments: String,
});

const Feedback = mongoose.model('Feedback', feedbackSchema);
const mentalHealthSchema = new mongoose.Schema({
  concern: String,
  severity: String,
  email: String,
  date: Date,
});
const alertSchema = new mongoose.Schema({
  name: String,
  date: Date,
  time: String,
  viaEmail: Boolean,
  viaAlert: Boolean,
  email: String, // Add email field to associate alerts with users
});
const Alert = mongoose.model('Alert', alertSchema);
const reportSchema = new mongoose.Schema({
  email: String,
  problem: String,
});

// Create model based on schema
const Report = mongoose.model('Report', reportSchema);
// now for subscrpition schema
const subscriptionSchema = new mongoose.Schema({
  name: String,
  email: String,
  plan: String,
  cardNumber: String,
  cvv: String,
  expiryDate: String,
});
const Subscription = mongoose.model('Subscription', subscriptionSchema);
// Create a new model for the mental health assessment
const MentalHealth = mongoose.model('MentalHealth', mentalHealthSchema);
const weightSchema = new mongoose.Schema({
  email: String,
  weight: Number,
  type: String,
  duration: Number,
  intensity: String,
  meal: String,
  protein: Number,
  carbs: Number,
  fat: Number,
  date: Date,
  emotion: String,
  emotion_intensity_level: String,
  mental_health_identified_concern: String,
  concern_severity_level: String,
  concern_severity_anx: String,
  recommend_game: String,
  spend_play_time:Number,
  impact_on_mood: String,
  emotions: String,
  calories_burn: Number,
});


// Create a model based on the schema
const Weight = mongoose.model('Weight', weightSchema);
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

// Login endpoint
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });

  if (user) {
    // Compare the provided password with the hashed password in the database
    const isPasswordMatch = await bcrypt.compare(password, user.password);

    if (isPasswordMatch) {
      // Password is correct
      res.status(200).send('Login successful');
    } else {
      // Password is incorrect
      res.status(401).send('Invalid email or password');
    }
  } else {
    // User not found
    res.status(401).send('Invalid email or password');
  }
});
app.post('/submit-report', async (req, res) => {
  const { email,problem } = req.body;

  // Validate request data
  if (!problem) {
    return res.status(400).json({ error: 'Problem field is required' });
  }

  // Save report to MongoDB
  try {
    const newReport = new Report({
      email,
      problem,
    });
    await newReport.save();
    return res.status(200).json({ message: 'Report submitted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Failed to submit report' });
  }
});
app.post('/submit-subs', async (req, res) => {
  const { name, email, plan, cardNumber,cvv, expiryDate } = req.body;
  const hashedcvv = await bcrypt.hash(cvv, 10);
  const hashedcardNumber = await bcrypt.hash(cardNumber, 10);


  // Save subscription to MongoDB
  try {
    const newSubscription = new Subscription({
      name,
      email,
      plan,
      cardNumber:hashedcardNumber,
      cvv:hashedcvv,
      expiryDate,
    });
    await newSubscription.save();
    return res.status(200).json({ message: 'Subscription submitted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Failed to submit subscription' });
  }
}
);
app.post('/save-avatar', async (req, res) => {
  const { email, avatarUrl } = req.body;

  try {
    // Check if an avatar entry for the email already exists
    let existingAvatar = await Avatar.findOne({ email });

    if (existingAvatar) {
      // If an avatar entry already exists, update the avatar URL
      existingAvatar.avatarUrl = avatarUrl;
      await existingAvatar.save();
    } else {
      // If no avatar entry exists, create a new one
      const newAvatar = new Avatar({ email, avatarUrl });
      await newAvatar.save();
    }

    res.status(200).json({ message: 'Avatar URL saved successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
//now we fetch the avatar url
app.get('/get-avatar/:email', async (req, res) => {
  const email = req.params.email;
//now we check if the avatar exists
  try {
    const avatar = await Avatar.findOne({ email });  
    if (avatar) {
      res.status(200).json({ avatarUrl: avatar.avatarUrl });
    } else {
      res.status(404).send('Avatar not found');
    }
  } catch (error) {
    res.status(500).send('Error fetching avatar');
  }
});
  

// Create Alert endpoint
app.post('/create-alert', async (req, res) => {
  const { name, date, time, viaEmail, viaAlert, email } = req.body;

  // Validate request data
  if (!name || !date || !time || (!viaEmail && !viaAlert) || !email) {
    return res.status(400).json({ error: 'Invalid data' });
  }

  // Save alert to MongoDB
  try {
    const newAlert = new Alert({
      name,
      date,
      time,
      viaEmail,
      viaAlert,
      email, // Associate alert with user by storing user's email
    });
    await newAlert.save();
    return res.status(200).json({ message: 'Alert created successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'Failed to create alert' });
  }
});

// Fetch User Alerts endpoint
app.get('/get-user-alerts', async (req, res) => {
  const { email } = req.query;

  try {
    const userAlerts = await Alert.find({ email });
    res.status(200).json(userAlerts);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch user alerts' });
  }
});
app.delete('/delete-alert/:id', async (req, res) => {
  const { id } = req.params;

  try {
    await Alert.findByIdAndDelete(id);
    res.status(200).json({ message: 'Alert deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to delete alert' });
  }
});

app.post('/store-mental-health', async (req, res) => {
  const { concern, severity, email } = req.body;

  try {
    const newMentalHealthData = new MentalHealth({
      concern,
      severity,
      email,
      date: new Date(),
    });

    await newMentalHealthData.save();
    res.status(200).send('Mental health assessment result stored successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error storing mental health assessment result');
  }
});
app.post('/register', async (req, res) => {
  print("New user registered");
  const {
    name,
    email,
    password,
    age,
    country,
    gender,
    weight,
    height,
    securityQuestion1,
    securityQuestion2,
  } = req.body;

  // Check if email is already registered
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    res.status(400).send('Email already exists');
    return;
  }

  // Hash the password before saving it in the database
  const hashedPassword = await bcrypt.hash(password, 10);

  // Hash the security question answers before saving them
  const hashedSecurityQuestion1 = await bcrypt.hash(securityQuestion1, 10);
  const hashedSecurityQuestion2 = await bcrypt.hash(securityQuestion2, 10);

  const newUser = new User({
    name,
    email,
    password: hashedPassword,
    age,
    country,
    gender,
    weight,
    height,
    securityQuestion1: hashedSecurityQuestion1,
    securityQuestion2: hashedSecurityQuestion2,
  });

  try {
    await newUser.save();
    res.status(200).send('User registered successfully');
  } catch (err) {
    res.status(500).send('Error registering user');
  }
});
// Add this schema at the beginning of your app.js file
const inputSchema = new mongoose.Schema({
  text: String,
  email: String,
});

const Input = mongoose.model('Input', inputSchema);
const emotiondetection = new mongoose.Schema({
  emotion: String,
  email: String,
  Date: String,
});

const emotions = mongoose.model('Emotion', emotiondetection);

const audioSchema = new mongoose.Schema({
  filename: String,
  data: Buffer,
});

const Audio = mongoose.model('Audio', audioSchema);

const upload = multer({ dest: 'uploads/' });

app.post('/upload-audio', upload.single('audio'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).send('No file uploaded');
    }

    const { originalname, path: filePath } = req.file;

    // Convert the audio file to WAV format
    const wavFilePath = await audioConverter.convert({
      source: filePath,
      target: 'wav',
    });

    // Read the WAV file as a buffer
    const data = fs.readFileSync(wavFilePath);

    // Check if the original filename already exists in the database
    let existingAudios = await Audio.find({ filename: originalname });
    let filename = originalname;
    if (existingAudios.length > 0) {
      // If the filename already exists, increment the filename
      const lastUpdatedOriginalname = existingAudios[existingAudios.length - 1].filename;
      const [baseName, extension] = lastUpdatedOriginalname.split('.');
      const index = baseName.match(/\d+$/) ? parseInt(baseName.match(/\d+$/)[0]) + 1 : 1;
      filename = `${baseName}${index}.${extension}`;
    }

    // Create a new Audio document and save it to the database
    const newAudio = new Audio({
      filename: filename,
      data: data,
    });

    await newAudio.save();

    // Remove the temporary WAV file
    fs.unlinkSync(wavFilePath);

    // Remove the temporary MP3 file
    fs.unlinkSync(filePath);

    return res.status(200).send('Audio uploaded and converted to WAV successfully');
  } catch (error) {
    console.error(error);
    return res.status(500).send('Error uploading audio');
  }
});// Add a new endpoint to handle text submission
app.post('/submit-text', async (req, res) => {
  const { email,text } = req.body;

  try {
    const inputData = new Input({ email,text });
        await inputData.save();
    res.status(200).send('Data submitted successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error submitting data');
  }
});
app.post('/submit-emotions', async (req, res) => {
  const { email,emotion,Date } = req.body;

  try {
    const inputData = new emotions({ email,emotion ,Date});
        await inputData.save();
    res.status(200).send('Data submitted successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error submitting data');
  }
});

// Update user profile based on email
app.put('/update-profile/:email', async (req, res) => {
  const email = req.params.email;
  const updatedProfile = req.body;

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).send('User not found');
    }

    // Update only the fields that are provided in the request body
    for (const field in updatedProfile) {
      if (field === 'password') {
        // If 'password' field is provided, hash it before updating
        const hashedPassword = await bcrypt.hash(updatedProfile[field], 10);
        user[field] = hashedPassword;
      } else if (updatedProfile[field] !== undefined) {
        user[field] = updatedProfile[field];
      }
    }

    await user.save();
    res.status(200).send('Profile updated successfully');
  } catch (error) {
    res.status(500).send('Error updating user profile');
  }
});
app.post('/feedback', (req, res) => {
  const { email, experience, satisfactionLevel, signUpNavigation, additionalComments } = req.body;

  // Check if all necessary fields are present
  if (!email || !experience || !satisfactionLevel || !signUpNavigation) {
    return res.status(400).json({ error: 'Please provide all necessary fields' });
  }

  // Save feedback data to MongoDB
  const feedback = new Feedback({
    email,
    experience,
    satisfactionLevel,
    signUpNavigation,
    additionalComments,
  });

  feedback.save()
  .then(result => {
      console.log('User saved successfully:', result);
      res.status(200).send('User saved successfully');
  })
  .catch(err => {
      console.error(err);
      res.status(500).send('Error saving user');
  });
});

app.post('/forgot-password', async (req, res) => {
  const { email, securityQuestion1, securityQuestion2 } = req.body;

  const user = await User.findOne({ email });

  if (!user) {
    return res.status(400).send('Incorrect Email');
  }

  // Compare the provided answers with the hashed answers in the database
  const isSecurityQuestion1Match = await bcrypt.compare(
    securityQuestion1,
    user.securityQuestion1
  );
  const isSecurityQuestion2Match = await bcrypt.compare(
    securityQuestion2,
    user.securityQuestion2
  );

  if (!isSecurityQuestion1Match || !isSecurityQuestion2Match) {
    return res.status(400).send('Incorrect Answers');
  }

  // Email and answers are correct, send a password reset link or provide further steps.
  res.status(200).send('Success');
});
// Add this route to handle input data submission
app.post('/submit-input', async (req, res) => {
  const { text } = req.body;

  // You should replace 'Input' with the actual name of your collection
  const inputCollection = mongoose.model('Input', mongoose.Schema({ text: String }));
  
  try {
    const inputData = new inputCollection({ text });
    await inputData.save();
    res.status(200).send('Data submitted successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error submitting data');
  }
});

app.post('/check-username', async (req, res) => {
  const { username } = req.body;

  const existingUser = await User.findOne({ name: username });

  if (existingUser) {
    res.status(400).send('Username already exists');
  } else {
    res.status(200).send('Username is available');
  }
});

// Add a new endpoint to fetch user data based on email
app.get('/user/:email', async (req, res) => {
  const email = req.params.email;
  const user = await User.findOne({ email });

  if (user) {
    // User found, send the user details
    res.status(200).json(user);
  } else {
    // User not found
    res.status(404).send('User not found');
  }
});
// Update user password based on email
app.put('/update-password/:email', async (req, res) => {
  const email = req.params.email;
  const newPassword = req.body.password; // Assuming the password is sent in the request body

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).send('User not found');
    }

    // Update the user's password
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;

    await user.save();
    res.status(200).send('Password updated successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error updating password');
  }
});
// Add a new endpoint to fetch username based on email
app.get('/get-username/:email', async (req, res) => {
  const email = req.params.email;
  try {
    const user = await User.findOne({ email });
    if (user) {
      res.status(200).json({ username: user.name });
    } else {
      res.status(404).send('User not found');
    }
  } catch (error) {
    res.status(500).send('Error fetching username');
  }
});

app.get('/get-weight-data/:email', async (req, res) => {
  const email = req.params.email;
  
  try {
    const weightData = await Weight.find({ email: email });
    res.status(200).json(weightData);
  } catch (error) {
    res.status(500).send('Error fetching weight data');
  }
});

app.post('/saveData', async (req, res) => {
  const rowData = req.body;
  
  try {
    // Create a new workout instance using the Workout model
    const newWorkout = new Workout({
      rowData: rowData,
    });

    // Save the new workout instance to MongoDB
    await newWorkout.save();
    console.log('Data saved successfully');
    res.status(200).send('Data saved successfully');
  } catch (err) {
    console.error('Error saving data:', err);
    res.status(500).send('Error saving data');
  }
});
app.post('/saveData1', async (req, res) => {
  const rowData = req.body;
  
  try {
    // Create a new workout instance using the Workout model
    const newCalorie = new Calorie({
      rowData: rowData,
    });

    // Save the new workout instance to MongoDB
    await newCalorie.save();
    console.log('Data saved successfully');
    res.status(200).send('Data saved successfully');
  } catch (err) {
    console.error('Error saving data:', err);
    res.status(500).send('Error saving data');
  }
});

app.listen(port, '192.168.0.106', () => {
  console.log(`Server is running on IP: 192.168.0.106, port ${port}`);
});
