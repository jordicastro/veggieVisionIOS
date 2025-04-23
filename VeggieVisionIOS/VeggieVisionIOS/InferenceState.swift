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
    @Published var selectedItemInfo: (label: String, emoji: String)? = nil
    @Published var showToast: Bool = false
    
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
    func triggerToast(with item: (label: String, emoji: String)) {
        selectedItemInfo = item
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showToast = false
            self.selectedItemInfo = nil
        }
    }
}
