# News9
Internship project - Flutter - April 2021

The main goal of this project was to provide users a way to sign up, sign in to the application, see the list of news, open and read news, browse news by date, categories, sources, keywords, etc., save favorite ones and see them later.

Used [News API](https://newsapi.org/) for fetching news and [Firebase](https://firebase.google.com/) for authentication.

Support mobile (Android & IOS), web, and desktop (macOS) app.

![1](https://i.ibb.co/Db1rJk7/1.png) ![2](https://i.ibb.co/mXKD1cb/2.png) ![3](https://i.ibb.co/L8BtGdg/3.png) 

![4](https://i.ibb.co/CzLJNR4/4.png) ![5](https://i.ibb.co/dDVgQPc/5.png) ![6](https://i.ibb.co/6W1x3z5/6.png)

![7](https://i.ibb.co/zRxmsgD/7.png) ![8](https://i.ibb.co/BVr43SV/8.png) ![9](https://i.ibb.co/D8bjhLW/9.png)

![10](https://i.ibb.co/F04GG0H/10.png) ![11](https://i.ibb.co/tHt9src/11.png)

## Getting Started

1. [Setup Flutter](https://flutter.dev/docs/get-started/install)

1. Clone the repo
    
    ```
    $ git clone https://github.com/Vukan-Markovic/news9.git
    $ cd news9
    ```

1. Setup Firebase app

   1. You'll need to create a Firebase instance. Follow the instructions at [Firebase console](https://console.firebase.google.com/).

   1. Once your Firebase instance is created, you'll need to enable Google and Email/Password authentication:
    
      * Go to the Firebase Console for your new instance
      * Click "Authentication" in the left-hand menu
      * Click the "Sign-in method" tab
      * Click "Google" and enable it
      * Click "Email/Password" and enable it.

   1. For Android:

      * Create an app within your Firebase instance for Android, with same package name as this app.
        
      * Run the following command to get your SHA-1 key:
         ```
         keytool -exportcert -list -v \
         -alias androiddebugkey -keystore ~/.android/debug.keystore
         ```
                
         * In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".

         * Follow instructions to download `google-services.json`.
 
         * Place `google-services.json` into `news9/android/app/`.

   1. For IOS:

         * Create an app within your Firebase instance for iOS, with same package name as this app.

         * Follow instructions to download `GoogleService-Info.plist`, and place it into `news9/ios/Runner` in XCode.

         * Open `news9/ios/Runner/Info.plist`. Locate the second CFBundleURLSchemes key. The item in the array value of this key is specific to the Firebase instance. Replace it with the value for REVERSED_CLIENT_ID from `GoogleService-Info.plist`.

   1. For macOS:

         * Place same `GoogleService-Info.plist` into `news9/macos/Runner` in XCode.
    
   1. For Web:

         * Create an app within your Firebase instance for web, with same package name as this app.

         * Create file `firebase_config.js` at `news9/web` and follow instructions to initialize firebase config variable for the web here.

1. Run the app

   ```
   $ flutter run
   ```
