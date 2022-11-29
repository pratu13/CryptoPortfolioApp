//
//  SettingsView.swift
//  Crypto
//
//  Created by Pratyush  on 7/2/21.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/c/cswit")
    
    
    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Header")) {
                    Text("Hi")
                    Text("Hi")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
