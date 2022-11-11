//
//  OrderbookViewController.swift
//  CryptocurrencyExchange
//
//  Created by Derrick kim on 2022/03/06.
//

import Foundation
import SpreadsheetView
import UIKit

extension OrderbookViewController: SpreadsheetViewDelegate {
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension OrderbookViewController: SpreadsheetViewDataSource {
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return UIScreen.main.bounds.width / 3
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 30
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 3
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 60
    }
    
    // 각 컬럼의 row들을 합치는 곳입니다.
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return [
            CellRange(from: (row: 0, column: 2), to: (row: 25, column: 2)),
            CellRange(from: (row: 27, column: 2), to: (row: 29, column: 2)),
            CellRange(from: (row: 30, column: 0), to: (row: 59, column: 0))
        ]
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch indexPath.column {
        case 0:
            if indexPath.row < 30 {
                guard let askQuantityCell = AskQuantityViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? AskQuantityViewCell else {
                    return nil
                }
                
                if viewModel.askOrderbooksList.value.count > indexPath.row {
                    askQuantityCell.setData(data: viewModel.askOrderbooksList.value[indexPath.row])
                }
                
                return askQuantityCell
            } else if indexPath.row == 30 {
                guard let conclusionTableViewCell = ConclusionTableView.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? ConclusionTableView else {
                    return nil
                }
                
                conclusionTableViewCell.fasteningStrengthData = viewModel.fasteningStrengthList.value
                
                guard let data = viewModel.transactionList.value as? [TransactionEntity] else {
                    return nil
                }
                
                conclusionTableViewCell.concludedQuantityList = data
                
                return conclusionTableViewCell
            }
        case 1:
            if indexPath.row < 30 {
                guard let askPriceViewCell = AskPriceViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? AskPriceViewCell else {
                    return nil
                }
                
                if viewModel.askOrderbooksList.value.count > indexPath.row {
                    askPriceViewCell.setData(
                        data: viewModel.askOrderbooksList.value[indexPath.row],
                        closedPrice: viewModel.closedPrice.value
                    )
                }
                
                return askPriceViewCell
            } else {
                guard let bidPriceViewCell = BidPriceViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? BidPriceViewCell else {
                    return nil
                }
                
                if viewModel.bidOrderbooksList.value.count == 30 {
                    bidPriceViewCell.setData(
                        data: viewModel.bidOrderbooksList.value[indexPath.row - 30],
                        closedPrice: viewModel.closedPrice.value
                    )
                }
                
                return bidPriceViewCell
            }
        case 2:
            if indexPath.row >= 30 {
                guard let bidQuantityViewCell = BidQuantityViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? BidQuantityViewCell else {
                    return nil
                }
                
                if viewModel.bidOrderbooksList.value.count == 30 {
                    bidQuantityViewCell.setData(data: viewModel.bidOrderbooksList.value[indexPath.row - 30])
                }
                
                return bidQuantityViewCell
            } else if indexPath.row == 26 {
                guard let descriptionTopCell = TopViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? TopViewCell else {
                    return nil
                }
                
                if viewModel.tradeDescriptionList.value.count > 0 {
                    descriptionTopCell.setData(data: viewModel.tradeDescriptionList.value[indexPath.row - 26])
                }
                
                return descriptionTopCell
            } else if indexPath.row == 27 {
                guard let descriptionBottomCell = BottomViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? BottomViewCell else {
                    return nil
                }
                
                if viewModel.tradeDescriptionList.value.count > 0 {
                    descriptionBottomCell.setData(data: viewModel.tradeDescriptionList.value[indexPath.row - 27])
                }
                
                return descriptionBottomCell
            } else {
                guard let emptyViewCell = EmptyViewCell.dequeueReusableCell(spreadsheet: spreadsheetView, indexPath: indexPath) as? EmptyViewCell else {
                    return nil
                }
                emptyViewCell.backgroundColor = .tabBarColor
                return emptyViewCell
            }
        default:
            break
        }
        return nil
    }
}

extension Cell {
    static func register(spreadsheet: SpreadsheetView) {
        let Nib = UINib(nibName: self.NibName, bundle: nil)
        spreadsheet.register(Nib, forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static func dequeueReusableCell(spreadsheet: SpreadsheetView, indexPath: IndexPath) -> Self {
        guard let cell = spreadsheet.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Error! \(self.reuseIdentifier)")
        }
        
        return cell as! Self
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var NibName: String {
        return String(describing: self)
    }
}
