//
//  ItemSaleForm.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

enum UnitMeasure : String, CaseIterable {
    case single
        = "unidade"
    case kilogram = "kilo"
    case gram = "grama"
    case liter = "litro"
    case mililiter = "ml"
    case averageWeight = "peso médio unitário"
    
    static var allCases : [UnitMeasure] = [.single,.averageWeight,.gram,.mililiter,.kilogram,.liter]
}

class ItemSaleForm{
    private static var classCounter : Int = 0
    private var soldBy : UnitMeasure = .kilogram
    private var standarWeightValue : Double = 1.0
    private var quantity : Double = 1
    private var price : Double = 0.0
    private let gramDivisor = 100
    private let mililiterDivisor = 100
    private let averageWeightDivisor = 1000
    private let allOtherDivisors = 1
    private let constantForCurrency : Double = 100
    private let constantForQuantity : Double = 1_000
    
    //getter&setters
    func setUnitMeasure(howItIsSold unit: UnitMeasure){
        self.soldBy = unit
    }
    func getUnitMeasure()->String{
        return self.soldBy.rawValue
    }
    func getUnitMeasureNoRawValue()-> UnitMeasure {
        return self.soldBy
    }
    func setStandarWeightValue(standarWeightIs weight : Double = 0){
        switch self.soldBy {
        case .averageWeight:
            self.standarWeightValue = Double(round(weight)/Double(self.averageWeightDivisor))
        case .gram:
            self.standarWeightValue = Double(self.gramDivisor)
        case .mililiter:
            self.standarWeightValue = Double(self.mililiterDivisor)
        default:
            self.standarWeightValue = 1
        }
    }
    func getStandarWeightValue()->Double{
        return self.standarWeightValue
    }
    func getDivisor() -> [UnitMeasure : Int] {
        var dictAry = [UnitMeasure : Int]()
        dictAry[.averageWeight] = self.averageWeightDivisor
        dictAry[.gram] = self.gramDivisor
        dictAry[.kilogram] = self.allOtherDivisors
        dictAry[.liter] = self.allOtherDivisors
        dictAry[.mililiter] = self.mililiterDivisor
        dictAry[.single] = self.allOtherDivisors
        return dictAry
    }
    func setQuantityInUnits(howManyUnits quantity : Int){
        self.quantity = Double(quantity)
    }
    func setQuantityInDecimal(howMuchItWeighs quantity : String){
        let tempStr = quantity.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted).split(separator: ",").joined()
        let decimalNR = NSDecimalNumber(string: tempStr)
        self.quantity = decimalNR.doubleValue/constantForQuantity
    }
    func getItemQuantityInWeight()->Double{
        return quantity
    }
    func setItemPrice(howMuchIsIt price: String){
        let tempStr = price.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted).split(separator: ",").joined().split(separator: ".").joined()
        let decimalNR = NSDecimalNumber(string: tempStr)
        let intNr = decimalNR.doubleValue/constantForCurrency
        self.price = intNr
    }
    func getItemPrice()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: self.price))!
        return amount
    }
    func getItemPriceDouble()->Double {
        return self.price
    }
    func getFinalQuantityPrice()->Double{
        var result = Double()
        switch self.soldBy {
        case .gram:
            result = self.price * self.quantity/Double(self.gramDivisor)
        case .mililiter:
            result = self.price * self.quantity/Double(self.mililiterDivisor)
        default:
            result = self.price * self.quantity * self.standarWeightValue
        }
        return round(result*constantForCurrency)/constantForCurrency
    }
    func getFormattedFinalQuantityPrice()->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: self.getFinalQuantityPrice()))!
        return amount
    }
    func getFinalQuantityPriceDouble()->Double{
        self.getFinalQuantityPrice()
    }
}


