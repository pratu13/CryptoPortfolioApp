//
//  HomeStatsView.swift
//  Crypto
//
//  Created by Pratyush  on 6/17/21.
//

import SwiftUI

struct HomeStatsView: View {
    @Binding var showPortfolio: Bool
    @EnvironmentObject private var vm: HomeViewModel
    var body: some View {
        HStack {
            Spacer()
            ForEach(vm.statictics) { stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
