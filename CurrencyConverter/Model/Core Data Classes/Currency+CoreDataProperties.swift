//
//  Currency+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 11/2/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var currencyCode: String?
    @NSManaged public var currencyID: String?
    @NSManaged public var currencyName: String?
    @NSManaged public var currencySymbol: String?
    @NSManaged public var flag: String?

}
