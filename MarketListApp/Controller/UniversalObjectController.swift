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
    private let constantForCellAddress: Int = 100_000
    private let constantForMarketTag: Int = 1_000
    private let constantForSectorTag: Int = 1_000
    private let constantForItemTag: Int = 10_000
    private var itemObjTag : Int = -1
    private var itemIsSoldInKilosOrLitters : Bool = false
    
    //MARK:- DATA MANIPULATION
    func isItemSoldByKiloOrLiter() -> Bool {
        return self.itemIsSoldInKilosOrLitters
    }
    func registerDecimalFunctionInTextFieldIfItemSoldByInKiloOrLiter(withUnitMeasureRawValue x: Int) {
        self.itemIsSoldInKilosOrLitters = (x == UnitMeasure.allCases[4].rawValue || x == UnitMeasure.allCases[5].rawValue) ? true : false
    }
    func isThereText(inTextField text : String?) -> (Bool, String) {
        if let name = text {
            let range = name.rangeOfCharacter(from: NSCharacterSet.alphanumerics)
            if range != nil { return (true, name) }
        }
        return (false, "")
    }
    func isThereNumber(inTextField text : String?)->(Bool, String) {
        if let value = text {
            let newValue = self.currencyStringToDouble(withString: value)
            if newValue > 0 { return (true, "\(newValue)") }
        }
        return (false, "")
    }
    func isTherePrice(inTextField text : String?)->(Bool, String) {
        if let value = text {
            let tempStr = value.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted).split(separator: ",").joined().split(separator: ".").joined()
            let decimalNR = NSDecimalNumber(string: tempStr)
            let newValue = decimalNR.doubleValue/1_000
            if newValue > 0 { return (true, "\(newValue)") }
        }
        return (false, "")
    }
}
//MARK:- FORMATTERS
extension UniversalObjectController {
    func currencyDoubleToString(usingNumber number: Double)->String{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        let amount = currencyFormatter.string(from: NSNumber(value: number))!
        return amount
    }
    func numberByLocalityDoubleToString(valueToFormat value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.locale = NSLocale(localeIdentifier: "pt_BR") as Locale
        formatter.maximumFractionDigits = 3
        formatter.minimumFractionDigits = 3
        let valueF = formatter.string(from: NSNumber(value: value))!
        return valueF
    }
    func currencyStringToDouble(withString price: String) -> Double {
        let tempStr = price.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted).split(separator: ",").joined().split(separator: ".").joined()
        let decimalNR = NSDecimalNumber(string: tempStr)
        let intNr = decimalNR.doubleValue/100
        return intNr
    }
    func currentSystemDate()->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: Date())
        return result
    }
    func dateDateToString(withDate x: Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: x)
        return result
    }
    func quantityDoubleToInt(formatQtty value : Double)-> Int {
        let qtty = Int(value)
        return qtty
    }
}
//MARK:- GENERAL ITEM INFORMATION
extension UniversalObjectController{
    //MARK: ITEM INFORMATION
    func sectionSubsectionForItemInTableView(atSection market : Int, atRow row : Int, inMarketArray ary : [Market]) -> IndexPath {
        let sectorsInMarkets = ary[market].getSector()
        var itemIndex = row
        var sectorIndex : Int = 0
        for i in 0..<sectorsInMarkets.count {
            itemIndex = itemIndex - 1
            let itemsInMarket = sectorsInMarkets[i].getItem().count
            if itemsInMarket == 0 { itemIndex = itemIndex + 1 }
            if itemIndex < itemsInMarket {
                sectorIndex = i
                break
            } else { itemIndex = itemIndex - itemsInMarket }
        }
        return IndexPath(row: itemIndex, section: sectorIndex)
    }
    //MARK: CELL ADDRESS
    func setTagForObtainingItemObj(usingBtnTag value : Int){
        itemObjTag = value
    }
    func getTagForObtainingItemObj() -> Int {
        return itemObjTag
    }
    func getConstantForCellAddress()->Int{
        return self.constantForCellAddress
    }
    func getConstantsForTags(oneMarketTwoSectorThreeItem x : Int)->Int{
        switch x {
        case 1:
            return self.constantForMarketTag
        case 2:
            return self.constantForSectorTag
        case 3:
            return self.constantForItemTag
        default:
            return 0
        }
    }
}

//MARK:- ENUMS
extension UniversalObjectController {
    func returnUnitMeasureInString(forNumber x: Int) -> String {
        switch x {
        case 0:
            return "unidade"
        case 1:
            return "peso medio unitario"
        case 2:
            return "grama"
        case 3:
            return "ml"
        case 4:
            return "kilo"
        case 5:
            return "litro"
        default:
            return "error || UnitMeasure not Registered || returnNameForUnitMeasure || UniversalObjectController.swift"
        }
    }
}
//MARK:- USER INTERFACE ELEMENTS
extension UniversalObjectController{
    func getUIColorForSelectedTableViewCells() -> UIColor {
        return UIColor.init(named: "selectedCell")!
    }
}
