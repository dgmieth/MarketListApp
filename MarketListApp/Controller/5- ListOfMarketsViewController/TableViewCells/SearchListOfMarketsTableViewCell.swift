//
//  SearchListOfMarketsTableViewCell.swift
//  MarketListApp
//
//  Created by Diego Mieth on 11/04/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import UIKit

class SearchListOfMarketsTableViewCell: UITableViewCell {
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
           selectedBackgroundView?.backgroundColor = UIColor(red: 0.161, green: 0.136, blue: 0.127, alpha: 0.1)
       }

}
