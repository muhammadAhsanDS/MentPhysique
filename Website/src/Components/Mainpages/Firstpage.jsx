import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import startimg from '../Assets/startimage.png';
import { Link } from 'react-router-dom';
import { NavLink } from 'react-router-dom';
import "../Profilemanage/Navfoot.css";
import logoimg from '../Assets/logo.png';
import iconImage1 from '../Assets/iconimg1.png';
import iconImage2 from '../Assets/iconimg2.png';
import iconImage3 from '../Assets/iconimg3.png';
import iconImage4 from '../Assets/iconimg4.png';
import iconImage5 from '../Assets/iconimg5.png';
import iconImage6 from '../Assets/iconimg6.png';
import chatimage from '../Assets/chatimg.png';

import './Firstpage.css'; // Add your CSS file

const Firstpage = () => {
    const navigate = useNavigate(); // Initialize the navigate function
    const [menuOpen, setMenuOpen] = useState(false);



    const handleSubmit = () => {
        navigate('/register');
    };

    const handleSubmit1 = () => {
        navigate('/loggedin');
    };

    return (
        <div className="container">

          <div className="container0">
                
          <div className="logoname1">
        <img src={logoimg} alt="Logo" className="logoimg1" />
        <h2>MentPhysique</h2>
      </div>

            </div>


            <div className="container1">
                <div className="form-row">
                    <div className="heading">
                        <div className="heading-text">
                            <h1 className='firstheading'>Holistic Health</h1>
                            <h1 className='secondheading'>AI Chatbot</h1>
                            <svg className="marker" viewBox="0 0 160 7">
                                <defs>
                                    <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%" style={{ stopColor: '#95B7B7', stopOpacity: 1 }} />
                                        <stop offset="100%" style={{ stopColor: '#95B7B7', stopOpacity: 1 }} />
                                    </linearGradient>
                                </defs>
                                <path d="M 0 -7 Q 50 -10 115 -4" fill="none" stroke="url(#grad)" strokeWidth="1">
                                    <animate attributeName="stroke-width" from="1" to="20" dur="1s" repeatCount="1" fill="freeze" />
                                </path>
                            </svg>
                            <h3>Move Your Body, Speak Your Mind</h3>

                          <div className='firstpagebuttons'>

                            <button className='button1'>Try Demo</button>


                            <button className='button2'>
                              Download The App
                <div className="circle" style={{ backgroundColor: 'white', color: '#526564', borderRadius: '50%', width: '30px', height: '30px', display: 'flex', justifyContent: 'center', alignItems: 'center', marginLeft: '30px' }}>&rarr;</div>
                 </button>


                      </div>
                        

                        </div>
                    </div>
                    <img src={startimg} alt="Image" className="startimg" />
                </div>
            </div>
        
        



            <div className="feature-container" style={{ backgroundColor: '#A8A8A8' }}>
                <h1>Mentphysique App Features</h1>
                <div className="feature-boxes">
                    {/* Feature Box 1 */}
                    <div className="feature-box">
                        <img src={iconImage1} alt="Feature Icon" />
                        <h2>Emotional Support</h2>
                        <p>Receive empathetic and compassionate guidance tailored to your unique mental health needs, helping you navigate challenges with confidence.</p>
                    </div>
                    {/* Feature Box 2 */}
                    <div className="feature-box">
                        <img src={iconImage2} alt="Feature Icon" />
                        <h2>Personalized Insights</h2>
                        <p>Gain deep insights into your thoughts, emotions, and behaviors with personalized analysis.</p>
                    </div>
                    {/* Feature Box 3 */}
                    <div className="feature-box">
                        <img src={iconImage3} alt="Feature Icon" />
                        <h2>Self-Discovery</h2>
                        <p>Unlock a deeper understanding of yourself through reflective exercises, empowering you to make positive changes and growth.</p>
                    </div>
                    {/* Feature Box 4 */}
                    <div className="feature-box">
                        <img src={iconImage4} alt="Feature Icon" />
                        <h2>Physical Health</h2>
                        <p>This feature can take input in text as well as voice form.
                      user can take guidance about workout exercises,
                      Meditation exercises and some other valuable outputs.</p>
                    </div>
                    {/* Feature Box 5 */}
                    <div className="feature-box">
                        <img src={iconImage5} alt="Feature Icon" />
                        <h2>Mental Health</h2>
                        <p>This feature can take input in text as well as voice form.
                        user can take guidance about Stress relieving exercises,
                        Meditation exercises and some other valuable outputs.</p>
                                            </div>
                    {/* Feature Box 6 */}
                    <div className="feature-box">
                        <img src={iconImage6} alt="Feature Icon" />
                        <h2>Food Guidance</h2>
                        <p>This feature can take input in text as well as voice form.
                        user can tell about food items he/she eat in meal and
                        get how much calories they intake, also can get 
                        valuable outputs</p>
                    </div>
                </div>
            </div>




            <div className="thirdcontainer" style={{ backgroundColor: '#95B7B7' }}>

            

            <h1> Start Your Holistic </h1>
            <h1> Health Journey!</h1>
            <p>Get started on your holistic health journey today! SignUp or Login</p>
            <p>the Mentphysique  and experience the benefits of our innovative solutions:</p>
            
            
           <div className='journey'> 

            <button className='button3' onClick={handleSubmit1}>
                              Login
                <div className="circle" style={{ backgroundColor: '#95B7B7', color: 'white', borderRadius: '50%', width: '30px', height: '30px', display: 'flex', justifyContent: 'center', alignItems: 'center', marginLeft: '30px' }}>&rarr;</div>
                 </button>

                 <button className='button4' onClick={handleSubmit}>
                              Signup
                <div className="circle" style={{ backgroundColor: '#95B7B7', color: 'white', borderRadius: '50%', width: '30px', height: '30px', display: 'flex', justifyContent: 'center', alignItems: 'center', marginLeft: '30px' }}>&rarr;</div>
                 </button>      

                 </div>

                 <img src={chatimage} alt="Logo" className="chatimgclass" />


           </div>     



        </div>
    );
};

export default Firstpage;
