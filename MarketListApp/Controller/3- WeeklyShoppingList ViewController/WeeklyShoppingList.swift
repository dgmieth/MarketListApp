////
////  WeeklyShoppingList.swift
////  MarketListApp
////
////  Created by Diego Mieth on 19/11/19.
////  Copyright © 2019 dgmieth. All rights reserved.
////
//
import UIKit
import CoreData

//protocol WeeklyShoppingListDelegate {
//    func callDelegateWSL()
//}

class WeeklyShoppingList: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //    var weeklyVCMarketsArray = [Market]()
    var marketsArray = [Market]()
    var purchasedItemsArrayWSLVC = [PurchasedList]()
    var objCtrl = WeeklyShoppingListObjectController()
    var uObjCtrl = UniversalObjectController()
    var chosenImageForItemImageExpandedVC = UIImage()
//    var delegate : WeeklyShoppingListDelegate?
    
//    let marketCell = MarketItemWeeklyShoppingList()
//    let sectorCell = SectorItemWeeklyShoppingList()
//    let itemCell = ItemItemWeeklyShoppingListVC ()
    var dataController : DataController!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchingOn : Bool = false
    var searchBarArray = [Item]()
    
    @IBOutlet weak var boughttemsLbl1: UILabel!
    @IBOutlet weak var boughitemsLbl2: UILabel!
    @IBOutlet weak var boughtListPriceLbl1: UILabel!
    @IBOutlet weak var boughtListPriceLbl2: UILabel!
    @IBOutlet weak var finishListBtn: UIBarButtonItem!
    
    @IBOutlet weak var weeklyShoppingListTableView: UITableView!
    
    //scroolview, lbls and txtField for editing price and quantity information
    @IBOutlet weak var editingInforationScrolView: UIScrollView!
    @IBOutlet weak var titleInformation: UILabel!
    @IBOutlet weak var howItemIsSoldInformation: UILabel!
    @IBOutlet weak var descriptionInformation: UILabel!
    @IBOutlet weak var newInformationTxt: UITextField!
    
    //decimal keyboard toolbar
    var decimalKeyToolbar : UIToolbar?
    var keyboardHeight = CGFloat()
    
    //updating item quantity or price
    private var quantity : Bool = false
    private var price : Bool = false
    private var cellPath = IndexPath()
    //MARK:- VIEW LOADING
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        if objCtrl.hasItemsToBuy(lookInArray: marketsArray) {
            objCtrl.fillMIndex(withArray: marketsArray)
            updateLables()
            registerToKeyboardNotifications(registerTrueAndUnregisterFalse: true)
            enableUserInterface(value: true)
        } else {
            enableUserInterface(value: false)
            print("ERROR | WeeklyShoppingListVC || viewWillAppear || array is empty") }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFunctions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        saveData()
        registerToKeyboardNotifications(registerTrueAndUnregisterFalse: false)
    }
}
//MARK:- TABLE VIEW
extension WeeklyShoppingList{
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchingOn ? 1 : objCtrl.returnNumberOfSections(inMarketsArray: marketsArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingOn ? searchBarArray.count : objCtrl.returnNumberOfRows(inMarketsArray: marketsArray, inSection: section)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !searchingOn {
            if objCtrl.returnMarketIndex(inSection: section).0 {
                let index = objCtrl.returnMarketIndex(inSection: section).1
                if objCtrl.checkMarketHasItemsInHeaders(inMarketsArray: marketsArray, inSection: index){
                    let mCell = tableView.dequeueReusableCell(withIdentifier: "marketHeaderCell") as! MarketHeaderCell
                    mCell.tappedBtn.addTarget(self, action: #selector(expandCollapseHeader(sender:)), for: .touchUpInside)
                    return objCtrl.returnCell(withCell: mCell, cellType: .market, itemInArray: marketsArray, inIndexPath: IndexPath(row: 0, section: index), itemIndexPath: IndexPath()) as! MarketHeaderCell
                }       }       }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !searchingOn {
            if objCtrl.returnMarketIndex(inSection: section).0 {
                let index = objCtrl.returnMarketIndex(inSection: section).1
                if objCtrl.checkMarketHasItemsInHeaders(inMarketsArray: marketsArray, inSection: index){
                    return objCtrl.returnHeighForHeader(inSection: index, usingMarketsArray: marketsArray)
                }       }       }
        return CGFloat(0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchingOn {
            let iCell = tableView.dequeueReusableCell(withIdentifier: "cellForItemInTableViews", for: indexPath) as! CellForItemInTableViews
            iCell.namLbl.text = searchBarArray[indexPath.row].name!
            return iCell
        } else {
            if objCtrl.returnMarketIndex(inSection: indexPath.section).0 {
                let index = objCtrl.returnMarketIndex(inSection: indexPath.section).1
                if !objCtrl.checkMarketHasItemsInHeaders(inMarketsArray: marketsArray, inSection: index){
                    let cellOne = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath)
                    return cellOne
                } else {
                    let rowAndSection = objCtrl.returnItemObjIndexPath(inMarketsArray: marketsArray, inSection: index, inRow: indexPath.row)
                    if marketsArray[index].getSector()[rowAndSection.section].isOpened(){
                        if rowAndSection.row < 0 {
                            let sCell = tableView.dequeueReusableCell(withIdentifier: "cellForSectorInTableViews", for: indexPath) as! CellForSectorInTableViews
                            return objCtrl.returnCell(withCell: sCell, cellType: .sector, itemInArray: marketsArray, inIndexPath: IndexPath(row: indexPath.row, section: index), itemIndexPath: rowAndSection) as! CellForSectorInTableViews
                        } else {
                            let iCell = tableView.dequeueReusableCell(withIdentifier: "cellForItemInTableViews", for: indexPath) as! CellForItemInTableViews
                            iCell.checkMarkBtn.addTarget(self, action: #selector(setItemAsPurchased(sender:)), for: .touchUpInside)
                            iCell.imageBtn.addTarget(self, action: #selector(getItemImage(sender:)), for: .touchUpInside)
                            iCell.notesBtn.addTarget(self, action: #selector(getItemNotes(sender:)), for: .touchUpInside)
                            return objCtrl.returnCell(withCell: iCell, cellType: .item, itemInArray: marketsArray, inIndexPath: IndexPath(row: indexPath.row, section: index), itemIndexPath: rowAndSection) as! CellForItemInTableViews
                        }
                    } else {
                        if rowAndSection.row < 0 {
                            let sCell = tableView.dequeueReusableCell(withIdentifier: "cellForSectorInTableViews", for: indexPath) as! CellForSectorInTableViews
                            return objCtrl.returnCell(withCell: sCell, cellType: .sector, itemInArray: marketsArray, inIndexPath: IndexPath(row: indexPath.row, section: index), itemIndexPath: rowAndSection) as! CellForSectorInTableViews
                        } else {
                            return UITableViewCell()
                        }     }     }     }
        }
        let cellOne = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath)
        return cellOne
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchingOn {
            return CGFloat(89)
        }
        if objCtrl.returnMarketIndex(inSection: indexPath.section).0 {
            let index = objCtrl.returnMarketIndex(inSection: indexPath.section).1
            if objCtrl.checkMarketHasItemsInHeaders(inMarketsArray: marketsArray, inSection: index) {
                return objCtrl.returnHeightForCell(atIndexPath: IndexPath(row: indexPath.row, section: index), usingMarketsArray: marketsArray)
            }
        }
        return CGFloat(tableView.bounds.height)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchingOn {

        } else {
            if objCtrl.returnMarketIndex(inSection: indexPath.section).0 {
                let index = objCtrl.returnMarketIndex(inSection: indexPath.section).1
                let rowAndSection = objCtrl.returnItemObjIndexPath(inMarketsArray: marketsArray, inSection: index, inRow: indexPath.row)
                if rowAndSection.row < 0 {
                    marketsArray[index].getSector()[rowAndSection.section].isOpened() ? marketsArray[index].getSector()[rowAndSection.section].closeSubcell() : marketsArray[index].getSector()[rowAndSection.section].openedSubcell()
                    weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
                } else if !objCtrl.checkMarketHasItemsInHeaders(inMarketsArray: marketsArray, inSection: index){
                    
                } else {
                    cellPath = IndexPath(row: indexPath.row, section: index)
                    present(didSelectRowAtAlertsWSLVC(withIndexPath: cellPath), animated: true)
                }
            }
        }
        weeklyShoppingListTableView.reloadData()
    }
    
}
//MARK:- TARGETS
extension WeeklyShoppingList{
    @objc func expandCollapseHeader(sender: UIButton) {
        marketsArray[sender.tag].isOpened() ?  marketsArray[sender.tag].closeSubcell() : marketsArray[sender.tag].openSubcell()
        weeklyShoppingListTableView.reloadData()
    }
    //set items as purchased upon touching it
    @objc func setItemAsPurchased(sender: UIButton) {
        let item = objCtrl.getItemObj(usingTag: sender.tag, inMarketsArray: marketsArray, dataControler: dataController)
        item.getIsAlreadyPurchased() ? item.setIsAlreadyPurchased(value: false) : item.setIsAlreadyPurchased(value: true)
        saveData()
        updateLables()
        weeklyShoppingListTableView.reloadData()
    }
    //get items image upon touching it
    @objc func getItemImage(sender: UIButton) {
        chosenImageForItemImageExpandedVC = objCtrl.getItemImage(usingTag: sender.tag, inMarketsArray: marketsArray)
        goToItemImageExpandedVC()
    }
    //get notes about the item
    @objc func getItemNotes(sender: UIButton){
        present(itemInfoAlertWSLVC(withSenderTag: sender.tag), animated: true, completion: nil)
    }
}
//MARK:- DATA MANIPULATION
extension WeeklyShoppingList{
    func removeItemFromListWhenDesctructiveButtonInAlertIsTouched(selectedCell cell: Item){
        cell.setIsAlreadyPurchased(value: true)
        cell.setAddToBuyList(changeBoolValue: false)
        saveData()
        updateLables()
    }
}
//MARK:- KEYBOARD
extension WeeklyShoppingList{
    //keyboard notification show
    @objc func keyboardWillShow(notification: Notification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        self.keyboardHeight = keyboardSize!.height*(keyboardSize!.height/self.view.frame.height)
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        self.editingInforationScrolView.contentInset = contentInsets
    }
    // keyboard notification: setting scroll view offset
    @objc func keyboadFrame(notification: Notification) {
        DispatchQueue.main.async {
            if self.newInformationTxt.isFirstResponder {
                self.editingInforationScrolView.setContentOffset(CGPoint(x: 0, y: self.keyboardHeight), animated: true)
            }       }
    }
    //keyboard notification will hide
    @objc func keyboardWillDisappear(notification: Notification) {
        print("keyboard will hide")
    }
    func registerToKeyboardNotifications(registerTrueAndUnregisterFalse value : Bool){
        if value {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboadFrame(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        } else if !value {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    //tap gesture for view
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFieldsResignFirstResponder()
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
//MARK:- TEXTFIELDS
extension WeeklyShoppingList{
    //textfield delegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
    }
    //textfield delegate method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == newInformationTxt {
            if decimalKeyToolbar == nil {
                decimalKeyToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            }
            decimalKeyToolbar?.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtn))]
            textField.inputAccessoryView = decimalKeyToolbar
            return true
        }
        return false
    }
    //textfield delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldsResignFirstResponder()
        return true
    }
    //usetting textfield as firstResponder and hiding scrollview
    func textFieldsResignFirstResponder(){
        editingInforationScrolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        editingInforationScrolView.isScrollEnabled = false
        newInformationTxt.resignFirstResponder()
    }
    //done button for bar in the keyboard
    @objc func doneBtn() {
        textFieldsResignFirstResponder()
    }
}
//MARK:- ALERTS
extension WeeklyShoppingList{
    func didSelectRowAtAlertsWSLVC(withIndexPath indexPath: IndexPath)->UIAlertController {
        let item = objCtrl.getItemObj(indexPath: indexPath, inMarketsArray: marketsArray, dataControler: dataController)
        uObjCtrl.registerDecimalFunctionInTextFieldIfItemSoldByInKiloOrLiter(withUnitMeasureRawValue: item.getFormOfSale().getUnitMeasure())
        let alert = UIAlertController()
        let editPrice = UIAlertAction(title: "Editar Preço", style: .default) { (action) in
            self.price = true
            self.settingUpLblForEditingItemInformation(withTitle: "Preço", isItPrice: true, withCell: item)
            self.realTiemTextFieldUpdate(registerTrueAndUnregisterFalse: true, isItPrice: true, isItKiloLiter: false)
            self.weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
        }
        let editQuantity = UIAlertAction(title: "Editar Quantidade", style: .default) { (action) in
            self.quantity = true
            if self.uObjCtrl.isItemSoldByKiloOrLiter() {
                self.realTiemTextFieldUpdate(registerTrueAndUnregisterFalse: true, isItPrice: false, isItKiloLiter: true)
            } else {
                self.realTiemTextFieldUpdate(registerTrueAndUnregisterFalse: true, isItPrice: false, isItKiloLiter: false)
            }
            self.settingUpLblForEditingItemInformation(withTitle: "Quantidade", isItPrice: false, withCell: item)
            self.weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
        }
        let removeItem = UIAlertAction(title: "Remover Item", style: .destructive) { (action) in
            self.removeItemFromListWhenDesctructiveButtonInAlertIsTouched(selectedCell: item)
            self.weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
            self.objCtrl.fillMIndex(withArray: self.marketsArray)
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            self.weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
        }
        alert.addAction(editPrice)
        alert.addAction(editQuantity)
        alert.addAction(cancel)
        alert.addAction(removeItem)
        return alert
    }
    func itemInfoAlertWSLVC(withSenderTag tag: Int) -> UIAlertController {
        let cell = objCtrl.getItemObj(usingTag: tag, inMarketsArray: marketsArray, dataControler: dataController)
        let alertMsg = cell.getItemInformation().hasValue ? "\n\(cell.getItemInformation().value.uppercased())" : ""
        let alert = UIAlertController( title: "Obsevações:", message: alertMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        return alert
    }
}
//MARK:- BUTTONS
extension WeeklyShoppingList{
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !newInformationTxt.text!.isEmpty && uObjCtrl.isThereText(inTextField: newInformationTxt.text).0 {
            let item = objCtrl.getItemObj(indexPath: cellPath, inMarketsArray: marketsArray, dataControler: dataController)
            if price {
                item.getFormOfSale().setItemPriceStringToDouble(howMuchIsIt: newInformationTxt.text!)
            } else if quantity {
                uObjCtrl.isItemSoldByKiloOrLiter() ?
                    item.getFormOfSale().setQuantityStringToDouble(howManyUnits: newInformationTxt.text!, kiloOrLiter: true) : item.getFormOfSale().setQuantityStringToDouble(howManyUnits: newInformationTxt.text!, kiloOrLiter: false)
            } else {
                print("ERROR || EDITING PRICE/QUANTITY INFORMATION IN WEEKLYSHOPPINGLISTVC || STRING IS EMPTY/ZERO")
            }
        }
        updateLables()
        scrollViewHideAndUnhide(trueToHideFalseToUnhide: true)
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        scrollViewHideAndUnhide(trueToHideFalseToUnhide: true)
    }
    //Conlcude list buttonPressed
    @IBAction func finishListButtonPressed(_ sender: Any) {
        if let list = objCtrl.finishLists(withMarketsArray: marketsArray, withDataController: dataController, withFinishedListsArray: purchasedItemsArrayWSLVC){
            purchasedItemsArrayWSLVC.append(list)
            saveData()
        }
//        delegate?.callDelegateWSL()
        navigationController?.popViewController(animated: true)
    }
}
//MARK:- LAYOUT
extension WeeklyShoppingList{
    func updateLables(){
        boughitemsLbl2.text = "\(objCtrl.totalAmountAndQttyBought(withArray: marketsArray).qtty) item(s)"
        boughtListPriceLbl2.text = objCtrl.totalAmountAndQttyBought(withArray: marketsArray).amount
        weeklyShoppingListTableView.reloadData()
    }
    func enableUserInterface(value: Bool){
        boughttemsLbl1.isHidden = !value
        boughitemsLbl2.isHidden = !value
        boughtListPriceLbl1.isHidden = !value
        boughtListPriceLbl2.isHidden = !value
        finishListBtn.isEnabled = value
        searchBar.isHidden = !value
    }
    func enableUserInterfaceSearchBar(value: Bool){
        boughttemsLbl1.isHidden = !value
        boughitemsLbl2.isHidden = !value
        boughtListPriceLbl1.isHidden = !value
        boughtListPriceLbl2.isHidden = !value
        finishListBtn.isEnabled = value
    }
    func scrollViewHideAndUnhide(trueToHideFalseToUnhide value: Bool){
        if value {
            editingInforationScrolView.isHidden = value
            editingInforationScrolView.isScrollEnabled = !value
            textFieldsResignFirstResponder()
            newInformationTxt.text = ""
            price = false
            quantity = false
            realTiemTextFieldUpdate(registerTrueAndUnregisterFalse: false, isItPrice: false, isItKiloLiter: false)
        } else {
            editingInforationScrolView.isHidden = value
            enableScrolInScrollView()
        }
    }
    //enabling scrol in scrollview
    func enableScrolInScrollView(){
        editingInforationScrolView.isScrollEnabled = true
    }
    //changing text insie lables for editing price and quantity of item
    func settingUpLblForEditingItemInformation(withTitle txt: String, isItPrice value: Bool, withCell cell: Item) {
        scrollViewHideAndUnhide(trueToHideFalseToUnhide: false)
        titleInformation.text = txt
        howItemIsSoldInformation.text = objCtrl.qttyAndPriceStandardTextForAlerts(selectedCell: cell)[0]
        if value {
            let measure = cell.getFormOfSale().getUnitMeasureNoRawValue()
            descriptionInformation.text = measure == UnitMeasure.averageWeight ? "Cada unidade pesa \(Int(cell.getFormOfSale().getStandarWeightValue()*Double(cell.getFormOfSale().getDivisor()[.averageWeight]!)))\ngrama(s)/ml(s), mas o preço\ndeverá ser informado em Kilo/Litro" : "Informe novo preço\npara \(Int(cell.getFormOfSale().getStandarWeightValue())) \(uObjCtrl.returnUnitMeasureInString(forNumber: cell.getFormOfSale().getUnitMeasure()))"
        } else {
            descriptionInformation.text = objCtrl.qttyAndPriceStandardTextForAlerts(selectedCell: cell)[1]
        }
    }
    //setting method as target for textfield
    @objc func realTimePriceTextFieldUpdateTripleDigits(){
        newInformationTxt.text = (Double(newInformationTxt.text!.numbersOnly.integerValue)/1000).threeDigits
    }
    @objc func realTimePriceTextFieldUpdateDoubleDigits(){
        newInformationTxt.text = (Double(newInformationTxt.text!.numbersOnly.integerValue)/100).twoDigits
    }
}
//MARK:-REGISTRATION
extension WeeklyShoppingList{
    //setting kilo decimal or other form of sales units in the textfield
    func realTiemTextFieldUpdate(registerTrueAndUnregisterFalse value : Bool, isItPrice price: Bool, isItKiloLiter tripleDigits: Bool) {
        if value {
            if price {
                newInformationTxt.text = 0.twoDigits
                newInformationTxt.addTarget(self, action: #selector(realTimePriceTextFieldUpdateDoubleDigits), for: UIControl.Event.editingChanged)
            } else if tripleDigits {
                newInformationTxt.text = 0.threeDigits
                newInformationTxt.addTarget(self, action: #selector(realTimePriceTextFieldUpdateTripleDigits), for: UIControl.Event.editingChanged)
            } else {
                newInformationTxt.text = ""
            }
        } else if !value {
            newInformationTxt.text = ""
            newInformationTxt.removeTarget(self, action: #selector(realTimePriceTextFieldUpdateTripleDigits), for: UIControl.Event.editingChanged)
            newInformationTxt.removeTarget(self, action: #selector(realTimePriceTextFieldUpdateTripleDigits), for: UIControl.Event.editingChanged)
        }
    }
}
//MARK:- SEGUEWAYS
extension WeeklyShoppingList{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemImageExpandedVC = segue.destination as! ItemImageExpandedVC
        itemImageExpandedVC.selectedCellImage = chosenImageForItemImageExpandedVC
    }
    func goToItemImageExpandedVC() {
        performSegue(withIdentifier: "goToItemImageExpandedFromWeeklyShoppingListVC", sender: self)
    }
}
//MARK:- DELEGATE
extension WeeklyShoppingList {
    
}
//MARK:- LOADING/UNLOADING FUNCTIONS
extension WeeklyShoppingList{
    func initialFunctions(){
        weeklyShoppingListTableView.delegate = self
        weeklyShoppingListTableView.dataSource = self
        
        newInformationTxt.delegate = self
        searchBar.delegate = self
        
        self.editingInforationScrolView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
        
        weeklyShoppingListTableView.register(UINib(nibName: "MarketHeaderCell", bundle: nil), forCellReuseIdentifier: "marketHeaderCell")
        weeklyShoppingListTableView.register(UINib(nibName: "CellForSectorInTableViews", bundle: nil), forCellReuseIdentifier: "cellForSectorInTableViews")
        weeklyShoppingListTableView.register(UINib(nibName: "CellForItemInTableViews", bundle: nil), forCellReuseIdentifier: "cellForItemInTableViews")
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor.black
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
        let cancel = searchBar.value(forKey: "cancelButton") as! UIButton
        cancel.tintColor = .white
    }
}
//MARK:- COREDATA
extension WeeklyShoppingList{
    func saveData(){
        do {
            try dataController.viewContext.save()
            print("saved")
        } catch {   print("notSaved")   }
    }
    func loadData(){
        let fetchRequest = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderingID", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            marketsArray = results     }
        let fetchRequest1 = NSFetchRequest<Item>(entityName: "Item")
        fetchRequest1.predicate = NSPredicate(format: "addToList == YES")
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest1){
            searchBarArray = results     }
    }
    func delete(item: Item){
        dataController.viewContext.delete(item)
        saveData()
        loadData()
    }
}
//MARK:- SEARCH BAR
extension WeeklyShoppingList: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
        if searchText.isEmpty {
            weeklyShoppingListTableView.reloadData()
            return
        } else {
            let myFilter = searchText.lowercased()
            searchBarArray = searchBarArray.filter({ $0.name?.lowercased().range(of: myFilter, options: [.diacriticInsensitive]) != nil})
        }
        weeklyShoppingListTableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        enableUserInterfaceSearchBar(value: false)
        searchingOn = true
        weeklyShoppingListTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        enableUserInterfaceSearchBar(value: true)
        searchingOn = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        loadData()
        weeklyShoppingListTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

