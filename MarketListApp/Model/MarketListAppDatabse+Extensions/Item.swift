//
//  Item.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Item {
    func setName(itsNameIs name : String){
        self.name = name
    }
    func getName()->String{
        return self.name!
    }
    func setBrand(itsBrandIs brand : String){
        self.brand = brand
    }
    func getBrand()->(hasValue: Bool, Value: String){
        if let value = self.brand {
            if value != "" {
                return (true, value)
            }   }
            return (false, "")
    }
    func setItemTemp (isItCold cold : Bool){
        self.coldItem = cold
    }
    func getItemTemp ()->Bool{
        return self.coldItem
    }
    func setImage(useImage image: UIImage){
        self.image = image.pngData()
    }
    func getImage() -> UIImage {
        if let image = image {
            return UIImage(data: image)!
        }
        return UIImage(named: "standarNewItemImage")!
    }
    func setAddToBuyList(changeBoolValue newValue : Bool) {
        self.addToList = newValue
    }
    func getAddToBuyList() -> Bool {
        return self.addToList
    }
    func getAddToBuyListOpositeValue () -> Bool{
        return self.addToList
    }
    func setPurchase(value: Bool) {
        self.purchased = value
    }
    func getPurchase() -> Bool {
        return self.purchased
    }
    func setPurchaseHistory(withText txt: [String]){
        if var counter = self.purchasingHistory {
            counter.append(txt)
            self.purchasingHistory = counter
        } else {
            let counter = [txt]
            self.purchasingHistory = counter
        }
    }
    func getPurchaseHistory() -> [[String]]{
        let length = Int(self.purchasedArrayLength)
        if let aryLength = self.purchasingHistory {
            if aryLength.count == length {
                self.purchasingHistory!.remove(at: length - 1)
                return self.purchasingHistory!
            } else {
                return self.purchasingHistory!
            }
        }
        return [[String]]()
    }
    func setItemInformation(information info : String?){
        self.information = info
    }
    func getItemInformation()->(hasValue: Bool, value: String) {
        if let itemInfo = self.information {
            return (true, itemInfo)
        } else {
            return (false, "Nao ha informacoes para este item")
        }
    }
    func getPurchaseHistoryArrayLength()->Int{
        return Int(self.purchasedArrayLength)
    }
    //formOfSale
    func getFormOfSale () -> FormOfSale {
        return self.formOfSale!
    }
    func getOrderingID() -> Int{
        return Int(self.orderingID)
    }
    func setOredringId(setAt value: Int){
        self.orderingID = Int16(value)
    }
    func subtractItemFromMarketAndSectorCounter(){
        self.sector!.subtractOneItem()
    }
    func addOneitemInMarketAndSectorCounter(){
        self.sector!.addOneItem()
    }
    func getIsAlreadyPurchased()->Bool{
        return self.alreadyPurchased
    }
    func setIsAlreadyPurchased(value: Bool){
        self.alreadyPurchased = value
    }
}
