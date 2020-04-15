//
//  FinishedShoppingListsSearchCells.swift
//  MarketListApp
//
//  Created by Diego Mieth on 05/04/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import UIKit

class FinishedShoppingListsSearchCells: UITableViewCell {
    let hCell : CGFloat = 40
    @IBOutlet weak var itemInfoLbl: UILabel!
    @IBOutlet weak var dateInfoLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceInfoLbl: UILabel!
    @IBOutlet weak var qttyLbl: UILabel!
    @IBOutlet weak var qttyInfoLbl: UILabel!
    @IBOutlet weak var finalPriceLbl: UILabel!
    @IBOutlet weak var finalPriceInfoLbl: UILabel!
    
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
        selectedBackgroundView?.backgroundColor = UIColor(red: 0.161, green: 0.136, blue: 0.127, alpha: 0.5)
    }
}
