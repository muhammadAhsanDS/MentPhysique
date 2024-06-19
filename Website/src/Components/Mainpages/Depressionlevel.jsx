import React, { useState } from 'react';
import Resultimg from '../Assets/resultimg.svg';
import './Questionarie.css';

const Depressionlevel = () => {
  const [selectedOptions, setSelectedOptions] = useState(Array(8).fill(null));
  const [totalScore, setTotalScore] = useState(0);

  const handleOptionSelect = (questionIndex, optionIndex) => {
    const newSelectedOptions = [...selectedOptions];
    newSelectedOptions[questionIndex] = optionIndex;
    setSelectedOptions(newSelectedOptions);
  };

  const calculateTotalScore = () => {
    let score = 0;

    for (let i = 0; i < selectedOptions.length; i++) {
      score += selectedOptions[i];
    }

    setTotalScore(score);
  };

  const interpretDepressionSeverity = () => {
    if (totalScore >= 1 && totalScore <= 4) return 'Minimal depression';
    else if (totalScore >= 5 && totalScore <= 9) return 'Mild depression';
    else if (totalScore >= 10 && totalScore <= 14) return 'Moderate depression';
    else if (totalScore >= 15 && totalScore <= 19) return 'Moderately severe depression';
    else if (totalScore >= 20 && totalScore <= 27) return 'Severe depression';

    return '';
  };

  const questions = [
    { question: 'How often you Trouble falling or staying asleep, or sleeping too much', options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'] },
    { question: 'How often you Feel tired or having little energy', options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'] },
    { question: 'How often you experience Poor appetite or overeating', options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'] },
    { question: 'How often you Feel bad about yourself or that you are a failure or have let yourself or your family down', options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'] },
    { question: 'How often you feel Trouble concentrating on things, such as reading the newspaper or watching television', options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'] },
    { question: 'How often you feel that Moving or speaking so slowly that other people could have noticed. Or the opposite being so fidgety or restless that you have been moving around a lot more than usual', options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'] },
    { question: 'How often you get Thoughts that you would be better off dead, or of hurting yourself', options: ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'] },
    { question: 'If you checked off any problems, how difficult have these problems made it for you to do your work, take care of things at home, or get along with other people?', options: ['Not difficult at all', 'Somewhat difficult', 'Very difficult', 'Extremely difficult'] }
  ];

  return (
    <div className="depression-level-container">
      <h1 className="page-heading">Depression Level</h1>
      <div className="questions-container">
        {questions.map((questionObj, questionIndex) => (
          <div key={questionIndex} className="question-box">
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
        <button onClick={calculateTotalScore}>Check Depression</button>
      </div>

      <div className='depression'>
        <div className="content">
          <img src={Resultimg} alt="Result" className="resultimg" />
          <h2>{interpretDepressionSeverity()}</h2>
        </div>
      </div>
    </div>
  );
};

export default Depressionlevel;
