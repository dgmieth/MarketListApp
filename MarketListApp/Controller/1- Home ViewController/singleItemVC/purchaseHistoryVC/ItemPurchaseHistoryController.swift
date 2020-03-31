//
//  ItemPurchaseHistoryController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 16/12/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class ItemPurchaseHistoryController {
    let tableViewCell = ItemPurchaseHistoryVCCell()
    
    func returnCellHeightForCellForRowAT(isItCustomTableViewCell value : Bool)->CGFloat {
        if value {
            return CGFloat(tableViewCell.hValue)
        } else {
            return 21
        }
        
    }
}
