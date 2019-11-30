//
//  Item.swift
//  MarketListApp
//
//  Created by Diego Mieth on 03/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
class Item {
    static var classCount : Int = 0
    private var ID : Int = 0
    private var name : String
    private var atMarket : Market
    private var atSector : Sector
    private var brand : String = "no brand"
    private var isARefrigeratedProduct : Bool = false
    private var thisProdcutIsSoldByUnit : Unit?
    private var thisProdcutIsSoldByKilogram : Kilogram?
    private var notes : String = ""
    
    init (nameIs name: String, atMarket market : Market, atSector sector : Sector, soldByKilo form : Kilogram){
        Item.classCount = Item.classCount + 1
        self.ID = Item.classCount
        self.name = name
        self.atMarket = market
        self.atSector = sector
        self.thisProdcutIsSoldByKilogram = form
    }
    
    //MARK: - ID
    func getID()-> Int {
        return self.ID
    }
    
    //MARK: - name
    func setName(newNameIs name : String){
        self.name = name
    }
    func getName() -> String {
        return self.name
    }
    
    //MARK: - market
    func setMarket(atMarket market : Market){
        self.atMarket = market
    }
    func getMarket() -> Market{
        return self.atMarket
    }
    
    //MARK: - sector
    func setSector(atSector sector : Sector){
        self.atSector = sector
    }
    func getSector() -> Sector{
        return self.atSector
    }
    
    //MARK: - brand
    func setBrand(newBrandIs brand : String) {
        self.brand = brand
    }
    func getBrand() -> String {
        return self.brand
    }
    //MARK: - refrigerated?
    func setRefrigeration(isTheProductRefrigerated answer : Bool){
        self.isARefrigeratedProduct = answer
    }
    func getRefrigeration() -> Bool {
        return self.isARefrigeratedProduct
    }
    
    //MARK: - form of sale
    func setSoldByUnit(thisProductIsSoldBy form : Unit){
        self.thisProdcutIsSoldByUnit! = form
    }
    func getSoldByUnit() -> Unit {
        return self.thisProdcutIsSoldByUnit!
    }
    func setSoldByKilo(thisProductIsSoldBy form : Kilogram){
        self.thisProdcutIsSoldByKilogram! = form
    }
    func getSoldByKilogram() -> Kilogram{
        return self.thisProdcutIsSoldByKilogram!
    }
    
    //MARK: - notes
    func setNotes(noteForThisItem note : String){
        self.notes = note
    }
    func getNotes() -> String {
        return self.notes
    }
}
