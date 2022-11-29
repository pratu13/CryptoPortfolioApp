//
//  DetailView.swift
//  Crypto
//
//  Created by Pratyush  on 6/29/21.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: Coin?
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    private let columns: Array<GridItem> = [GridItem(.flexible()),GridItem(.flexible())]
    
    private let spacing: CGFloat = 30.0
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical, 20)
                VStack(spacing: 20.0) {
                    overviewTitle
                    Divider()
                    description
                    overviewGrid
                    additionalTitle
                    Divider()
                    addtionalGrid
                    linkSection
                 
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTailingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
        
    }
}


private extension DetailView {
    
    var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.Palette.themeAccent.color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.Palette.themeAccent.color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    var addtionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: /*@START_MENU_TOKEN@*/[]/*@END_MENU_TOKEN@*/) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }
    
    var navigationBarTailingItem: some View {
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.Palette.secondaryText.color)
            CoinImageView(coin: vm.coin)
                .frame(width: 25.0, height: 25.0)
        }
    }
    
    var description: some View {
        ZStack {
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                ExpandableTextView(text: coinDescription)
            }
        }
    }
    
    var linkSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let webURL = vm.websiteURL,
               let url = URL(string: webURL) {
                Link("Website", destination: url)
            }
            
            if let redditURL = vm.redditURL,
               let url = URL(string: redditURL) {
                Link("Reddit", destination: url)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
        .foregroundColor(.blue)
    }
}
