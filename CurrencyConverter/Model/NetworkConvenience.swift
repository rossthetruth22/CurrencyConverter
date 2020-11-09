//
//  NetworkConvenience.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 5/18/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

extension NetworkClient{
    
    func getAllCurrencies(completionHandlerForAll: @escaping (_ currencies: [String:Currencies], _ error: Error?) -> Void){
        
        /*List of currencies
        /api/v7/currencies?apiKey=[YOUR_API_KEY]*/
        
        let method = "currencies"
        
        let parametersForAPI = ["apiKey":"aba4c9be72f206458adb"] as [String:AnyObject]
        
        let _ = getDataMethod(method, parameters: parametersForAPI) { (result, error) in
            if let error = error{
                completionHandlerForAll([:], error)
            }else{
                guard let results = result?["results"] as? [String:[String:AnyObject]] else{
                    return
                }
                
                //print(results)
                
                let currencies = Currencies.addCurrency(currencies: results)
                CurrencyData.shared.createCurrencies(currencyDict: results)

                completionHandlerForAll(currencies, nil)
                
                
            }
        }
        
        
    }
    
    func getAllCountries(completionHandlerForAll: @escaping (_ countries: [String:Countries], _ error: Error?) -> Void){
        
        //var returnDict = [String: Currency]()
        
        /*List of countries
        /api/v7/countries?apiKey=[YOUR_API_KEY]*/
        
        let method = "countries"
        
        let parametersForAPI = ["apiKey":"aba4c9be72f206458adb"] as [String:AnyObject]
        
        let _ = getDataMethod(method, parameters: parametersForAPI) { (result, error) in
            if let error = error{
                completionHandlerForAll([:], error)
            }else{
                guard let results = result?["results"] as? [String:[String:AnyObject]] else{
                    return
                }
                
                //print(results)
//                for (_, value) in results{
//
//                    if let id = value["id"] as? String{
//
//                        if let currencyId = value["currencyID"] as? String{
//
//                            returnDict[id] = currencyId
//                        }
//                    }
//                }
//                completionHandlerForAll(returnDict, nil)
                
                CurrencyData.shared.createCountries(countryDict: results)
                let countries = Countries.addCountry(results)
                completionHandlerForAll(countries, nil)
                
            }
        }
    }
    
    func getCurrenciesWithFlag(completionHandlerForThis: @escaping (_ currencies: [Currencies], _ success: Bool, _ error:Error?) -> Void){
        
        getAllCountries { (countries, error) in
            if error != nil{
                completionHandlerForThis([Currencies](), false, error)
            }else{
                self.getAllCurrencies { (currencies, error) in
                    if error != nil{
                        completionHandlerForThis([Currencies](), false, error)
                    }else{
                        let splitCurrencies = Currencies.splitCurrency(currencies)
                        let realCurrencies = Currencies.addFlag(countries: countries, currencies: splitCurrencies)
                        completionHandlerForThis(realCurrencies, true, nil)
                        
                    }
                }
            }
        }
        
    }
    
    func convertCurrency(from: String, to: String, convertAmount: Double, completionHandlerForConversion: @escaping (_ amount: Double, _ error: Error?) -> Void){
        
        /*Ultra compact, multiple queries.
        /api/v7/convert?q=USD_PHP,PHP_USD&compact=ultra&apiKey=[YOUR_API_KEY]*/
        
        let method = "convert"
        
        let conversionParameter = from + "_" + to
        
        let parametersForAPI = ["q":conversionParameter, "compact":"ultra", "apiKey":"aba4c9be72f206458adb"] as [String:AnyObject]
        
        let _ = getDataMethod(method, parameters: parametersForAPI) { (result, error) in
            if let error = error{
                completionHandlerForConversion(Double(), error)
            }else{
                guard let result = result?[conversionParameter] as? Double else{
                    completionHandlerForConversion(Double(), error)
                    return
                }
                
                let convertedAmount = convertAmount * result
                
                completionHandlerForConversion(convertedAmount, nil)
            }
        }
        
        //let paramatersForApi = []
        
    }
    
}
