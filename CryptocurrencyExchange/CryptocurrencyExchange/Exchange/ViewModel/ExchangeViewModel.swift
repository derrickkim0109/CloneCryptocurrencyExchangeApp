//
//  ExchangeViewModel.swift
//  CryptocurrencyExchange
//
//  Created by Dayeon Jung on 2022/02/25.
//

import Foundation

class ExchangeViewModel: ViewControllerFromNib {
    var nibName: String?
    
    init(nibName: String? = nil) {
        self.nibName = nibName
    }
}


