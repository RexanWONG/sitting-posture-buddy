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
        label.text = "" // Start with no text
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoPreview()
        setupStatusLabel()
                
        videoCapture.predictor.delegate = self
    }
    
    private func setupVideoPreview() {
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else { return }
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
    }
    
    private func setupStatusLabel() {
        let statusBackgroundView = UIView()
        statusBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        statusBackgroundView.layer.cornerRadius = 10
        statusBackgroundView.clipsToBounds = true
        
        // Add statusBackgroundView to the view hierarchy
        view.addSubview(statusBackgroundView)
        
        // Add statusLabel to the statusBackgroundView
        statusBackgroundView.addSubview(statusLabel)
        
        // Disable autoresizing mask translation into constraints for both views
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for statusLabel to add padding inside the statusBackgroundView
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: statusBackgroundView.topAnchor, constant: 8),
            statusLabel.bottomAnchor.constraint(equalTo: statusBackgroundView.bottomAnchor, constant: -8),
            statusLabel.leadingAnchor.constraint(equalTo: statusBackgroundView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: statusBackgroundView.trailingAnchor, constant: -16),
        ])
        
        // Constraints for statusBackgroundView to position it in the center bottom of the screen
        NSLayoutConstraint.activate([
            statusBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
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
                let statusText = "\(action) \(confidencePercent)%"
                self.isBadPostureDetected = false
            }
        } else {
            DispatchQueue.main.async {
                self.statusLabel.text = statusText
            }
        }
    }
}
  
