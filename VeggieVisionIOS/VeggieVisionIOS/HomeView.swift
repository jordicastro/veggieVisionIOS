//
//  HomeView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/20/25.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview()
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    HomeView()
}
