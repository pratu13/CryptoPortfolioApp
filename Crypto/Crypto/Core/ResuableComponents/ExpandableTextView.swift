//
//  ExpandableTextView.swift
//  Crypto
//
//  Created by Pratyush  on 7/2/21.
//

import SwiftUI

struct ExpandableTextView: View {
    
    @State private var showMore: Bool = false
    let text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.body)
                .foregroundColor(Color.Palette.secondaryText.color)
                .multilineTextAlignment(.leading)
                .lineLimit(showMore ? nil : 3)
            
            Button(action: {
                withAnimation(.easeInOut) {
                    showMore.toggle()
                }
            }, label: {
                Text(showMore ? "Less" : "Read More...")
                    .foregroundColor(.blue)
                    .font(.caption)
                    .bold()
                    .padding(.vertical, 4)
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      
    }
}

struct ExpandableTextView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableTextView(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
    }
}
