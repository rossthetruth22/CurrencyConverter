//
//  Country.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 5/18/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

struct Countries{
    
    var currencyID: String
    var countrySymbol: String
    var currencyName: String
    var flagID: String
    
    init(currencyID: String, countrySymbol: String, currencyName:String, flagID:String) {
        self.currencyID = currencyID
        self.countrySymbol = countrySymbol
        self.currencyName = currencyName
        self.flagID = flagID
    }
    
    static func addCountry(_ countries: [String:[String:AnyObject]]) -> [String:Countries]{
        //print(countries)
        var returnCountries = [String:Countries]()
        
        for (_, country) in countries{
            
            let currencyID = country["currencyId"] as! String
            let countrySymbol = country["currencySymbol"] as! String
            let currencyName = country["currencyName"] as! String
            let flagID = country["id"] as! String
            let country = Countries(currencyID: currencyID, countrySymbol: countrySymbol, currencyName: currencyName, flagID: flagID)
            
            returnCountries[currencyID] = country
        }
       // print(returnCountries)
        return returnCountries
    }
}
