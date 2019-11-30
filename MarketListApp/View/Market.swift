//
//  Market.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

class Market {
    private static  var classCounter : Int = 0
    private let ID : Int
    private var name : String
    private var sectors : [Sector] = []
    
    init (marketName name: String){
        Market.classCounter = Market.classCounter + 1
        self.ID = Market.classCounter
        self.name = name
    }
    
    //getter&setters
    func setName(marketName name: String){
        self.name = name
    }
    func getName()->String{
        return self.name
    }
    func getID()->Int{
        return self.ID
    }
    func getClassCounter()->Int{
        return Market.classCounter
    }
    func setSector(sector: Sector){
            self.sectors.append(sector)
    }
    func getSector()->[Sector]{
        return self.sectors
    }
}
