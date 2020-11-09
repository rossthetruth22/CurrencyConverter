//
//  Country+CoreDataClass.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 11/2/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Country)
public class Country: NSManagedObject {
    
    

    static func createCountryDict(countries: [Country])-> [String:Country]{
        
        var countryDict = [String:Country]()
        
        for country in countries{
            //print(country.currencyID)
            countryDict[country.currencyID!] = country
        }
        print(countryDict.count)
        return countryDict
        
    }
    
    static func addCountry(_ countries: [String:AnyObject], context: NSManagedObjectContext){
        
        //var returnCountries = [String:Countries]()
        var currencyID = String()
        var countrySymbol = String()
        var currencyName = String()
        var flagID = String()
        
        for (key, value) in countries{
            //print(key)
            switch key{
            case "currencyId":
                currencyID = value as! String
            case "currencySymbol":
                countrySymbol = value as! String
            case "currencyName":
                currencyName = value as! String
            case "id":
                flagID = value as! String
            default:
                continue
            }
        }
        let country = Country(context: context)
        country.currencyID = currencyID
        country.currencySymbol = countrySymbol
        country.currencyName = currencyName
        country.flagID = flagID
    }
    
//    convenience init(countries: [String:[String:AnyObject]], context: NSManagedObjectContext) {
//        //statements
//        self.init()
//    }
    
}
