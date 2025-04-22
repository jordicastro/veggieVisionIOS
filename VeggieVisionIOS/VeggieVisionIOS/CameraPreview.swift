//
//  CameraPreview.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/20/25.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewControllerRepresentable {
    @EnvironmentObject var inferenceState: InferenceState
    func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController()
        vc.inferenceState = inferenceState
        return vc
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) { }
}


#Preview {
    CameraPreview()
        .environmentObject(InferenceState())
}
