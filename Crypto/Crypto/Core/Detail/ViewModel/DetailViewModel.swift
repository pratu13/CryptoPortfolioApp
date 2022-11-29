//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Pratyush  on 6/29/21.
//

import SwiftUI
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [Statistic] = []
    @Published var additionalStatistics: [Statistic] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var coin: Coin
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(dataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.additionalStatistics = returnedArrays.additional
                self?.overviewStatistics = returnedArrays.overview
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] coinDetails in
                guard let coinD = coinDetails else { return }
                self?.coinDescription = coinD.readeableDescription
                self?.websiteURL = coinD.links?.homepage?.first
                self?.redditURL = coinD.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func dataToStatistics(coinDetail: CoinDetailModel?, coin: Coin) -> (overview: [Statistic], additional: [Statistic]) {
        return (createOverviewArray(coin: coin), createAdditionalArray(coin: coin, coinDetail: coinDetail))
    }
    
    private func createOverviewArray(coin: Coin) -> [Statistic] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStatistics = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Makret Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volumne", value: volume)
        
        let overviewArray: [Statistic] = [
            priceStatistics,
            marketCapStat,
            rankStat,
            volumeStat
        ]
        return overviewArray
    }
    
    private func createAdditionalArray(coin: Coin, coinDetail: CoinDetailModel?) -> [Statistic] {
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let high24Stat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let low24Stat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = Statistic(title: "Block TIme", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        
        let additional: [Statistic] = [
            high24Stat,
            low24Stat,
            priceChangeStat,
            marketCapChangeStat,
            blockStat,
            hashingStat
        ]
        
        return additional
        
    }
}
