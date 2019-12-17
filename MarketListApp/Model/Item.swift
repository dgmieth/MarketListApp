//
//  Item.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import UIKit

class Item {
    private static var classCounter : Int = 0
    private let ID : Int
    //main item information
    private var name : String
    private var brand : String?
    private var formOfSale : ItemSaleForm = ItemSaleForm()
    private var coldItem : Bool = false
    //secondaryItemInformation
    private var information : String?
    private var purchaseHistory = [[String]]()
    private var image : UIImage = UIImage(named: "standarNewItemImage")!
    private var addToShopList : Bool = false
    private var purchased : Bool = false
    
    init (itemName name : String){
        Item.classCounter = Item.classCounter + 1
        self.ID = Item.classCounter
        self.name = name
    }
    init(){
        self.ID = 0
        self.name = ""
        self.image = UIImage(named: "standarNewItemImage")!
    }
    deinit {
        print("killed")
    }
    //getter&setters
    func getID()->Int{
        return self.ID
    }
    func setName(itsNameIs name : String){
        self.name = name
    }
    func getName()->String{
        return self.name
    }
    func setBrand(itsBrandIs brand : String){
        self.brand = brand
    }
    func getBrand()->(hasValue: Bool, Value: String){
        if let value = self.brand {
            return (true, value)
        } else {
            return (false, "")
        }
    }
    func setItemTemp (isItCold cold : Bool){
        self.coldItem = cold
    }
    func getItemTemp ()->Bool{
        return self.coldItem
    }
    func setImage(useImage image: UIImage){
        self.image = image
    }
    func getImage() -> UIImage {
        return self.image
    }
    func setAddToBuyList(changeBoolValue newValue : Bool) {
        self.addToShopList = newValue
    }
    func getAddToBuyList() -> Bool {
        return self.addToShopList
    }
    func getAddToBuyListOpositeValue () -> Bool{
        return !self.addToShopList
    }
    func setPurchase(value: Bool) {
        self.purchased = value
    }
    func getPurchase() -> Bool {
        return self.purchased
    }
    func setPurchaseHistory(withText txt: [String]){
        self.purchaseHistory.append(txt)
        print(self.purchaseHistory)
    }
    func getPurchaseHistory() -> [[String]]{
        return self.purchaseHistory
    }
    func setItemInformation(information info : String){
        self.information = info
    }
    func getItemInformation()->String {
        if let itemInfo = self.information {
            return itemInfo
        } else {
            return "Nao ha informacoes para este item"
        }
    }
    //formOfSale
    func getFormOfSale () -> ItemSaleForm {
        return self.formOfSale
    }
    
}
