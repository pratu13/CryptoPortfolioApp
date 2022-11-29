//
//  StatisticView.swift
//  Crypto
//
//  Created by Pratyush  on 6/17/21.
//

import SwiftUI

struct StatisticView: View {
    let stat: Statistic
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.Palette.secondaryText.color)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.Palette.themeAccent.color)
            HStack(spacing: 4.0) {
                Image(systemName: "triangle.fill")
                    
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (stat.percentageChange ?? 0.0) >= 0.0 ? 0 : 180.0))
                Text(stat.percentageChange?.asPercentageString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0.0) >= 0.0 ? Color.Palette.green.color : Color.Palette.red.color)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)

        }
       
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(stat: dev.stat2)
    }
}
