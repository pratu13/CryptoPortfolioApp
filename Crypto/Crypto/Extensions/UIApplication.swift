//
//  UIApplication.swift
//  Crypto
//
//  Created by Pratyush  on 6/17/21.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
