# MentPhysique User Manual

## Introduction
Welcome to MentPhysique, a holistic voice assistant designed to enhance both mental and physical wellbeing. This manual will guide you through the functionalities and usage of the app.

## Starting the App
### Start Page
When you open the app, you will see a short description of MentPhysique and two buttons: **Login** and **Sign Up**.

### Sign Up
1. **Click on Sign Up**.
2. **Enter your details**:
   - Username
   - Email
   - Password
3. **Click Next**.
4. **Enter additional information**:
   - Country
   - Gender
   - Age
   - Weight
   - Height
   - Two security questions and answers
5. **Click on Sign Up**. Your account will be created, and you will be directed to the chat page.

### Login
1. **Click on Login**.
2. **Enter your email and password**.
3. **Click on Login**. You will be directed to the chat page.

## Main Features

### Chat Page
Here you can interact with the model using text or voice commands. 

#### Mental Health Detection
- The model can detect anxiety and depression.
- You will be prompted to visit the questionnaire page where you fill out PHQ-9 and GAD-7 forms.
- Based on your responses, the model will determine the severity of your depression and anxiety.

#### Calorie Tracking
- Tell the model what you have eaten.
- A table with options will appear. Select the item you ate, and the information will be saved.

#### Exercise Tracking
- Report your exercise, e.g., "I did 20 minutes of swimming today".
- Select the exercise from the table, and the information will be saved.

#### Motivational Quotes and Meditation Exercises
- Request motivational quotes or meditation exercises.
- The model will provide recommendations based on your request.

### Emotion Toggle
- **Off**: The app will not store your emotions.
- **On**: The app will store your emotions in the database.

## Sidebar Options

### Mental Health Test
- Two test options: **Depression Test** and **Anxiety Test**.
- Each test contains a questionnaire page to determine the severity of your condition.

### Alerts Page
- Create alerts by giving them a name, selecting a date and time, and clicking on Create Alert.
- View all your created alerts, along with remaining days and details.

### Dashboard
- Track metrics in **Mental Health**, **Physical Health**, and **Calorie Tracking**.
- Select options to view graphs for mental health, physical health, and calorie tracking.
- Filter data by year, specific months, or a specific month of a year.

### Logs Page
- Track highlights similar to the Dashboard.
- View three graphs: Exercise Tracking in Seconds, Calorie Tracking, and Mental Health Tracking.

### Feedback Page
- Share your overall experience using specific emojis.
- Answer additional questions to help us improve the app.

### Settings Page
- **Manage Profile**: Change username, age, country, weight, height.
- **Change Password**: Update your password by entering a new one.
- **Select a Plan**: Choose between Standard and Premium packages.
- **Help and Support**: View frequently asked questions and contact us via email.
- **Terms and Conditions**: Read the terms and conditions.
- **Report a Problem**: Report any issues you encounter.

## Running the App

### Running the Flutter App
1. **Navigate to the `node_tutorial` directory**:
    ```bash
    cd App/node_tutorial
    ```
2. **Check `pubspec.yaml`** to ensure you have the required version and libraries.
3. **Set up a virtual device** in Android Studio or use a physical device:
   - **Virtual Device**: Create one in Android Studio.
   - **Physical Device**: Enable developer options and USB debugging, then connect it via USB to your laptop.
4. **Run the Flutter app**:
    ```bash
    flutter run
    ```

### Running the Node.js Server
1. **Navigate to the `node_test` directory**:
    ```bash
    cd App/node_test
    ```
2. **Change the IP address** in the code to your local machine's IP address:
   - Find your IP address using `ipconfig` in the command prompt (look for the IPv4 address).
   - Replace `192.168.0.106` with your IP address in the code.
3. **Run the Node.js server**:
    ```bash
    node app.js
    ```
   The server will run on your IP address at port 3000.

### Running the Model
1. **Navigate to the `Deploy` directory**:
    ```bash
    cd App/Deploy
    ```
2. **Check the requirements** in `requirements.txt` and install them:
    ```bash
    pip install -r requirements.txt
    ```
3. **Run the model**:
    ```bash
    uvicorn main:app --host <your-ip-address> --port 8000
    ```
   Replace `<your-ip-address>` with your actual IP address.

Thank you for using MentPhysique. We aim to provide a seamless experience to help you manage your mental and physical wellbeing. If you have any questions or encounter any issues, please visit our Help and Support page or contact us via email.
