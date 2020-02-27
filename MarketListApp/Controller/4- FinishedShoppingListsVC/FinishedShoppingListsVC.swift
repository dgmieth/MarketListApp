//
//  FinishedShoppingListsVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 19/12/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class FinishedShoppingListsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var purchasedItemsArrayFSLVC : [PurchasedItemsList]?
    var uObjCtrlFSLVC = UniversalObjectController()
    let headerCell = FinishedShoppingListsVCHeaderCellTableViewCell()
    let mainCell = FinishedShoppingListsVCItemsCells()
    @IBOutlet weak var finishedListsTableView: UITableView!
    @IBOutlet weak var searchBarFSLVC: UISearchBar!
    
    //MARK:- VIEW LOADING
    override func viewWillAppear(_ animated: Bool) {
        if let purchased = purchasedItemsArrayFSLVC {
            print(purchased.count)
        } else {
            print("ERROR | FINISHEDSHOPPINGLISTSVC | VIEWWILLAPPEAR | purchasedItemsArrayFSLCV had NIL")
        }
    }
    override func viewDidLoad() {
        print("entrou:")
        finishedListsTableView.delegate = self
        finishedListsTableView.dataSource = self
        
        finishedListsTableView.register(UINib(nibName: "FinishedShoppingListsVCItemsCells", bundle: nil), forCellReuseIdentifier: "mainCell")
        finishedListsTableView.register(UINib(nibName: "FinishedShoppingListsVCHeaderCellTableViewCell", bundle: nil), forCellReuseIdentifier: "headerCell")
        
        if let textfield = searchBarFSLVC.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor.black
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
    }
    //MARK:- TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return purchasedItemsArrayFSLVC!.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let items = purchasedItemsArrayFSLVC![section]
        let hCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! FinishedShoppingListsVCHeaderCellTableViewCell
        hCell.listDateLbl.text = "Concluida em \(uObjCtrlFSLVC.returnFormattedDate(withDate: items.getListFinishedDate()))"
        hCell.itemsQttyInfoLbl.text = " \(uObjCtrlFSLVC.returnFormattedQttyInInt(formatQtty: items.getBoughtItemsQtty()))"
        hCell.itemsPriceInfoLbl.text = uObjCtrlFSLVC.returnFormattedCurrency(usingNumber: items.getTotalAmountSpent())
        return hCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(headerCell.hCell)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchasedItemsArrayFSLVC![section].getBoughItems().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ary = purchasedItemsArrayFSLVC![indexPath.section].getBoughItems()
        let item = ary[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! FinishedShoppingListsVCItemsCells
        cell.itemNameLbl.text = item.getItemName()
        switch item.getItemPriceDescription() {
        case .averageWeight:
            cell.itemPriceLbl.text = "Preco (kilo/litro)"
        case .gram, .mililiter:
            cell.itemPriceLbl.text = "Preco (100 \(item.getItemPriceDescription().rawValue)s):"
        default:
            cell.itemPriceLbl.text = "Preco (\(item.getItemPriceDescription().rawValue)):"
        }
        cell.itemPriceInfoLbl.text = item.getItemPrice()
        cell.itemMarketInfoLbl.text = item.getMarket()
        switch item.getItemPriceDescription() {
        case .averageWeight:
            cell.itemQttyInfoLbl.text = "\(item.getBoughtQuantity()) unidade(s)"
        case .kilogram, .liter:
            cell.itemQttyInfoLbl.text = "\(uObjCtrlFSLVC.returnDecimalNumberFormattedAccordingToLocality(valueToFormat: item.getItemBoughQuantityInDouble())) \(item.getItemPriceDescription().rawValue)(s)"
        default:
            cell.itemQttyInfoLbl.text = "\(item.getBoughtQuantity()) \(item.getItemPriceDescription().rawValue)(s)"
        }
        cell.itemFinalPriceInfoLbl.text = item.getFinalAmmount()
        cell.itemFormOfSaleInfoLbl.text = item.getItemPriceDescription().rawValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(mainCell.cellHeigh)
    }
}
