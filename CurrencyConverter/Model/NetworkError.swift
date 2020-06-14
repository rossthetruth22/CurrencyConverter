//
//  NetworkError.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 6/13/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import Foundation

enum NetworkError:Error{
    case badReturn, couldNotParseJSON
    
    func errorDescription()->String{
        switch self{
        case .badReturn:
            return "There was an problem getting currencies. Please try again later."
        case .couldNotParseJSON:
            return "There was an internal error. Please try again later."
        }
    }
}
