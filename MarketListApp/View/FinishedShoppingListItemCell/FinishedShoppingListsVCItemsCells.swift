//
//  FinishedShoppingListsVCItemsCells.swift
//  MarketListApp
//
//  Created by Diego Mieth on 21/12/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class FinishedShoppingListsVCItemsCells: UITableViewCell {
    let cellHeigh: CGFloat = 80
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var itemFinalPriceLbl: UILabel!
    @IBOutlet weak var itemMarketLbl: UILabel!
    @IBOutlet weak var itemPriceInfoLbl: UILabel!
    @IBOutlet weak var itemFinalPriceInfoLbl: UILabel!
    @IBOutlet weak var itemMarketInfoLbl: UILabel!
    @IBOutlet weak var itemQttyLbl: UILabel!
    @IBOutlet weak var itemQttyInfoLbl: UILabel!
    @IBOutlet weak var itemFormOfSaleLbl: UILabel!
    @IBOutlet weak var itemFormOfSaleInfoLbl: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    func initViews() {
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = UIColor.init(named: "selectedCell")
    }
}
