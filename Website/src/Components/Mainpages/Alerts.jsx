import React, { useState , useEffect} from 'react';
import './Alerts.css';
import icon from '../Assets/coolicon.png';
import notification from '../Assets/alerts.png';
import DatePicker from 'react-datepicker';
import 'react-datepicker/dist/react-datepicker.css';
import TimePicker from 'react-time-picker';
import { collection, addDoc } from 'firebase/firestore';
import { getAuth, sendEmailVerification } from 'firebase/auth';
import { db } from '../../firebase';
import { doc, setDoc ,getDoc, updateDoc,deleteDoc} from 'firebase/firestore'; // Import Firestore functions


const Alerts = () => {
     
  const [alertName, setAlertName] = useState('');
  const [selectedDate, setSelectedDate] = useState(null);
  const [selectedTime, setSelectedTime] = useState(null);
  const [viaEmail, setViaEmail] = useState(false);
  const [viaAlertMessage, setViaAlertMessage] = useState(false);
  const [alerts, setAlerts] = useState([]);

  const [userEmail, setUserEmail] = useState('');


  useEffect(() => {

    const loadUserData = async () => {
      const userId = localStorage.getItem('userId');
      if (userId) {
        try {
          const userDocRef = doc(db, 'profiledata', userId);
          const docSnap = await getDoc(userDocRef);
          if (docSnap.exists()) {
            const userData = docSnap.data();
            setUserEmail(userData.email); // Assuming email is stored in 'email' field
          }
        } catch (error) {
          console.error('Error fetching user data:', error);
          // Handle error
        }
      }
    };

    loadAlerts();
  }, []);
  

  

  /*
  const sendAlertsViaEmail = (alert, userEmail) => {
    const now = new Date();
    const alertDateTime = new Date(alert.selectedDate);
    const [hours, minutes] = alert.selectedTime.split(':');
    alertDateTime.setHours(parseInt(hours, 10));
    alertDateTime.setMinutes(parseInt(minutes, 10));
  
    // Check if the current time matches the alert time and if the alert is set to be sent via email
    if (now.getTime() === alertDateTime.getTime() && alert.notificationMethods.includes('via email')) {
      // Implement your email sending logic here
      sendEmail(userEmail, alert.alertName);
    }
  };

  const sendEmail = (recipient, alertName) => {
    const auth = getAuth();
    
    sendEmailVerification(auth.currentUser)
      .then(() => {
        console.log(`Email sent to ${recipient} for alert: ${alertName}`);
      })
      .catch((error) => {
        console.error('Error sending email:', error);
      });
  };
*/





  const loadAlerts = async () => {
    const userId = localStorage.getItem('userId');
    if (userId) {
      try {
        const docRef = doc(db, 'alerts', userId);
        const docSnap = await getDoc(docRef);
  
        if (docSnap.exists()) {
          // If the document exists, extract the alerts array from the document data
          const alertsData = docSnap.data().alerts || [];
          setAlerts(alertsData);
        } else {
          // If the document doesn't exist, set alerts to an empty array
          setAlerts([]);
        }
      } catch (error) {
        console.error('Error loading alerts:', error);
      }
    }
  };
  

  



  const handleNameChange = (event) => {
    setAlertName(event.target.value);
  };

  const handleDateChange = (date) => {
    setSelectedDate(date);
  };

  const handleTimeChange = (time) => {
    setSelectedTime(time);
  };

  

  const handleCreateAlert = async () => {
    const notificationMethods = [];
    if (viaEmail) {
      notificationMethods.push('via email');
    }
    if (viaAlertMessage) {
      notificationMethods.push('via alert message');
    }
    const notificationMethodsString = notificationMethods.join(', ');
  
    const userId = localStorage.getItem('userId');
    if (userId) {
      try {
        // Define the Firestore document structure according to the sample code
        const alertData = {
          id: Date.now(),
          alertName,
          selectedDate,
          selectedTime,
          notificationMethods: notificationMethodsString
        };
  
        // Get the Firestore document reference
        const docRef = doc(db, 'alerts', userId);
  
        // Check if the document already exists for the user
        const docSnap = await getDoc(docRef);
  
        if (docSnap.exists()) {
          // If the document exists, update the existing document with new alert data
          await updateDoc(docRef, {
            alerts: [...docSnap.data().alerts, alertData]
          });
          console.log('Alert updated for user ID: ');
        } else {
          // If the document doesn't exist, create a new document with the user ID and alert data
          await setDoc(docRef, {
            alerts: [alertData]
          });
          console.log('Alert submitted for user ID: ');
        }
  
        // Reset form fields and reload alerts
        setAlertName('');
        setSelectedDate(null);
        setSelectedTime(null);
        setViaEmail(false);
        setViaAlertMessage(false);
        loadAlerts();
      } catch (error) {
        console.error('Error creating alert:', error);
      }
    }
  };
  


  const handleCancel = () => {
    setAlertName('');
    setSelectedDate(null);
    setSelectedTime(null);
    setViaEmail(false);
    setViaAlertMessage(false);
};



const handleDeleteAlert = async (alertId) => {
  try {
    if (alertId) { // Ensure alertId is not undefined
      const userId = localStorage.getItem('userId');
      if (userId) {
        const docRef = doc(db, 'alerts', userId);
        await updateDoc(docRef, {
          alerts: alerts.filter(alert => alert.id !== alertId) // Filter out the alert to be deleted
        });
        console.log('Alert deleted:', alertId);
        loadAlerts();
      } else {
        console.error('Error deleting alert: User ID is undefined');
      }
    } else {
      console.error('Error deleting alert: Alert ID is undefined');
    }
  } catch (error) {
    console.error('Error deleting alert:', error);
  }
};





  

    return (
      

      <div className='notifymain'>

      <h1 className='notifyheading'>Customize Alerts</h1>

      <div className='notifycontainer1'>


      <h2>Name</h2>
  
        <div className="input-container">
          <input
            type="text"
            value={alertName}
            onChange={handleNameChange}
            placeholder="Enter alert name"
            className="rounded-input"
            style={{ backgroundImage: `url(${icon})` }}
          />
        </div>

       <h2>Notify</h2> 

    
   
       <div className='notifycontainer2'>

       <div className="date-container">
          <label>Select Date:</label>
          
          <DatePicker
            selected={selectedDate}
            onChange={handleDateChange}
            dateFormat="MM/dd/yyyy"
            popperPlacement="top"
            locale="en"  
            className="custom-datepicker"
          />

        </div>


        
        <div className="time-container">
            <label>Select Time:</label>
            <TimePicker
              onChange={handleTimeChange}
              value={selectedTime}
              className="custom-timepicker"
            />
          </div>
    
      </div>       

<h2> </h2>

     <div className='notifycontainer3'>


    <div className='mailcontainer'>
     <label>
          Via Email
     </label>

          <input
            type="checkbox"
            checked={viaEmail}
            onChange={() => setViaEmail(!viaEmail)}
          />
    </div>    

     <div className='messageconatiner'> 
        <label>
          Via Alert 
        </label>  
          <input
            type="checkbox"
            checked={viaAlertMessage}
            onChange={() => setViaAlertMessage(!viaAlertMessage)}
          />
       
        </div>

     </div>


<h2> </h2>

       
      <div className='lastbuttons'>

      <h3 className='cancelalert' onClick={handleCancel}>Cancel</h3>


     <button className='createalert' onClick={handleCreateAlert}>Create Alert</button>

      </div>
    
      </div>


       <h1 className='notifyheading1'>Your Alerts</h1>

       
       <div className='notifycontainer4'>
        
       

       {alerts.map(alert => (

          <div key={alert.id} className='alert-item'>
         
            <div>{alert.selectedDate ? alert.selectedDate.toDate().toLocaleString() : ""} - {alert.selectedTime}</div>

           
            <button onClick={() => handleDeleteAlert(alert.id)}>Delete</button>
          </div>
           
        ))}

        

      </div>

      </div>

  );
};

export default Alerts;



