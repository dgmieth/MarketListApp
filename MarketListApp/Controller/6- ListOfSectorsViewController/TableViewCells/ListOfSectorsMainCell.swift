//
//  HeaderListOfSectorsTableViewCell.swift
//  MarketListApp
//
//  Created by Diego Mieth on 12/04/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import UIKit

class ListOfSectorsMainCell: UITableViewCell {
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
