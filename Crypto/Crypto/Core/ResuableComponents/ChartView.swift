//
//  ChartView.swift
//  Crypto
//
//  Created by Pratyush  on 7/2/21.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let yMax: Double
    private let yMin: Double
    private let strokeColor: Color
    @State private var percentage: CGFloat = 0.0
    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        yMax = data.max() ?? 0
        yMin = data.min() ?? 0
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        strokeColor = priceChange > 0 ? Color.Palette.green.color : Color.Palette.red.color
        
    }
    
    var body: some View {
        chartView
            .background(grid)
            .overlay(yLabels.padding(.horizontal, 4), alignment: .leading)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}


private extension ChartView {
    
    var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in 0..<data.count {
                    let xPosition = (geometry.size.width) / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = yMax - yMin
                    let yPosition = CGFloat(1 - (data[index] - yMin) / yAxis) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0.0, to: percentage)
            .stroke(strokeColor, style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
        }
        .frame(height: 200)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
        .shadow(color: strokeColor, radius: 10, x: 0, y: 10)
        .shadow(color: strokeColor.opacity(0.5), radius: 20, x: 0, y: 20)
        .shadow(color: strokeColor.opacity(0.25), radius: 30, x: 0, y: 40)
        .shadow(color: strokeColor.opacity(0.1), radius: 40, x: 0, y: 60)
    }
    
    var grid: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    var yLabels: some View {
        VStack {
            Text(yMax.formattedWithAbbreviations())
            Spacer()
            Text(((yMax + yMin) / 2).formattedWithAbbreviations())
            Spacer()
            Text(yMin.formattedWithAbbreviations())
        }
        .font(.caption)
        .foregroundColor(Color.Palette.secondaryText.color)
    }
}
