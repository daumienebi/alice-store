# Alice Store

Simple project to simulate a Shopping App where users can view products, add products to wishlist, handle cart items,search for products etc..

The app is part of a friend's final project of a Screen printing course. I decided to take on this task to broaden my knowledge,get to work
with Firebase and polish my flutter skills.

**Note** : The app is not meant to be a real-world shopping app, it might be be taken down from the Playstore after the project is presented but
the APK will be available here with the source code.

## Features

- [x] View products.
- [x] Add items to cart (remaining persistence).
- [x] Wishlist items (remaining persistence).
- [x] User Authentication
- [x] Search for items.
- [x] Delete user account.

## Screenshots

| 📸 | 📸 | 📸 |
|:---:|:---:|:---:|
| ![file2](https://user-images.githubusercontent.com/90214727/229847111-99e16d3b-93b9-4bdd-a3a2-5be6696a7a6a.png) | ![file3](https://user-images.githubusercontent.com/90214727/229847126-63afc6c4-0bbf-4ea1-8904-050684fce0d2.png) | ![file4](https://user-images.githubusercontent.com/90214727/229847134-331e23ac-c440-4af7-82df-a3b0b941dc15.png) |
| ![file5](https://user-images.githubusercontent.com/90214727/229847141-0e3ae3fb-cb52-4664-9575-c7ef6caac89c.png) | ![file6](https://user-images.githubusercontent.com/90214727/229847148-cc0192b4-999c-4436-8a08-a37abb09f2ca.png) | ![file7](https://user-images.githubusercontent.com/90214727/229847152-17748ef4-9764-462f-b026-1757536a1b09.png) |

## Configure Firebase for the project
To modify the app for your personal use you have to create your own Firebase project for the developement and configure it correctly.

Use the [Firebase Console](https://console.firebase.google.com) to create a new firebase project and add the android/ios app. If you prefer to configure it directly
for Flutter, you can choose the Flutter option and follow the FlutterFire instructions. After the configuration, Download the google-services.json file and add it 
to the `alice_store/android/app/` folder. The project won't connect to firebase without that file.
  
  ### Resources
  - [Firebase setup page](https://firebase.google.com/docs/android/setup?hl=es-419) for more help or reference.
  - Follow this [Youtube Tutorial](https://www.youtube.com/watch?v=1k-gITZA9CI&t=1s) on HeyFlutter / Johannes Mike channel to set it up easily.
  - Extra [Building and Releasing and Android app](https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration)
  
In case you get any error while compiling the app, you might need to add the SHA-1 and SHA-256 Fingerprints to the app if you haven't added them yet. Check out [How to generate SHA Fingerprints](https://developers.google.com/android/guides/client-auth?hl=es-419) and [How to add SHA Fingerprints to Firebase for Android app](https://www.geeksforgeeks.org/how-to-add-sha-fingerprints-for-your-firebase-android-app/)
for more info on how to generate the fingerprints and add them to your Firebase project.

For debug mode Fingerprints, you can use

- `keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore` for Mac/Linux.

- `keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore` for Windows.

## Data
  ### API
  
  The app uses the [Json Server](https://github.com/typicode/json-server) for the data. Details on how to configure it the
  [branch](https://github.com/daumienebi/alice_store/tree/json_server)
  
  ### Images
  
  The images are hosted here on github in different folders in the store_data branch, details here : in this [branch](https://github.com/daumienebi/alice_store/tree/store_data)

## Todo :
 - Complete Firestore implementation (Cart and wishlist)
 - Implement custom exceptions
 - Privacy
 - Localization

