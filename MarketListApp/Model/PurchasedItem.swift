//
//  PurchasedItem.swift
//  MarketListApp
//
//  Created by Diego Mieth on 18/12/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

class PurchasedItem {
    private static var classCounter : Int = 0
    private let id : Int
    private let itemName : String
    private let itemPrice : Double
    private let formOfSale : UnitMeasure
    private let boughtQuatity : Double
    private let finalAmount : Double
    private let atMarket : String
    
    init (name: String, price: Double, priceDescription: UnitMeasure, boughtQ: Double, finalPaidPrice: Double, market: String) {
        PurchasedItem.classCounter = PurchasedItem.classCounter + 1
        self.id = PurchasedItem.classCounter
        self.itemName = name
        self.itemPrice = price
        self.formOfSale = priceDescription
        self.boughtQuatity = boughtQ
        self.finalAmount = finalPaidPrice
        self.atMarket = market
    }
    //getters
    func getId() -> Int {
        return self.id
    }
    func getItemName()-> String {
        return self.itemName
    }
    func getItemPrice()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: self.itemPrice))!
        return amount
    }
    func getItemPriceDescription()->UnitMeasure{
        return self.formOfSale
    }
    func getBoughtQuantity()->Int{
        return Int(self.boughtQuatity)
    }
    func getItemBoughQuantityInDouble()->Double{
        return self.boughtQuatity
    }
    func getFinalAmmount()->String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: self.finalAmount))!
        return amount
    }
    func getMarket()->String{
        return self.atMarket
    }
}
