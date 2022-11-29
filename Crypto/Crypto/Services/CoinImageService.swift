//
//  CoinImageService.swift
//  Crypto
//
//  Created by Pratyush  on 6/14/21.
//

import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    private var imageSubscription:  AnyCancellable?
    private let coin: Coin
    private let folderName: String = "Coin_Images"
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }

    func getCoinImage() {
        if let savedImage = LocalFileManager.instance.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage()
        }
    }
    
    func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { print("Error")
            return }
        
        imageSubscription = NetworkingManager.downloadData(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .replaceError(with: nil)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let rImage = returnedImage,
                    let self = self else { return }
                self.image = returnedImage
                LocalFileManager.instance.saveImage(image: rImage, imageName: self.imageName, folderName: self.folderName)
                self.imageSubscription?.cancel()
            })
    }
    
}
