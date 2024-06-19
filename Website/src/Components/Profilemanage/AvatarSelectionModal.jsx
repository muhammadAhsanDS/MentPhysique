import React from 'react';
import avatar1 from '../Assets/avtr1.jpg';
import avatar2 from '../Assets/avtr2.jpg';
import avatar3 from '../Assets/avtr3.jpg';
import avatar4 from '../Assets/avtr4.jpg';
import avatar5 from '../Assets/avtr5.jpg';
import avatar6 from '../Assets/avtr6.jpg';
import avatar7 from '../Assets/avtr7.jpg';
import avatar8 from '../Assets/avtr8.jpg';
import avatar9 from '../Assets/avtr9.jpg';
import avatar10 from '../Assets/avtr10.jpg';
import avatar11 from '../Assets/avtr11.jpg';
import avatar12 from '../Assets/avtr12.jpg';
import avatar13 from '../Assets/avtr13.jpg';
import avatar14 from '../Assets/avtr14.jpg';
import avatar15 from '../Assets/avtr15.jpg';
import avatar16 from '../Assets/avtr16.jpg';
import avatar17 from '../Assets/avtr17.jpg';
import avatar18 from '../Assets/avtr18.jpg';
import avatar19 from '../Assets/avtr19.jpg';
import avatar20 from '../Assets/avtr20.jpg';
import avatar21 from '../Assets/avtr21.jpg';
import avatar22 from '../Assets/avtr22.jpg';
import avatar23 from '../Assets/avtr23.jpg';
import avatar24 from '../Assets/avtr24.jpg';
// Import other avatar images here
import './AvatarSelectionModal.css';

const AvatarSelectionModal = ({ show, onClose, onSelectAvatar }) => {
  const avatars = [avatar1, avatar2, avatar3,avatar4,avatar5,avatar6,avatar7, avatar8 , avatar9 ,avatar10 ,
   avatar11,  avatar12, avatar13 , avatar14 ,avatar15  ,avatar16 , avatar17 ,  avatar18 , avatar19 , avatar20 , 
   avatar21, avatar22 , avatar23 , avatar24  ]; // Add all avatar images here

  return (
    <div className={`modal ${show ? 'show' : ''}`} onClick={onClose}>
      <div className="modal-content" onClick={(e) => e.stopPropagation()}>
        <span className="close" onClick={onClose}>&times;</span>
        <h2>Select Your Avatar</h2>
        <div className="avatar-list">
          {avatars.map((avatar, index) => (
            <div key={index} className="avatar" onClick={() => onSelectAvatar(avatar)}>
              <img src={avatar} alt={`Avatar ${index + 1}`} />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default AvatarSelectionModal;
