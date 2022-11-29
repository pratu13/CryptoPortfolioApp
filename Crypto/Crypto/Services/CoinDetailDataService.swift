//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by Pratyush  on 6/29/21.
//

import Combine
import SwiftUI

class CoinDetailDataService: ObservableObject {
    
    @Published var coinDetails: CoinDetailModel? = nil
    private var coinDetailSubscription: AnyCancellable?
    let coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetail()
    }
    
    func getCoinDetail() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { print("Error")
            return }
        
        coinDetailSubscription = NetworkingManager.downloadData(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .replaceError(with: CoinDetailModel(id: "1", symbol: "1", name: "1", blockTimeInMinutes: 1, hashingAlgorithm: "1", description: nil, links: nil))
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
    }
}
