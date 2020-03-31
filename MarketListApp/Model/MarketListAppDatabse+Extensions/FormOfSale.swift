//
//  ItemSaleForm.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import CoreData

enum UnitMeasure : Int, CaseIterable {
    case single
        = 0
    case kilogram = 4
    case gram = 2
    case liter = 5
    case mililiter = 3
    case averageWeight = 1
    
    static var allCases : [UnitMeasure] = [.single,.averageWeight,.gram,.mililiter,.kilogram,.liter]
}

extension FormOfSale{
    //getter&setters
    func setUnitMeasure(howItIsSold unit: UnitMeasure){
        self.soldBy = Int16(unit.rawValue)
    }
    func getUnitMeasure()->Int{
        return Int(self.soldBy)
    }
    func getUnitMeasureNoRawValue()-> UnitMeasure {
        return UnitMeasure.allCases[Int(self.soldBy)]
    }
    func setStandardWeight(standarWeightIs value : String = ""){
        switch UnitMeasure.allCases[Int(self.soldBy)] {
        case .averageWeight:
            let weight = Double(NSDecimalNumber(string: value).intValue)
            self.standardWeight = Double(round(weight)/Double(self.avgWeightDivisor))
        case .gram, .mililiter:
            self.standardWeight = Double(100)
        default:
            self.standardWeight = 1
        }
    }
    func getStandarWeightValue()->Double{
        return self.standardWeight
    }
    func getDivisor() -> [UnitMeasure : Double] {
        var dictAry = [UnitMeasure : Double]()
        dictAry[.averageWeight] = self.avgWeightDivisor
        dictAry[.gram] = self.gramMililiterDivisor
        dictAry[.kilogram] = self.allOtherDivisors
        dictAry[.liter] = self.allOtherDivisors
        dictAry[.mililiter] = self.gramMililiterDivisor
        dictAry[.single] = self.allOtherDivisors
        return dictAry
    }
    func setQuantityStringToDouble(howManyUnits quantity : String, kiloOrLiter value: Bool){
        let tempStr = quantity.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted).split(separator: ",").joined().split(separator: ".").joined()
        let decimalNR = NSDecimalNumber(string: tempStr)
        self.quantity = value ? decimalNR.doubleValue/constantForQuantity : decimalNR.doubleValue
    }
    func getItemQtty()->Double{
        return quantity
    }
    func setItemPriceStringToDouble(howMuchIsIt price: String){
        let tempStr = price.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted).split(separator: ",").joined().split(separator: ".").joined()
        let decimalNR = NSDecimalNumber(string: tempStr)
        let intNr = decimalNR.doubleValue/constantForCurrency
        self.price = intNr
    }
    func getItemPriceDoubleToString()->String{
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
        case 2:
            result = self.price * self.quantity/self.gramMililiterDivisor
        case 3:
            result = self.price * self.quantity/self.gramMililiterDivisor
        default:
            result = self.price * self.quantity * self.standardWeight
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
}
