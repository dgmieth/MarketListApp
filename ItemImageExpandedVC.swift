//
//  ItemImageExpandedVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 16/11/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class ItemImageExpandedVC: UIViewController {
    var selectedCellImage = UIImage()

    @IBOutlet weak var itemImageExpanded: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImageExpanded.image = selectedCellImage
    }
}
