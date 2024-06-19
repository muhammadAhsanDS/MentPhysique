import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { auth } from '../../firebase.js';
import { doc, getDoc, updateDoc,setDoc } from 'firebase/firestore';
import { sendPasswordResetEmail } from 'firebase/auth';
import { db } from '../../firebase'; // Import your Firebase configuration
import { reauthenticateWithCredential, EmailAuthProvider } from 'firebase/auth'; // Import Firebase Auth methods
import passwordimg from '../Assets/changepassword.png';


import './ChangePassword.css';



const ChangePassword = () => {
  
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    cardNumber: '',
    selectDate: '',
    subscription: 'basic',
  });


  
  const [message, setMessage] = useState('');



  

  useEffect(() => {
    const userId = localStorage.getItem('userId');
    const userDocRef = doc(db, 'profiledata', userId);
    console.log(userId);

    getDoc(userDocRef)
      .then((docSnap) => {
        if (docSnap.exists()) {
          const userData = docSnap.data();
          console.log('neha');
          setFormData(userData);
        }
      })
      .catch((error) => {
        console.error('Error fetching user data:', error);
        setMessage('Error fetching user data');
      });
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };





  
  const handleSaveChanges = async () => {
    const user = auth.currentUser;
  
    if (user) {
      try {
        const userId = localStorage.getItem('userId');
        const userDocRef = doc(db, 'profiledata', userId);
        const userDoc = await getDoc(userDocRef);
  
        if (userDoc.exists()) {
          // If document exists, update existing fields and add new ones
          await updateDoc(userDocRef, {
            ...userDoc.data(), // Preserve existing fields
            name: formData.name,
            cardNumber: formData.cardNumber,
            selectDate: formData.selectDate,
            subscription: formData.subscription,
          });
        } else {
          // If document doesn't exist, create it with all the fields
          await setDoc(userDocRef, {
            email: formData.email,
            name: formData.name,
            cardNumber: formData.cardNumber,
            selectDate: formData.selectDate,
            subscription: formData.subscription,
          });
        }
  
        console.log('Profile updated successfully in Firestore');
        setMessage('Changes Saved Successfully');
      } catch (error) {
        console.error('Error updating profile:', error);
        setMessage('Error updating profile');
      }
    }
  };
  



 


  return (
    
<div className='resetpasspage'>

        <div className='resetheading'>
          <img src={passwordimg} alt="Setting Icon" />
           <h1>Change Password</h1>

          </div>


      <div className="resetpass-formprofile">
      
      <div className='resetpasscontent'> 

      <div className="message-box2">
        {message && <div className="message">{message}</div>} {/* Display common message */}
      </div>


<form className='resetpass-form'>
          
         
    <div className="form-group">
      <label htmlFor="password">New Password</label>
      <input
        type="password"
        id="password"
        name="password"
        value={formData.password}
        onChange={handleChange}
        required
      />
    </div>
    <div className="form-group">
      <label htmlFor="password">Confirm Password</label>
      <input
        type="password"
        id="password"
        name="confirm password"
        onChange={handleChange}
        required
      />
    </div>
   

 
          


          
          
          
         
        

          <button type="button" onClick={handleSaveChanges}>
            Submit
          </button>

         



        </form>

        </div>


      </div>

      </div> 
    
  );
};



export default ChangePassword;
