////
////  ItemPurchaseHistoryVC.swift
////  MarketListApp
////
////  Created by Diego Mieth on 16/12/19.
////  Copyright © 2019 dgmieth. All rights reserved.
////
//
import UIKit

class ItemPurchaseHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //variables
    var passedItem : Item?
    var item : Item?
    var objCtrlIPHVC = ItemPurchaseHistoryController()
    var qttyItemsInArray = 3
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var purchaseHistoryTableView: UITableView!
    
    //MARK: - VIEWS LOADING
    override func viewWillAppear(_ animated: Bool) {
        if let hasItem = passedItem {
            item = hasItem
            print(item!.getName())
            itemNameLbl.text = item!.getName()
        } else {
            print("ERROR || ITEMPURCHASEDHISTORYVC || VIEWWILLAPPEAR || Foun nil while unwrapping passedItem")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseHistoryTableView.delegate = self
        purchaseHistoryTableView.dataSource = self
        
        purchaseHistoryTableView.allowsSelection = false
        purchaseHistoryTableView.separatorStyle = .none

        purchaseHistoryTableView.register(UINib(nibName: "ItemPurchaseHistoryVCCell", bundle: nil), forCellReuseIdentifier: "itemPurchaseHistoryVCCell")
    }
    //MARK:- TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if item!.getPurchaseHistory().count > 0{
            return item!.getPurchaseHistory().count
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && item!.getPurchaseHistory().count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "purchasedHistoryVCCell", for: indexPath)
            return cell
        } else if indexPath.row <= item!.getPurchaseHistoryArrayLength() - qttyItemsInArray {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemPurchaseHistoryVCCell", for: indexPath) as! ItemPurchaseHistoryVCCell
            cell.itemDateLbl.text = item!.getPurchaseHistory()[indexPath.row][0]
            cell.itemPriceLbl.text = item!.getPurchaseHistory()[indexPath.row][1]
            cell.itemQuantityLbl.text = item!.getPurchaseHistory()[indexPath.row][2]
            cell.soldByInfoLbl.text = item!.getPurchaseHistory()[indexPath.row][3]
            cell.ItemFinalVlLbl.text = item!.getPurchaseHistory()[indexPath.row][4]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "oldPurchasedHistoryVCCell", for: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && item!.getPurchaseHistory().count == 0 {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: false)
        } else if indexPath.row <= item!.getPurchaseHistoryArrayLength() - qttyItemsInArray {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: true)
        } else {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: false)
        }
    }
}
