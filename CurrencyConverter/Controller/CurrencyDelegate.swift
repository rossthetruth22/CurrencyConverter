//
//  CurrencyDelegate.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 6/1/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

protocol CurrencyDelegate{
    func returnFromCurrency(_ currency: Currency)
    func returnToCurrency(_ currency: Currency)
}

protocol CurrencyDelegateI{
    func getTheCurrency() -> Currency
}
