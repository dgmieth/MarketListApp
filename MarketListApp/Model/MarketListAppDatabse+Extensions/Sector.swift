//
//  Sector.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import CoreData

extension Sector {
    //getter&setters
    func setName(sectorName name: String){
        self.name = name
    }
    func getName()->String{
        return self.name!
    }
    func setItem(item: Item){
        items!.setValue(item.addToList, forKey: "addToList")
        items!.setValue(item.brand, forKey: "brand")
        items!.setValue(item.coldItem, forKey: "coldItem")
        items!.setValue(item.image, forKey: "image")
        items!.setValue(item.information, forKey: "information")
        items!.setValue(item.name, forKey: "name")
        items!.setValue(item.purchased, forKey: "purchased")
    }
    func getItem() -> [Item]{
        return self.items!.sortedArray(using: [(NSSortDescriptor(key: "orderingID", ascending: true))]) as! [Item]
    }
    func setHasItems(value : Bool){
        self.hasItems = value
    }
    func getHasItems()->Bool{
        return self.hasItems
    }
    func addOneItem(){
        self.market!.addOneItem()
        self.qttyOfItems += 1
        if self.qttyOfItems > 0 {
            self.setHasItems(value: true)
        }
    }
    func subtractOneItem(){
        self.qttyOfItems -= 1
        self.market!.subtractOneItem()
        if self.qttyOfItems == 0 {
            self.setHasItems(value: false)
        }
    }
    func getQttOfItems()-> Int{
        return Int(self.qttyOfItems)
    }
    func getOrderingID() -> Int{
        return Int(self.orderingID)
    }
    func setOredringId(setAt value: Int){
        self.orderingID = Int16(value)
    }
    func openedSubcell(){
        self.opened = true
    }
    func closeSubcell(){
        self.opened = false
    }
    func isOpened()->Bool{
        return self.opened
    }
    func resetItemOrdering(){
        if self.getItem().count > 0 {
            for i in 0..<self.getItem().count{
                self.getItem()[i].setOredringId(setAt: i)
            }       }
    }
}


