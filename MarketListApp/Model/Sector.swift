//
//  Sector.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

class Sector {
    private static  var classCounter : Int = 0
    private let ID : Int
    private var name : String
    private var items : [Item] = []
    
    init (sectorName name: String){
        Sector.classCounter = Sector.classCounter + 1
        self.ID = Sector.classCounter
        self.name = name
    }
    
    //getter&setters
    func setName(sectorName name: String){
        self.name = name
    }
    func getName()->String{
        return self.name
    }
    func getID()->Int{
        return self.ID
    }
    func getClassCounter()->Int{
        return Sector.classCounter
    }
    func setItem(item: Item){
            self.items.append(item)
    }
    func getItem() -> [Item]{
        return self.items
    }
}


