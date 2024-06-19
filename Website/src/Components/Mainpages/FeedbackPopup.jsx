import React, { useState } from 'react';
import { db } from '../../firebase'; // Import your Firebase instance
import { collection, addDoc } from 'firebase/firestore'; // Import Firestore functions
import { doc, getDoc, updateDoc, setDoc } from 'firebase/firestore';
import './FeedbackPopup.css'; // Add your CSS file for styling

const FeedbackPopup = ({ onClose, onSubmit }) => {
  const [selectedEmoji, setSelectedEmoji] = useState('');
  const [question1Answer, setQuestion1Answer] = useState('');
  const [question2Answer, setQuestion2Answer] = useState('');
  const [additionalComment, setAdditionalComment] = useState('');

  

  


  


  const handleSubmit = async () => {
    // Get the selected emoji label
    const selectedEmojiLabel = emojiLabels[selectedEmoji];
  
    // Prepare feedback data
    const feedbackData = {
      emoji: selectedEmojiLabel,
      question1: question1Answer,
      question2: question2Answer,
      comment: additionalComment,
    };
  
    try {
      // Retrieve user ID from local storage
      const userId = localStorage.getItem('userId');
      
      // Check if the document already exists for the user
      const docRef = doc(db, 'feedbackdata', userId);
      const docSnap = await getDoc(docRef);
  
      if (docSnap.exists()) {
        // If the document exists, update the existing document with new feedback data
        await setDoc(docRef, {
          ...docSnap.data(),
          feedback: feedbackData
        });
        console.log('Feedback updated for user ID: ', userId);
      } else {
        // If the document doesn't exist, create a new document with the user ID and feedback data
        await setDoc(docRef, {
          feedback: feedbackData
        });
        console.log('Feedback submitted for user ID: ', userId);
      }
    } catch (error) {
      console.error('Error adding/updating feedback: ', error);
    }
  
    // Close the feedback popup
    onClose();
  };
  
  






  const emojis = ['😊', '😐', '😕', '😞', '😡']; // Black and white emojis
  const emojiLabels = ['Happy', 'Neutral', 'Unhappy', 'Disappointed', 'Angry'];

  return (
    <div className="feedback-popup-overlay">
      <div className="feedback-popup">
        <span className="close" onClick={onClose}>&times;</span>
        <h2>Give Feedback</h2>
        <div className="emoji-container">
          {/* Render emojis */}
          {emojis.map((emoji, index) => (
            <div key={index} className="emoji-item" onClick={() => setSelectedEmoji(index)}>
              <span className={`emoji ${selectedEmoji === index ? 'selected' : ''}`}>{emoji}</span>
              <span className={`emoji-label ${selectedEmoji === index ? 'selected-label' : ''}`}>{emojiLabels[index]}</span>
            </div>
          ))}
        </div>

        {/* Question 1 Container */}
        <div className="question-container" style={{ backgroundColor: '#A5E0DD' }}>
          <p>How satisfied are you with the profile management features?</p>
          <div className="radio-options">
            <label>
              <input
                type="radio"
                value="Very satisfied"
                checked={question1Answer === 'Very satisfied'}
                onChange={() => setQuestion1Answer('Very satisfied')}
              />
              Very satisfied
            </label>
            <label>
              <input
                type="radio"
                value="Satisfied"
                checked={question1Answer === 'Satisfied'}
                onChange={() => setQuestion1Answer('Satisfied')}
              />
              Satisfied
            </label>
            <label>
              <input
                type="radio"
                value="Neutral"
                checked={question1Answer === 'Neutral'}
                onChange={() => setQuestion1Answer('Neutral')}
              />
              Neutral
            </label>
            <label>
              <input
                type="radio"
                value="Dissatisfied"
                checked={question1Answer === 'Dissatisfied'}
                onChange={() => setQuestion1Answer('Dissatisfied')}
              />
              Dissatisfied
            </label>
            <label>
              <input
                type="radio"
                value="Very dissatisfied"
                checked={question1Answer === 'Very dissatisfied'}
                onChange={() => setQuestion1Answer('Very dissatisfied')}
              />
              Very dissatisfied
            </label>
          </div>
        </div>

        {/* Question 2 Container */}
        <div className="question-container" style={{ backgroundColor: '#A5E0DD' }}>
          <p>Did you find the sign-up and login process easy to navigate?</p>
          <div className="radio-options">
            <label>
              <input
                type="radio"
                value="Yes"
                checked={question2Answer === 'Yes'}
                onChange={() => setQuestion2Answer('Yes')}
              />
              Yes
            </label>
            <label>
              <input
                type="radio"
                value="No"
                checked={question2Answer === 'No'}
                onChange={() => setQuestion2Answer('No')}
              />
              No
            </label>
          </div>
        </div>

        <div className='comment'>
          <p></p>
          <textarea value={additionalComment} onChange={(e) => setAdditionalComment(e.target.value)} placeholder="Add comments" />
        </div>

        <div className='feedbacksubmit'>
          <button onClick={handleSubmit}>Submit</button>
        </div>

      </div>
    </div>
  );
};

export default FeedbackPopup;
