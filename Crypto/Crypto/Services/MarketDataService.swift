//
//  MarketDataService.swift
//  Crypto
//
//  Created by Pratyush  on 6/18/21.
//

import SwiftUI
import Combine

class MarketDataService: ObservableObject {
    
    static let shared = MarketDataService()
    @Published var marketData: MarketData?
    private var marketDataSubscription: AnyCancellable?
    
    private init() { getData() }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { print("Error")
            return }
        
        marketDataSubscription = NetworkingManager.downloadData(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .replaceError(with: GlobalData(data: MarketData(totalMarketCap: [:], totalVolume: [:], marketCapPercentage: [:], marketCapChangePercentage24HUsd: 0.0)))
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] receivedData in
                self?.marketData = receivedData.data
                self?.marketDataSubscription?.cancel()
            })
    }
    
    
}
