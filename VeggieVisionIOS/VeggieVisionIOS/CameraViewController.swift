//
//  CameraViewController.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/20/25.
//

import UIKit
import AVFoundation
import onnxruntime_objc

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var inferenceState: InferenceState!
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let videoOutput = AVCaptureVideoDataOutput()
    private let videoQueue = DispatchQueue(label: "camera.video.queue")

    private var inferenceLabel: UILabel!
    private var resultLabel: UILabel!
    private var isInferencing = true
    private var processingFrame = false

    private let classColors: [String: UIColor] = [
        "bagged_banana": UIColor(.red),
        "banana": UIColor(.green),
        "broccoli": UIColor(.blue),
        "bagged_broccoli": UIColor(.orange),
        "fiji_apple": UIColor(.brown),
        "bagged_fiji_apple": UIColor(.indigo),
        "granny_apple": UIColor(.mint),
        "bagged_granny_apple": UIColor(.orange),
        "jalapeno": UIColor(.pink),
        "bagged_jalapeno": UIColor(.teal),
        "red_bell_pepper": UIColor(.red),
        "bagged_red_bell_pepper": UIColor(.yellow),
        "orange_bell_pepper": UIColor(.green),
        "bagged_orange_bell_pepper": UIColor(.blue)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupOverlay()
        
        print("✅ InferenceState connected?", inferenceState != nil)
        
        
        do {
            try EfficientNetB0.initializeModel()
        } catch {
            print("❌ Failed to load model:", error)
        }
    }

    private func setupCamera() {
        captureSession.sessionPreset = .high

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("❌ Failed to access camera input")
            return
        }

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    private func setupOverlay() {
        inferenceLabel = UILabel(frame: CGRect(x: 16, y: 40, width: 150, height: 30))
        inferenceLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        inferenceLabel.textColor = .white
        inferenceLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        inferenceLabel.textAlignment = .center
        inferenceLabel.text = "Time: --"
        view.addSubview(inferenceLabel)

        resultLabel = UILabel(frame: CGRect(x: 16, y: 80, width: view.frame.width - 32, height: 140))
        resultLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        resultLabel.numberOfLines = 6
        resultLabel.textColor = .white
        resultLabel.font = UIFont.systemFont(ofSize: 14)
        resultLabel.layer.cornerRadius = 8
        resultLabel.clipsToBounds = true
        view.addSubview(resultLabel)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isInferencing && !processingFrame else { return }
        processingFrame = true

        guard let pb = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            processingFrame = false
            return
        }

        let ciImage = CIImage(cvPixelBuffer: pb)
        let ctx = CIContext()
        guard let cgImg = ctx.createCGImage(ciImage, from: ciImage.extent) else {
            processingFrame = false
            return
        }

        let uiImage = UIImage(cgImage: cgImg)
        let start = Date()

        DispatchQueue.global(qos: .userInitiated).async {
            defer { self.processingFrame = false }

            do {
                let top5 = try EfficientNetB0.classify(image: uiImage)
                let guesses: [Inference] = top5.map {
                    let label = EfficientNetB0.labelsMap[Int($0.0)] ?? "unknown"
                    let emoji = EfficientNetB0.emojiMap[Int($0.0)] ?? "🍔"
                    return Inference(label: label, confidence: $0.1, emoji: emoji)
                }
                let elapsed = Date().timeIntervalSince(start)

                let attr = NSMutableAttributedString()
                for (idx, prob) in top5 {
                    let label = EfficientNetB0.labelsMap[idx] ?? "unknown"
                    let color = self.classColors[label] ?? .white
                    let line = String(format: "%@: %.1f%%\n", label, prob * 100)
                    attr.append(NSAttributedString(string: line, attributes: [.foregroundColor: color]))
                }

                DispatchQueue.main.async {
                    self.inferenceState.updateGuesses(with: guesses)
                    self.inferenceLabel.text = String(format: "Time: %.2fs", elapsed)
                    self.resultLabel.attributedText = attr
                }
            } catch {
                print("❌ Inference error:", error)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
}
