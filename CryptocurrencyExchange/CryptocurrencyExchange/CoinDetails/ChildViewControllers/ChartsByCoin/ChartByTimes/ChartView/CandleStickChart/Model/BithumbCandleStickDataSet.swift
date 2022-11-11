//
//  BithumbCandleStickDataSet.swift
//  CryptocurrencyExchange
//
//  Created by 정다연 on 3/2/22.
//

import UIKit
import Charts

class BithumbCandleChartDataSet: CandleChartDataSet {
    convenience init(_ entryArr: [ChartDataEntry]) {
        self.init(entries: entryArr, label: "")
    }
    
    override init(entries: [ChartDataEntry], label: String) {
        super.init(entries: entries, label: label)
        self.axisDependency = .right
        self.drawIconsEnabled = false
        self.shadowColor = .darkGray
        self.shadowWidth = 0.7
        self.decreasingColor = UIColor.decreasingColor
        self.decreasingFilled = true
        self.increasingColor = UIColor.increasingColor
        self.increasingFilled = true
        self.drawValuesEnabled = false
        self.highlightColor = .lightGray
    }
    
    required init() {
        super.init()
    }
}
