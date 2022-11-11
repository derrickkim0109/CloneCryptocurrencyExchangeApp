//
//  ParamOptionDataType.swift
//  CryptocurrencyExchange
//
//  Created by Derrick on 2022/11/09.
//

import RealmSwift

enum OrderCurrency {
    case all
    case appoint(name: String)
    
    var value: String {
        switch self {

        case .all:
            return "ALL"
        case .appoint(let name):
            return "\(name)"
        }
    }
}

enum PaymentCurrency: String, PersistableEnum {
    case KRW
    case BTC
    
    var value: String {
        switch self {
        case .KRW:
            return "KRW"
        case .BTC:
            return "BTC"
        }
    }
}
