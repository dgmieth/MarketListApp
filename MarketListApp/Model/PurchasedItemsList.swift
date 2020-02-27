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
    private var itemsStrArray = [PurchasedItem]()
    private let boughtIn : Date
    private var totalAmountSpent : Double
    private var boughtItemsQtty : Double
    
    init(){
        PurchasedItemsList.classCounter = PurchasedItemsList.classCounter + 1
        self.boughtIn = Date()
        self.totalAmountSpent = 0
        self.boughtItemsQtty = 0
    }
    func addBoughtItem(item: PurchasedItem){
        self.itemsStrArray.append(item)
    }
    func getListFinishedDate()->Date {
        return self.boughtIn
    }
    func getBoughItems()->[PurchasedItem]{
        return self.itemsStrArray
    }
    func setTotalAmountSpent(price : Double){
        self.totalAmountSpent = self.totalAmountSpent + price
    }
    func getTotalAmountSpent()->Double{
        return totalAmountSpent
    }
    func setBoughtItemsQtty(itemQtty value: Double){
        self.boughtItemsQtty = self.boughtItemsQtty + value
    }
    func getBoughtItemsQtty()-> Double{
        return self.boughtItemsQtty
    }
}
