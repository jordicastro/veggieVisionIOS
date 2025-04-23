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
            .overlay( // Toast
                Group {
                    if inferenceState.showToast, let item = inferenceState.selectedItemInfo {
                        Text("✅ \(item.emoji) \(clean(item.label)) added to cart")
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, 60)
                    }
                }
            )
            .animation(.easeInOut, value: inferenceState.showToast)
            .navigationBarHidden(true)
        }
    }
}



#Preview {
    ScanView()
        .environmentObject(InferenceState())
}
