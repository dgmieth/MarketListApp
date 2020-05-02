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
    var uObjCtrl = UniversalObjectController()
    var qttyItemsInArray = 3
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var purchaseHistoryTableView: UITableView!
    
    //MARK: - VIEWS LOADING
    override func viewWillAppear(_ animated: Bool) {
        if let hasItem = passedItem {
            item = hasItem
            itemNameLbl.text = item!.getName()
        } else {
            print("ERROR || ITEMPURCHASEDHISTORYVC || VIEWWILLAPPEAR || Foun nil while unwrapping passedItem")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        purchaseHistoryTableView.delegate = self
        purchaseHistoryTableView.dataSource = self
        
        //        purchaseHistoryTableView.allowsSelection = false
        purchaseHistoryTableView.separatorColor = UIColor.init(named: "textColor")
        purchaseHistoryTableView.tableFooterView = UIView()
        
        purchaseHistoryTableView.register(UINib(nibName: "ItemPurchaseHistoryVCCell", bundle: nil), forCellReuseIdentifier: "itemPurchaseHistoryVCCell")
        
    }
    //MARK:- TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let toUseItem = item {
            return toUseItem.getPurchaseHistoryString().count > 0 ? toUseItem.getPurchaseHistoryString().count : 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if indexPath.row == 0 && item!.getPurchaseHistoryString().count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "purchasedHistoryVCCell", for: indexPath)
            return cell
        } else if indexPath.row <= item!.getPurchaseHistoryArrayLength() - qttyItemsInArray {
            tableView.separatorStyle = .singleLine
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemPurchaseHistoryVCCell", for: indexPath) as! ItemPurchaseHistoryVCCell
            cell.itemDateLbl.text = item!.getPurchaseHistoryString()[indexPath.row][0]
            cell.itemPriceLbl.text = uObjCtrl.currencyDoubleToString(usingNumber: item!.getPurchaseHistoryDouble()[indexPath.row][1])
            if item!.getPurchaseHistoryString()[indexPath.row][1] == uObjCtrl.returnUnitMeasureInString(forNumber: 4) || item!.getPurchaseHistoryString()[indexPath.row][1] == uObjCtrl.returnUnitMeasureInString(forNumber: 5) {
                cell.itemQuantityLbl.text = ("\(uObjCtrl.numberByLocalityDoubleToString(valueToFormat: item!.getPurchaseHistoryDouble()[indexPath.row][0]))")
            } else {
                cell.itemQuantityLbl.text = ("\(Int(item!.getPurchaseHistoryDouble()[indexPath.row][0]))")
            }
            
            cell.soldByInfoLbl.text = item!.getPurchaseHistoryString()[indexPath.row][1]
            cell.ItemFinalVlLbl.text =
                uObjCtrl.currencyDoubleToString(usingNumber: item!.getPurchaseHistoryDouble()[indexPath.row][2])
            return cell
        } else {
            tableView.separatorStyle = .singleLine
            let cell = tableView.dequeueReusableCell(withIdentifier: "oldPurchasedHistoryVCCell", for: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && item!.getPurchaseHistoryString().count == 0 {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: false)
        } else if indexPath.row <= item!.getPurchaseHistoryArrayLength() - qttyItemsInArray {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: true)
        } else {
            return objCtrlIPHVC.returnCellHeightForCellForRowAT(isItCustomTableViewCell: false)
        }
    }
}
