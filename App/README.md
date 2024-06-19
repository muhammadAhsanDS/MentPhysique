# MentPhysique App

This is the app for MentPhysique, developed using Flutter for the frontend and Node.js for the backend. The model is located in the Deploy folder.

## Project Structure
- **node_tutorial**: Contains Flutter code.
- **node_test**: Contains Node.js code.
- **Deploy**: Contains the model code.

## Getting Started

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

---

This README file provides a clear guide on how to set up and run each part of the MentPhysique app, including the Flutter frontend, Node.js backend, and the model in the Deploy folder.
