//
//  PurchasedItem.swift
//  MarketListApp
//
//  Created by Diego Mieth on 18/12/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import CoreData

extension PurchasedItem {
    func getItemName()-> String {
        return self.name!
    }
    func setItemName(name: String){
        self.name = name
    }
    func getItemPrice()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: self.price))!
        return amount
    }
    func setItemPrice(price: Double){
        self.price = price
    }
    func getItemPriceDescription()->Int{
        return Int(self.formOfSale)
    }
    func getBoughtQuantity()->Int{
        return Int(self.qttBought)
    }
    func setBoughtQtty(qtty : Double){
        self.qttBought = qtty
    }
    func getItemBoughQuantityInDouble()->Double{
        return self.qttBought
    }
    func setMarket(market: String){
        self.market = market
    }
    func getMarket()-> String{
        if let name = market {
            return name
        }
        return "no market name found"
    }
    func getFinalAmmount()->String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: self.finalAmount))!
        return amount
    }
    func setTotalAmmount(value: Double){
        self.finalAmount = value
    }
    func getTotalAmount()->Double{
        return self.finalAmount
    }
    func setItemFormOfSale(rawValue value : Int){
        self.formOfSale = Int16(value)
    }
}
