//
//  CircleButtonView.swift
//  Crypto
//
//  Created by Pratyush  on 6/13/21.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.Palette.themeAccent.color)
            .frame(width: 50.0, height: 50.0)
            .background(
                Circle()
                    .foregroundColor(Color.Palette.themeBackground.color)
            )
            .shadow(
                color: Color.Palette.themeAccent.color.opacity(0.25),
                radius: 10,
                x: 0.0, y: 0.0)
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
            CircleButtonView(iconName: "plus")
                .colorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
