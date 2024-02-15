//
//  Predictor.swift
//  SittingPostureBuddy
//
//  Created by Rexan Wong on 13/2/2024.
//

import Foundation
import Vision

protocol PredictorDelegate: AnyObject {
    func predictor(_ predictor: Predictor, didFindNewRecgonizedPoints points: [CGPoint])
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double)
}

class Predictor {
    weak var delegate: PredictorDelegate?
    
    let predictionWindowSize = 120
    var posesWindow: [VNHumanBodyPoseObservation] = []
    
    init() {
        posesWindow.reserveCapacity(predictionWindowSize)
    }
    
    func estimation(sampleBuffer: CMSampleBuffer) {
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request with error : \(error)")
        }
    }
                    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanBodyPoseObservation] else { return }
        observations.forEach {
            processObservation($0)
        }
        
        if let result = observations.first {
            storeObservation(result)
            labelActionType()
        }
    }
    
    func labelActionType() {
        guard let postureClassifier = try? PostureClassifier(configuration:  MLModelConfiguration()), 
                let poseMultiArray = prepareInputWithObservations(posesWindow),
                let predictions = try? postureClassifier.prediction(poses: poseMultiArray) else {
            return
        }
        
        let label = predictions.label
        let confidence = predictions.labelProbabilities[label] ?? 0
        
        delegate?.predictor(self, didLabelAction: label, with: confidence)
    }
    
    func prepareInputWithObservations(_ observations: [VNHumanBodyPoseObservation]) -> MLMultiArray? {
        let numAvaliableFrames = observations.count
        let observationsNeeded = 120
        var multiArrayBuffer = [MLMultiArray]()
        
        for frameIndex in 0..<min(numAvaliableFrames, observationsNeeded) {
            let pose = observations[frameIndex]
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            } catch {
                continue
            }
        }
        
        if numAvaliableFrames < observationsNeeded {
            for _ in 0 ..< (observationsNeeded - numAvaliableFrames) {
                do {
                    let oneFrameMultiArray = try MLMultiArray(shape: [120, 3, 18], dataType: .float16)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append(oneFrameMultiArray)
                } catch {
                    continue
                }
            }
        }
        
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray(_ predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    
    func storeObservation(_ observation: VNHumanBodyPoseObservation) {
        if posesWindow.count >= predictionWindowSize {
            posesWindow.removeFirst()
        }
        
        posesWindow.append(observation)
    }
    
    func processObservation(_ observation: VNHumanBodyPoseObservation) {
        do {
            let recgonizedPoints = try observation.recognizedPoints(forGroupKey: .all)
            let displayedPoints = recgonizedPoints.map {
                CGPoint(x: $0.value.x, y: 1 - $0.value.y)
            }
            
            delegate?.predictor(self, didFindNewRecgonizedPoints: displayedPoints)
        } catch {
            print("error finding recgonizedPoints")
        }
    }
}
