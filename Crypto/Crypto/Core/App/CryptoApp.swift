//
//  CryptoApp.swift
//  Crypto
//
//  Created by Pratyush  on 6/13/21.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @State var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.Palette.themeAccent.color)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.Palette.themeAccent.color)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .environmentObject(homeViewModel)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
