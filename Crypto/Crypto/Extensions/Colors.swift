//
//  Colors.swift
//  Crypto
//
//  Created by Pratyush  on 6/13/21.
//

import Foundation
import SwiftUI

extension Color {
    
    enum Palette: String {
        
        case launchAccent = "LaunchAccentColor"
        case launchBackground = "LaunchBackgroundColor"
        case themeAccent = "AccentColor"
        case themeBackground = "BackgroundColor"
        case green = "GreenColor"
        case red = "RedColor"
        case secondaryText = "SecondaryTextColor"
        
        var color: Color {
            Color(self.rawValue)
        }
    }
}
