//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 5/18/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit
import CoreData

class Currencies{
    
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String?
    var currencyID: String
    var flag: String?
    
    init(code: String, name: String, symbol: String?, id: String) {
        currencyCode = code
        currencyName = name
        currencySymbol = symbol
        currencyID = id
    }
    
    static func addCurrency(currencies: [String:[String:AnyObject]]) -> [
        String:Currencies]{
        
            var newCurrencies = [String:Currencies]()
        
        for (dictKey, currency) in currencies{
            let code = dictKey
            let name = currency["currencyName"] as! String
            let symbol :String? = currency["currencySymbol"] as? String
            let id : String = currency["id"] as! String
            let currency = Currencies(code: code, name: name, symbol: symbol, id: id)
            newCurrencies[dictKey] = currency
        }
            //print(newCurrencies)
        return newCurrencies
    }
    
    static func splitCurrency(_ currencies: [String:Currencies]) -> [Currencies]{
        
        var returnCurrency = [Currencies]()
        for (_, currency) in currencies{
            returnCurrency.append(currency)
        }
        
        return returnCurrency
    }
    
    static func addFlag(countries: [String:Countries], currencies: [Currencies]) -> [Currencies]{
        
        let newCurrencies = currencies
        var index = 0
        while index < newCurrencies.count{
            if let flag = DuplicateCountry.duplicates[newCurrencies[index].currencyID]{
                newCurrencies[index].flag = flag.lowercased()
            }else if let country = countries[newCurrencies[index].currencyID]{
                newCurrencies[index].flag = country.flagID.lowercased()
            }
            index += 1
        }
//        for var currency in newCurrencies{
//            if let country = countries[currency.currencyID]{
//                print("inside with country")
//                currency.flag = country.flagID
//                print(currency)
//            }
//        }
        
        //print(newCurrencies)
        
        let sortedCurrencies = newCurrencies.sorted { $0.currencyCode < $1.currencyCode}
        
        return sortedCurrencies
        //return newCurrencies
    }
}
