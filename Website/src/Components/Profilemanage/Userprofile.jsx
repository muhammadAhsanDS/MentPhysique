import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { auth } from '../../firebase.js';
import { doc, getDoc, updateDoc } from 'firebase/firestore';
import { sendPasswordResetEmail } from 'firebase/auth';
import { db } from '../../firebase'; // Import your Firebase configuration
import { reauthenticateWithCredential, EmailAuthProvider } from 'firebase/auth'; // Import Firebase Auth methods
import editicon from '../Assets/Edit.png';
import AvatarSelectionModal from './AvatarSelectionModal';
import Sidebar from '../Mainpages/Sidebar.jsx'; 

import { useAvatar } from '../../AvatarContext.js';

import './Userprofile.css';

import usericon from '../Assets/userprofileicon.png';

const Userprofile = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    country: '',
    age: '',
    height: '',
    weight: '',
  });


  const [isModalOpen, setIsModalOpen] = useState(false);
//  const [selectedAvatar, setSelectedAvatar] = useState(null);
  const [message, setMessage] = useState('');

  const { setSelectedAvatar } = useAvatar();
  const [selectedAvatar, setSelectedAvatarLocally] = useState(null);


  

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
        // You can update other fields in the Firestore document here if needed
        const userId = localStorage.getItem('userId');
        const userDocRef = doc(db, 'profiledata', userId);

        await updateDoc(userDocRef, {
          fullName: formData.fullName,
          country: formData.country,
          age: formData.age,
          height: formData.height,
          weight: formData.weight,
        });

        console.log('Profile updated successfully in Firestore');
       // navigate('/profile');
        setMessage('Changes Saved Successfully');
      } catch (error) {
        console.error('Error updating profile:', error);
        setMessage('Error updating profile');
      }
    }


  };



  const handleAvatarSelect = (avatar) => {
    setSelectedAvatar(avatar); // Update avatar in context
    setSelectedAvatarLocally(avatar); // Update locally for immediate feedback
    localStorage.setItem('selectedAvatar', avatar); // Optionally, save to local storage
  };


  useEffect(() => {
    // Retrieve selectedAvatar from local storage
    const selectedAvatar = localStorage.getItem('selectedAvatar');
    setSelectedAvatar(selectedAvatar);
    setSelectedAvatarLocally(selectedAvatar);
  }, []);


  return (
    
      <div className="sign-up-formprofile">
      
      <div className='insidecontent'> 

      <div className="message-box1">
        {message && <div className="message">{message}</div>} {/* Display common message */}
      </div>

        <h2> 
          
        <div className="avatar-selection" onClick={() => setIsModalOpen(true)}>
          <div className="avatar-circle">
            
            {selectedAvatar ? (
              <img src={selectedAvatar } alt="Selected Avatar" />
            ) 
            : 
            (
              <span>Select Avatar</span>
            )}
            
          </div>
        </div>


        <img src={editicon} alt="Icon" className="editiconclass" /></h2>
        <form>
          
        <div className="form-row">

        <div className="form-group">
              <label htmlFor="fullName">User Name</label>
              <input
                type="text"
                id="fullName"
                name="fullName"
                value={formData.fullName}
                onChange={handleChange}
                required
              />
           

             </div>


             <div className="form-group">
            <label htmlFor="country">Country</label>
            <input
             type="text"  // Change this to "text"
             id="country"
             name="country"
             value={formData.country}
             onChange={handleChange}
             required
            />
           
        </div>

          </div>

          <div className="form-row">

          <div className="form-group">
            <label htmlFor="age">Age</label>
            <input
              type="age"
              id="age"
              name="age"
              value={formData.age}
              onChange={handleChange}
              required
            />
            
          </div>
          


          
          <div className="form-group">
            <label htmlFor="height">Height</label>
            <input
              type="number"
              id="height"
              name="height"
              value={formData.height}
              onChange={handleChange}
              required
            />
          
          </div>

          </div>

          

          <div className="form-group1">
            <label htmlFor="weight">Weight</label>
            <input
              type="number"
              id="weight"
              name="weight"
              value={formData.weight}
              onChange={handleChange}
              required
            />
          
          </div>

          


          
          
          
         
        

          <button type="button" onClick={handleSaveChanges}>
            Save Changes
          </button>

         


          {isModalOpen && (
        
          
            <AvatarSelectionModal onClose={() => setIsModalOpen(false)} onSelectAvatar={handleAvatarSelect} />
          
        
      )}




        </form>

        </div>


      </div>
    
  );
};



export default Userprofile;
