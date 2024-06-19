import React, { useState, useEffect } from 'react';
import './Healthlogs.css';
import Chart from 'chart.js/auto';
import { db } from '../../firebase';
import { doc, getDoc } from 'firebase/firestore';

const Healthlogs = () => {
  const [selectedYear, setSelectedYear] = useState('all');
  const [selectedMonth, setSelectedMonth] = useState('all');
  const [years, setYears] = useState([]);
  const [months, setMonths] = useState([]);
  const [chartData, setChartData] = useState(null);
  const [calorieChartData, setCalorieChartData] = useState([]);
  const [mentalHealthChartData, setMentalHealthChartData] = useState([]);
  const [chartInstance, setChartInstance] = useState(null);
  const [calorieChartInstance, setCalorieChartInstance] = useState(null);
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
            updateChart(data, 'all', 'all');
            updateCalorieChart(data, 'all', 'all');
            updateMentalHealthChart(data, 'all', 'all');
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
        years[year] = { totalDuration: 0, totalCalories: 0, severityLevel: {}, severityAnx: {} };
      }
      years[year].totalDuration += entry.duration;
      years[year].totalCalories += entry.calories_burn;
      years[year].severityLevel[entry.concern_severity_level] = (years[year].severityLevel[entry.concern_severity_level] || 0) + 1;
      years[year].severityAnx[entry.concern_severity_anx] = (years[year].severityAnx[entry.concern_severity_anx] || 0) + 1;
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
        months[yearMonth] = { count: 0, totalDuration: 0, severityLevel: {}, severityAnx: {} };
      }
      months[yearMonth].count++;
      months[yearMonth].totalDuration += entry.duration;
      months[yearMonth].severityLevel[entry.concern_severity_level] = (months[yearMonth].severityLevel[entry.concern_severity_level] || 0) + 1;
      months[yearMonth].severityAnx[entry.concern_severity_anx] = (months[yearMonth].severityAnx[entry.concern_severity_anx] || 0) + 1;
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
    updateChart(exerciseData, year, selectedMonth);
    updateCalorieChart(exerciseData, year, selectedMonth);
    updateMentalHealthChart(exerciseData, year, selectedMonth);
  };

  const handleMonthChange = (e) => {
    const month = e.target.value;
    const formattedMonth = month.length === 1 ? `0${month}` : month;
    setSelectedMonth(formattedMonth);
    updateChart(exerciseData, selectedYear, formattedMonth);
    updateCalorieChart(exerciseData, selectedYear, formattedMonth);
    updateMentalHealthChart(exerciseData, selectedYear, formattedMonth);
  };

  const updateChart = (data, year, month) => {
    let chartData;
    if (year === 'all') {
      chartData = generateYearlyChartData(data);
    } else {
      chartData = generateMonthlyChartData(data, year, month);
    }
    setChartData(chartData);
  };

  const updateCalorieChart = (data, year, month) => {
    let calorieChartData;
    if (year === 'all') {
      calorieChartData = generateYearlyCalorieChartData(data);
    } else {
      calorieChartData = generateMonthlyCalorieChartData(data, year, month);
    }
    setCalorieChartData(calorieChartData);
  };

  const updateMentalHealthChart = (data, year, month) => {
    let mentalHealthChartData;
    if (year === 'all') {
      mentalHealthChartData = generateYearlyMentalHealthChartData(data);
    } else {
      mentalHealthChartData = generateMonthlyMentalHealthChartData(data, year, month);
    }
    setMentalHealthChartData(mentalHealthChartData);
  };

  const generateYearlyChartData = (data) => {
    const yearlyData = {};
    data.forEach((entry) => {
      const [year] = entry.date.split('-');
      if (!yearlyData[year]) {
        yearlyData[year] = 0;
      }
      yearlyData[year] += entry.duration;
    });
    return {
      labels: Object.keys(yearlyData),
      datasets: [
        {
          label: 'Total Exercise Time',
          backgroundColor: 'rgba(75,192,192,0.4)',
          borderColor: 'rgba(75,192,192,1)',
          borderWidth: 1,
          data: Object.values(yearlyData),
        },
      ],
    };
  };

  const generateMonthlyChartData = (data, year, month) => {
    const monthlyData = {};
    data.forEach((entry) => {
      const [entryYear, entryMonth] = entry.date.split('-');
      if (entryYear === year && (month === 'all' || entryMonth === month)) {
        const key = month === 'all' ? entryMonth : entry.date;
        if (!monthlyData[key]) {
          monthlyData[key] = {
            count: 0,
            totalDuration: 0,
          };
        }
        monthlyData[key].count++;
        monthlyData[key].totalDuration += entry.duration;
      }
    });
    const labels = Object.keys(monthlyData);
    const durations = labels.map((key) => monthlyData[key].totalDuration);
    return {
      labels: labels,
      datasets: [
        {
          label: 'Exercise Duration',
          backgroundColor: 'rgba(75,192,192,0.4)',
          borderColor: 'rgba(75,192,192,1)',
          borderWidth: 1,
          data: durations,
        },
      ],
    };
  };


  
  const generateYearlyCalorieChartData = (data) => {
    const yearlyData = {};
    data.forEach((entry) => {
      const [year] = entry.date.split('-');
      if (!yearlyData[year]) {
        yearlyData[year] = 0;
      }
      yearlyData[year] += entry.calories_burn;
    });
    return {
      labels: Object.keys(yearlyData),
      datasets: [
        {
          label: 'Total Calories Burned',
          backgroundColor: 'rgba(255, 99, 132, 0.4)',
          borderColor: 'rgba(255, 99, 132, 1)',
          borderWidth: 1,
          data: Object.values(yearlyData),
        },
      ],
    };
  };

  const generateMonthlyCalorieChartData = (data, year, month) => {
    const monthlyData = {};
    data.forEach((entry) => {
      const [entryYear, entryMonth] = entry.date.split('-');
      if (entryYear === year && (month === 'all' || entryMonth === month)) {
        const key = month === 'all' ? entryMonth : entry.date;
        if (!monthlyData[key]) {
          monthlyData[key] = {
            count: 0,
            totalCalories: 0,
          };
        }
        monthlyData[key].count++;
        monthlyData[key].totalCalories += entry.calories_burn;
      }
    });
    const labels = Object.keys(monthlyData);
    const calories = labels.map((key) => monthlyData[key].totalCalories);
    return {
      labels: labels,
      datasets: [
        {
          label: 'Calories Burned',
          backgroundColor: 'rgba(255, 99, 132, 0.4)',
          borderColor: 'rgba(255, 99, 132, 1)',
          borderWidth: 1,
          data: calories,
        },
      ],
    };
  };

  




 

  const generateMonthlyMentalHealthChartData = (data, year, month) => {
    const monthlyData = {};
    data.forEach((entry) => {
        const [entryYear, entryMonth] = entry.date.split('-');
        if (entryYear === year && (month === 'all' || entryMonth === month)) {
            const key = month === 'all' ? entryMonth : entry.date;
            if (!monthlyData[key]) {
                monthlyData[key] = {};
            }
            monthlyData[key][entry.date] = {
                concern_severity_level: entry.concern_severity_level,
                concern_severity_anx: entry.concern_severity_anx
            };
        }
    });

    const labels = Object.keys(monthlyData);
    const datasets = ['mild', 'high', 'minimal', 'moderate'].map((severity, index) => {
        const backgroundColor = computeBackgroundColor(severity, monthlyData);
        const data = labels.map(month => {
            // Count occurrences of the severity level for concern_severity_level
            const levelCount = Object.values(monthlyData[month]).filter(entry => entry.concern_severity_level === severity).length || 0;
            // Count occurrences of the severity level for concern_severity_anx
            const anxCount = Object.values(monthlyData[month]).filter(entry => entry.concern_severity_anx === severity).length || 0;
            return index < 2 ? levelCount : anxCount;
        });

        return {
            label: severity,
            backgroundColor: backgroundColor,
            data: data
        };
    });

    return {
        labels: labels,
        datasets: datasets
    };
};

const generateYearlyMentalHealthChartData = (data) => {
    const yearlyData = {};
    data.forEach((entry) => {
        const [year] = entry.date.split('-');
        if (!yearlyData[year]) {
            yearlyData[year] = {};
        }
        yearlyData[year][entry.date] = {
            concern_severity_level: entry.concern_severity_level,
            concern_severity_anx: entry.concern_severity_anx
        };
    });

    const labels = Object.keys(yearlyData);
    const datasets = ['mild', 'high', 'minimal', 'moderate'].map((severity, index) => {
        const backgroundColor = computeBackgroundColor(severity, yearlyData);
        const data = labels.map(year => {
            // Count occurrences of the severity level for concern_severity_level
            const levelCount = Object.values(yearlyData[year]).filter(entry => entry.concern_severity_level === severity).length || 0;
            // Count occurrences of the severity level for concern_severity_anx
            const anxCount = Object.values(yearlyData[year]).filter(entry => entry.concern_severity_anx === severity).length || 0;
            return index < 2 ? levelCount : anxCount;
        });

        return {
            label: severity,
            backgroundColor: backgroundColor,
            data: data
        };
    });

    return {
        labels: labels,
        datasets: datasets
    };
};

// Function to compute background color based on the most occurring severity level
const computeBackgroundColor = (severity, data) => {
    const counts = Object.keys(data).map(key => {
        const levelCounts = Object.values(data[key]).map(entry => entry.concern_severity_level);
        const anxCounts = Object.values(data[key]).map(entry => entry.concern_severity_anx);
        return levelCounts.concat(anxCounts);
    });

    const maxCount = Math.max(...counts.flat().filter(level => level === severity).map(_ => 1));
    const totalCount = counts.flat().filter(level => level === severity).length;

    if (totalCount === counts.flat().length && severity !== 'mild') {
        return 'red'; // Red color if all options have the same occurrence and not 'mild'
    } else {
        return severityColors[severity];
    }
};








  useEffect(() => {
    if (!chartData) return;
    if (chartInstance) {
      chartInstance.destroy();
    }
    const ctx = document.getElementById('phyhealthchart').getContext('2d');
    const newChartInstance = new Chart(ctx, {
      type: 'bar',
      data: chartData,
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
              text: 'Exercise Tracking',
            },
          },
        },
      },
    });
    setChartInstance(newChartInstance);
    return () => {
      if (newChartInstance) {
        newChartInstance.destroy();
      }
    };
  }, [chartData, selectedYear, selectedMonth]);

  useEffect(() => {
    if (!calorieChartData) return;
    if (calorieChartInstance) {
      calorieChartInstance.destroy();
    }
    const ctx = document.getElementById('caloriehealthchart').getContext('2d');
    const newCalorieChartInstance = new Chart(ctx, {
      type: 'bar',
      data: calorieChartData,
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
              text: 'Calorie Tracking',
            },
          },
        },
      },
    });
    setCalorieChartInstance(newCalorieChartInstance);
    return () => {
      if (newCalorieChartInstance) {
        newCalorieChartInstance.destroy();
      }
    };
  }, [calorieChartData, selectedYear, selectedMonth]);

  useEffect(() => {
    if (!mentalHealthChartData) return;
    if (mentalHealthChartInstance) {
      mentalHealthChartInstance.destroy();
    }
    const ctx = document.getElementById('mentalhealthchart').getContext('2d');
    const newMentalHealthChartInstance = new Chart(ctx, {
      type: 'bar',
      data: mentalHealthChartData,
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
              text: 'Mental Health Tracking',
            },
          },
        },
      },
    });
    setMentalHealthChartInstance(newMentalHealthChartInstance);
    return () => {
      if (newMentalHealthChartInstance) {
        newMentalHealthChartInstance.destroy();
      }
    };
  }, [mentalHealthChartData, selectedYear, selectedMonth]);

  return (
    <div className="healthlogcontainer">
      <h1 className="logheading">Health Logs</h1>
      <div className='healthlogcontainer1'>

        <div className='choosenboxes'>
          <div className="yearsbox">
            <select value={selectedYear} onChange={handleYearChange}>
              <option value="all">All Years</option>
              {years.map((year) => (
                <option key={year} value={year}>
                  {year}
                </option>
              ))}
            </select>
          </div>

          <div className="monthsbox">
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

        <div className='exercisetracking'>
          <div className="exerciseheading">
            Exercise Tracking In Seconds
          </div>
          <div className="chart-container" style={{ marginTop: 50,marginLeft: 10 ,width: '470px', height: '250px' }}>
            <canvas id="phyhealthchart"></canvas>
          </div>
        </div>

        <div className='calorietracking'>
          <div className="calorieheading">
            Calorie Tracking
          </div>
          <div className="chart-container" style={{ marginTop: 50,marginLeft: 10 ,width: '470px', height: '250px' }}>
            <canvas id="caloriehealthchart"></canvas>
          </div>
        </div>

        <div className='mentaltracking'>
          <div className="mentalheading">
            Mental Health Tracking
          </div>
          <div className="chart-container" style={{ marginTop: 50,marginLeft: 10 ,width: '470px', height: '250px' }}>
            <canvas id="mentalhealthchart"></canvas>
          </div>
        </div>

      </div>
    </div>
  );
};

export default Healthlogs;
