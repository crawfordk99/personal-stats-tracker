# personal_stats_tracker

# Overview

Sports is something I've always been passionate about. I wanted to learn 
how to make an app that allows you to keep track of your personal stats. Flutter is a
newer framework I've been trying to learn, and I wanted to lay the groundwork for this idea
in Flutter (and Dart). 

I've now updated the app to use Firebase local emulator suite to simulate running the app on the cloud. 
It now opens with a login/sign up page, and a navigation bar for the user to switch between an enter stats screen and 
see stats screen. It uses a drop down menu to switch between sports, and their different stats. The app is able to save
the user's login email, password, and their stats locally. It persists after closing and restarting the app. When the
user enters stats, it will rewrite the entry instead of making new entries (still need to implement accumulation of stats). 


[Software Demo Video part 1](https://youtu.be/6tIJdPUmhKc)
[Software Demo Video part 2](https://youtu.be/nc6d-AjsOgA)

# Development Environment

I used Flutter's basic create project template to create the flutter folder.
I did this in Android Studio. I used Android Version 8.2.2 to allow for Android emulation. 

Updated Java JDK to 17 from 11. (17 and up needed to run Android emulation)

Used Firebase auth, firestore, and ui emulators. Created a shell script to allow for simulating saving
to the cloud locally (./emulator-data). 

firebase emulators:start --import=./emulator-data --export-on-exit=./emulator-data

Dart is the programming language for Flutter. Used material, flutter_riverpod, and collection dart packages 
in addition to base dart packages.

# Useful Websites

Flutter and Dart have many examples on their sites.
* [Flutter Docs](https://docs.flutter.dev/)
* [Dart Dev](https://dart.dev/docs)
* [ChatGpt](https://chatgpt.com)

# Future Work

* Continue to separate UI logic and business logic (reduce using set state)
* Implement password rules
* Clean up stat calculations, and allow for accumulation of stats, not just rewriting the entry
* Add more sports
* Implement a drop down menu for user to choose which stats they want to update
* Switch from emulators to actual cloud features
