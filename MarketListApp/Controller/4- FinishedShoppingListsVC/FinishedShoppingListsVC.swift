////
////  FinishedShoppingListsVC.swift
////  MarketListApp
////
////  Created by Diego Mieth on 19/12/19.
////  Copyright © 2019 dgmieth. All rights reserved.
////
//
import UIKit
import CoreData

class FinishedShoppingListsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var purchasedItemsArrayFSLVC = [PurchasedList]()
    var filteredPurchasedList = [PurchasedItem]()
    var uObjCtrl = UniversalObjectController()
    let headerCell = FinishedShoppingListsVCHeaderCellTableViewCell()
    let mainCell = FinishedShoppingListsVCItemsCells()
    var dataController : DataController!
    @IBOutlet weak var finishedListsTableView: UITableView!
    @IBOutlet weak var searchBarFSLVC: UISearchBar!
    var searchingOn : Bool = false
}
//MARK:- VIEW LOADING
extension FinishedShoppingListsVC{
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    override func viewDidLoad() {
        finishedListsTableView.delegate = self
        finishedListsTableView.dataSource = self
        
        finishedListsTableView.separatorStyle = .none
        finishedListsTableView.tableFooterView = UIView()

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
        let cancel = searchBarFSLVC.value(forKey: "cancelButton") as! UIButton
        cancel.tintColor = .white
        searchBarFSLVC.delegate = self
    }
}
//MARK:- TABLEVIEW
extension FinishedShoppingListsVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchingOn ? 1 : purchasedItemsArrayFSLVC.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !searchingOn {
            let items = purchasedItemsArrayFSLVC[section]
            let hCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! FinishedShoppingListsVCHeaderCellTableViewCell
            hCell.listDateLbl.text = "Concluida em \(uObjCtrl.dateDateToString(withDate: items.getListFinishedDate()!))"
            hCell.collapseOpenBtn.addTarget(self, action: #selector(openCloseHeaders(sender:)), for: .touchUpInside)
            hCell.collapseOpenBtn.tag = section
            hCell.itemsQttyInfoLbl.text = "\(uObjCtrl.quantityDoubleToInt(formatQtty: items.getBoughtItemsQtty()))"
            hCell.itemsPriceInfoLbl.text = uObjCtrl.currencyDoubleToString(usingNumber: items.getTotalAmountSpent())
            return hCell
        }
        return UIView()
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !searchingOn {
            return purchasedItemsArrayFSLVC[section].isOpened() ? CGFloat(headerCell.hCell) : CGFloat(headerCell.hCell + 10)
        }
        return CGFloat(0)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingOn {
            return filteredPurchasedList.count
        }
        return purchasedItemsArrayFSLVC[section].isOpened() ? purchasedItemsArrayFSLVC[section].getBoughItems().count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchingOn {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! FinishedShoppingListsVCItemsCells
            cell.itemNameLbl.text = filteredPurchasedList[indexPath.row].getItemName()
            return cell
        }
        let ary = purchasedItemsArrayFSLVC[indexPath.section].getBoughItems()
        let item = ary[indexPath.row]
        if purchasedItemsArrayFSLVC[indexPath.section].isOpened() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! FinishedShoppingListsVCItemsCells
            cell.itemNameLbl.text = item.getItemName()
            switch UnitMeasure.allCases[item.getItemPriceDescription()] {
            case .averageWeight:
                cell.itemPriceLbl.text = "Preco (kilo/litro)"
            case .gram, .mililiter:
                cell.itemPriceLbl.text = "Preco (100 \(uObjCtrl.returnUnitMeasureInString(forNumber: item.getItemPriceDescription()))s):"
            default:
                cell.itemPriceLbl.text = "Preco (\(uObjCtrl.returnUnitMeasureInString(forNumber: item.getItemPriceDescription()))):"
            }
            cell.itemPriceInfoLbl.text = item.getItemPrice()
            cell.itemMarketInfoLbl.text = item.getMarket()
            switch UnitMeasure.allCases[item.getItemPriceDescription()]  {
            case .averageWeight:
                cell.itemQttyInfoLbl.text = "\(item.getBoughtQuantity()) unidade(s)"
            case .kilogram, .liter:
                cell.itemQttyInfoLbl.text = "\(uObjCtrl.numberByLocalityDoubleToString(valueToFormat: item.getItemBoughQuantityInDouble())) \(uObjCtrl.returnUnitMeasureInString(forNumber: item.getItemPriceDescription()))(s)"
            default:
                cell.itemQttyInfoLbl.text = "\(item.getBoughtQuantity()) \(uObjCtrl.returnUnitMeasureInString(forNumber: item.getItemPriceDescription()))(s)"
            }
            cell.itemFinalPriceInfoLbl.text = item.getFinalAmmount()
            cell.itemFormOfSaleInfoLbl.text = "\(uObjCtrl.returnUnitMeasureInString(forNumber: item.getItemPriceDescription()))"
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchingOn {
            return CGFloat(89)
        }
        if purchasedItemsArrayFSLVC[indexPath.section].isOpened() {
            return CGFloat(mainCell.cellHeigh)
        }
        return CGFloat(0)
    }
}
//MARK:- TARGETS
extension FinishedShoppingListsVC{
    @objc func openCloseHeaders(sender: UIButton){
        if purchasedItemsArrayFSLVC[sender.tag].isOpened(){
            purchasedItemsArrayFSLVC[sender.tag].closeSubcell()
            finishedListsTableView.separatorStyle = .none
        } else {
            purchasedItemsArrayFSLVC[sender.tag].openSubcell()
            finishedListsTableView.separatorColor = .black
            finishedListsTableView.separatorStyle = .singleLine
        }
        finishedListsTableView.reloadData()
    }
}
//MARK:- CORE DATA
extension FinishedShoppingListsVC{
    func loadData(){
        let fetchRequest = NSFetchRequest<PurchasedList>(entityName: "PurchasedList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "boughDate", ascending: false)]
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            purchasedItemsArrayFSLVC = results
        }
        let fetchRequest1 = NSFetchRequest<PurchasedItem>(entityName: "PurchasedItem")
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest1){
            filteredPurchasedList = results
        }
        else {
            print("ERROR | FINISHEDSHOPPINGLISTSVC | VIEWWILLAPPEAR | purchasedItemsArrayFSLCV had NIL")
        }
    }
}
//MARK:- SEARCH BAR
extension FinishedShoppingListsVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
        if searchText.isEmpty {
            finishedListsTableView.reloadData()
            return
        } else {
            let myFilter = searchText.lowercased()
            filteredPurchasedList = filteredPurchasedList.filter({ $0.name?.lowercased().range(of: myFilter, options: [.diacriticInsensitive]) != nil})
        }
        finishedListsTableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        enableUserInterfaceSearchBar(value: false)
        searchingOn = true
        finishedListsTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        enableUserInterfaceSearchBar(value: true)
        searchingOn = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        loadData()
        finishedListsTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
