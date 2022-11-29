//
//  CoinLogoView.swift
//  Crypto
//
//  Created by Pratyush  on 6/18/21.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: Coin
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.Palette.themeAccent.color)
                .lineSpacing(1)
                .minimumScaleFactor(0.5)
            Text(coin.name.capitalized)
                .font(.caption)
                .foregroundColor(Color.Palette.secondaryText.color)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
