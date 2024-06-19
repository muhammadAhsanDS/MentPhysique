import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { auth } from '../../firebase.js';
import { sendPasswordResetEmail } from 'firebase/auth';

import './LoggedIn.css';
import logoimg from '../Assets/logo.png';
import headerimg2 from '../Assets/startimage.png';

const LoggedIn = () => {
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    email: '',
    password: '',
    rememberMe: false, // Add rememberMe field
  });


  const [message, setMessage] = useState(''); // State for displaying messages

  // Load email and password from local storage if "Remember Me" was checked
  useEffect(() => {
    const savedEmail = localStorage.getItem('email');
    const savedPassword = localStorage.getItem('password');

    if (savedEmail && savedPassword) {
      setFormData({
        ...formData,
        email: savedEmail,
        password: savedPassword,
        rememberMe: true,
      });
    }
  }, []);

  const isFormValid = () => {
    return formData.email !== '' && formData.password !== '';
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    const newValue = type === 'checkbox' ? checked : value;

    setFormData({
      ...formData,
      [name]: newValue,
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (formData.rememberMe) {
      // Store the email and password in local storage
      localStorage.setItem('email', formData.email);
      localStorage.setItem('password', formData.password);
    } else {
      // Clear email and password from local storage
      localStorage.removeItem('email');
      localStorage.removeItem('password');
    }

    if (isFormValid()) {
      signInWithEmailAndPassword(auth, formData.email, formData.password)
        .then((userCredential) => {
          const user = userCredential.user;
          const userId = user.uid;
          localStorage.setItem('userId', userId);
          navigate('/main');
        })
        .catch((error) => {
          console.log(error);

          if (error.code === 'auth/invalid-login-credentials') {
            setMessage('This email is not registered. Please sign up first.');
          } else if (error.code === 'auth/wrong-password') {
            setMessage('Incorrect password. Please try again.');
          } else {
            setMessage('An error occurred. Please try again later.');
          }
        });
    } else {
      console.log('Please fill in all required fields.');
      setMessage('Please fill in all required fields.');
    }
  };






  const handleResetPassword = async () => {
    const user = auth.currentUser;

    if (user) {
      try {
        // Send a password reset email to the user's email address
        await sendPasswordResetEmail(auth, user.email);
        console.log('Password reset email sent to user');
        setMessage('Password reset email sent to user');
      } catch (error) {
        console.error('Error sending password reset email:', error);
        setMessage('Error sending password reset email');
      }
    }
  };



  return (


    <div className="Logincontainer">
      <div className="logoname">
        <img src={logoimg} alt="Logo" className="logginlogoimg" />
        <h2>MentPhysique</h2>
      </div>



      <div className="loginform">

      <div className="message-box2">
        {message && <div className="message">{message}</div>} {/* Display common message */}
      </div>

        <h2>Welcome Back</h2>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="email" className="label1">
              Email
            </label>
            <input
              className="input1"
              type="email"
              id="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              required
            />
          </div>
          <div className="form-group">
            <label htmlFor="password" className="label1">
              Password
            </label>
            <input
              className="input1"
              type="password"
              id="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              required
            />
          </div>


          <div className="form-row">
          <div className="form-group">
            <label htmlFor="rememberMe" className="label1">
              Remember Me
            </label>
            <input
              type="checkbox"
              id="rememberMe"
              name="rememberMe"
              checked={formData.rememberMe}
              onChange={handleChange}
            />
          </div>

          <Link onClick={handleResetPassword} className="link">
          Forget Password?
        </Link>
       

          </div>


          <button type="submit" onClick={handleSubmit}>
            Log In
          </button>
       


        </form>

        <Link to="/register" className="link">
          Don't have an account? Signup
        </Link>

        

      </div>



      <div className="header-image2">
        <img src={headerimg2} alt="Header" />
      </div>
    
    
    </div>

    
  );
};

export default LoggedIn;
