//
//  VVTabView.swift
//  VeggieVisionIOS
//
//  Created by Jordi Castro on 4/20/25.
//

import SwiftUI

struct VVTabView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            scanView()
                .tabItem {
                    Image(systemName: "camera.aperture")
                    Text("Scan")
                }
            cartView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
        }
        .accentColor(Color.veggieSecondary)
    }
}

#Preview {
    VVTabView()
}
