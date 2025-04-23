//
//  AddItemView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/21/25.
//

import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var inferenceState: InferenceState
    @EnvironmentObject var cartState: CartState
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedItemInfo: (label: String, emoji: String) = ("Broccoli", "🥦")

    // Computed properties instead of let inside body
    var topGuess: Inference {
        inferenceState.topGuesses.first ?? Inference(label: "Broccoli", confidence: 0.94, emoji: "🥦")
    }

    var otherGuesses: [Inference] {
        Array(inferenceState.topGuesses.dropFirst())
    }

    var body: some View {
        VStack(spacing: 50) {
            // Back Button + Title
            HStack {
                Text("Select your Item")
                    .font(.title2).bold()
                    .foregroundColor(.veggiePrimary)
                    .padding(.leading, 24)
                    .padding(.top, 32)
                Spacer()
            }
            .padding(.top, 20)

            // Top Guess Box (selectable)
            VStack {
                Text(topGuess.emoji)
                    .font(.system(size: 80))
                Text(clean(topGuess.label))
                    .font(.title3)
                    .foregroundColor(.darkOrLightText)
                    .bold()
                    .padding(.bottom, 2)
                Text(String(format: "%.1f conf", topGuess.confidence * 100))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selectedItemInfo.label == topGuess.label ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 32)
            .onTapGesture {
                selectedItemInfo.label = topGuess.label
                selectedItemInfo.emoji = topGuess.emoji
            }

            // Other Guesses
            VStack(alignment: .leading, spacing: 8) {
                Text("Other guesses")
                    .font(.headline)
                    .padding(.leading, 24)
                    .padding(.bottom, 5)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(otherGuesses) { item in
                            Button(action: {
                                selectedItemInfo.label = item.label
                                selectedItemInfo.emoji = item.emoji
                                
                            }) {
                                VStack(spacing: 1) {
                                    Text(item.emoji)
                                        .font(.largeTitle)
                                    Text(clean(item.label))
                                        .font(.caption2)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .foregroundColor(.darkOrLightText)
                                }
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedItemInfo.label == item.label ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }

            Spacer()

            // Add Button + Manual
            VStack(spacing: 24) {
                Button(action: {
                    print("selectedItemInfo ", selectedItemInfo)
//                    print("selectedItemInfo.emoji ", selectedItemInfo.emoji)
                    // redirect back to scanner, toast selectedItem
                    inferenceState.triggerToast(with: selectedItemInfo)
                    presentationMode.wrappedValue.dismiss()
                    
                    cartState.addItem(label: selectedItemInfo.label, emoji: selectedItemInfo.emoji)
                    cartState.showCartBadge = true
                }) {
                    Text("+ Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.veggieSecondary)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 60)

                Button(action: {
                    // TODO: manual search
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.veggiePrimary)
                        Text("manual search")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.veggiePrimary)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 24)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 1))
                }
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            print("on AddItemView appear, updating selectedItemInfo with LABEL: ", topGuess.label, " and EMOJI:", topGuess.emoji)
            selectedItemInfo = (topGuess.label, topGuess.emoji)
            inferenceState.freeze()
        }
    }
}

func clean(_ label: String) -> String {
    var result = label
    
    if result.hasPrefix("bagged_") {
        result = String(result.dropFirst("bagged_".count))
    }
    
    result = result.replacingOccurrences(of: "_", with: " ")
    
    result = result.capitalized
    
    return result
}


#Preview {
    AddItemView()
        .environmentObject(InferenceState())
        .environmentObject(CartState())
}
