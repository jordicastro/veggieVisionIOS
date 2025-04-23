//
//  HomeView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/20/25.
//

import SwiftUI

struct StaffMember: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let description: String
    let link: URL?
}

struct VVModel: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let isSelection: Bool
    let description: String
}

let staffMembers: [StaffMember] = [
    StaffMember(
        name: "Jordi Castro",
        image: "😛",
        description: "Trained rt_detr_v2 model. Failed and then mocked and developed the app 😭",
        link: URL(string: "https://github.com/jordicastro")
    ),
    StaffMember(
        name: "Dylan Clark",
        image: "🥸",
        description: "Documented and ran financial analysis. Created draw-dropping slides 🤯",
        link: URL(string: "https://github.com/dec-pip")
    ),
    StaffMember(
        name: "Samuel Lin",
        image: "😎",
        description: "YOLOv8 model implementation. Manually drew bounding boxes all night long 🤧",
        link: URL(string: "https://github.com/smlin2000")
    ),
    StaffMember(
        name: "David Nystrom",
        image: "🤠",
        description: "EfficientNet model and app implementation. Had a fridge full of vegetables at all times 🥦",
        link: URL(string: "https://github.com/DavidNystrom")
    )
]

let VVModels: [VVModel] = [
    VVModel(name: "EfficientNetB0", image: "🤖", isSelection: true, description: "Real-time classification and top-5 predictions."),
    VVModel(name: "YOLOv8Small", image: "👾", isSelection: false, description: "Real-time bounding boxes for detection and classification.")
]

struct HomeView: View {
    let columnStaff = [GridItem(.flexible()), GridItem(.flexible())]
    let columnModels = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("🥑 Veggie Vision")
                        .font(.largeTitle.bold())
                        .padding(.top)

                    Text(
                        "VeggieVision is an image classification pipeline trained on a custom dataset of both bagged and unbagged produce. Deployed on Walmart self‑checkout kiosks, it automatically recognizes fruits and vegetables in real time—so customers don’t have to type in produce item names, dramatically reducing wait times. By incorporating on‑device inference, VeggieVision delivers high accuracy and fast, reliable performance under a wide range of in‑store conditions."
                    )
                    .font(.body)
                    .foregroundColor(.secondary)
                    // Optional: Add expand/collapse toggle if needed in the future

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Models")
                            .font(.title2.bold())

                        LazyVGrid(columns: columnModels, spacing: 16) {
                            ForEach(VVModels) { model in
                                ModelCard(model: model)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Our Team")
                            .font(.title2.bold())

                        LazyVGrid(columns: columnStaff, spacing: 16) {
                            ForEach(staffMembers) { member in
                                StaffCard(member: member)
                            }
                        }
                    }

                    Text("Special thanks to Divya Dadi and the Walmart Team! 👏")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}

struct StaffCard: View {
    let member: StaffMember

    var body: some View {
        Group {
            if let url = member.link {
                Link(destination: url) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle()) // Prevents default blue Link style
            } else {
                cardContent
            }
        }
    }

    private var cardContent: some View {
        VStack(spacing: 8) {
            Text(member.image)
                .font(.system(size: 48))

            Text(member.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)

            Text(member.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}


struct ModelCard: View {
    let model: VVModel

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(model.image)
                .font(.system(size: 48))

            Text(model.name)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(model.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(model.isSelection ? Color.veggieSecondary.opacity(0.15) : Color(.systemGray6))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(model.isSelection ? Color.veggieSecondary : Color.clear, lineWidth: 2)
        )
        .cornerRadius(16)
    }
}

#Preview {
    HomeView()
}
