//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by Pratyush  on 6/14/21.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: Coin
    private let dataService: CoinImageService?
    var cancellables =  Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        dataService = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService?.$image
            .sink(receiveCompletion: { [weak self ]_ in
                self?.isLoading = false
            }, receiveValue: { [weak self ]image in
                self?.image = image
            })
            .store(in: &cancellables)
    }
}
