//
//  CellForItemInTableViews.swift
//  MarketListApp
//
//  Created by Diego Mieth on 07/03/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import UIKit

class CellForItemInTableViews: UITableViewCell {
    let hValue : CGFloat = 89
    @IBOutlet weak var namLbl: UILabel!
    @IBOutlet weak var soldByLbl: UILabel!
    @IBOutlet weak var soldByValueLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceValueLbl: UILabel!
    @IBOutlet weak var toBuyLbl: UILabel!
    @IBOutlet weak var qttyToByLbl: UILabel!
    @IBOutlet weak var notesBtn: UIButton!
    @IBOutlet weak var coldImg: UIImageView!
    @IBOutlet weak var imageImgView: UIImageView!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var brandLblInfo: UILabel!
    
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var checkMarkBtn: UIButton!
    @IBOutlet weak var cellViewView: UIView!
        
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
