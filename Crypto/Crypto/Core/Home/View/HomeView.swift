//
//  HomeView.swift
//  Crypto
//
//  Created by Pratyush  on 6/13/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false // animate right
    @State private var showPortfolioView: Bool = false // new sheet
    
    @State private var selectedCoin: Coin? = nil
    @State private var showDetailView: Bool = false
    var body: some View {
        ZStack {
            //background layer
            Color.Palette.themeBackground.color
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(vm)
                })
            
            //content Layer
            VStack {
                homeHeader
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitle
                
                if !showPortfolio {
                    allCoinList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
               
                Spacer(minLength: 0.0)
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HomeView()
                    .colorScheme(.dark)
                    .navigationBarHidden(true)
            }
            .preferredColorScheme(.dark)
            .environmentObject(dev.homeVM)
            
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(dev.homeVM)
        }
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .background(CircleButtonAnimationView(animate: $showPortfolio))
                .onTapGesture {
                    showPortfolioView.toggle()
                }
            Spacer()
            Text(showPortfolio ? "Portfolio" :"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.Palette.themeAccent.color)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
        }
        .padding(.horizontal)
        
        
    }
    
    private var allCoinList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
   
    private var portfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitle: some View {
        HStack {
            HStack(spacing: 4.0) {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0: 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0.0 : 180.0))
            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
                
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4.0) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0: 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0.0 : 180.0))
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack {
                HStack(spacing: 4.0) {
                    Text("Price")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0: 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0.0 : 180.0))
                }
                .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
                .onTapGesture {
                    withAnimation {
                        vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                    }
                    
                }
                
                Button(action: {
                    withAnimation(.linear(duration: 2.0)) {
                        vm.reloadData()
         
                    }
                }, label: {
                    Image(systemName: "goforward")
                })
                .rotationEffect(Angle(degrees: vm.isLoading ? 360: 0), anchor: .center)
                
            }
        }
        .font(.callout)
        .foregroundColor(Color.Palette.secondaryText.color)
        .padding(.horizontal)
    }
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
}


