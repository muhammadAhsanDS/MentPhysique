import './App.css';
import { BrowserRouter, Route, Routes,Outlet } from 'react-router-dom'; // Import BrowserRouter

 
import Register from './Components/Loginsignup/Register.jsx';
 
import LoggedIn from './Components/Loginsignup/LoggedIn.jsx';

import Userprofile from './Components/Profilemanage/Userprofile.jsx';


import Firstpage from './Components/Mainpages/Firstpage.jsx';

import Chatpage from './Components/Mainpages/ChatPage.jsx';

 
import Mainpage from './Components/Mainpages/Mainwebsite.jsx';
import Sidebar from './Components/Mainpages/Sidebar.jsx';


 

import Healthlog from './Components/Mainpages/Healthlogs.jsx';
import Setting from './Components/Mainpages/Settings.jsx';

import Depressionlevel from './Components/Mainpages/Depressionlevel.jsx';
import AnxietyLevel from './Components/Mainpages/Anxietylevel.jsx';


import Alerts from './Components/Mainpages/Alerts.jsx';

import Feedback from './Components/Mainpages/FeedbackPopup.jsx';

import Dashboard from './Components/Mainpages/Dashboard.jsx';
 

import Avatar from './Components/Profilemanage/AvatarSelectionModal.jsx';

import Subscriptionpage from './Components/Mainpages/Subscription.jsx';
import Helpsupport from './Components/Mainpages/Helpandsupport.jsx';
import Reportpage from'./Components/Mainpages/Reportprob.jsx';
import Termspage from './Components/Mainpages/Termspolicies.jsx';

import Changepassword from './Components/Mainpages/ChangePassword.jsx';

function App() {
  return (
    <BrowserRouter> {/* Wrap your routes with BrowserRouter */}
      <Routes>
        <Route path="/" element={<Firstpage />} />
        <Route path="/firstpage" element={<Firstpage />} />

        
        <Route path="/loggedin" element={<LoggedIn />} />

         
        <Route path="/register" element={<Register />} />

        <Route path="/main" element={<Mainpage />} />
        <Route path="/Sidebar" element={<Sidebar />} />

        <Route path="/Chat" element={<Chatpage />} />

        <Route path="/depressionlevel" element={<Depressionlevel />} />
        <Route path="/anxietylevel" element={<AnxietyLevel />} />

        <Route path="/alerts" element={<Alerts />} />

        <Route path="/feedback" element={<Feedback />} />

        <Route path="/avatarselection" element={<Avatar />} />

        <Route path="/settings" element={<Setting />} />

        <Route path="/resetpassword" element={<Changepassword />} />
        <Route path="/subscription" element={<Subscriptionpage />} />
        <Route path="/helpandsupport" element={<Helpsupport />} />
        <Route path="/reportproblem" element={<Reportpage />} />
        <Route path="/termspolicies" element={<Termspage />} />

        <Route path="/userprofile" element={<Userprofile />} />

        <Route path="/healthlog" element={<Healthlog />} />
       
        
        
       <Route path="/dashboard" element={<Dashboard />} />
        
        

  

      </Routes>
    </BrowserRouter>
  );
}

 


export default App;
