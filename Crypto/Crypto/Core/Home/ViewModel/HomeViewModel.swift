//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Pratyush  on 6/14/21.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var statictics: [Statistic] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscriber()
    }
    
    func updatePorfolio(coin: Coin, amount: Double) {
        PortfolioDataService.instance.updatePorfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        CoinDataService.shared.getCoins()
        MarketDataService.shared.getData()
        HapticManager.notification(type: .success)
    }
}

//MARK:- Private Helpers
private extension HomeViewModel {
    
    func addSubscriber() {
        $searchText
            .combineLatest(CoinDataService.shared.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(PortfolioDataService.instance.$fetchedPorfolio)
            .map(portfolioEntityToCoin)
            .sink { [weak self] returnedCoins in
                guard let self = self else  { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        MarketDataService.shared.$marketData
            .combineLatest($portfolioCoins)
            .map(mapData)
            .sink { [weak self] stats in
                self?.statictics = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func filterAndSortCoins(text: String, startingCoins: [Coin], sortingOption: SortOption) -> [Coin] {
        var updatedCoins = filterCoins(text: text, startingCoins: startingCoins)
        sortCoins(sort: sortingOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        //will only sort by holding or reverse holdings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
    }
    
    func portfolioEntityToCoin(coinModel: [Coin], portfolioEntities: [PortfolioEntity]) -> [Coin] {
        return coinModel
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    
    func filterCoins(text: String, startingCoins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return startingCoins
        }
        let lowercasedText = text.lowercased()
        return startingCoins.filter { $0.name.lowercased().contains(lowercasedText) ||
            $0.symbol.lowercased().contains(lowercasedText) ||
            $0.id.lowercased().contains(lowercasedText)
        }
    }
    
    func mapData(receivedData: MarketData?, pCoins: [Coin]) -> [Statistic] {
        
        var stats: [Statistic] = []
        guard let data = receivedData else { return stats }
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volumne", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.bitcoinDominance)
        
        let porfolioValue =
            pCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0,+)
        
        let pChange =
        pCoins
            .map( { $0.priceChangePercentage24H ?? 0.0})
            .reduce(0, +)
        
        let previousValue =
            pCoins
            .map({ (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            })
            .reduce(0,+)
        
        let percentageChange = ((porfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(
            title: "Portfolio Value",
            value: porfolioValue.asCurrencyWith2Decimals(),
            percentageChange: pChange
        )
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats

    }
}
