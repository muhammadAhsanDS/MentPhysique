import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { auth } from '../../firebase.js';
import { doc, getDoc, updateDoc,setDoc } from 'firebase/firestore';
import { sendPasswordResetEmail } from 'firebase/auth';
import { db } from '../../firebase'; // Import your Firebase configuration
import { reauthenticateWithCredential, EmailAuthProvider } from 'firebase/auth'; // Import Firebase Auth methods
import supportimg from '../Assets/support.png';


import './Helpandsupport.css';



const Helpandsupport = () => {
  
   

  return (
    
<div className='supportpage'>

        <div className='supportheading'>
          <img src={supportimg} alt="Setting Icon" />
           <h1>Help & Support</h1>

          </div>


      <div className="supportcontainer1">
       
       <h1>Frequently Asked Questions</h1>

       <div className='supportcontainer11'>

       <h2>Q1: Is Our Data Secure? </h2>
       <p>A: Yes, It is secure. We respect the privacy of our customers and do not share data with third parties</p>
       
       <h2>Q2: Is MentPhysique available on multiple devices and platforms? </h2>
       <p>A: Yes, MentPhysique is available on both Android devices and the web.</p>
       
       </div>
      </div>



      <div className='supportcontainer2'>
      <h1>Contact Us</h1> 

      <div className='supportcontainer21'>
      <p>If you have any queries or suggestions, please feel free to contact us at:</p>

      <h3>mentphysique@gmail.com</h3>
      </div>

      </div>



      </div> 
    
  );
};



export default Helpandsupport;
