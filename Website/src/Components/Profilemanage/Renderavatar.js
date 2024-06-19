// Renderavatar.js
import React, { useState } from 'react';
import Sidebar from '../Mainpages/Sidebar';
import Userprofile from './Userprofile';

const Renderavatar = () => {
  const [selectedAvatar, setSelectedAvatar] = useState(null);

  return (
    <div>
      <Sidebar selectedAvatar={selectedAvatar} />
      <Userprofile selectedAvatar={selectedAvatar} setSelectedAvatar={setSelectedAvatar} />
    </div>
  );
};

export default Renderavatar;
