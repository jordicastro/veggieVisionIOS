//
//  InferenceState.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/21/25.
//

import Foundation
import Combine

struct Inference: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let emoji: String
}

class InferenceState: ObservableObject {
    @Published var topGuesses: [Inference] = []
    @Published var isPaused: Bool = false
    
    func freeze() {
        isPaused = true
    }
    func unfreeze() {
        isPaused = false
    }
    
    func updateGuesses(with newGuesses: [Inference]) {
        if !isPaused {
                self.topGuesses = newGuesses
        }
    }
    func clearGuesses() {
            self.topGuesses = []
    }
}
