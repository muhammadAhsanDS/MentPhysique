import React, { useState, useRef, useEffect } from 'react';
import firebase from 'firebase/compat/app';
import 'firebase/storage';
import { useNavigate } from 'react-router-dom';
import { Link } from 'react-router-dom';
import '../Profilemanage/Navfoot.css';
import { doc, setDoc ,getDoc, updateDoc,deleteDoc} from 'firebase/firestore'; 
import axios from 'axios';


import mikeicon from '../Assets/mikeicon.svg';
import speakericon from '../Assets/speakericon.png';
import texticon from '../Assets/texticon.png';
import './ChatPage.css'; // Add your CSS file
import { db } from '../../firebase'; // Import the Firestore instance
import { addDoc, collection, serverTimestamp } from 'firebase/firestore';
import { getStorage, ref, uploadBytes } from 'firebase/storage';
import { getDownloadURL } from 'firebase/storage';
import FeedbackPopup from './FeedbackPopup';
import TableUser from './CalorieTableUser'; // Import the TableUser component

import TableUser1 from './WorkoutTableUser';

import { FaSpinner } from 'react-icons/fa';


const ChatPage = (onSubmenuSelect ) => {
  const [message, setMessage] = useState(''); // State for displaying messages

  const [convertedText, setConvertedText] = useState('');

  const [text, setText] = useState('');
  const characterLimit = 210;

  const [isLoading, setIsLoading] = useState(false);

  const [buttonsVisible, setButtonsVisible]=useState(false);
 

  const [response,setResponse]=useState('');

  const remainingChars = characterLimit - text.length;

  const [isRecording, setIsRecording] = useState(false);

  const [messages, setMessages] = useState([]); // State for storing messages

  const mediaRecorderRef = useRef(null);
  const audioChunksRef = useRef([]);

  const [isToggled, setIsToggled] = useState(false);

  const [tableData, setTableData] = useState(null);

  const [tableData1, setTableData1] = useState(null);



  const handleMenuSelect = (menu) => {
   
    onSubmenuSelect(menu);
  
  };


  const handleChange = (e) => {
    const inputText = e.target.value;

    if (inputText.length <= characterLimit) {
      setText(inputText);
    }
  };



  const handleToggle = () => {
    setIsToggled(!isToggled);
  };




  const startRecording = () => {
    setIsLoading(true);
    setIsRecording(true);
    const maxRecordingTime = 15 * 1000; // 15 seconds in milliseconds
    let recordingTimeout;
  
    navigator.mediaDevices.getUserMedia({ audio: true })
      .then(stream => {
        const mediaRecorder = new MediaRecorder(stream);
        mediaRecorderRef.current = mediaRecorder;
  
        mediaRecorder.addEventListener("dataavailable", event => {
          if (event.data.size > 0) {
            audioChunksRef.current.push(event.data);
          }
        });
  
        mediaRecorder.addEventListener("stop", () => {
          const audioBlob = new Blob(audioChunksRef.current, { type: "audio/wav" }); // Explicitly specify WAV format
          console.log("recorded")
          saveAudioToServer(audioBlob);
          audioChunksRef.current = [];
        });
  
        // Start the recording
        mediaRecorder.start();
  
        // Set a timeout to stop the recording after 15 seconds
        recordingTimeout = setTimeout(() => {
          stopRecording();
        }, maxRecordingTime);
      })
      .catch(error => {
        console.error("Error accessing microphone:", error);
      });
  
    // Cleanup function to clear the timeout if the recording stops manually
    const cleanup = () => {
      clearTimeout(recordingTimeout);
    };
  
    return cleanup;
  };
  


  
  const stopRecording = () => {
    setIsLoading(false);
    setIsRecording(false);
  
    if (mediaRecorderRef.current && mediaRecorderRef.current.state !== "inactive") {
      mediaRecorderRef.current.stop();
    }
  };


  
  

  

  const saveAudioToServer = async (audioBlob) => {
    try {
        // Check if audioBlob is not empty
        if (!audioBlob) {
            console.error("Error: Audio Blob is empty");
            return;
        }

        // Convert audioBlob to base64 encoded string
        const reader = new FileReader();
        reader.readAsDataURL(audioBlob);
        reader.onloadend = async function () {
            const base64data = reader.result.split(',')[1];

            // Send base64 encoded audio data to Deepinfra API
            const response = await axios.post(
                "https://api.deepinfra.com/v1/inference/openai/whisper-large?version=9065fbc87cc7164fda86caa00cdeec40f846dbca",
                { audio: base64data },
                {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }
            );

             
            // Extract text from response
            const text1 = response.data.text;
            console.log("Text from audio:", text1);



            setText(text1);
        };
    } catch (error) {
        // Handle error
        console.error("Error occurred while saving audio to server:", error);
    }
};

  
  
  
  









   


  

  const saveAudioToFirestore = async (audioBlob) => {
    const audioCollectionRef = collection(db, 'audio-recordings');
    const storageRef = ref(getStorage(), `audio-recordings/${Date.now()}.wav`);

    try {
      // Upload the audio blob to Firebase Storage
      const snapshot = await uploadBytes(storageRef, audioBlob);

      // Get the Reference object from the snapshot
      const fileRef = ref(getStorage(), snapshot.metadata.fullPath);

      // Get the download URL of the uploaded audio
      const downloadURL = await getDownloadURL(fileRef);

      // Add a document to the Firestore collection with the audio URL
      const docRef = await addDoc(audioCollectionRef, {
        audioURL: downloadURL,
        timestamp: serverTimestamp(),
      });

      setMessage('Voice recording saved to Firestore.');
      console.log('Voice recording saved to Firestore with doc ID:', docRef.id);
    } catch (error) {
      console.error('Error saving voice recording to Firestore:', error);
      setMessage('Error saving voice recording to Firestore.');
    }
  };


 
  


  const sendMessage = async () => {
    if (text.trim() !== '') {
      const userMessage = { text, isUser: true };
      setText('');
      setIsLoading(true);

      try {
        setMessages(prevMessages => [...prevMessages, userMessage]);
          // If isToggled is true, send user query to emotion intent first
          if (isToggled) {
            const emotionResponse = await fetch('http://127.0.0.1:8000/emotion', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json'
              },
              body: JSON.stringify({ query: text }) 
            });
  
            if (emotionResponse.ok) {
              
              const emotionData = await emotionResponse.json();
              console.log(emotionData);

              setResponse(emotionData);
              setIsLoading(false)

              const userId = localStorage.getItem('userId');
              if (userId) {
                try {
                  // Define the Firestore document structure according to the sample code
                  const userData = {
                    emotionData
                  };
            
                  // Get the Firestore document reference
                  const docRef = doc(db, 'userdata', userId);
            
                  // Check if the document already exists for the user
                  const docSnap = await getDoc(docRef);
            
                  if (docSnap.exists()) {
                    let updatedUserData;
                    if (docSnap.data().userdata) {
                      // If the document exists and userdata field exists, update the existing document with new  data
                      updatedUserData = [...docSnap.data().userdata, userData];
                    } else {
                      // If the document exists but userdata field doesn't exist, initialize it as an empty array
                      updatedUserData = [userData];
                    }
                  
                    await updateDoc(docRef, {
                      userdata: updatedUserData
                    });
                    console.log('User data updated for: ');
                  } else {
                    // If the document doesn't exist, create a new document with the user ID and  data
                    await setDoc(docRef, {
                      userdata: [userData]
                    });
                    console.log('User data submitted for user ID: ');
                  }
                  
          
                } catch (error) {
                  console.error('Error saving data :', error);
                }
              }

              
            } 
            
            else {
              throw new Error('Failed to fetch emotion intent');
            }
          }
        


       else{
        // Send user query to intent endpoint
        const response = await fetch('http://127.0.0.1:8000/intent', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ query: text }) // assuming 'text' is the user's query
        });
  
        if (response.ok) {
          const data = await response.json();
          // Handle the response data as needed
          console.log(data);
           

         //send data to particular intent

          if(data==='calorie_tracking')
          {
           
                     // Send user query to calorie endpoint
                  const response1 = await fetch('http://127.0.0.1:8000/calorie', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ query: text }) 
                  });

                  if (response1.ok) {
                    const data1 = await response1.json();
                     

                    if (data1 === 'NA') {
                      setResponse(data1);

                      setIsLoading(false);
                  } 
                    
                  else{
                    setTableData(data1);
                    
                    setMessages(prevMessages => [...prevMessages, { isUser: false, isTableUser: true }]);
                    // Update state or perform other actions with the response data
                    // For example, updating the state to store the response data
                    //setResponse(data1);

                    setIsLoading(false);

                  }  

                  } 
                  
                  else {
                    throw new Error('Failed to fetch calorie information');
                  }




          }

          else if(data==='wellbeing_relief')
          {
             
                    // Send user query to intent endpoint
                const response1 = await fetch('http://127.0.0.1:8000/relief', {
                  method: 'POST',
                  headers: {
                    'Content-Type': 'application/json'
                  },
                  body: JSON.stringify({ query: text }) // assuming 'text' is the user's query
                });
          
                if (response1.ok) {
                  const data1 = await response1.json();
                  // Handle the response data as needed
                 // console.log(data1);
                  setResponse(data1); 
                  
                  setIsLoading(false);

                } 
                else {
                  throw new Error('Failed to fetch intent');
                }
               
          }




          else if (data === 'wellbeing_check') {
            console.log("Setting buttonsVisible to true");
            setButtonsVisible(true);
            console.log(buttonsVisible)
           
            setResponse("Kindly Visit Questionnarie From side menu to check on mental health");
            console.log(buttonsVisible) 
            setIsLoading(false);     
          }
          
          
          
          
          
          
         

          else if(data==='workout_tracking')
          {
             
                              // Send user query to workout endpoint
                  const response1 = await fetch('http://127.0.0.1:8000/workout', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ query: text }) // Sending user's query to the server
                  });

                  if (response1.ok) {
                    const data1 = await response1.json();
                   
                    
                    if (data1 === 'NA') {
                      setResponse(data1);

                      setIsLoading(false);
                  } 
                  
                  else{
                    
                    setTableData1(data1);
                   
                    
                    setMessages(prevMessages => [...prevMessages, { isUser: false, isTableUser1: true }]);

                    setIsLoading(false);

                  } 

                  } 
                  
                  else {
                    throw new Error('Failed to fetch workout data');
                  }


          }

          else
          {
            
            setResponse(data);
            setIsLoading(false);

          }
        

        }

        else 
        {
          throw new Error('Failed to fetch intent');
        }
      
      

      }  


      } 
      
      catch (error) {
        console.error('Error fetching intent:', error);
      }
    


    
    }
  };
  
  
  
  




  const receiveMessage = () => {
    setMessages([...messages, { text: response, isUser: false }]);


  };
  







  const [isFeedbackPopupOpen, setIsFeedbackPopupOpen] = useState(false);

  const handleGiveFeedbackClick = () => {
    setIsFeedbackPopupOpen(true);
  };

  const handleCloseFeedbackPopup = () => {
    setIsFeedbackPopupOpen(false);
  };



  const handleSubmitFeedback = (selectedEmoji, question1Answer, question2Answer, additionalComment) => {
    // Handle feedback submission
    console.log('Selected Emoji:', selectedEmoji);
    console.log('Question 1 Answer:', question1Answer);
    console.log('Question 2 Answer:', question2Answer);
    console.log('Additional Comment:', additionalComment);
    // You can add Firebase Firestore code here to store feedback
    // Reset state and close modal
    setIsFeedbackPopupOpen(false);
  };


  useEffect(() => {
    // This effect will be triggered whenever `response` state changes 
    if (response !== '') {
      receiveMessage();
      setResponse('');
    }
  }, [response]);


  const textToSpeech = (text) => {

    

                              // Define the URL of your FastAPI server
                  const url = "http://127.0.0.1:8000/tts";

                  // Define the data to be sent in the request body
                  const data = {
                      query: text
                  };

                  // Send a POST request to the server
                  fetch(url, {
                      method: 'POST',
                      headers: {
                          'Content-Type': 'application/json'
                      },
                      body: JSON.stringify(data)
                  })
                  .then(response => {
                      if (!response.ok) {
                          throw new Error('Network response was not ok');
                      }
                      return response.json(); // Assuming the response is JSON data
                  })
                  .then(jsonData => {
                      // Now you have the JSON data, extract the audio URL
                      const audioURL = jsonData; // Assuming the JSON data directly contains the audio URL

                      // Assuming you want to play the audio in the browser
                      const audioElement = new Audio(audioURL);
                      audioElement.play();
                  })
                  .catch(error => {
                      console.error('There was a problem with the fetch operation:', error);
                  });
                  


  }


  return (

    

    <div className="container">

      
<div className="message-container">
    {messages.map((message, index) => (
      <div key={index} className={message.isUser ? 'message-user' : 'message-other'}>
        {/* Render user's message */}
        <div>
          {message.text}
          {!message.isUser && !message.isTableUser && !message.isTableUser1 &&  (
            <img
              src={speakericon}
              alt="speaker"
              className="speakericon"
              onClick={() => textToSpeech(message.text)} // Call textToSpeech function on click
            />
          )}
        </div>

        {/* Render table for table-user */}
        {message.isTableUser && (
          <TableUser tableData={tableData} />
        )}

          {/* Render table for table-user1 */}
          {message.isTableUser1 && (
            <TableUser1 tableData1={tableData1} />
          )}

      </div>
    ))}
  </div>


      
            

      <div className="text-container">
        <label htmlFor="text-input"></label>
        <div style={{ position: 'relative' }}>
          <textarea
            id="text-input"
            value={convertedText || text}
            onChange={handleChange}
            placeholder="Enter text (max 210 characters):"
            style={{
              width: '605px',
              height: '50px',
              color: '#526564',
              borderRadius: '20px',
              paddingLeft: '40px',
              paddingRight: '35px',
            }}
          />
          <img
            src={mikeicon}
            alt="mikeicon"
            style={{
              position: 'absolute',
              left: '10px',
              top: '50%',
              transform: 'translateY(-50%)',
              width: '30px',
              height: '30px',
              cursor: 'pointer',
            }}
            onClick={isRecording ? stopRecording : startRecording}
          />

        {isLoading ? (
          <FaSpinner className="loading-spinner" 
          style={{
            position: 'absolute',
            right: '10px',
            top: '50%',
            transform: 'translateY(-50%)',
            width: '20px',
            height: '20px',
            cursor: 'pointer',
          }}
          
          />

            ) 
            
            : (
          <img
            src={texticon}
            alt="texticon"
            style={{
              position: 'absolute',
              right: '10px',
              top: '50%',
              transform: 'translateY(-50%)',
              width: '30px',
              height: '30px',
              cursor: 'pointer',
            }}
            onClick={sendMessage}
          />

          
              
            )}
         
        </div>
    {/*    <p>Characters remaining: {remainingChars}</p>  */}

       <div className='Link1'> 
        <Link  to="#" onClick={handleGiveFeedbackClick}>Give Feedback</Link>
        <p> </p>
        </div>

      </div>

     
      {/* Feedback Popup */}
      {isFeedbackPopupOpen && (
        <FeedbackPopup onClose={handleCloseFeedbackPopup} onSubmit={handleSubmitFeedback} />
      )}

      <div className='toggling'> 

      <button className={`toggle-button ${isToggled ? 'toggled' : ''}`} onClick={handleToggle}>
            <span className="label">{isToggled ? 'Emotion ON' : 'Emotion OFF'}</span>
            <span className="slider"></span>
          </button>
        
      </div>
 

    </div>
  );

};

export default ChatPage;
