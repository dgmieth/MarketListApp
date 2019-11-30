//
//  Kilo.swift
//  MarketListApp
//
//  Created by Diego Mieth on 03/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
class Kilogram: FormOfSale {
    //private var packageWeight : Double
    private var weighUnitMeasure : String
    
    init(priceOfItem itsPriceIs: Double, quantityOfItem itsQuantityIs: Double) {
        self.weighUnitMeasure = "kilogram(s)"
        super.init()
        super.setParameters(itemPrice: itsPriceIs, quantifiedBy: "Kilogram", quantity: itsQuantityIs)
        super.setFinalPriceOfItem(price: itsPriceIs, quantity: itsQuantityIs)
    }
    
    func getUnitMeasure() -> String {
        return self.weighUnitMeasure
    }
    
}

