//
//  VVTabView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/20/25.
//

import SwiftUI

enum Tab {
    case home
    case scan
    case cart
}

struct VVTabView: View {
    @EnvironmentObject var cartState: CartState
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(Tab.home)
            ScanView()
                .tabItem {
                    Image(systemName: "camera.aperture")
                    Text("Scan")
                }
                .tag(Tab.scan)
            CartView()
                .tabItem {
                    cartState.showCartBadge ?
                        Image(systemName: "cart.fill.badge.plus") :
                        Image(systemName: "cart")
                    Text("Cart")
                }
                .tag(Tab.cart)
        }
        .accentColor(Color.veggieSecondary)
        .onChange(of: selectedTab) {
            if selectedTab == .cart {
                print("🛒 Clearing badge")
                cartState.clearBadge()
            }
        }
    
    }
}
#Preview {
    VVTabView()
        .environmentObject(CartState())
}
