//
//  WebSocketTickerEntity.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/02/26.
//

import Foundation

struct WebSocketTickerEntity: Codable {
    let type: WebSocketType
    let content: WebSocketTickerContent
}

struct WebSocketTickerContent: Codable {
    let symbol: String              // 통화코드
    let tickType: WebSocketTickType // 변동 기준시간- 30M, 1H, 12H, 24H, MID
    let date: String                // 일자
    let time: String                // 시간
    let openPrice: String           // 시가
    let closePrice: String          // 종가
    let lowPrice: String            // 저가
    let highPrice: String           // 고가
    let value: String               // 누적거래금액
    let volume: String              // 누적거래량
    let sellVolume: String          // 매도누적거래량
    let buyVolume: String           // 매수누적거래량
    let prevClosePrice: String      // 전일종가
    let chgRate: String             // 변동률
    let chgAmt: String              // 변동금액
    let volumePower: String         // 체결강도
}

extension WebSocketTickerContent {
    func generate() -> TradeDescriptionEntity{
        return TradeDescriptionEntity(
            volume: volume,
            value: value,
            prevClosingPrice: prevClosePrice,
            openingPrice: openPrice,
            maxPrice: highPrice,
            minPrice: lowPrice,
            symbol: symbol
        )
    }
}
