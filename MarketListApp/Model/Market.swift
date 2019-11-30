//
//  Market.swift
//  MarketListApp
//
//  Created by Diego Mieth on 02/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.

import Foundation

class Market {
    static var classCount : Int = 0
    private var ID : Int = 0
    private var name : String
    
    init (withMarketName market : String){
        Market.classCount = Market.classCount + 1
        self.ID = Market.classCount
        self.name = market
    }
    
    func getMarketName() -> String{
        return self.name
    }
    
    func getMarketID() -> Int {
        return self.ID
    }
    
}
