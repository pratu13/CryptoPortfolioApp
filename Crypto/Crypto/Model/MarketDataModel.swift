//
//  MarketDataModel.swift
//  Crypto
//
//  Created by Pratyush  on 6/18/21.
//

import SwiftUI

/*
 API:
 https://api.coingecko.com/api/v3/global
 */

/*
 JSON Data
 {
   "data": {
     "active_cryptocurrencies": 8013,
     "upcoming_icos": 0,
     "ongoing_icos": 50,
     "ended_icos": 3375,
     "markets": 622,
     "total_market_cap": {
       "btc": 42974871.01092979,
     },
     "total_volume": {
       "btc": 2876298.6882890775,
     },
     "market_cap_percentage": {
       "btc": 43.60161312697002,
       "uni": 0.6929406409865165
     },
     "market_cap_change_percentage_24h_usd": -3.5448675610722633,
     "updated_at": 1624000357
   }
 }
 */
struct GlobalData: Codable {
    let data: MarketData?
}

struct MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: {$0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: {$0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
            
        }
        return  ""
    }
    
    var bitcoinDominance: String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}) {
            return item.value.asPercentageString()
        }
        return ""
    }
}
