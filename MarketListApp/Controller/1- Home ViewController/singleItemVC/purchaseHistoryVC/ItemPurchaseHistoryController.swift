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
        return value ? CGFloat(tableViewCell.hValue) : 21
//        if value {
//            return CGFloat(tableViewCell.hValue)
//        } else {
//            return 21
//        }
    }
}
