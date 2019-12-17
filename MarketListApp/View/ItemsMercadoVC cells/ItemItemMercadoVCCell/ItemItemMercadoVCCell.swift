//
//  ItemItemMercadoVCCell.swift
//  MarketListApp
//
//  Created by Diego Mieth on 15/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class ItemItemMercadoVCCell: UITableViewCell {
    let hValue = 80
    var cellAddress = IndexPath()
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var formOfSaleLable: UILabel!
    @IBOutlet weak var itemFormOfSale: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemPriceAmount: UILabel!
    @IBOutlet weak var addedToWeeklyShoppingListLab: UILabel!
    @IBOutlet weak var addedToWeeklyListTextField: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemImageButton: UIButton!
    @IBOutlet weak var itemNotes: UIButton!
    @IBOutlet weak var coldSingImageView: UIImageView!
    
    
    @IBOutlet weak var checkmarkSign: UIButton!
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
