//
//  CoinDataService.swift
//  Crypto
//
//  Created by Pratyush  on 6/14/21.
//

import Foundation
import Combine

class CoinDataService {
    
    static let shared = CoinDataService()
    @Published var allCoins: [Coin] = []
    private var coinSubscription: AnyCancellable?
    
    private init() { getCoins() }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { print("Error")
            return }
        
        coinSubscription = NetworkingManager.downloadData(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.coinSubscription?.cancel()
            })
    }
}
