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
    var searchBarArray = [PurchasedItem]()
    var uObjCtrl = UniversalObjectController()
    let headerCell = FinishedShoppingListsVCHeaderCellTableViewCell()
    let mainCell = FinishedShoppingListsVCItemsCells()
    let searchCell = FinishedShoppingListsSearchCells()
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

        finishedListsTableView.register(UINib(nibName: "FinishedShoppingListsSearchCells", bundle: nil), forCellReuseIdentifier: "FinishedShoppingListsSearchCells")
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
        searchBarFSLVC.delegate = self
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
    }
    override func viewWillDisappear(_ animated: Bool) {
        purchasedItemsArrayFSLVC = [PurchasedList]()
        searchBarArray = [PurchasedItem]()
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
            return searchBarArray.count
        }
        return purchasedItemsArrayFSLVC[section].isOpened() ? purchasedItemsArrayFSLVC[section].getBoughItems().count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchingOn {
            tableView.separatorStyle = .singleLine
            let item = searchBarArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedShoppingListsSearchCells", for: indexPath) as! FinishedShoppingListsSearchCells
            cell.itemInfoLbl.text = item.getItemName()
            cell.dateInfoLbl.text = uObjCtrl.dateDateToString(withDate: item.purchasedList!.getListFinishedDate()!)
            cell.priceInfoLbl.text = item.getItemPrice()
            switch UnitMeasure.allCases[item.getItemPriceDescription()]  {
            case .averageWeight:
                cell.qttyInfoLbl.text = "\(item.getBoughtQuantity()) unidade(s)"
            case .kilogram, .liter:
                cell.qttyInfoLbl.text = "\(uObjCtrl.numberByLocalityDoubleToString(valueToFormat: item.getItemBoughQuantityInDouble())) \(uObjCtrl.returnUnitMeasureInString(forNumber: item.getItemPriceDescription()))(s)"
            default:
                cell.qttyInfoLbl.text = "\(item.getBoughtQuantity()) \(uObjCtrl.returnUnitMeasureInString(forNumber: item.getItemPriceDescription()))(s)"
            }
            cell.finalPriceInfoLbl.text = item.getFinalAmmount()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchingOn {
            endSearchMode()
            var foundValue = false
            var counter = 0
            var newIndexPath = IndexPath()
            let item = searchBarArray[indexPath.row]
            while foundValue == false {
                if purchasedItemsArrayFSLVC[counter].getListFinishedDate() == item.purchasedList!.getListFinishedDate()! {
                    for i in 0..<purchasedItemsArrayFSLVC[counter].getBoughItems().count {
                        if item == purchasedItemsArrayFSLVC[counter].getBoughItems()[i] {
                            newIndexPath = IndexPath(row: i, section: counter)
                            foundValue = true
                            break
                        }       }       }
                counter += 1
            }
            DispatchQueue.main.async {
                !self.purchasedItemsArrayFSLVC[newIndexPath.section].isOpened() ? self.purchasedItemsArrayFSLVC[newIndexPath.section].openSubcell() : nil
                tableView.reloadData()
                tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .middle)
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchingOn {
            return searchCell.hCell
        }
        if purchasedItemsArrayFSLVC[indexPath.section].isOpened() {
            return mainCell.cellHeigh
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
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "purchasedList.boughDate", ascending: false)]
        if let results = try? dataController.viewContext.fetch(fetchRequest1){
            searchBarArray = results
        }
        else {
            print("ERROR | FINISHEDSHOPPINGLISTSVC | VIEWWILLAPPEAR | purchasedItemsArrayFSLCV had NIL")
        }
        searchBarFSLVC.isHidden = purchasedItemsArrayFSLVC.count == 0 ? true : false
    }
}
//MARK:- SEARCH BAR
extension FinishedShoppingListsVC: UISearchBarDelegate{
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showCanceButton()
        loadData()
        if searchText.isEmpty {
            finishedListsTableView.reloadData()
            return
        } else {
            let myFilter = searchText.lowercased()
            searchBarArray = searchBarArray.filter({ $0.name?.lowercased().range(of: myFilter, options: [.diacriticInsensitive]) != nil})
        }
        finishedListsTableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCanceButton()
        finishedListsTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endSearchMode()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        showCanceButton()
    }
    func showCanceButton(){
        searchingOn = true
        searchBarFSLVC.showsCancelButton = true
        let cancel = searchBarFSLVC.value(forKey: "cancelButton") as! UIButton
        cancel.tintColor = .black
        cancel.isEnabled = true
    }
    func endSearchMode(){
        DispatchQueue.main.async {
            self.searchBarFSLVC.endEditing(true)
            self.searchBarFSLVC.showsCancelButton = false
            self.searchBarFSLVC.resignFirstResponder()
            self.searchBarFSLVC.text = ""
            self.searchingOn = false
            self.loadData()
            self.finishedListsTableView.keyboardDismissMode = .onDrag
            self.finishedListsTableView.reloadData()
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        finishedListsTableView.keyboardDismissMode = .onDrag
        searchingOn ? showCanceButton() : nil
    }
}
