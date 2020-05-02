//
//  ItemsMercadoVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 15/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit
import CoreData

class ItemsMercadoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var fullArray : [Market]!
    var itemsOnlyArray = [Market]()
    var editingArray : [Sector]!
    var objCtrl = itemsMercadoObjectController()
    var uObjCtrl = UniversalObjectController()
    var dataController : DataController!
    var itemImageForItemImageExpandedVC = UIImage()
    @IBOutlet weak var addNewItemBtn: UIBarButtonItem!
    
    @IBOutlet weak var itemsMercadoTableView: UITableView!
    @IBOutlet weak var searchBarInTouched: UISearchBar!
    var searchingOn : Bool = false
    var searchBarArray = [Item]()
    
    //adding item to weekly shopping list
    @IBOutlet weak var qttyInfoScrollView: UIScrollView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityDetailsLabel: UILabel!
    @IBOutlet weak var quantityValueTextField: UITextField!
    
    //decimal keyboard toolbar
    var decimalKeyTooblar : UIToolbar?
    var keyboardHeight = CGFloat()
    
    //variables for single item VC
    var itemObj : Item?
    
}
//MARK:- VC INATE FUNCTIONS
extension ItemsMercadoVC{
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        if let ary = objCtrl.getArrayWithItemsOnly(inMarketsArray: fullArray){
            itemsOnlyArray = ary
            reloadData()
        } else { enableSearchBar() }
        rightNavigationBarButton()
        itemsMercadoTableView.setEditing(false, animated: true)
        itemsMercadoTableView.reloadData()
    }
    override func viewDidLoad() {
        initialFunctions()
        print(itemsMercadoTableView.isEditing)
    }
    override func viewWillDisappear(_ animated: Bool) {
        finalFunctions()
        itemsOnlyArray = [Market]()
        fullArray = [Market]()
        searchBarArray = [Item]()
        editingArray = [Sector]()
        itemsMercadoTableView.setEditing(false, animated: true)
    }
}
//MARK:- TABLEVIEW METHODS
extension ItemsMercadoVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.isEditing == true {
            return editingArray.count }
        return searchingOn ? 1 : objCtrl.getSectionsForTableView(inMarketsArray: itemsOnlyArray)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEditing == true { return editingArray[section].getItem().count }
        return searchingOn ? searchBarArray.count : objCtrl.getRowsForTableView(inMarketsArray: itemsOnlyArray, inSection: section)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.isEditing == true {
            let eHeader = tableView.dequeueReusableCell(withIdentifier: "editingSector")
            eHeader?.textLabel!.text = "Setor: \(editingArray[section].getName())"
            eHeader?.detailTextLabel!.text = "No \(editingArray[section].market!.getName())"
            return eHeader
        }
        if !searchingOn {
            if objCtrl.checkMarketHasItemsInHeaders(inArray: itemsOnlyArray, inSection: section) {
                let mCell = tableView.dequeueReusableCell(withIdentifier: "marketHeaderCell") as! MarketHeaderCell
                mCell.tappedBtn.addTarget(self, action: #selector(expandCollapseHeader(sender:)), for: .touchUpInside)
                return objCtrl.returnCell(withCell: mCell, withCellType: .market, withArray: itemsOnlyArray, inMarket: section) as! MarketHeaderCell
            }   }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.isEditing == true { return CGFloat(44)}
        if !searchingOn {
            if objCtrl.checkMarketHasItemsInHeaders(inArray: itemsOnlyArray, inSection: section){
                return objCtrl.returnHeighForHeader(inSection: section, usingMarketsArray: itemsOnlyArray)
            }   }
        return CGFloat(0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
        if tableView.isEditing == true {
            let eCell = tableView.dequeueReusableCell(withIdentifier: "editingCell", for: indexPath)
            eCell.textLabel!.text = editingArray[indexPath.section].getItem()[indexPath.row].getName()
            return eCell
        }
        if searchingOn {
            let iCell = tableView.dequeueReusableCell(withIdentifier: "cellForItemInTableViews", for: indexPath) as! CellForItemInTableViews
            iCell.checkMarkBtn.addTarget(self, action: #selector(addToShoppingList(sender:)), for: .touchUpInside)
            iCell.imageBtn.addTarget(self, action: #selector(getItemImage(sender:)), for: .touchUpInside)
            iCell.notesBtn.addTarget(self, action: #selector(getItemNotesItemsVC(sender:)), for: .touchUpInside)
            return objCtrl.returnCell(withCell: iCell, withCellType: .searchBar, searchBarArray: searchBarArray, itemLocator: indexPath.row) as! CellForItemInTableViews
        } else {
            if !objCtrl.checkMarketHasItemsInHeaders(inArray: itemsOnlyArray, inSection: indexPath.section){
                tableView.separatorStyle = .none
                tableView.isScrollEnabled = false
                tableView.allowsSelection = false
                let cellOne = tableView.dequeueReusableCell(withIdentifier: "cellOne", for: indexPath)
                return cellOne
            } else {
                tableView.separatorStyle = .singleLine
                let rowAndSection = uObjCtrl.sectionSubsectionForItemInTableView(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: itemsOnlyArray)
                if itemsOnlyArray[indexPath.section].getSector()[rowAndSection.section].isOpened(){
                    if rowAndSection.row < 0 {
                        let sCell = tableView.dequeueReusableCell(withIdentifier: "cellForSectorInTableViews", for: indexPath) as! CellForSectorInTableViews
                        return objCtrl.returnCell(withCell: sCell, withCellType: .sector, withArray: itemsOnlyArray, inMarket: indexPath.section, inSector: rowAndSection.section) as! CellForSectorInTableViews
                    } else {
                        let iCell = tableView.dequeueReusableCell(withIdentifier: "cellForItemInTableViews", for: indexPath) as! CellForItemInTableViews
                        iCell.checkMarkBtn.addTarget(self, action: #selector(addToShoppingList(sender:)), for: .touchUpInside)
                        iCell.imageBtn.addTarget(self, action: #selector(getItemImage(sender:)), for: .touchUpInside)
                        iCell.notesBtn.addTarget(self, action: #selector(getItemNotesItemsVC(sender:)), for: .touchUpInside)
                        return objCtrl.returnCell(withCell: iCell, withCellType: .item, withArray: itemsOnlyArray, inMarket: indexPath.section, inSector: rowAndSection.section, itemLocator: rowAndSection.row, rowForCellTag: indexPath.row) as! CellForItemInTableViews  }
                } else {
                    if rowAndSection.row < 0 {
                        let sCell = tableView.dequeueReusableCell(withIdentifier: "cellForSectorInTableViews", for: indexPath) as! CellForSectorInTableViews
                        return objCtrl.returnCell(withCell: sCell, withCellType: .sector, withArray: itemsOnlyArray, inMarket: indexPath.section, inSector: rowAndSection.section) as! CellForSectorInTableViews
                    } else { return UITableViewCell()   }   }   }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEditing == true { return CGFloat(45) }
        if searchingOn {
            return CGFloat(89)
        }
        if objCtrl.checkMarketHasItemsInHeaders(inArray: itemsOnlyArray, inSection: indexPath.section){
            return objCtrl.returnHeightForCell(atIndexPath: indexPath, usingMarketsArray: itemsOnlyArray)   }
        return CGFloat((tableView.bounds.height-44))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchingOn {
            endSearchMode()
            itemObj = searchBarArray[indexPath.row]
            itemsMercadoTableView.deselectRow(at: indexPath, animated: true)
            goToSingleItemVC()
        } else if itemsOnlyArray.count > 0 {
            let rowAndSection = uObjCtrl.sectionSubsectionForItemInTableView(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: itemsOnlyArray)
            if rowAndSection.row < 0 {
                itemsOnlyArray[indexPath.section].getSector()[rowAndSection.section].isOpened() ? itemsOnlyArray[indexPath.section].getSector()[rowAndSection.section].closeSubcell() : itemsOnlyArray[indexPath.section].getSector()[rowAndSection.section].openedSubcell()
                itemsMercadoTableView.deselectRow(at: indexPath, animated: true)
            } else {
                itemObj = itemsOnlyArray[indexPath.section].getSector()[rowAndSection.section].getItem()[rowAndSection.row]
                itemsMercadoTableView.deselectRow(at: indexPath, animated: true)
                goToSingleItemVC()
            }
            itemsMercadoTableView.reloadData()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
//MARK:- CORE DATA
extension ItemsMercadoVC{
    func saveData(){
        do {
            try dataController.viewContext.save()
            print("saved")
        } catch { print("notSaved")     }
    }
    func loadData(){
        let fetchRequest = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderingID", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "hasItems == YES")
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            fullArray = results     }
        let fetchRequest1 = NSFetchRequest<Item>(entityName: "Item")
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest1){
            searchBarArray = results     }
        loadEditingArray()
    }
    func delete(item: Item){
        dataController.viewContext.delete(item)
        saveData()
        loadData()
    }
}
//MARK:- TARGETS
extension ItemsMercadoVC {
    //expand UIImage to expandedImageView
    @objc func expandCollapseHeader(sender: UIButton) {
        itemsOnlyArray[sender.tag].isOpened() ?  itemsOnlyArray[sender.tag].closeSubcell() : itemsOnlyArray[sender.tag].openSubcell()
        itemsMercadoTableView.reloadData()
    }
    @objc func getItemImage(sender: UIImageView) {
        endSearchMode()
        itemImageForItemImageExpandedVC = searchingOn ? searchBarArray[sender.tag].getImage() : objCtrl.getItemImage(usingTag: sender.tag, inMarketsArray: itemsOnlyArray)
        goToItemImageExpandedVC()
    }
    //tap gesture for Item CELL
    @objc func addToShoppingList(sender: UIButton) {
        uObjCtrl.setTagForObtainingItemObj(usingBtnTag: sender.tag)
        let item = searchingOn ? searchBarArray[sender.tag] : objCtrl.getItemObject(usingTag: sender.tag, inMarketsArray: itemsOnlyArray)
        if item.getAddToBuyList() {
            item.setAddToBuyList(changeBoolValue: false)
            item.setIsAlreadyPurchased(value: false)
            saveData()
            itemsMercadoTableView.reloadData()
        } else {
            uObjCtrl.registerDecimalFunctionInTextFieldIfItemSoldByInKiloOrLiter(withUnitMeasureRawValue: item.getFormOfSale().getUnitMeasure())
            priceLabel.text = objCtrl.getTextForPopUpToAddItemToShoppingList(item: item)[0]
            quantityDetailsLabel.text = objCtrl.getTextForPopUpToAddItemToShoppingList(item: item)[1]
            showAlertAddToShoppingList()
        }
    }
    //get item notes
    @objc func getItemNotesItemsVC(sender: UIButton){
        present(itemInfoAlertIMVC(withSenderTag: sender.tag), animated: true, completion: nil)
        itemsMercadoTableView.reloadData()
    }
    @objc func reorderSectors(sender: UIBarButtonItem){
        if itemsMercadoTableView.isEditing {
            rightNavigationBarButton()
            itemsMercadoTableView.setEditing(false, animated: true)
            editingArray = [Sector]()
            if let ary = objCtrl.getArrayWithItemsOnly(inMarketsArray: fullArray){
                itemsOnlyArray = ary
                reloadData()
            }
        } else {
            rightNavigationBarButton(text: "Concluir")
            loadEditingArray()
            itemsMercadoTableView.setEditing(true, animated: true)
        }
        itemsMercadoTableView.reloadData()
    }
}
//MARK:- TEXTFIELDS
extension ItemsMercadoVC {
    //textfield delegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        enableScrolInScrollView()
    }
    //textfield delegate method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        }
        if textField == quantityValueTextField {
            
            if decimalKeyTooblar == nil {
                decimalKeyTooblar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            }
            decimalKeyTooblar!.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtn))]
            textField.inputAccessoryView = decimalKeyTooblar
            if uObjCtrl.isItemSoldByKiloOrLiter() {
                setTextFieldForDecimalIfItemSoldByKiloOrLiter(setTrueUnsetFalse: true)
            }
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
        qttyInfoScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        qttyInfoScrollView.isScrollEnabled = false
        quantityValueTextField.resignFirstResponder()
    }
}
//MARK:- BUTTONS
extension ItemsMercadoVC{
    //button to add quantity and item to weekly shopping list
    @IBAction func addItemToWeeklyShoppingListPressed(_ sender: Any) {
        let tag = uObjCtrl.getTagForObtainingItemObj()
        let item = searchingOn ? searchBarArray[tag] : objCtrl.getItemObject(usingTag: tag, inMarketsArray: itemsOnlyArray)
        if !quantityValueTextField.text!.isEmpty && uObjCtrl.isThereNumber(inTextField: quantityValueTextField.text).0 {
            if uObjCtrl.isItemSoldByKiloOrLiter() {
                item.getFormOfSale().setQuantityStringToDouble(howManyUnits: quantityValueTextField.text!, kiloOrLiter: true)
            } else {
                item.getFormOfSale().setQuantityStringToDouble(howManyUnits: quantityValueTextField.text!, kiloOrLiter: false)
            }
            item.setAddToBuyList(changeBoolValue: true)
            item.setIsAlreadyPurchased(value: false)
            saveData()
        } else {
            print("ERROR - NOTHING ADDED TO WEEKLY SHOPPING LIST")
        }
        dismissQttyInfoScrollView()
    }
    //button to cancel quantity and item to weekly shopping list
    @IBAction func cancelAddItemToWeeklyListActionPressed(_ sender: Any) {
        dismissQttyInfoScrollView()
    }
}
//MARK:- KEYBOARD
extension ItemsMercadoVC{
    //keyboard notification show
    @objc func keyboardWillShow(notification: Notification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        self.keyboardHeight = keyboardSize!.height*(keyboardSize!.height/self.view.frame.height)
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        self.qttyInfoScrollView.contentInset = contentInsets
    }
    // keyboard notification: setting scroll view offset
    @objc func keyboadFrame(notification: Notification) {
        DispatchQueue.main.async {
            if self.quantityValueTextField.isFirstResponder {
                self.qttyInfoScrollView.setContentOffset(CGPoint(x: 0, y: self.keyboardHeight), animated: true)
            }
        }
    }
    //keyboard notification will hide
    @objc func keyboardWillDisappear(notification: Notification) {
        print("keyboard will hide")
    }
    //tap gesture for view
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFieldsResignFirstResponder()
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
}
//MARK:- ALERTS
extension ItemsMercadoVC{
    func itemInfoAlertIMVC(withSenderTag tag: Int) -> UIAlertController {
        let item = searchingOn ? searchBarArray[tag] : objCtrl.getItemObject(usingTag: tag, inMarketsArray: itemsOnlyArray)
        var textField = UITextField()
        let alert = UIAlertController(title: "Item Information", message: "\nOBSERVACOES:\n\(item.getItemInformation().value)", preferredStyle: .alert)
        let save = UIAlertAction(title: "Salvar", style: .default) { (action) in
            !textField.text!.isEmpty ? item.setItemInformation(information: textField.text!) : nil
            self.saveData()
            self.reloadData()
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(save)
        
        if item.getItemInformation().hasValue {
            let delete = UIAlertAction(title: "Deletar observação", style: .destructive) { (action) in
                item.setItemInformation(information: nil)
                self.saveData()
                self.reloadData()
            }
            alert.addAction(delete)
        }
        alert.addTextField { (field) in
            field.placeholder = "Alterar: escreva e salve"
            textField = field
        }
        return alert
    }
}
//MARK:- LAYOUT
extension ItemsMercadoVC{
    //setting kilo decimal or other form of sales units in the textfield
    func setTextFieldForDecimalIfItemSoldByKiloOrLiter(setTrueUnsetFalse value : Bool = false) {
        if value {
            quantityValueTextField.text = 0.threeDigits
            quantityValueTextField.addTarget(self, action: #selector(realTimePriceTextFieldUpdate), for: UIControl.Event.editingChanged)
        } else {
            quantityValueTextField.text = ""
            quantityValueTextField.removeTarget(self, action: #selector(realTimePriceTextFieldUpdate), for: UIControl.Event.editingChanged)
        }
    }
    //showing view for addin quatity and item to weekly shopping list
    func showAlertAddToShoppingList() {
        qttyInfoScrollView.isHidden = false
        enableScrolInScrollView()
        quantityValueTextField.becomeFirstResponder()
    }
    //enable scroll in scrollview
    func enableScrolInScrollView(){
        qttyInfoScrollView.isScrollEnabled = true
    }
    //dismissing view for addin quatity and item to weekly shopping list
    func dismissQttyInfoScrollView() {
        setTextFieldForDecimalIfItemSoldByKiloOrLiter()
        textFieldsResignFirstResponder()
        qttyInfoScrollView.isHidden = true
        itemsMercadoTableView.reloadData()
    }
    //setting method as target for textfield
    @objc func realTimePriceTextFieldUpdate(){
        quantityValueTextField.text = (Double(quantityValueTextField.text!.numbersOnly.integerValue)/1000).threeDigits
    }
    //done button for bar in the keyboard
    @objc func doneBtn() {
        textFieldsResignFirstResponder()
    }
    func hideUserInterfaceInSearchBar(value: Bool){
        addNewItemBtn.isEnabled = !value
    }
    func rightNavigationBarButton(value : Bool = true, text : String = "Editar"){
        if objCtrl.aryHasTwoOrMoreItems(withAry: itemsOnlyArray) {
            if value {
                self.navigationItem.rightBarButtonItems?.removeAll()
                let button = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(reorderSectors(sender:)))
                self.navigationItem.rightBarButtonItem  = button
            } else {
                if self.navigationItem.rightBarButtonItems?.count != 0 {
                    self.navigationItem.rightBarButtonItems?.remove(at: 0)
                }
            }
        } else {
            if self.navigationItem.rightBarButtonItems?.count != 0 {
                self.navigationItem.rightBarButtonItems?.remove(at: 0)
            }
        }
    }
    func enableSearchBar(){
        searchBarInTouched.isHidden = itemsOnlyArray.count > 0 ? false : true
    }
}
//MARK:- DATA HANDLING
extension ItemsMercadoVC{
    func reloadData(){
        itemsMercadoTableView.reloadData()
        enableSearchBar()
        DispatchQueue.main.async {
            self.registerToKeyboardNotifications(registerTrueAndUnregisterFalse: true)
        }
    }
    func reorderIDItems(withItemArray ary : [Item]){
        for i in 0..<ary.count {
            if ary[i].getOrderingID() != i {
                ary[i].setOredringId(setAt: i)
            }
        }
    }
    func loadEditingArray(){
        editingArray = objCtrl.returnSectorsArray(marketsArray: fullArray)
    }
}
//MARK: - SEGUEWAYS
extension ItemsMercadoVC{
    //prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemImageExpandedVC" {
            let destinationVC = segue.destination as! ItemImageExpandedVC
            destinationVC.selectedCellImage = itemImageForItemImageExpandedVC
        } else if segue.identifier == "goToAddNewItem" {
            let destinationVC = segue.destination as! NewItemVC
            destinationVC.dataController = dataController
        } else if segue.identifier == "goToSingleItemVC" {
            let destinationVC = segue.destination as! SingleItemInfoVC
            destinationVC.passedItem = itemObj
            destinationVC.dataController = dataController
        }
    }
    //adding a new item
    @IBAction func addButtonPressed(_ sender: Any) {
        goToNewItemVC()
    }
    func goToNewItemVC () {
        performSegue(withIdentifier: "goToAddNewItem", sender: self)
    }
    //showing image
    func goToItemImageExpandedVC() {
        performSegue(withIdentifier: "goToItemImageExpandedVC", sender: self)
    }
    func goToSingleItemVC(){
        performSegue(withIdentifier: "goToSingleItemVC", sender: self)
    }
}
//MARK:- START/END
extension ItemsMercadoVC{
    func initialFunctions(){
        itemsMercadoTableView.delegate = self
        itemsMercadoTableView.dataSource = self
        itemsMercadoTableView.separatorColor = UIColor.init(named: "textColor")
        itemsMercadoTableView.separatorStyle = .singleLine
        
        itemsMercadoTableView.register(UINib(nibName: "MarketHeaderCell", bundle: nil), forCellReuseIdentifier: "marketHeaderCell")
        itemsMercadoTableView.register(UINib(nibName: "CellForSectorInTableViews", bundle: nil), forCellReuseIdentifier: "cellForSectorInTableViews")
        itemsMercadoTableView.register(UINib(nibName: "CellForItemInTableViews", bundle: nil), forCellReuseIdentifier: "cellForItemInTableViews")
        
        
        itemsMercadoTableView.tableFooterView = UIView()
        
        quantityValueTextField.delegate = self
        searchBarInTouched.delegate = self
        
        qttyInfoScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
        searchBarInTouched.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
        
        if let textfield = searchBarInTouched.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.init(named: "tableViewColor")
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor(named: "textColor")
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor(named: "textColor")
            }
        }
        
        registerToKeyboardNotifications(registerTrueAndUnregisterFalse: true)
    }
    func finalFunctions(){
        registerToKeyboardNotifications(registerTrueAndUnregisterFalse: false)
    }
}
//MARK:- SEARCH BAR
extension ItemsMercadoVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showCanceButton()
        loadData()
        if searchText.isEmpty {
            itemsMercadoTableView.reloadData()
            return
        } else {
            let myFilter = searchText.lowercased()
            searchBarArray = searchBarArray.filter({ $0.name?.lowercased().range(of: myFilter, options: [.diacriticInsensitive]) != nil})
        }
        itemsMercadoTableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showCanceButton()
        hideUserInterfaceInSearchBar(value: true)
        itemsMercadoTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endSearchMode()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        showCanceButton()
    }
    func showCanceButton(){
        itemsMercadoTableView.setEditing(false, animated: true)
        searchingOn = true
        searchBarInTouched.setShowsCancelButton(true, animated: true)
        let cancel = searchBarInTouched.value(forKey: "cancelButton") as! UIButton
        cancel.tintColor = UIColor(named: "textColor")
        cancel.isEnabled = true
    }
    func endSearchMode(){
        DispatchQueue.main.async {
            self.searchBarInTouched.endEditing(true)
            self.searchBarInTouched.showsCancelButton = false
            self.searchBarInTouched.resignFirstResponder()
            self.searchBarInTouched.text = ""
            self.searchingOn = false
            self.loadData()
            self.hideUserInterfaceInSearchBar(value: false)
            self.itemsMercadoTableView.keyboardDismissMode = .onDrag
            self.itemsMercadoTableView.reloadData()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        itemsMercadoTableView.keyboardDismissMode = .onDrag
        searchingOn ? showCanceButton() : nil
    }
}
//MARK:- TABLEVIEW EDITING MODE
extension ItemsMercadoVC{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return editingArray.count > 0 ? true : false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let dSector = editingArray[destinationIndexPath.section]
        let item = editingArray[sourceIndexPath.section].getItem()[sourceIndexPath.row]
        var sAry = editingArray[sourceIndexPath.section].getItem()
        var dAry = editingArray[destinationIndexPath.section].getItem()
        if sourceIndexPath.section != destinationIndexPath.section {
            item.subtractItemFromMarketAndSectorCounter()
            dAry.insert(item, at: destinationIndexPath.row)
            sAry.remove(at: sourceIndexPath.row)
            item.sector = dSector
            item.addOneitemInMarketAndSectorCounter()
            for i in 0..<sAry.count {
                if i != sAry[i].getOrderingID(){
                    sAry[i].setOredringId(setAt: i)
                }
            }
            for i in 0..<dAry.count {
                if i != dAry[i].getOrderingID(){
                    dAry[i].setOredringId(setAt: i)
                }
            }
        } else {
            item.setOredringId(setAt: destinationIndexPath.row)
            sAry.remove(at: sourceIndexPath.row)
            sAry.insert(item, at: destinationIndexPath.row)
            for i in 0..<sAry.count {
                if i != sAry[i].getOrderingID(){
                    sAry[i].setOredringId(setAt: i)
                }
            }
        }
        
        saveData()
        loadData()
        tableView.reloadData()
    }
}
