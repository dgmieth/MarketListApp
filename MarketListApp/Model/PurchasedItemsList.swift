//
//  PurchasedItemsList.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

class PurchasedItemsList{
    private static var classCounter : Int = 0
    private var itemsStrArray : [[[[[[String]]]]]]
    private var boughtIn : Date
    private var totalAmountSpent : Double
    
    init(boughIn date: Date, supermarketItemsCost amount: Double){
        PurchasedItemsList.classCounter = PurchasedItemsList.classCounter + 1
        self.itemsStrArray = [[[[[[]]]]]]
        self.boughtIn = date
        self.totalAmountSpent = amount
    }
}
