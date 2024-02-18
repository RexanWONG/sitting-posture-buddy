//
//  InstructionsViewController.swift
//  SittingPostureBuddy
//
//  Created by Rexan Wong on 15/2/2024.
//

import UIKit
import AVFoundation

class InstructionsViewController: UIViewController {
    enum MediaType {
        case image(String)
        case video(String)
    }

    struct InstructionMedia {
        var title: String
        var text: String
        var media: [MediaType]?
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupInstructions()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupInstructions() {
        let instructions: [InstructionMedia] = [
            InstructionMedia(
                title: "Hey!",
                text: "Welcome to SittingPostureBuddy.  This section will guide you through the basics of getting started and give some background on how this app was built.  Estimated read time is ~5 mins.",
                media: nil
            ),
            InstructionMedia(
                title: "Using the app",
                text:  "Here's a working demo of the app.  A couple of tips to help you get started so the app will produce the best sitting posture detection results : \n\n1. Get something like a tripod to hold your iPhone vertically.  \n\n2. Position your iphone ~1 meter away from where you're sitting.  The camera should capture the entire side view of your body.  \n\n3. Try experimenting by switching your sitting posture from an upright posture to a bad posture.  When your sitting posture becomes bad, you will hear an alert sound.  The app makes a judgement of your sitting posture every 2 seconds, and displays it on the screen. : either a bad posture or a good posture, with the confidence level of its judgement",
                media: [.image("UsingTheApp")]
            ),
            InstructionMedia(
                title: "Why build?",
                text: "In this day and age, we spend a lot of time sitting in front of computers.  While we are focused and in our zone, we tend to forgot about our sitting posture and end up sitting like a cooked spaghetti noodle.  \n\nHaving a bad sitting posture can lead to back pain.  Personally, I spend a lot of time coding in front of my computer, and often I end up with a bad posture and nothing to remind me to sit back straight since my eyes were glued to the screen.  \n\nOne day, I was browsing through the CreateML docs on the Apple website, and my back started to hurt.  \n\nThat's when I got the idea : I'll build an app that tracks my sitting posture in real time and alerts me briefly when it detects that my sitting posture is bad.",
                media: [.image("WhyBuild")]
            ),
            InstructionMedia(
                title: "How I built it: The game plan",
                text: "To determine if someone has a good posture or bad posture, I decided to use machine learning to acheive that.  The app would make a prediction based on what it was told was a good posture or bad posture, aka the traning data.  \n\nHowever, after searching for long, I couldn't find any video dataset of people sitting in a good posture and people sitting in a bad posture.  I also couldn't find any machine learning model that classifies good and bad posture.  \n\nTherefore, I decided to create my own model that does that.",
                media: nil
            ),
            InstructionMedia(
                title: "Collecting the data",
                text: "Firstly, I needed to collect videos of good posture and bad posture.  I also needed to collect videos of quality and quantity.  This step was the most crucial.  \n\nAfter experimenting a lot with how to collect the best data, I decided to set up a camera and recorded my Dad and me constantly sitting on different chairs in front of different backgrounds, wearing different clothes.  \n\nIt was 1am in Hong Kong, everyone was asleep, meanwhile I'm busy collecting data for my machine learning model.  \n\nThe purpose of collecting sitting posture data of such variety was to feed the ML model more kinds of data to train on so it can recgonise different environments where people are sitting bettter.  In the end, I ended up with 25 videos of each good and bad sitting posture and a photo album full of sitting posture videos.",
                media: [.image("CollectingData")]
            ),
            InstructionMedia(
                title: "CreateML",
                text:  "Next, it was time to use these videos to train a machine learning (ML) model that makes the predictions.  Even though I had no real knowledge of machine knowledge, let alone training a ML model on videos to classify specific actions, CreateML made the job easy for me.  \n\nAll I had to do was to import my videos into CreateML. and in the end I ended up with an action classifier ML model from CreateML that could classify good sitting posture from bad sitting posture.  \n\nThe process was very straightforward, and I was shocked at how easy and powerful it was to create an ML model.  After previewing the model, the accuracy of detecting the sitting posture was 100% correct.  I learnt that the data was the most important part.  You need to collect data of high quality and quantity.",
                media: [.image("CreateML1"), .image("CreateML2")]
            ),
            InstructionMedia(
                title: "Building the app",
                text:  "After creating a model that could classify good sitting posture with bad sitting posture, it was time to code an app that could track sitting posture in real time and use the model to make a judgement about the sitting posture.  \n\nI used AVFoundation to quickly set up an AVCaptureSession that captures camera data and displays a live camera preview within the app.  \n\nNext, I used the vision framework to find human body poses within the live camera feed and then overlay a preview of the results on the camera preview to see if the framework is correctly recognizing a human body when moving in front of the camera.  \n\nThrough recgonising a human body pose, I used the ML model that I created to predict the sitting posture.  The ML model will return the prediction and the confidence of its prediction, and I used UIKit to display that information on the screen.  \n\nOverall, I learnt a lot of things from building this app.  I learnt how easy it was to create ML models with CreateML and attach it to an app with various technologies such as the vision framework.  I enjoyed the process of building a dataset and this entire process makes me want to build more apps in the future with machine learning to unlock a whole new array of applications.",
                media: [.image("BuildingTheApp")]
            ),
        ]

        var previousAnchor = contentView.topAnchor

        for instruction in instructions {
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            titleLabel.text = instruction.title
            titleLabel.textColor = .black
            contentView.addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: previousAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])

            let textLabel = UILabel()
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.font = UIFont.systemFont(ofSize: 14)
            textLabel.text = instruction.text // Use the corresponding text for each title
            textLabel.textColor = .black
            textLabel.numberOfLines = 0
            contentView.addSubview(textLabel)

            NSLayoutConstraint.activate([
                textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])

            previousAnchor = textLabel.bottomAnchor
            
            for mediaItem in instruction.media ?? [] {
                switch mediaItem {
                case .image(let imageName):
                    let imageView = UIImageView()
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.contentMode = .scaleAspectFit
                    imageView.image = UIImage(named: imageName)
                    contentView.addSubview(imageView)

                    NSLayoutConstraint.activate([
                        imageView.topAnchor.constraint(equalTo: previousAnchor, constant: 20),
                        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                        imageView.heightAnchor.constraint(equalToConstant: 200) // Adjust as needed
                    ])

                    previousAnchor = imageView.bottomAnchor

                case .video(let videoName):
                    let videoURL = Bundle.main.url(forResource: videoName, withExtension: "mp4")!
                    let player = AVPlayer(url: videoURL)
                    let playerLayer = AVPlayerLayer(player: player)
                    let videoView = UIView()
                    contentView.addSubview(videoView)
                    videoView.translatesAutoresizingMaskIntoConstraints = false
                    videoView.layer.addSublayer(playerLayer)

                    NSLayoutConstraint.activate([
                        videoView.topAnchor.constraint(equalTo: previousAnchor, constant: 20),
                        videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                        videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                        videoView.heightAnchor.constraint(equalToConstant: 200) // Adjust as needed
                    ])

                    // Adjust playerLayer frame in the layoutSubviews or similar
                    playerLayer.frame = videoView.bounds
                    player.play() // Consider controlling playback

                    previousAnchor = videoView.bottomAnchor
                }
            }
        }

        // Set the bottom anchor of contentView to be equal to the bottom of the last element
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: previousAnchor, constant: 20)
        ])
    }

}

