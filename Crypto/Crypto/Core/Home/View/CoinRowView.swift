//
//  CoinRowView.swift
//  Crypto
//
//  Created by Pratyush  on 6/13/21.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let showHoldingsColumn: Bool
    var body: some View {
        HStack(spacing: 0.0) {
            leftColumn
            Spacer()
            
            if showHoldingsColumn {
               centerColumn
            }

            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.Palette.themeBackground.color.opacity(0.001)
        )
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingsColumn: true)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0.0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.Palette.secondaryText.color)
                .frame(minWidth: 30.0)
            CoinImageView(coin: coin)
                .frame(width: 30.0, height: 30.0)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.Palette.themeAccent.color)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.Palette.themeAccent.color)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.Palette.themeAccent.color)
            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "" )
                .foregroundColor(
                    ( coin.priceChangePercentage24H ?? 0.0) >= 0 ?
                    Color.Palette.green.color :
                    Color.Palette.red.color
                )
        }
        .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
    }
}
