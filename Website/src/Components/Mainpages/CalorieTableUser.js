import React, { useState } from 'react';
import { doc, setDoc, updateDoc, arrayUnion,getDoc } from 'firebase/firestore';
import { db } from '../../firebase';

const CalorieTableUser = ({ tableData }) => {
  // Initialize state unconditionally
  const [selectedRows, setSelectedRows] = useState([]);

  // Check if tableData is empty or undefined
  if (!tableData || Object.keys(tableData).length === 0) {
    return <div>No data available</div>;
  }

  // Define event handler to save selected row data to Firestore
  const saveSelectedRowToFirestore = async (index) => {
    try {
      const selectedRowData = {
        description: tableData.Description[index],
        calories: tableData.Calories[index],
        carbs: tableData.Carbs[index],
        fat: tableData.Fat[index],
        protein: tableData.Protein[index],
        quantity: tableData.Quantity[index],
        verified: tableData.Verified[index],
        standardServingSize: tableData['Standard Serving Size'][index]
      };

      // Check if the document for the user exists
      const userId = localStorage.getItem('userId');
      const userDocRef = doc(db, 'userdata', userId);

      const userDocSnap = await getDoc(userDocRef); // Add this line to fetch the document snapshot

      if (userDocSnap.exists()) {
        // Update the existing document with the selected row data
        await updateDoc(userDocRef, {
          userData: arrayUnion(selectedRowData)
        });
      } else {
        // Create a new document with the user ID and the selected row data
        await setDoc(userDocRef, {
          userId: userId,
          userData: [selectedRowData]
        });
      }

      console.log('Selected row data saved to Firestore');
    } catch (error) {
      console.error('Error saving selected row data to Firestore:', error);
    }
  };

  // Define event handler to handle row click
  const handleRowClick = (index) => {
    // Check if the row is already selected
    const isSelected = selectedRows.includes(index);

    // Toggle the selection state
    if (isSelected) {
      // Remove the row index from selectedRows
      setSelectedRows(selectedRows.filter(row => row !== index));
    } else {
      // Add the row index to selectedRows
      setSelectedRows([...selectedRows, index]);
      // Save the selected row data to Firestore
      saveSelectedRowToFirestore(index);
    }
  };

  return (
    <div className="message-container">
      <h2>Calorie Data</h2>
      <table className="custom-table">
        <thead>
          <tr>
            <th>Description</th>
            <th>Calories</th>
            <th>Carbs</th>
            <th>Fat</th>
            <th>Protein</th>
            <th>Quantity</th>
            <th>Verified</th>
            <th>Standard Serving Size</th>
          </tr>
        </thead>
        <tbody>
          {tableData.Description.map((description, index) => (
            <tr
              key={index}
              className={selectedRows.includes(index) ? 'selected-row' : (index % 2 === 0 ? 'even-row' : 'odd-row')}
              onClick={() => handleRowClick(index)}
            >
              <td>{description}</td>
              <td>{tableData.Calories[index]}</td>
              <td>{tableData.Carbs[index]}</td>
              <td>{tableData.Fat[index]}</td>
              <td>{tableData.Protein[index]}</td>
              <td>{tableData.Quantity[index]}</td>
              <td>{tableData.Verified[index].toString()}</td>
              <td>{tableData['Standard Serving Size'][index]}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default CalorieTableUser;
