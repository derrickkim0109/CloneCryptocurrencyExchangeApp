//
//  BithumbBarDataSet.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/03/07.
//

import UIKit
import Charts

class BithumbBarDataSet: BarChartDataSet {
    convenience init(entryArr: BarChartDataEntries) {
        self.init(entries: entryArr.values, label: "")
        
        let increasingColor = UIColor.increasingColor?.cgColor ?? UIColor.systemRed.cgColor
        let decreasingColor = UIColor.decreasingColor?.cgColor ?? UIColor.systemBlue.cgColor
        self.colors = entryArr.isOverThanZero.map({
            $0 ? NSUIColor(cgColor: increasingColor)
            : NSUIColor(cgColor: decreasingColor)}
        )
    }
    
    override init(entries: [ChartDataEntry], label: String) {
        super.init(entries: entries, label: label)
        self.colors = ChartColorTemplates.material()
        self.drawValuesEnabled = false
        self.axisDependency = .right

        self.drawIconsEnabled = false
        self.highlightColor = .lightGray
    }
    
    required init() {
        super.init()
    }
}
