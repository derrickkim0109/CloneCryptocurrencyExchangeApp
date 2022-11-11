//
//  WebSoketType.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/26.
//

import Foundation

enum WebSocketType: String, Codable {
    case ticker = "ticker"
    case transaction = "transaction"
    case orderbookdepth = "orderbookdepth"
}
