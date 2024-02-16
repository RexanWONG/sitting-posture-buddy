# Sitting Posture Buddy

## Hey!
Welcome to SittingPostureBuddy.  This README will guide you through the basics of getting started and give some background on how this app was built.

## Firstly, why build?
In this day and age, we spend a lot of time sitting in front of computers.  While we are focused and in our zone, we tend to forgot about our sitting posture and end up sitting like a cooked spaghetti noodle.  

Having a bad sitting posture can lead to back pain.  Personally, I spend a lot of time coding in front of my computer, and often I end up with a bad posture and nothing to remind me to sit back straight since my eyes were glued to the screen.  

One day, I was browsing through the CreateML docs on the Apple website, and my back started to hurt.  

That's when I got the idea : I'll build an app that tracks my sitting posture in real time and alerts me briefly when it detects that my sitting posture is bad.

## Using the app
A couple of tips to help you get started so the app will produce the best sitting posture detection results : 
1. Get something like a tripod to hold your iPhone vertically.
2. Position your iphone ~1 meter away from where you're sitting.  The camera should capture the entire side view of your body.
3. Try experimenting by switching your sitting posture from an upright posture to a bad posture.  When your sitting posture becomes bad, you will hear an alert sound.  The app makes a judgement of your sitting posture every 2 seconds, and displays it on the screen. : either a bad posture or a good posture, with the confidence level of its judgement

## How I built it
To determine if someone has a good posture or bad posture, I decided to use machine learning to acheive that.  The app would make a prediction based on what it was told was a good posture or bad posture, aka the traning data.  

However, after searching for long, I couldn't find any video dataset of people sitting in a good posture and people sitting in a bad posture.  I also couldn't find any machine learning model that classifies good and bad posture.  

Therefore, I decided to create my own model that does that.  

Firstly, I needed to collect images of good posture and bad posture.  So I set up a tripod and recorded my family and friends sitting on a chair with a good or bad posture.  An hour later, after extracting the sitting footage from one long video of different people sitting down on a chair, I had around 20 videos of each good posture and bad posture.  

Next, it was time to use these videos to train a machine learning (ML) model that makes the predictions.  Even though I had no real knowledge of machine knowledge, let alone training a ML model on videos to classify specific actions, CreateML made the job easy for me.  All I had to do was to import my videos into CreateML and in the end I ended up with an action classifier ML model from CreateML that could classify good sitting posture from bad sitting posture.  

However, the first few models that I trained made some mistakes.  For example, they could identify bad sitting posture well with a high confidence level, but sometimes they thought footage of good sitting posture was bad sitting posture.  Luckly, CreateML also made it easy to iterate and experiment with the data to see if they yield different results.  In the end, I removed some footage that I thought could be good posture but close to bad posture from the dataset, and ended up with a model that could manage to classify good sitting posture from bad sitting posture fairly well, after training it for 80 iterations with a 85% accuracy score.  

After creating a model that could classify good sitting posture with bad sitting posture, it was time to code an app that could track sitting posture in real time and use the model to make a judgement about the sitting posture.  

I used AVFoundation to quickly set up an AVCaptureSession that captures camera data and displays a live camera preview within the app.  

Next, I used the vision framework to find human body poses within the live camera feed and then overlay a preview of the results on the camera preview to see if the framework is correctly recognizing a human body when moving in front of the camera.  

Through recgonising a human body pose, I used the ML model that I created to predict the sitting posture.  The ML model will return the prediction and the confidence of its prediction, and I used UIKit to display that information on the screen.  

Overall I learnt a lot of things from building this app.  I learnt how easy it was to create ML models with CreateML and attach it to an app with various technologies such as the vision framework.  I enjoyed the process of building a dataset and this entire process makes me want to build more apps in the future with machine learning to unlock a whole new array of applications.
