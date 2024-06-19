// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";

import {getAuth} from "firebase/auth";

//ye abhi add kia 
import { getFirestore } from 'firebase/firestore';

import { getStorage } from 'firebase/storage';


// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyA6DHNSLVhbDscu4NWU2lpw_QWnoiQy5GQ",
  authDomain: "fyp-authentication-a1d51.firebaseapp.com",
  projectId: "fyp-authentication-a1d51",
  storageBucket: "fyp-authentication-a1d51.appspot.com",
  messagingSenderId: "85417983043",
  appId: "1:85417983043:web:6ccc1b2f1f59abfa9ba8f6"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase Authentication and get a reference to the service
const auth = getAuth(app);


//ye abhi
const db = getFirestore(app);

const storage = getStorage(app);

export { db };

export { auth }; // Export the 'auth' variable

export { storage }