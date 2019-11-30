//
//  FormOfSale.swift
//  MarketListApp
//
//  Created by Diego Mieth on 02/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

class FormOfSale{
    private var itemPrice : Double = 0
    private var quantifiedBy : String = ""
    private var quantity : Double = 0
    private var finalPrice : Double = 0
    
    //MARK: - modified INIT for subclasses
    func setParameters(itemPrice price : Double, quantifiedBy quantifiedIn: String, quantity itsQuantityIs: Double){
        self.itemPrice = price
        self.quantifiedBy = quantifiedIn
        self.quantity = itsQuantityIs
    }

    //MARK: - item price
    func setItemPrice(withItemPrice price : Double){
        self.itemPrice = price
    }
    func getItemPrice () -> Double {
        return self.itemPrice
    }

    //MARK: - quantified by
    func getQuantifiedBy() -> String {
        return self.quantifiedBy
    }
    
    //Mark: - quantity of items
    func setQuantityOfItem(quantityOfItemIs quantity : Double){
        self.quantity = quantity
    }
    func getQuantityOfItem() -> Double {
        return self.quantity
    }
    
    //MARK: - final price
    func setFinalPriceOfItem(price: Double, quantity : Double){
        self.finalPrice = price * quantity
    }
    func getFinalPriceOfItem()->Double {
        return self.finalPrice
    }
    
}
