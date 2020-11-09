//
//  Currency+CoreDataClass.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 11/2/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Currency)
public class Currency: NSManagedObject {
    
    static func addCurrency(_ currencies: [String:AnyObject], context: NSManagedObjectContext){
        
        //var returnCountries = [String:Countries]()
        var currencyCode = String()
        var currencyName = String()
        var currencySymbol = String()
        var currencyID = String()
        for (key, value) in currencies{

            switch key{
            case "id":
                currencyID = value as! String
                currencyCode = value as! String
            case "currencySymbol":
                currencySymbol = value as! String
            case "currencyName":
                currencyName = value as! String
//            case "id":
//                flagID = value as! String
            default:
                continue
            }
        }
        let currency = Currency(context: context)
        currency.currencyID = currencyID
        currency.currencySymbol = currencySymbol
        currency.currencyName = currencyName
        currency.currencyCode = currencyCode
    }
    
    static func addFlag(countries: [String:Country], currencies: [Currency], context: NSManagedObjectContext){
            
            let newCurrencies = currencies
            var index = 0
            while index < newCurrencies.count{
                if let flag = DuplicateCountry.duplicates[newCurrencies[index].currencyID!]{
                    newCurrencies[index].flag = flag.lowercased()
                }else if let country = countries[newCurrencies[index].currencyID!]{
                    newCurrencies[index].flag = country.flagID!.lowercased()
                }
                //print(newCurrencies[index])
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
            
//            let sortedCurrencies = newCurrencies.sorted { $0.currencyCode < $1.currencyCode}
            
            //return sortedCurrencies
            //return newCurrencies
        }

}
