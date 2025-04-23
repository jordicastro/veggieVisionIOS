//
//  CartView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/21/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartState: CartState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(cartState.items) { item in
                        CartItemRow(item: item)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("🛒 Your Cart")
        }
    }
}

struct CartItemRow: View {
    let item: CartItem

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Text(item.emoji)
                    .font(.largeTitle)
                Text(clean(item.label))
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Spacer()

            Text("\(String(format: "%.1f", item.weight)) lb")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    CartView()
        .environmentObject(CartState())
}



