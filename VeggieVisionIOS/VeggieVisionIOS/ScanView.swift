//
//  ScanView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/21/25.
//

import SwiftUI

struct ScanView: View {
    @EnvironmentObject var inferenceState: InferenceState
    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview()
                    .onAppear {
                        print("📸 CameraPreview appeared, resetting state")
                        inferenceState.clearGuesses()
                        inferenceState.unfreeze()
                    }

                VStack {
                    Spacer()

                    NavigationLink(
                        destination: AddItemView()
                            .environmentObject(inferenceState),
                        label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                    )
                    .simultaneousGesture(TapGesture().onEnded {
                        inferenceState.freeze()
                    })
                    .padding(.bottom, 25)
                }
            }
            .navigationBarHidden(true)
        }
//        .onAppear {
//            inferenceState.unfreeze()
//            inferenceState.clearGuesses()
//            print("UNFROZEN SCAN, CLEARED GUESSES: ", inferenceState.topGuesses.isEmpty)
//        }
    }
}


#Preview {
    ScanView()
        .environmentObject(InferenceState())
}
