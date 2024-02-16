//
//  ViewController.swift
//  SittingPostureBuddy
//
//  Created by Rexan Wong on 12/2/2024.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let videoCapture = VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var pointsLayer = CAShapeLayer()
    
    var isBadPostureDetected = false
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Processing (5 seconds)..." // Start with no text
        return label
    }()
    
    let bottomControlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually // Adjust based on your layout needs
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var instructionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("WWDC Judges, click here", for: .normal)
        button.addTarget(self, action: #selector(showInstructions), for: .touchUpInside)
        return button
    }()
    
    let pointsVisibilityToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true // Default to showing the points layer
        toggle.addTarget(self, action: #selector(togglePointsVisibility), for: .valueChanged)
        return toggle
    }()
    
    let toggleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    let showDotsLabel: UILabel = {
        let label = UILabel()
        label.text = "Show Dots"
        label.textColor = .white // Adjust the color as needed
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoPreview()
        setupStatusLabel()
        setupUIComponents()
                
        videoCapture.predictor.delegate = self
    }
    
    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else { return }
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        // Create and add the semi-transparent black overlay
        let blackOverlayView = UIView()
        blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Adjust opacity as needed
        blackOverlayView.frame = view.frame
        view.addSubview(blackOverlayView)
        view.layer.addSublayer(blackOverlayView.layer)
        
        // Make sure pointsLayer is added above the blackOverlayView
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
        
        // Ensure statusLabel and other UI elements are brought to the front if needed
        view.bringSubviewToFront(statusLabel)
    }
    
    private func setupStatusLabel() {
        let statusBackgroundView = UIView()
        statusBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        statusBackgroundView.layer.cornerRadius = 10
        statusBackgroundView.clipsToBounds = true
        
        view.addSubview(statusBackgroundView)
        
        statusBackgroundView.addSubview(statusLabel)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: statusBackgroundView.topAnchor, constant: 8),
            statusLabel.bottomAnchor.constraint(equalTo: statusBackgroundView.bottomAnchor, constant: -8),
            statusLabel.leadingAnchor.constraint(equalTo: statusBackgroundView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: statusBackgroundView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            statusBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func setupUIComponents() {
        // Set up Instructions Button and Points Visibility Toggle together
        setupInstructionsButtonAndPointsVisibilityToggle()
    }

    private func setupInstructionsButtonAndPointsVisibilityToggle() {
        toggleStackView.spacing = 2

        toggleStackView.addArrangedSubview(showDotsLabel)
        toggleStackView.addArrangedSubview(pointsVisibilityToggle)

        let bottomContainerView = UIView()
        view.addSubview(bottomContainerView)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false

        bottomContainerView.addSubview(instructionsButton)
        bottomContainerView.addSubview(toggleStackView)

        NSLayoutConstraint.activate([
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 50) 
        ])

        // Constraints for the instructions button within the container
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instructionsButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            instructionsButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor)
        ])

        // Adjusting toggleStackView's position to be on the right side
        toggleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggleStackView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            toggleStackView.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor)
        ])
    }
    
    private func setupInstructionsButton() {
        view.addSubview(instructionsButton)
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPointsVisibilityToggle() {
        toggleStackView.addArrangedSubview(showDotsLabel)
        toggleStackView.addArrangedSubview(pointsVisibilityToggle)
        
        view.addSubview(toggleStackView)
        toggleStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func showInstructions() {
        let instructionsVC = InstructionsViewController()
        present(instructionsVC, animated: true)
    }
    
    @objc func togglePointsVisibility(_ sender: UISwitch) {
        pointsLayer.isHidden = !sender.isOn
    }

}

extension ViewController: PredictorDelegate {
    func predictor(_ predictor: Predictor, didFindNewRecgonizedPoints points: [CGPoint]) {
        guard let previewLayer = previewLayer else { return }
        
        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        
        let combinedPath = CGMutablePath()
        
        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        
        pointsLayer.path = combinedPath
        
        DispatchQueue.main.async {
            self.pointsLayer.didChangeValue(for: \.path)
        }
    }
    
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        let confidencePercent = Int(confidence * 100)
        var statusText = "\(action) \(confidencePercent)%"
        
        if action == "None" {
            statusText = "Good Posture \(confidencePercent)%"
        }

        if action == "BadPosture" && confidence > 0.9 && isBadPostureDetected == false {
            print("Bad posture detected")
            isBadPostureDetected = true
             
            DispatchQueue.main.async {
                self.statusLabel.text = statusText
                AudioServicesPlayAlertSound(SystemSoundID(1022))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                statusText = "\(action) \(confidencePercent)%"
                self.isBadPostureDetected = false
            }
        } else {
            DispatchQueue.main.async {
                self.statusLabel.text = statusText
            }
        }
    }
}
  
