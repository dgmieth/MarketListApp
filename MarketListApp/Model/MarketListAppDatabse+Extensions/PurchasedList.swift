//
//  PurchasedItemsList.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import CoreData

extension PurchasedList {
    func getListFinishedDate()->Date? {
        if let date = self.boughDate {
             return date
        }
        return nil
    }
    func setListFinishedDate(date: Date){
        self.boughDate = date
    }
    func getBoughItems()->[PurchasedItem]{
        return self.purchasedItems!.sortedArray(using: [(NSSortDescriptor(key: "market", ascending: true))]) as! [PurchasedItem]
    }
    func setTotalAmountSpent(price : Double){
        self.totalAmount = self.totalAmount + price
    }
    func getTotalAmountSpent()->Double{
        return totalAmount
    }
    func setBoughtItemsQtty(itemQtty value: Double){
        self.totalQttItems = self.totalQttItems + value
    }
    func getBoughtItemsQtty()-> Double{
        return self.totalQttItems
    }
    func openSubcell(){
        self.opened = true
    }
    func closeSubcell(){
        self.opened = false
    }
    func isOpened()->Bool{
        return self.opened
    }
}
