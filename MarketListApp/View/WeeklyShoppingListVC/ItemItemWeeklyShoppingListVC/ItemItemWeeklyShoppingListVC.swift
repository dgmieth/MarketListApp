//
//  ItemItemWeeklyShoppingListVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 19/11/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class ItemItemWeeklyShoppingListVC: UITableViewCell {

    let hValue = 80
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var seeImageButton: UIButton!
    
    
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var quantityTxtField: UILabel!
    @IBOutlet weak var singleItemPriceLbl: UILabel!
    @IBOutlet weak var singleItemPriceTxtField: UILabel!
    @IBOutlet weak var priceTimesQuantityLbl: UILabel!
    @IBOutlet weak var priceTimesQuantityTxtField: UILabel!
    
    @IBOutlet weak var purchasedButton: UIButton!
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var itemNotes: UIButton!
    @IBOutlet weak var coldSingImageView: UIImageView!
    
    
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
        selectedBackgroundView?.backgroundColor = UIColor(red: 0.161, green: 0.136, blue: 0.127, alpha: 0.6)
    }
}
