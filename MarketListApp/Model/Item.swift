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
    private var name : String
    private var brand : String
    private var coldItem : Bool
    private var formOfSale : ItemSaleForm = ItemSaleForm()
    private var addToShopList : Bool
    private var notes : String?
    private var purchaseHistory = [[String]]()
    private var image : UIImage
    private var purchased : Bool
    
    init (itemName name : String, itsBrandIs brand : String, itIsCold temp : Bool){
        Item.classCounter = Item.classCounter + 1
        self.ID = Item.classCounter
        self.name = name
        self.brand = brand
        self.coldItem = temp
        self.image = UIImage(named: "standarNewItemImage")!
        self.addToShopList = false
        self.purchased = false
    }
    init(){
        self.ID = 0
        self.name = ""
        self.brand = ""
        self.coldItem = false
        self.image = UIImage(named: "standarNewItemImage")!
        self.addToShopList = false
        self.purchased = false
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
    func getBrand()->String{
        return self.brand
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
    //formOfSale
    func getFormOfSale () -> ItemSaleForm {
        return self.formOfSale
    }
    
}
