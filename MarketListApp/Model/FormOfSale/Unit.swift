//
//  Unit.swift
//  MarketListApp
//
//  Created by Diego Mieth on 02/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
class Unit: FormOfSale {
    private var packageWeight : Double
    private var packageWeighUnitMeasure : String
    
    init(priceOfItem itsPriceIs: Double, quantityOfItem itsQuantityIs: Int, packageWeightOfIem itsPakcageWeighs: Double,
        withPackageWeightUnitMeasure itsWeightUnitMeasureIs : String) {
        self.packageWeight = itsPakcageWeighs
        self.packageWeighUnitMeasure = itsWeightUnitMeasureIs
        super.init()
        super.setParameters(itemPrice: itsPriceIs, quantifiedBy: "Unitario", quantity: Double(itsQuantityIs))
        super.setFinalPriceOfItem(price: itsPriceIs, quantity: Double(itsQuantityIs))
    }
    
    func setPackageWeith(weightOfPackageIs weight : Double){
        self.packageWeight = weight
    }
    func getPackageWeight() -> Double {
        return self.packageWeight
    }
    
    func setPackageWeightUnitMeasure(unitMeasureOfPackageIs unit: String){
        self.packageWeighUnitMeasure = unit
    }
    func getPackageUnitMeasure() -> String {
        return self.packageWeighUnitMeasure
    }

    func getFullPackageUnitMeasure() -> String {
        let fullText = ("\(self.packageWeight) \(self.packageWeighUnitMeasure)")
        return fullText
    }
    
}
