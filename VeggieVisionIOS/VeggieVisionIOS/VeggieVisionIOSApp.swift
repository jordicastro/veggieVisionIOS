//
//  VeggieVisionIOSApp.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/19/25.
//

import SwiftUI

@main
struct VeggieVisionIOSApp: App {
    @StateObject var inferenceState = InferenceState()
    @StateObject var cartState = CartState()
    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environmentObject(inferenceState)
                .environmentObject(cartState)
        }
    }
}
