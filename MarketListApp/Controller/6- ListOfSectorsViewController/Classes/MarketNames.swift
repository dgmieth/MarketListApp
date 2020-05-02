//
//  MarketNames.swift
//  MarketListApp
//
//  Created by Diego Mieth on 24/04/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import Foundation

class MarketNames {
    private var ary = [(name: String, isSelected: Bool)]()
    
    init(markets: [Market]?){
        if ary.count == 0 {
            ary.append((name: "Todos", isSelected: true))
        }
        if let nAry = markets {
            for m in nAry {
                ary.append((name: m.getName(), isSelected: false))
            }       }
    }
    func getArray()->[(name: String, isSelected: Bool)]{
        return self.ary
    }
    func setIsSelected(index: Int){
        for i in 0..<self.ary.count {
            ary[i].isSelected = false
        }
        ary[index].isSelected = !ary[index].isSelected
    }
}
