const express = require('express');
const router = express.Router();
const multer = require('multer'); // For handling file uploads

const ChatMessage = require('../models/ChatMessage');

// Multer configuration for handling audio file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './audio'); // Destination folder for storing audio files
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + '_' + Date.now() + '.mp3'); // Filename with timestamp
  }
});
const upload = multer({ storage: storage });

// Route for submitting audio messages
router.post('/submit-audio', upload.single('audio'), async (req, res) => {
  const { userEmail } = req.body;
  const audioFilePath = req.file.path;

  try {
    const newChatMessage = new ChatMessage({
      userEmail,
      messageType: 'audio',
      message: audioFilePath // Saving the file path of the audio message
    });
    await newChatMessage.save();
    res.status(200).send('Audio message uploaded successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error uploading audio message');
  }
});

// Route for submitting text messages
router.post('/submit-text', async (req, res) => {
  const { userEmail, message } = req.body;

  try {
    const newChatMessage = new ChatMessage({
      userEmail,
      messageType: 'text',
      message
    });
    await newChatMessage.save();
    res.status(200).send('Text message uploaded successfully');
  } catch (error) {
    console.error(error);
    res.status(500).send('Error uploading text message');
  }
});

module.exports = router;
