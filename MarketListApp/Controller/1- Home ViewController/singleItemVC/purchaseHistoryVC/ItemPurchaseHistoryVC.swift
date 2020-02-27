//
//  ItemPurchaseHistoryVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 16/12/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class ItemPurchaseHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //variables
    var item = Item()
    var objCtrlIPHVC = ItemPurchaseHistoryController()
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var purchaseHistoryTableView: UITableView!
    
    //MARK: - VIEWS LOADING
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameLbl.text = item.getName()
        purchaseHistoryTableView.delegate = self
        purchaseHistoryTableView.dataSource = self
        
        purchaseHistoryTableView.allowsSelection = false
        purchaseHistoryTableView.separatorStyle = .none

        purchaseHistoryTableView.register(UINib(nibName: "ItemPurchaseHistoryVCCell", bundle: nil), forCellReuseIdentifier: "itemPurchaseHistoryVCCell")
    }
    //MARK:- TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if item.getPurchaseHistory().count > 0{
            return item.getPurchaseHistory().count
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && item.getPurchaseHistory().count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "purchasedHistoryVCCell", for: indexPath)
            return cell
        } else if indexPath.row <= item.getPurchaseHistoryArrayLength() - 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemPurchaseHistoryVCCell", for: indexPath) as! ItemPurchaseHistoryVCCell
            cell.itemDateLbl.text = item.getPurchaseHistory()[indexPath.row][0]
            cell.itemPriceLbl.text = item.getPurchaseHistory()[indexPath.row][2]
            cell.itemQuantityLbl.text = item.getPurchaseHistory()[indexPath.row][1]
            cell.ItemFinalVlLbl.text = item.getPurchaseHistory()[indexPath.row][3]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "oldPurchasedHistoryVCCell", for: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && item.getPurchaseHistory().count == 0 {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: false)
        } else if indexPath.row <= item.getPurchaseHistoryArrayLength() - 3 {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: true)
        } else {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: false)
        }
    }
}
