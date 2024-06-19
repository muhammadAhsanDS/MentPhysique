import React, { useState } from 'react';
import Resultimg from '../Assets/resultimg.svg';
import './Questionarie.css';

const AnxietyLevel = () => {
  const [selectedOptions, setSelectedOptions] = useState(Array(7).fill(null));
  const [totalScore, setTotalScore] = useState(0);

  const handleOptionSelect = (questionIndex, optionIndex) => {
    const newSelectedOptions = [...selectedOptions];
    newSelectedOptions[questionIndex] = optionIndex;
    setSelectedOptions(newSelectedOptions);
  };

  const calculateTotalScore = () => {
    let score = 0;

    // Scoring: add up all checked boxes on GAD-7
    for (let i = 0; i < selectedOptions.length; i++) {
      score += selectedOptions[i];
    }

    setTotalScore(score);
  };

  const interpretAnxietySeverity = () => {
    // Interpretation of Total Score for GAD-7
    if (totalScore >= 0 && totalScore <= 4) return 'Minimal anxiety';
    else if (totalScore >= 5 && totalScore <= 9) return 'Mild anxiety';
    else if (totalScore >= 10 && totalScore <= 14) return 'Moderate anxiety';
    else if (totalScore >= 15 && totalScore <= 21) return 'Severe anxiety';

    return '';
  };

  const questions = [
    {
      question: 'Feeling nervous, anxious, or on edge',
      options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    },
    {
      question: 'Not being able to stop or control worrying',
      options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    },
    {
      question: 'Worrying too much about different things',
      options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    },
    {
      question: 'Trouble relaxing',
      options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    },
    {
      question: 'Being so restless that it is hard to sit still',
      options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    },
    {
      question: 'Becoming easily annoyed or irritable',
      options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    },
    {
      question: 'Feeling afraid, as if something awful might happen',
      options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
    },
  ];

  return (
    <div className="anxiety-level-container">
      <h1 className="page-heading">Anxiety Level</h1>
      <div className="questions-container">
        {questions.map((questionObj, questionIndex) => (
          <div key={questionIndex} className="question-box1">
            <h1>Question No {questionIndex + 1}:</h1>
            <p>{`${questionObj.question}`}</p>

            <div className="options">
              {questionObj.options.map((option, optionIndex) => (
                <label key={optionIndex} className="option">
                  <input
                    type="radio"
                    name={`question${questionIndex}`}
                    checked={selectedOptions[questionIndex] === optionIndex}
                    onChange={() => handleOptionSelect(questionIndex, optionIndex)}
                  />
                  {option}
                </label>
              ))}
            </div>

          </div>
        ))}
      </div>

      <div className='depresslevel'>
        <button onClick={calculateTotalScore}> Check Anxiety</button>
      </div>

      <div className='depression'>
        <div className="content">
        <img src={Resultimg} alt="Result" className="resultimg" /> 
          <h2>{interpretAnxietySeverity()}</h2>
        </div>
      </div>
    </div>
  );
};

export default AnxietyLevel;
