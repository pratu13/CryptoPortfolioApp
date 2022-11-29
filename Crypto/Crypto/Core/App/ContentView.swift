//
//  ContentView.swift
//  Crypto
//
//  Created by Pratyush  on 6/13/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            //background layer
            Color.Palette.themeBackground.color
                .ignoresSafeArea()
            
            //content Layer
            VStack {
                Text("Header")
                Spacer(minLength: 0.0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
