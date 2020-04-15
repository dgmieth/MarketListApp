//
//  FinishedShoppingListsVCHeaderCellTableViewCell.swift
//  MarketListApp
//
//  Created by Diego Mieth on 21/12/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class FinishedShoppingListsVCHeaderCellTableViewCell: UITableViewCell {
    let hCell : Int = 38
    
    @IBOutlet weak var listDateLbl: UILabel!
    @IBOutlet weak var itemsQttyLbl: UILabel!
    @IBOutlet weak var itemsQttyInfoLbl: UILabel!
    @IBOutlet weak var itemsPriceLbl: UILabel!
    @IBOutlet weak var itemsPriceInfoLbl: UILabel!
    @IBOutlet weak var collapseOpenBtn: UIButton!

}
