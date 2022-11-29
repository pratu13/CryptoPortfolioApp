//
//  SearchBarView.swift
//  Crypto
//
//  Created by Pratyush  on 6/17/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ?  Color.Palette.secondaryText.color : Color.Palette.themeAccent.color)

            TextField("Search by name or symbol...", text: $searchText)
                .foregroundColor(Color.Palette.themeAccent.color)
                .disableAutocorrection(true)
        
        }
        .font(.headline)
        .overlay(
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(Color.Palette.themeAccent.color)
                .padding()
                .offset(x: 10)
                .opacity(searchText.isEmpty ? 0.0 : 1.0)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    searchText = ""
                }
            
            ,alignment: .trailing)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.Palette.themeBackground.color)
                .shadow(color: Color.Palette.themeAccent.color.opacity(0.15), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
        )
        .padding()
       
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .preferredColorScheme(.dark)
                .padding()
                .previewLayout(.sizeThatFits)
            SearchBarView(searchText: .constant(""))
                .preferredColorScheme(.light)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
