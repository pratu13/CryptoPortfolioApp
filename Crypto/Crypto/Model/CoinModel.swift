//
//  CoinModel.swift
//  Crypto
//
//  Created by Pratyush  on 6/13/21.
//

import SwiftUI

//API
/*
 URL:
    
    https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=2&sparkline=true&price_change_percentage=24h
 */

//JSON Response
/*
 {
     "id": "melon",
     "symbol": "mln",
     "name": "Enzyme",
     "image": "https://assets.coingecko.com/coins/images/605/large/Enzyme_Icon_Secondary.png?1611576629",
     "current_price": 98.29,
     "market_cap": 132192623,
     "market_cap_rank": 251,
     "fully_diluted_valuation": 178865636,
     "total_volume": 43234870,
     "high_24h": 115.45,
     "low_24h": 86.06,
     "price_change_24h": 8.25,
     "price_change_percentage_24h": 9.16184,
     "market_cap_change_24h": 11612130,
     "market_cap_change_percentage_24h": 9.63019,
     "circulating_supply": 1348370.539019341,
     "total_supply": 1824437.31909865,
     "max_supply": 1824437.31909865,
     "ath": 258.26,
     "ath_change_percentage": -62.03843,
     "ath_date": "2018-01-04T00:00:00.000Z",
     "atl": 1.79,
     "atl_change_percentage": 5371.95204,
     "atl_date": "2020-03-13T02:24:22.336Z",
     "roi": null,
     "last_updated": "2021-06-13T13:46:28.818Z",
     "sparkline_in_7d": {
       "price": [
         146.3734219391234
       ]
     },
     "price_change_percentage_24h_in_currency": 9.161843718586848
   }
 */

struct Coin: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation, totalVolume: Double?
    let high24H, low24H, priceChange24H : Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H, circulatingSupply, totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
        
    }
    
    func updateHoldings(amount: Double) -> Coin {
        Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        Double((currentHoldings ?? 0) * currentPrice)
    }
    
    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
