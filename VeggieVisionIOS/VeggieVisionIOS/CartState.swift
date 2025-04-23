//
//  CartState.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/22/25.
//

import Foundation
import Combine

struct CartItem: Identifiable {
    let id = UUID()
    let label: String
    let emoji: String
    let weight: Double = Double.random(in: 0.1...2.0)
}

class CartState: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var showCartBadge: Bool = false
    
    func addItem(label: String, emoji: String) {
        let item = CartItem(label: label, emoji: emoji)
        items.append(item)
        showCartBadge = true
    }
    
    func removeItem(label:String) {
        // TODO: remove item
    }
    
    func clearBadge() {
        showCartBadge = false
    }
    
    func clearCart() {
        items.removeAll()
        showCartBadge = false
    }
}
