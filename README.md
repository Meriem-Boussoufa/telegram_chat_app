To get started with this project, follow these steps:

## Prerequisites
Before running the app, make sure you have:

Flutter SDK installed
Firebase installed
Google Firebase project created
Google Services JSON file and Firebase Options File are added to the project

## Installation
1- Clone this repository:
git clone https://github.com/Meriem-Boussoufa/telegram_chat_app

2- Navigate to the project directory:
cd telegram_chat_app

3- Install dependencies:
flutter pub get

## Configuration
Before running the app, you need to configure Firebase Authentication with Google Sign-In:

Go to the Firebase Console.

1- Create a new project or select an existing one.

2- Enable Google Sign-In authentication method in the Firebase Authentication panel.

3- Retrieves the SHA1 key for your debug keystore: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android 

4- Add your Android application to the Firebase.

5- Download the google-services.json file and add it to the android/app directory of your Flutter project using the following commands:

  - Re-authenticate Firebase CLI: firebase login --reauth 
  - Installs the FlutterFire CLI, a command-line tool for Flutter Firebase integration: dart pub global activate flutterfire_cli 
  - Lists all your Firebase projects along with their IDs: firebase projects:list 
  - Replace PROJECT_ID with the ID of your Firebase project. This command configures your Flutter project with Firebase: flutterfire configure --project=PROJECT ID

## Screenshots
![1](https://github.com/Meriem-Boussoufa/telegram_chat_app/assets/93092761/5bf85058-d54c-4716-a4cf-3fc7795f2f94)
![2](https://github.com/Meriem-Boussoufa/telegram_chat_app/assets/93092761/dfe8bd6c-7efa-468a-9f56-56d6b0403317)

![3](https://github.com/Meriem-Boussoufa/telegram_chat_app/assets/93092761/d3268bc3-638d-4b9a-bdfc-2710d5628ff9)
![4](https://github.com/Meriem-Boussoufa/telegram_chat_app/assets/93092761/1d698ef6-f900-4390-8c8c-11d55b042eab)
![5](https://github.com/Meriem-Boussoufa/telegram_chat_app/assets/93092761/127ce44a-f4de-4b91-8db7-efa64ec04546)



