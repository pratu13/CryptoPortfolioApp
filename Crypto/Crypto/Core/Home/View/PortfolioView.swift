//
//  PortfolioView.swift
//  Crypto
//
//  Created by Pratyush  on 6/18/21.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0.0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        porfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            }
            .onChange(of: quantityText, perform: { value in
                if value.isEmpty {
                    removeSelectedCoin()
                }
            })
          
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

private extension PortfolioView {
    
    var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75.0)
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.Palette.green.color : Color.clear, lineWidth: 1.0)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let coin = vm.portfolioCoins.first(where: {$0.id == coin.id }),
           let amount = coin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    var porfolioInputSection: some View {
        VStack(spacing: 20.0) {
            HStack {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith2Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    
    var trailingNavBarButton: some View {
        HStack(spacing: 10.0) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button(action: { saveButtonPressed() }, label: {
                Text("save".uppercased())
            })
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0:0.0)
            
            
        }
        .font(.headline)
    }
    
    func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0.0)
        }
        return 0.0
    }
    
    func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else {
            return
        }
  
        //save to portfolio
        vm.updatePorfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        //hide Keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
}
