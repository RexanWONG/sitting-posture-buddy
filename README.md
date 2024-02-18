# 🪑 Sitting Posture Buddy

## Hey!
Welcome to SittingPostureBuddy.  This section will guide you through the basics of getting started and give some background on how this app was built.  Estimated read time is ~5 mins.

## Using the app
Here's a working demo of the app.  A couple of tips to help you get started so the app will produce the best sitting posture detection results : 

- Get something like a tripod to hold your iPhone vertically.
- Position your iphone ~1 meter away from where you're sitting.  The camera should capture the entire side view of your body.
- Try experimenting by switching your sitting posture from an upright posture to a bad posture.  When your sitting posture becomes bad, you will hear an alert sound.  The app makes a judgement of your sitting posture every 2 seconds, and displays it on the screen. : either a bad posture or a good posture, with the confidence level of its judgement
 
Video Demo : [https://www.dropbox.com/scl/fi/25amzbkrceizpsy5bb740/SittingPostureBuddyDemo.mp4?rlkey=hts0l0a4am7crrgnrh8ijbeo5&dl=0](url)

![Screenshot 2024-02-18 at 12 55 18 PM](https://github.com/RexanWONG/sitting-posture-buddy/assets/96183717/8d3bcfc1-3643-427d-89fb-881a04d2a656)

## Why Build?
In this day and age, we spend a lot of time sitting in front of computers.  While we are focused and in our zone, we tend to forgot about our sitting posture and end up sitting like a cooked spaghetti noodle.  

Having a bad sitting posture can lead to back pain.  Personally, I spend a lot of time coding in front of my computer, and often I end up with a bad posture and nothing to remind me to sit back straight since my eyes were glued to the screen.  

One day, I was browsing through the CreateML docs on the Apple website, and my back started to hurt.  \n\nThat's when I got the idea : I'll build an app that tracks my sitting posture in real time and alerts me briefly when it detects that my sitting posture is bad.

![IMG_3654](https://github.com/RexanWONG/sitting-posture-buddy/assets/96183717/b1194aa9-320c-4337-a0e8-ba5ac6a0ce91)

## How I built it : The game plan
To determine if someone has a good posture or bad posture, I decided to use machine learning to acheive that.  The app would make a prediction based on what it was told was a good posture or bad posture, aka the traning data.  

However, after searching for long, I couldn't find any video dataset of people sitting in a good posture and people sitting in a bad posture.  I also couldn't find any machine learning model that classifies good and bad posture.  

Therefore, I decided to create my own model that does that.

## Collecting the data
Firstly, I needed to collect videos of good posture and bad posture.  I also needed to collect videos of quality and quantity.  This step was the most crucial.  

After experimenting a lot with how to collect the best data, I decided to set up a camera and recorded my Dad and me constantly sitting on different chairs in front of different backgrounds, wearing different clothes.  

It was 1am in Hong Kong, everyone was asleep, meanwhile I'm busy collecting data for my machine learning model.  

The purpose of collecting sitting posture data of such variety was to feed the ML model more kinds of data to train on so it can recgonise different environments where people are sitting bettter.  In the end, I ended up with 25 videos of each good and bad sitting posture and a photo album full of sitting posture videos.

![Screenshot 2024-02-18 at 1 02 27 PM](https://github.com/RexanWONG/sitting-posture-buddy/assets/96183717/a340004c-58c3-45ac-8e60-39326903183a)

## CreateML
Next, it was time to use these videos to train a machine learning (ML) model that makes the predictions.  Even though I had no real knowledge of machine knowledge, let alone training a ML model on videos to classify specific actions, CreateML made the job easy for me.  

All I had to do was to import my videos into CreateML. and in the end I ended up with an action classifier ML model from CreateML that could classify good sitting posture from bad sitting posture.  

The process was very straightforward, and I was shocked at how easy and powerful it was to create an ML model.  After previewing the model, the accuracy of detecting the sitting posture was 100% correct.  I learnt that the data was the most important part.  You need to collect data of high quality and quantity.

https://github.com/RexanWONG/sitting-posture-buddy/assets/96183717/858c8960-5c39-4c40-ba6d-6e80dc286d83

## Building the app
After creating a model that could classify good sitting posture with bad sitting posture, it was time to code an app that could track sitting posture in real time and use the model to make a judgement about the sitting posture.  

I used AVFoundation to quickly set up an AVCaptureSession that captures camera data and displays a live camera preview within the app.  

Next, I used the vision framework to find human body poses within the live camera feed and then overlay a preview of the results on the camera preview to see if the framework is correctly recognizing a human body when moving in front of the camera.  

Through recgonising a human body pose, I used the ML model that I created to predict the sitting posture.  The ML model will return the prediction and the confidence of its prediction, and I used UIKit to display that information on the screen.  

Overall, I learnt a lot of things from building this app.  I learnt how easy it was to create ML models with CreateML and attach it to an app with various technologies such as the vision framework.  I enjoyed the process of building a dataset and this entire process makes me want to build more apps in the future with machine learning to unlock a whole new array of applications.





