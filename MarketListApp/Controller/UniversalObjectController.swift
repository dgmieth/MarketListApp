//
//  UniversalObjectController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 20/11/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class UniversalObjectController {
    //variables for getting cell address outside tableview functions
    private let constantForCellAddress: Int = 10000
    private var cellAddress : Int = -1
    private var itemIsSoldInKilosOrLitters : Bool = false
    
    func getUIColorForSelectedTableViewCells() -> UIColor {
        return UIColor(red:0.81, green:0.85, blue:0.86, alpha:1.0)
    }
    //MARK:- FORMAT
    func returnFormattedCurrency(usingNumber number: Double)->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: number))!
        return amount
    }
    func returnFormattedCurrentSystemDate()->String {
        let datePurhcased = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: datePurhcased)
        return result
    }
    func returnFormattedDate(withDate x: Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: x)
        return result
    }
    func returnFormattedQttyInInt(formatQtty value : Double)-> Int {
        let qtty = Int(value)
        return qtty
    }
    func returnDecimalNumberFormattedAccordingToLocality(valueToFormat value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        let valueF = formatter.string(from: NSNumber(value: value))!
        return valueF
    }
    func stringToDoubleForPriceData(withString price: String) -> Double {
        let tempStr = price.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted).split(separator: ",").joined().split(separator: ".").joined()
        let decimalNR = NSDecimalNumber(string: tempStr)
        let intNr = decimalNR.doubleValue/100
        return intNr
    }
    //MARK: -GET CELL FROM ARRAY
    func computeRowAndColum(atSection market : Int, atRow row : Int, inMarketArray ary : [Market]) -> IndexPath {
        let sectorsInMarkets = ary[market].getSector()
        var itemIndex = row
        var sectorIndex : Int = 0
        for i in 0..<sectorsInMarkets.count {
            itemIndex = itemIndex - 1
            let itemsInMarket = sectorsInMarkets[i].getItem().count
            if itemsInMarket == 0 {
                itemIndex = itemIndex + 1
            }
            if itemIndex < itemsInMarket {
                sectorIndex = i
                break
            } else {
                itemIndex = itemIndex - itemsInMarket
            }
        }
        return IndexPath(row: itemIndex, section: sectorIndex)
    }
    //MARK:- CELL ADDRESS
    func setTagForCellAddressForOtherFunctionsOutsideTableView(atIndexPath value : Int){
        cellAddress = value
    }
    func getCellAdress() -> [CellAddressDictionary : Int] {
        var ary = [CellAddressDictionary : Int]()
        ary[.cellAddress] = cellAddress
        ary[.constantForCellAddress] = constantForCellAddress
        ary[.marketAndSectorIndex] = self.cellAddress/constantForCellAddress
        ary[.itemIndex] = self.cellAddress%constantForCellAddress
        return ary
    }
    //MARK:- DATA MANIPULATION
    func setItemsIsSoldInKilosOrLiters(value: Bool) {
        self.itemIsSoldInKilosOrLitters = value
    }
    func getItemIsSoldInKilosOrLitters() -> Bool {
        return self.itemIsSoldInKilosOrLitters
    }
    func checkIfItemIsSoldInKiloOrLiter(withDescription text: String) -> Bool {
        if text == UnitMeasure.allCases[4].rawValue {
            return true
        } else if text == UnitMeasure.allCases[5].rawValue {
            return true
        }
        return false
    }
    func checkIfInputInformationIsNotZero(price str: String)-> Bool{
        let price = (Double(str.numbersOnly.integerValue))
        if price > 0 {
            return true
        } else {
            return false
        }
    }

}
