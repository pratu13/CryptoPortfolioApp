//
//  String.swift
//  Crypto
//
//  Created by Pratyush  on 7/2/21.
//

import Foundation

extension String {
    
    var removingHTMLoccurences: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
