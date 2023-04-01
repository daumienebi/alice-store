# Alice Store

Simple project to simulate a Shopping App where users can view products, add products to wishlist, handle cart items,search for products etc..

The app is part of a friend's final project of a Screen printing course. I decided to take on this task to broaden my knowledge and
get to work with Firebase and polish my flutter skills.

Note : The app is not meant to be a real-world shopping app, it might be be taken down from the Playstore after the project is presented but
the APK will be available here with the source code.

## Features

- [x] View products.
- [x] Add items to wishlist (remaining persistence).
- [x] Wishlist (remaining persistence).
- [x] User Authentication
- [x] Search for items.
- [x] Delete user account.

## Screenshots
  📸                         | 📸                           | 📸                                       | 📸 
|:--------------------------:|:-----------------------------:|:-----------------------------------------:|:----------------------------------:|
![file1](https://user-images.githubusercontent.com/90214727/228094562-c356f513-6634-48dd-83e3-177281f668b7.png) | ![Screenshot_1679960908](https://user-images.githubusercontent.com/90214727/228094701-9800794a-2c6d-49ae-a361-4b219aba7575.png) | ![Screenshot_1679960612](https://user-images.githubusercontent.com/90214727/228094736-72ad1a2e-49c5-4cc1-9596-51a8f99e09cc.png) | ![Screenshot_1679960915](https://user-images.githubusercontent.com/90214727/228095326-aef4af1c-c692-40a4-a084-276c1154fff2.png) |
![Screenshot_1679960641](https://user-images.githubusercontent.com/90214727/228095404-c8feed59-8509-476b-8658-e090dbf8d0b9.png) | ![Screenshot_1679960654](https://user-images.githubusercontent.com/90214727/228095475-ca45d346-62c7-4a83-aef9-4ef95b226493.png) | ![Screenshot_1679960728](https://user-images.githubusercontent.com/90214727/228095531-53e98ce2-8172-4a98-b0cf-7e434183734e.png) | ![Screenshot_1679960700](https://user-images.githubusercontent.com/90214727/228095583-525b18b5-8691-45f8-a5ba-923a78628783.png)

## Configure Firebase for the project
To modify the app for your personal use you have to create your own Firebase project for the developement and configure it correctly.

Use the [Firebase Console](https://console.firebase.google.com) to create a new firebase project and add the android/ios app. If you prefer to configure it directly
for Flutter, you can choose the Flutter option and follow the FlutterFire instructions. After the configuration, Download the google-services.json file and add it 
to the `alice_store/android/app/` folder. The project won't connect to firebase without that file.
  
  ### Resources
  - [Firebase setup page](https://firebase.google.com/docs/android/setup?hl=es-419) for more help or reference.
  - Follow this [Youtube Tutorial](https://www.youtube.com/watch?v=1k-gITZA9CI&t=1s) on HeyFlutter / Johannes Mike channel to set it up easily.
  
In case you get any error while compiling the app, you might need to add the SHA-1 and SHA-256 Fingerprints to the app if you haven't added them yet. Check out [How to generate SHA Fingerprints](https://developers.google.com/android/guides/client-auth?hl=es-419) and [How to add SHA Fingerprints to Firebase for Android app](https://www.geeksforgeeks.org/how-to-add-sha-fingerprints-for-your-firebase-android-app/)
for more info on how to generate the fingerprints and add them to your Firebase project.

For debug mode Fingerprints, you can use

- `keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore` for Mac/Linux.

- `keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore` for Windows.

## Data
  ### API
  
  The app uses the [Json Server](https://github.com/typicode/json-server) for the data. Details on how to configure it the
  [branch(https://github.com/daumienebi/alice_store/tree/json_server)
  
  ### Images
  
  The images are hosted here on github in different folders in the store_data branch, details here : in this [branch](https://github.com/daumienebi/alice_store/tree/store_data)

## Todo :

  ### App Todo :
  - Multiple items to the cart
  - Complete Firestore implementation (Cart and wishlist)
  - Implement exceptions
  - About app page
  - Privacy
  - Translation

  ### README Todo : 
  - Explain how to configure the project for Firebase
  - Json_Server explanation in the [json_server branch](https://github.com/daumienebi/alice_store/tree/json_server)
  - store_data explanation in the [store_data branch](https://github.com/daumienebi/alice_store/tree/store_data)
  - Requirements
  - Polish App github page
  - Include credits
  - Extra [Building and Releasing and Android app](https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration)

