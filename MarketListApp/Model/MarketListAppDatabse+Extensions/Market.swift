//
//  Market.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import CoreData

extension Market {
    //getter&setters
    func setName(marketName name: String){
        self.name = name
        
    }
    func getName()->String{
        return self.name!
    }
    func setSector(sector: Sector){
        self.sectors!.setValue(String(sector.name!), forKey: "name")
    }
    func getSector()->[Sector]{
        return self.sectors!.sortedArray(using: [(NSSortDescriptor(key: "orderingID", ascending: true))]) as! [Sector]
    }
    func setHasItems(value : Bool){
        self.hasItems = value
    }
    func getHasItems()->Bool{
        return self.hasItems
    }
    func addOneItem(){
        self.qttOfItems += 1
        if self.qttOfItems > 0 {
            self.setHasItems(value: true)
        }
    }
    func subtractOneItem(){
        self.qttOfItems -= 1
        if self.qttOfItems == 0 {
            self.hasItems = false
        }
    }
    func getQttOfItems()-> Int{
        return Int(self.qttOfItems)
    }
    func getOrderingID() -> Int{
        return Int(self.orderingID)
    }
    func setOredringId(setAt value: Int){
        self.orderingID = Int16(value)
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
    func resetSectorOrdering(){
        if self.getSector().count > 0 {
            for i in 0..<self.getSector().count{
                self.getSector()[i].setOredringId(setAt: i)
            }       }
    }
}
