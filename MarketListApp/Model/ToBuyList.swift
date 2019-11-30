//
//  ToBuyList.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

class ToBuyList {
    private static var classCounter : Int = 0
    private var toBuyItems : [Item]
    private var startDate : Date
    private var endData : Date?
    
    init(){
        ToBuyList.classCounter = ToBuyList.classCounter + 1
        self.toBuyItems = [Item]()
        self.startDate = Date()
    }
    
}
