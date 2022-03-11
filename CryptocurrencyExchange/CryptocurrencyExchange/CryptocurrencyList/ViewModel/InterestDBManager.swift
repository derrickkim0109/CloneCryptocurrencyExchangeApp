//
//  InterestDBManager.swift
//  CryptocurrencyExchange
//
//  Created by Yoojin Park on 2022/03/11.
//

import RealmSwift

class InterestDBManager: DBAccessable {
    typealias T = InterestCurrency
    
    func existingData(completion: @escaping (Results<T>) -> ()) {
        let interestData = suitableData(condition: nil)
        completion(interestData)
    }
    
    func isInterest(of interestKey: String) -> Bool {
        let interestData = suitableData() { interestInfo in
            return (interestInfo.currency == interestKey &&
                    interestInfo.interest == true)
        }
        return !interestData.isEmpty
    }
    
    func add(interest: T) {
        addWithUpdate(data: interest) { _ in }
    }
}
