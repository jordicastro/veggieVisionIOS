//
//  ContentView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/19/25.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var showTabView: Bool = false
    @EnvironmentObject var inferenceState: InferenceState
    var body: some View {
        if showTabView {
            VVTabView()
                .environmentObject(inferenceState)
        } else {
            VStack {
                Spacer()
                Image("VEGGIE_VISION_LOGO")
                    .padding(45.5)
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Spacer()
                Button("Get Started") {
                    showTabView = true
                }
                .padding()
                .frame(width: 200, height: 50)
                .background(Color.veggieSecondary)
                .foregroundColor(Color.veggiePrimary)
                .fontWeight(.heavy)
                .cornerRadius(12)
                .tracking(2)
                
                
            }
            .padding()
        }
    }
    
    
    
}

#Preview {
    LaunchScreen()
        .environmentObject(InferenceState())
}
