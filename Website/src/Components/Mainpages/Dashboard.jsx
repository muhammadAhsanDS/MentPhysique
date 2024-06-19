import React, { useState, useEffect } from 'react';
import './Dashboard.css';
import Chart from 'chart.js/auto';
import { db } from '../../firebase';
import { doc, getDoc } from 'firebase/firestore';
import { Bar, Line, Scatter, Doughnut } from 'react-chartjs-2';
import burncalories from '../Assets/burnedcalories.png';

const Dashboard = () => {

  const [selectedYear, setSelectedYear] = useState('all');
  const [selectedMonth, setSelectedMonth] = useState('all');
  const [years, setYears] = useState([]);
  const [months, setMonths] = useState([]);
  const [chartData, setChartData] = useState(null);

  const [clicked, setClicked] = useState(false);
  
  
  const [calorieChartData, setCalorieChartData] = useState([]);
  const [calorieChartInstance, setCalorieChartInstance] = useState(null);
  const [showCaloriesChart, setShowCaloriesChart]=useState(false);

  const [carbfatproChartData, setCarbfatproChartData]= useState([]);
  const [carbfatproChartInstance, setCarbfatproChartInstance] = useState(null);
  const [showCarbfatproChart, setShowCarbfatproChart]=useState(false);

  const [emotionsChartData, setEmotionsChartData] =useState([]);
  const [emotionsChartInstance, setEmotionsChartInstance] =useState(null);
  const [showEmotionsChart, setShowEmotionsChart] = useState(false);


  const [depressionChartData, setDepressionChartData] = useState(null);
  const [showDepressionChart, setShowDepressionChart] = useState(false);


  const [anxietyChartData, setAnxietyChartData] = useState(null);
  const [showAnxietyChart, setShowAnxietyChart] = useState(false);

  const [mentalHealthChartData, setMentalHealthChartData] = useState([]);
  const [chartInstance, setChartInstance] = useState(null);

  
 

  const [mentalHealthChartInstance, setMentalHealthChartInstance] = useState(null);
  const [exerciseData, setExerciseData] = useState([]);

   



  const severityColors = {
    mild: 'rgba(255, 99, 132, 0.4)',
    high: 'rgba(54, 162, 235, 0.4)',
    moderate: 'rgba(255, 206, 86, 0.4)',
    minimal: 'rgba(75, 192, 192, 0.4)',
  };

  useEffect(() => {
    const fetchData = async () => {
      const userId = localStorage.getItem('userId');
      if (userId) {
        try {
          const docRef = doc(db, 'extradata', userId);
          const docSnap = await getDoc(docRef);
          if (docSnap.exists()) {
            const data = docSnap.data().data;
            const yearsSet = new Set();
            const monthsSet = new Set();
            data.forEach((entry) => {
              const [year, month] = entry.date.split('-').map(Number);
              yearsSet.add(year);
              monthsSet.add(month);
            });
            const yearsArray = Array.from(yearsSet);
            const monthsArray = Array.from(monthsSet);
            setYears(yearsArray);
            setMonths(monthsArray);
            setExerciseData(data);
            updateCarbfatproteinChart(data, 'all', 'all');
            updateEmotionsChartData(data, 'all', 'all');
            updateDepressionChartData(data, 'all', 'all');
            updateAnxietyChartData(data, 'all', 'all');
      //      updateChart(data, 'all', 'all');
            updateCalorieChart(data, 'all', 'all');
      //      updateMentalHealthChart(data, 'all', 'all');
          }
        } catch (error) {
          console.error('Error fetching data:', error);
        }
      }
    };

    fetchData();
  }, []);

  useEffect(() => {
    fetchData1();
  }, []);

  const fetchData1 = async () => {
    const userId = localStorage.getItem('userId');
    if (userId) {
      try {
        const docRef = doc(db, 'extradata', userId);
        const docSnap = await getDoc(docRef);
        if (docSnap.exists()) {
          const data = docSnap.data().data;
          setExerciseData(data);
          parseExerciseData(data);
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    }
  };

  const parseExerciseData = (data) => {
    const parsedData = data.map(entry => ({
      type: entry.type,
      duration: entry.duration,

      calories_burn: entry.calories_burn, // Add calories_burn field

      carb:entry.carb,
      fat:entry.fat,
      protein:entry.protein,

      emotions: entry.emotions,  //Joy, Sadness, Anger, Neutral, Admiration

      date: entry.date,
      concern_severity_level: entry.concern_severity_level,
      concern_severity_anx: entry.concern_severity_anx,
    }));

    displayExerciseInfo(parsedData);
  };

  const displayExerciseInfo = (parsedData) => {


    parsedData.forEach(entry => {
      const year = entry.date.split('-')[0];
      if (!years[year]) {
        years[year] = { totalDuration: 0, totalCalories: 0,totalCarb: 0,totaFat: 0,totalProtein: 0,emotiontype: {} ,severityLevel: {}, severityAnx: {} };
      }
      years[year].totalDuration += entry.duration;
      years[year].totalCalories += entry.calories_burn;

      years[year].totalCarb+=entry.carb;
      years[year].totaFat+=entry.fat;
      years[year].totalProtein+=entry.protein;

      years[year].severityLevel[entry.concern_severity_level] = (years[year].severityLevel[entry.concern_severity_level] || 0) + 1;
      years[year].severityAnx[entry.concern_severity_anx] = (years[year].severityAnx[entry.concern_severity_anx] || 0) + 1;
    
      years[year].emotiontype[entry.emotions] = (years[year].emotiontype[entry.emotions] || 0) + 1;
      


    });

    Object.keys(years).forEach(year => {
   //   console.log(`Year: ${year}`);
   //   console.log(`Total Exercise Time: ${years1[year].totalDuration} seconds`);
   //   console.log(`Total Calories Burned: ${years1[year].totalCalories}`);
   //   console.log('----------------------');
    });

    parsedData.forEach(entry => {
      const yearMonth = entry.date.substring(0, 7);
      if (!months[yearMonth]) {
        months[yearMonth] = { count: 0, totalDuration: 0,totalCalories: 0,totalCarb: 0,totaFat: 0,totalProtein: 0, emotiontype: {} ,severityLevel: {}, severityAnx: {} };
      }
      months[yearMonth].count++;
      months[yearMonth].totalDuration += entry.duration;

      months[yearMonth].totalCarb+=entry.carb;
      months[yearMonth].totaFat+=entry.fat;
      months[yearMonth].totalProtein+=entry.protein;

      months[yearMonth].severityLevel[entry.concern_severity_level] = (months[yearMonth].severityLevel[entry.concern_severity_level] || 0) + 1;
      months[yearMonth].severityAnx[entry.concern_severity_anx] = (months[yearMonth].severityAnx[entry.concern_severity_anx] || 0) + 1;
    
      months[yearMonth].emotiontype[entry.emotions] = (months[yearMonth].emotiontype[entry.emotions] || 0) + 1;
    
     

    });

    Object.keys(months).forEach(month => {
   //   console.log(`Month: ${month}`);
   //   console.log(`Total Exercises: ${months1[month].count}`);
   //   console.log(`Total Exercise Time: ${months1[month].totalDuration} seconds`);
   //   console.log(`Severity Levels:`, months1[month].severityLevel);
    //  console.log(`Severity Anx:`, months1[month].severityAnx);
    //  console.log('----------------------');
    });

    

  };





  const handleYearChange = (e) => {
    const year = e.target.value;
    setSelectedYear(year);
    updateCarbfatproteinChart(exerciseData, year, selectedMonth);
    updateEmotionsChartData(exerciseData, year, selectedMonth);
    updateDepressionChartData(exerciseData, year, selectedMonth);
    updateAnxietyChartData(exerciseData, year, selectedMonth);
 //   updateChart(exerciseData, year, selectedMonth);
    updateCalorieChart(exerciseData, year, selectedMonth);
 //   updateMentalHealthChart(exerciseData, year, selectedMonth);
  };

  const handleMonthChange = (e) => {
    const month = e.target.value;
    const formattedMonth = month.length === 1 ? `0${month}` : month;
    setSelectedMonth(formattedMonth);
    updateCarbfatproteinChart(exerciseData, selectedYear, formattedMonth);
    updateEmotionsChartData(exerciseData, selectedYear, formattedMonth);
    updateDepressionChartData(exerciseData, selectedYear, formattedMonth);
    updateAnxietyChartData(exerciseData, selectedYear, formattedMonth);
  //  updateChart(exerciseData, selectedYear, formattedMonth);
    updateCalorieChart(exerciseData, selectedYear, formattedMonth);
  //  updateMentalHealthChart(exerciseData, selectedYear, formattedMonth);
  };



/* carb, fat , protein */
const updateCarbfatproteinChart = (data, year, month) => {
  let carbfatproChartData;
  if (year === 'all') {
    carbfatproChartData = generateYearlyCarbfatproteinChartData(data);
  } else {
    carbfatproChartData = generateMonthlyCarbfatproteinChartData(data, year, month);
  }
  setCarbfatproChartData(carbfatproChartData);
};

const generateYearlyCarbfatproteinChartData = (data) => {
  const yearlyData = {
    carb: {},
    fat: {},
    protein: {}
  };

  data.forEach((entry) => {
    const [year] = entry.date.split('-');
    if (!yearlyData.carb[year]) {
      yearlyData.carb[year] = 0;
      yearlyData.fat[year] = 0;
      yearlyData.protein[year] = 0;
    }
    yearlyData.carb[year] += entry.carb;
    yearlyData.fat[year] += entry.fat;
    yearlyData.protein[year] += entry.protein;
  });

  return {
    labels: Object.keys(yearlyData.carb),
    datasets: [
      {
        label: 'Carb Intake',
        backgroundColor: 'rgba(255, 99, 132, 0.4)',
        borderColor: 'rgba(255, 99, 132, 1)',
        borderWidth: 1,
        data: Object.values(yearlyData.carb),
      },
      {
        label: 'Fat Intake',
        backgroundColor: 'rgba(54, 162, 235, 0.4)',
        borderColor: 'rgba(54, 162, 235, 1)',
        borderWidth: 1,
        data: Object.values(yearlyData.fat),
      },
      {
        label: 'Protein Intake',
        backgroundColor: 'rgba(255, 206, 86, 0.4)',
        borderColor: 'rgba(255, 206, 86, 1)',
        borderWidth: 1,
        data: Object.values(yearlyData.protein),
      },
    ],
  };
};

const generateMonthlyCarbfatproteinChartData = (data, year, month) => {
  const monthlyData = {
    carb: {},
    fat: {},
    protein: {}
  };

  data.forEach((entry) => {
    const [entryYear, entryMonth] = entry.date.split('-');
    if (entryYear === year && (month === 'all' || entryMonth === month)) {
      const key = month === 'all' ? entryMonth : entry.date;
      if (!monthlyData.carb[key]) {
        monthlyData.carb[key] = 0;
        monthlyData.fat[key] = 0;
        monthlyData.protein[key] = 0;
      }
      monthlyData.carb[key] += entry.carb;
      monthlyData.fat[key] += entry.fat;
      monthlyData.protein[key] += entry.protein;
    }
  });

  const labels = Object.keys(monthlyData.carb);
  
  return {
    labels: labels,
    datasets: [
      {
        label: 'Carb Intake',
        backgroundColor: 'rgba(255, 99, 132, 0.4)',
        borderColor: 'rgba(255, 99, 132, 1)',
        borderWidth: 1,
        data: labels.map((key) => monthlyData.carb[key]),
      },
      {
        label: 'Fat Intake',
        backgroundColor: 'rgba(54, 162, 235, 0.4)',
        borderColor: 'rgba(54, 162, 235, 1)',
        borderWidth: 1,
        data: labels.map((key) => monthlyData.fat[key]),
      },
      {
        label: 'Protein Intake',
        backgroundColor: 'rgba(255, 206, 86, 0.4)',
        borderColor: 'rgba(255, 206, 86, 1)',
        borderWidth: 1,
        data: labels.map((key) => monthlyData.protein[key]),
      },
    ],
  };
};

useEffect(() => {
  
  // Effect for carbfatdata chart
  if (!showCarbfatproChart || !carbfatproChartData) return;
   
  const ctx = document.getElementById('carbfatproteinchart').getContext('2d');
  
   const newCarbfatproChartInstance = new Chart(ctx, {
    type: 'line', // Change the chart type to 'line'
    data: carbfatproChartData,
    options: {
      scales: {
        x: {
          type: 'category',
          position: 'bottom',
          title: {
            display: true,
            text: selectedYear === 'all' ? 'Year' : selectedMonth === 'all' ? 'Year' : 'Month',
          },
        },
        y: {
          title: {
            display: true,
            text: 'Nutrient Intake',
          },
        },
      },
    },
  });

  return () => {
    if (newCarbfatproChartInstance) {
      newCarbfatproChartInstance.destroy();
    }
  };
}, [showCarbfatproChart, carbfatproChartData]);

const handleContainerClick4 = () => {
    // Function to handle container click
    setShowCarbfatproChart(true); // Show emotions chart when container is clicked
  };














/* emotions chart */
const updateEmotionsChartData = (data, year, month) => {
  let emotionsChartData;
  if (year === 'all') {
    emotionsChartData = generateYearlyEmotionsChartData(data);
  } else {
    emotionsChartData = generateMonthlyEmotionsChartData(data, year, month);
  }
  setEmotionsChartData(emotionsChartData);
};


const emotionColors = {
  Joy: 'rgba(255, 99, 132, 0.4)',
  Anger: 'rgba(255, 206, 86, 0.4)',
  Admiration: 'rgba(54, 162, 235, 0.4)',
  Neutral: 'rgba(75, 192, 192, 0.4)',
  Sadness: 'rgba(153, 102, 255, 0.4)',
  Fear: 'rgba(255, 159, 64, 0.4)'
};


const getEmotionColor = (emotion) => {
  // Define colors for each emotion type
  const colors = {
    Joy: 'rgba(255, 99, 132, 0.4)',
    Anger: 'rgba(54, 162, 235, 0.4)',
    Admiration: 'rgba(255, 206, 86, 0.4)',
    Neutral: 'rgba(75, 192, 192, 0.4)',
    Sadness: 'rgba(153, 102, 255, 0.4)',
    Fear: 'rgba(255, 159, 64, 0.4)'
  };
  return colors[emotion];
};


const generateYearlyEmotionsChartData = (data) => {
  const yearlyData = {};
  
  // Initialize yearlyData with emotion counts for each year
  data.forEach((entry) => {
    const year = entry.date.split('-')[0];
    if (!yearlyData[year]) {
      yearlyData[year] = {
        Joy: 0,
        Anger: 0,
        Admiration: 0,
        Neutral: 0,
        Sadness: 0,
        Fear: 0
      };
    }
    yearlyData[year][entry.emotions] += 1;
  });

  const years = Object.keys(yearlyData).sort(); // Sort years in ascending order
  const labels = years.map(year => year.toString()); // Convert years to strings for labels

  // Prepare datasets for each emotion
  const datasets = Object.keys(emotionColors).map((emotion, index) => ({
    label: emotion,
    backgroundColor: emotionColors[emotion],
    data: years.map(year => yearlyData[year][emotion] || 0) // Get emotion count for each year
  }));

  return {
    labels: labels,
    datasets: datasets
  };
};


const generateMonthlyEmotionsChartData = (data, year, month) => {
  // Initialize an object to store emotions data for each month of the selected year
  const monthlyData = {};

  // Filter data for the selected year
  const filteredData = data.filter(entry => {
    const [entryYear, entryMonth] = entry.date.split('-');
    return entryYear === year;
  });

  // Iterate over the filtered data to populate monthlyData
  filteredData.forEach(entry => {
    const [entryYear, entryMonth, entryDay] = entry.date.split('-');
    const key = month === 'all' ? entryMonth : entry.date;
    if (!monthlyData[key]) {
      // Initialize the data for the month if it doesn't exist
      monthlyData[key] = {};
      // Initialize counts for all emotion types
      Object.keys(emotionColors).forEach(emotion => {
        monthlyData[key][emotion] = 0;
      });
    }
    // Increment the occurrence count for the emotion in this month
    monthlyData[key][entry.emotions] += 1;
  });

  // Extract labels (months) and datasets (emotions) from monthlyData
  const labels = Object.keys(monthlyData);
  const emotions = Object.keys(emotionColors);

  // Generate datasets for each emotion
  const datasets = emotions.map(emotion => ({
    label: emotion,
    backgroundColor: getEmotionColor(emotion),
    data: labels.map(month => monthlyData[month][emotion] || 0) // Populate the data array with counts, or 0 if no data for that emotion in that month
  }));

  return {
    labels: labels,
    datasets: datasets
  };
};


 useEffect(() => {
    // Effect for emotions chart
    if (!showEmotionsChart || !emotionsChartData) return;

    const ctx = document.getElementById('emotionhealthchart').getContext('2d');

    if (!ctx) return;

    const newEmotionsChartInstance = new Chart(ctx, {
      type: 'bar',
      data: emotionsChartData,
      options: {
        scales: {
          x: {
            stacked: true,
            type: 'category',
            position: 'bottom',
            title: {
              display: true,
              text: 'Date',
            },
          },
          y: {
            stacked: true,
            title: {
              display: true,
              text: 'Emotion Occurrences',
            },
          },
        },
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      },
    });

    return () => {
      if (newEmotionsChartInstance) {
        newEmotionsChartInstance.destroy();
      }
    };
  }, [showEmotionsChart, emotionsChartData]);

  const handleContainerClick5 = () => {
    // Function to handle container click
    setShowEmotionsChart(true); // Show emotions chart when container is clicked
  };

















  /* Depression chart data */
  const updateDepressionChartData = (data, year, month) => {
    let depressionChartData;
    if (year === 'all') {
      depressionChartData = generateYearlyDepressionChartData(data);
    } else {
      depressionChartData = generateMonthlyDepressionChartData(data, year, month);
    }
    setDepressionChartData(depressionChartData);
  };
  

  const depressionColors = {
    high: 'rgba(255, 99, 132, 0.4)',
    Mild: 'rgba(54, 162, 235, 0.4)',
    Minimal: 'rgba(255, 206, 86, 0.4)',
    moderate: 'rgba(75, 192, 192, 0.4)',
    'moderately severe': 'rgba(153, 102, 255, 0.4)',
  };
  
  const getDepressionColor = (depressionLevel) => {
    return depressionColors[depressionLevel];
  };
  
  const generateYearlyDepressionChartData = (data) => {
    const yearlyData = {};
    
    data.forEach((entry) => {
      const year = entry.date.split('-')[0];
      if (!yearlyData[year]) {
        yearlyData[year] = {
          high: 0,
          Mild: 0,
          Minimal: 0,
          moderate: 0,
          'moderately severe': 0,
        };
      }
      yearlyData[year][entry.concern_severity_level] += 1;
    });
  
    const years = Object.keys(yearlyData).sort(); 
    const labels = years.map(year => year.toString()); 
  
    const datasets = Object.keys(depressionColors).map((level) => ({
      label: level,
      backgroundColor: depressionColors[level],
      data: years.map(year => yearlyData[year][level] || 0)
    }));
  
    return {
      labels: labels,
      datasets: datasets
    };
  };
  
  const generateMonthlyDepressionChartData = (data, year, month) => {
    const monthlyData = {};
  
    const filteredData = data.filter(entry => {
      const [entryYear, entryMonth] = entry.date.split('-');
      return entryYear === year;
    });
  
    filteredData.forEach(entry => {
      const [entryYear, entryMonth, entryDay] = entry.date.split('-');
      const key = month === 'all' ? entryMonth : entry.date;
      if (!monthlyData[key]) {
        monthlyData[key] = {};
        Object.keys(depressionColors).forEach(level => {
          monthlyData[key][level] = 0;
        });
      }
      monthlyData[key][entry.concern_severity_level] += 1;
    });
  
    const labels = Object.keys(monthlyData);
    const levels = Object.keys(depressionColors);
  
    const datasets = levels.map(level => ({
      label: level,
      backgroundColor: getDepressionColor(level),
      data: labels.map(month => monthlyData[month][level] || 0)
    }));
  
    return {
      labels: labels,
      datasets: datasets
    };
  };
  
  
 useEffect(() => {
  if (!showDepressionChart || !depressionChartData) return;

  const ctx = document.getElementById('depressionhealthchart').getContext('2d');

  if (!ctx) return;

  const newDepressionChartInstance = new Chart(ctx, {
    type: 'bar', // Change chart type to 'bar'
    data: depressionChartData,
    options: {
      indexAxis: 'x', // Change the axis to 'x' for horizontal bars
      scales: {
        y: {
          stacked: false, // Disable stacking for multiple bars
          title: {
            display: true,
            text: 'Emotion Occurrences',
          },
        },
        x: {
          title: {
            display: true,
            text: 'Date',
          },
        },
      },
      plugins: {
        legend: {
          display: true,
          position: 'top', // Position legend above the chart
        },
      },
    },
  });

  return () => {
    if (newDepressionChartInstance) {
      newDepressionChartInstance.destroy();
    }
  };
}, [showDepressionChart, depressionChartData]);

const handleContainerClick1 = () => {
  setShowDepressionChart(true); 
};

  




















/* Anxiety chart data */

const updateAnxietyChartData = (data, year, month) => {
  let anxietyChartData;
  if (year === 'all') {
    anxietyChartData = generateYearlyAnxietyChartData(data);
  } else {
    anxietyChartData = generateMonthlyAnxietyChartData(data, year, month);
  }
  setAnxietyChartData(anxietyChartData);
};

const anxietyColors = {
  moderate: 'rgba(255, 99, 132, 0.4)',
  mild: 'rgba(54, 162, 235, 0.4)',
  severe: 'rgba(255, 206, 86, 0.4)',
  minimal: 'rgba(75, 192, 192, 0.4)',
};

const getAnxietyColor = (anxietyLevel) => {
  return anxietyColors[anxietyLevel];
};

const generateYearlyAnxietyChartData = (data) => {
  const yearlyData = {};

  // Iterate through the data and count occurrences of each anxiety level for each year
  data.forEach((entry) => {
    const year = entry.date.split('-')[0];
    if (!yearlyData[year]) {
      yearlyData[year] = {
        moderate: 0,
        mild: 0,
        severe: 0,
        minimal: 0,
      };
    }
    yearlyData[year][entry.concern_severity_anx] += 1;
  });

  // Extract years and anxiety levels from the yearlyData object
  const years = Object.keys(yearlyData).sort(); 
  const labels = years.map(year => year.toString());

  // Generate datasets for each year
  const datasets = years.map((year) => ({
    label: year,
    backgroundColor: Object.values(anxietyColors),
    data: Object.values(yearlyData[year])
  }));

  return {
    labels: labels,
    datasets: datasets
  };
};

const generateMonthlyAnxietyChartData = (data, year, month) => {
  const monthlyData = {};

  // Filter data for the selected year
  const filteredData = data.filter(entry => {
    const [entryYear, entryMonth] = entry.date.split('-');
    return entryYear === year;
  });

  // Iterate through the filtered data and count occurrences of each anxiety level for each month
  filteredData.forEach(entry => {
    const [entryYear, entryMonth, entryDay] = entry.date.split('-');
    const key = month === 'all' ? entryMonth : entry.date;
    if (!monthlyData[key]) {
      monthlyData[key] = {
        moderate: 0,
        mild: 0,
        severe: 0,
        minimal: 0,
      };
    }
    monthlyData[key][entry.concern_severity_anx] += 1;
  });

  // Extract months and anxiety levels from the monthlyData object
  const labels = Object.keys(monthlyData);
  const levels = Object.keys(anxietyColors);

  // Generate datasets for each month
  const datasets = labels.map((label) => ({
    label: label,
    backgroundColor: Object.values(anxietyColors),
    data: Object.values(monthlyData[label])
  }));

  return {
    labels: labels,
    datasets: datasets
  };
};


useEffect(() => {
  if (!showAnxietyChart || !anxietyChartData) return;

  const ctx = document.getElementById('anxietyHealthChart').getContext('2d');

  if (!ctx) return;

  const newAnxietyChartInstance = new Chart(ctx, {
    type: 'pie', // Set chart type to 'pie' for a pie chart
    data: anxietyChartData,
    options: {
      plugins: {
        legend: {
          display: true,
          position: 'top',
        },
      },
    },
  });

  return () => {
    if (newAnxietyChartInstance) {
      newAnxietyChartInstance.destroy();
    }
  };
}, [showAnxietyChart, anxietyChartData]);


const handleContainerClick2 = () => {
  setShowAnxietyChart(true);
};

   




/* calorie chart  */
const updateCalorieChart = (data, year, month) => {
  let totalCalories = 0;

  if (year === 'all' && month === 'all') {
    // Sum up all calories burned across all years and all months
    data.forEach((entry) => {
      totalCalories += entry.calories_burn;
    });
  } else if (year !== 'all' && month === 'all') {
    // Sum up all calories burned for a specific year across all months
    data.forEach((entry) => {
      const [entryYear] = entry.date.split('-');
      if (entryYear === year) {
        totalCalories += entry.calories_burn;
      }
    });
  } else {
    // Sum up all calories burned for a specific year and month
    data.forEach((entry) => {
      const [entryYear, entryMonth] = entry.date.split('-');
      if (entryYear === year && entryMonth === month) {
        totalCalories += entry.calories_burn;
      }
    });
  }

  // Set the totalCalories value to be displayed in container 3
  setCalorieChartData({ totalCalories });
};

// Click event handler for container 3
const handleContainerClick3 = () => {
  setClicked(!clicked); // Toggle the clicked state
};



  


  return (
    <div className="dashboardmaincontainer">
  



     <div className='choosenboxes1'>
          <div className="yearsbox1">
            <select value={selectedYear} onChange={handleYearChange}>
              <option value="all">All Years</option>
              {years.map((year) => (
                <option key={year} value={year}>
                  {year}
                </option>
              ))}
            </select>
          </div>

          <div className="monthsbox1">
            <select value={selectedMonth} onChange={handleMonthChange}>
              <option value="all">All Months</option>
              {months.map((month) => (
                <option key={month} value={month}>
                  {month}
                </option>
              ))}
            </select>
          </div>          
        </div>




        
      <div className='dashboardcontainer1'> 

      {/* Container 1 */}
      <div className="chart-container1" onClick={handleContainerClick1} >
        <h3>Depression Logs</h3>
        {showDepressionChart && depressionChartData ? (
          <canvas id="depressionhealthchart"></canvas>
        ) : (
          <p>Click here to view Depression Logs</p>
        )}
        
      </div>




      {/* Container 2 */}
      <div className="chart-container2" onClick={handleContainerClick2}>
        <h3>Anxiety Logs</h3>
        {showAnxietyChart && anxietyChartData ? (
          <canvas id="anxietyHealthChart"></canvas>
        ) : (
          <p>Click here to view Anxiety Logs</p>
        )}
      </div>




      {/* Container 3 */}
      <div className="chart-container3" onClick={handleContainerClick3}>
        <h3>Burned Calories</h3>
        {clicked ? (
          // Display total calories burned if clicked
          calorieChartData ? (
            
            <div>
            <p> {calorieChartData.totalCalories}</p>
            <img src={burncalories} alt="Burned Calories" />
          </div>
            //calorieChartData.totalCalories
             

          ) : (
            // Display loading message or handle empty state
            'No Data Available'
          )
        ) : (
          // Display "Burned Calories Click" initially
          <>
          <p>Burned Calories Click</p>
          <img src={burncalories} alt="Burned Calories" />
        </>
        )}
        
      </div>

      </div>




     <div className='dashboardcontainer2'> 
      {/* Container 4 */}
      <div className="chart-container4" onClick={handleContainerClick4}>
        <h3>Calorie Logs</h3>
        {showCarbfatproChart && carbfatproChartData ? (
          <canvas id="carbfatproteinchart"></canvas>
        ) : (
          <p>Click here to view Calorie Logs</p>
        )}
      </div>




      {/* Container 5 */}
      <div className="chart-container5" onClick={handleContainerClick5}>
        <h3>Mood Logs</h3>
        {showEmotionsChart && emotionsChartData ? (
          <canvas id="emotionhealthchart"></canvas>
        ) : (
          <p>Click here to view Mood Logs</p>
        )}
      </div>

      </div>

    </div>
  );
};

export default Dashboard;
