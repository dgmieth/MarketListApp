//
//  WeeklyShoppingList.swift
//  MarketListApp
//
//  Created by Diego Mieth on 19/11/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class WeeklyShoppingList: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var weeklyVCMarketsArray = [Market]()
    var weeklyOnlyToBuyItems = [Market]()
    var objCtrl = WeeklyShoppingListObjectController()
    var uObjCtrl = UniversalObjectController()
    var chosenImageForItemImageExpandedVC = UIImage()
    
    let marketCell = MarketItemWeeklyShoppingList()
    let sectorCell = SectorItemWeeklyShoppingList()
    let itemCell = ItemItemWeeklyShoppingListVC ()
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var toBuyItemsLbl1: UILabel!
    @IBOutlet weak var toBuyItemsLbl2: UILabel!
    @IBOutlet weak var boughitemsLbl1: UILabel!
    @IBOutlet weak var boughitemsLbl2: UILabel!
    @IBOutlet weak var toBuyListPriceLbl1: UILabel!
    @IBOutlet weak var toBuyListPriceLbl2: UILabel!
    @IBOutlet weak var boughtListPriceLbl1: UILabel!
    @IBOutlet weak var boughtListPriceLbl2: UILabel!
    
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
    private var cellToUpdate = Item()
    //MARK:- VIEW LOADING
    override func viewWillAppear(_ animated: Bool) {
        weeklyOnlyToBuyItems = objCtrl.getOnlyToBuyItems(withMarketsArray: weeklyVCMarketsArray)
        if !objCtrl.canLoadItemsOntoTableView(inMarketsArray: weeklyOnlyToBuyItems) {
            print("ERROR | WeeklyShoppingListVC || viewWillAppear || array is empty")
        } else {
            weeklyShoppingListTableView.reloadData()
            registerToKeyboardNotifications(registerTrueAndUnregisterFalse: true)
        }
        updateBottomLables(withTexts: objCtrl.setResetBottomLableVariables(usingArray: weeklyOnlyToBuyItems))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        weeklyShoppingListTableView.delegate = self
        weeklyShoppingListTableView.dataSource = self
        
        newInformationTxt.delegate = self
        
        addKeyboardDismissalUponTouchOnScreen()
        
        weeklyShoppingListTableView.register(UINib(nibName: "MarketItemWeeklyShoppingList", bundle: nil), forCellReuseIdentifier: "marketWeeklyShoppingListVc")
        weeklyShoppingListTableView.register(UINib(nibName: "SectorItemWeeklyShoppingList", bundle: nil), forCellReuseIdentifier: "sectorWeeklyShoppingListVC")
        weeklyShoppingListTableView.register(UINib(nibName: "ItemItemWeeklyShoppingListVC", bundle: nil), forCellReuseIdentifier: "itemWeeklyListCell")
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor.black
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        registerToKeyboardNotifications(registerTrueAndUnregisterFalse: false)
        weeklyOnlyToBuyItems = objCtrl.emptyOnlyToBuyArray(usingMarketsArray: weeklyOnlyToBuyItems)
    }
    //MARK:- TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        objCtrl.getSectionsForTableView(inMarketsArray: weeklyOnlyToBuyItems)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objCtrl.getRowsForTableView(inMarketsArray: weeklyOnlyToBuyItems, inSection: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowAndSection = uObjCtrl.computeRowAndColum(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: weeklyOnlyToBuyItems)
        if rowAndSection.row < 0 && indexPath.row == 0 {
            let mCell = tableView.dequeueReusableCell(withIdentifier: "marketWeeklyShoppingListVc", for: indexPath) as! MarketItemWeeklyShoppingList
            return objCtrl.returnMarketCell(withCell: mCell, inMarket: indexPath.section, inSector: rowAndSection.section, withMarketsArray: weeklyOnlyToBuyItems)
        } else if rowAndSection.row < 0 {
            let sCell = tableView.dequeueReusableCell(withIdentifier: "sectorWeeklyShoppingListVC", for: indexPath) as! SectorItemWeeklyShoppingList
            return objCtrl.returnSectorCell(withCell: sCell, inMarket: indexPath.section, inSector: rowAndSection.section, withMarketsArray: weeklyOnlyToBuyItems)
        } else {
            let iCell = tableView.dequeueReusableCell(withIdentifier: "itemWeeklyListCell", for: indexPath) as! ItemItemWeeklyShoppingListVC
            weeklyShoppingListTableView.separatorStyle = .singleLine
            iCell.purchasedButton.addTarget(self, action: #selector(setItemAsPurchased(sender:)), for: .touchUpInside)
            iCell.seeImageButton.addTarget(self, action: #selector(getItemImage(sender:)), for: .touchUpInside)
            iCell.itemNotes.addTarget(self, action: #selector(getItemNotes(sender:)), for: .touchUpInside)
            return objCtrl.returnItemCell(withCell: iCell, inMarket: indexPath.section, inSector: rowAndSection.section, itemIndex: rowAndSection.row, indexPathRow: indexPath.row, withMarketsArray: weeklyOnlyToBuyItems)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objCtrl.returnHeightForCell(atIndexPath: indexPath, usingMarketsArray: weeklyOnlyToBuyItems)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(didSelectRowAtAlertsWSLVC(withIndexPath: indexPath) , animated: true)
    }
    //MARK:- TARGETS
    //set items as purchased upon touching it
    @objc func setItemAsPurchased(sender: UIButton) {
        uObjCtrl.setTagForCellAddressForOtherFunctionsOutsideTableView(atIndexPath: sender.tag)
        objCtrl.setOrUnsetCellAsPurhcase(inCellAddress: uObjCtrl.getCellAdress(), withMarketsArray: weeklyOnlyToBuyItems)
        updateBottomLables(withTexts: objCtrl.updateBottomLableInsideTargetForButton(inCellAddress: uObjCtrl.getCellAdress(), withMarketsArray: weeklyOnlyToBuyItems))
        weeklyShoppingListTableView.reloadData()
    }
    //get items image pon touching it
    @objc func getItemImage(sender: UIButton) {
        uObjCtrl.setTagForCellAddressForOtherFunctionsOutsideTableView(atIndexPath: sender.tag)
        chosenImageForItemImageExpandedVC = objCtrl.getItemImage(inCellAddress: uObjCtrl.getCellAdress(), inMarketsArray: weeklyOnlyToBuyItems)
        goToItemImageExpandedVC()
    }
    //get notes about the item
    @objc func getItemNotes(sender: UIButton){
        uObjCtrl.setTagForCellAddressForOtherFunctionsOutsideTableView(atIndexPath: sender.tag)
        present(itemInfoAlertWSLVC(withSenderTag: sender.tag), animated: true, completion: nil)
    }
    //MARK:- DATA MANIPULATION
    func removeItemFromListWhenDesctructiveButtonInAlertIsTouched(selectedCell cell: Item){
        cell.setAddToBuyList(changeBoolValue: false)
        cell.setPurchase(value: false)
        updateModel()
        if weeklyOnlyToBuyItems.count == 0 {
            weeklyShoppingListTableView.separatorStyle = .none
        }
    }
    func updateModel(){
        weeklyOnlyToBuyItems = objCtrl.getOnlyToBuyItems(withMarketsArray: weeklyOnlyToBuyItems)
        updateBottomLables(withTexts: objCtrl.setResetBottomLableVariables(usingArray: weeklyOnlyToBuyItems))
        weeklyShoppingListTableView.reloadData()
    }
    //MARK:- KEYBOARD
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
            }
        }
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
    //adding keyboard dismissal upon touching screen
    func addKeyboardDismissalUponTouchOnScreen(){
        let tapToDimissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.editingInforationScrolView.addGestureRecognizer(tapToDimissKeyBoard)
    }
    //tap gesture for view
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFieldsResignFirstResponder()
    }
    //MARK:- TEXTFIELDS
    //textfield delegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        enableScrolInScrollView()
    }
    //textfield delegate method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == newInformationTxt {
            if decimalKeyToolbar == nil {
                decimalKeyToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            }
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtn))
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            decimalKeyToolbar?.items = [spacer, doneButton]
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
    //MARK:- ALERTS
    func didSelectRowAtAlertsWSLVC(withIndexPath indexPath: IndexPath)->UIAlertController {
        let cellIndex = uObjCtrl.computeRowAndColum(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: weeklyOnlyToBuyItems)
        let selectedCell = weeklyOnlyToBuyItems[indexPath.section].getSector()[cellIndex.section].getItem()[cellIndex.row]
        if uObjCtrl.checkIfItemIsSoldInKiloOrLiter(withDescription: selectedCell.getFormOfSale().getUnitMeasure()) {
            uObjCtrl.setItemsIsSoldInKilosOrLiters(value: true)
        }
        self.cellToUpdate = selectedCell
        let alert = UIAlertController()
        let editPrice = UIAlertAction(title: "Editar Preço", style: .default) { (action) in
            self.price = true
            self.settingUpLblForEditingItemInformation(withTitle: "Preço", isItPrice: true, withCell: selectedCell)
            self.registerUnregisterRealTimeTextFieldUpdate(registerTrueAndUnregisterFalse: true, isItPrice: true, isItKiloLiter: false)
            self.weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
        }
        let editQuantity = UIAlertAction(title: "Editar Quantidade", style: .default) { (action) in
            self.quantity = true
            if self.uObjCtrl.checkIfItemIsSoldInKiloOrLiter(withDescription: selectedCell.getFormOfSale().getUnitMeasure()) {
                self.registerUnregisterRealTimeTextFieldUpdate(registerTrueAndUnregisterFalse: true, isItPrice: false, isItKiloLiter: true)
            } else {
                self.registerUnregisterRealTimeTextFieldUpdate(registerTrueAndUnregisterFalse: true, isItPrice: false, isItKiloLiter: false)
            }
            self.settingUpLblForEditingItemInformation(withTitle: "Quantidade", isItPrice: false, withCell: selectedCell)
            self.weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
        }
        let removeItem = UIAlertAction(title: "Remover Item", style: .destructive) { (action) in
            self.removeItemFromListWhenDesctructiveButtonInAlertIsTouched(selectedCell: selectedCell)
            self.weeklyShoppingListTableView.deselectRow(at: indexPath, animated: true)
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
        let cell = objCtrl.getCell(inCellAddress: uObjCtrl.getCellAdress(), inTheArray: weeklyOnlyToBuyItems)
        var alertMsg = ""
        if cell.getBrand().hasValue {
            alertMsg = "\nMARCA:\n\(cell.getBrand().Value)\n\nINFORMACAO ATUAL:\n\(cell.getItemInformation())"
        } else {
            alertMsg = "\nOBSERVACOES:\n\(cell.getItemInformation())"
        }
        let alert = UIAlertController(
            title: "Item Information",
            message: alertMsg,
            preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(cancel)
        return alert
    }
    //MARK:- BUTTONS
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !newInformationTxt.text!.isEmpty && uObjCtrl.checkIfInputInformationIsNotZero(price: newInformationTxt.text!) {
            if price {
                cellToUpdate.getFormOfSale().setItemPrice(howMuchIsIt: newInformationTxt.text!)
            } else if quantity {
                if uObjCtrl.checkIfItemIsSoldInKiloOrLiter(withDescription: cellToUpdate.getFormOfSale().getUnitMeasure()) {
                    cellToUpdate.getFormOfSale().setQuantityInDecimal(howMuchItWeighs: newInformationTxt.text!)
                } else {
                    cellToUpdate.getFormOfSale().setQuantityInUnits(howManyUnits: newInformationTxt.text!.numbersOnly.integerValue)
                }
            }
        } else {
            print("ERROR || EDITING PRICE/QUANTITY INFORMATION IN WEEKLYSHOPPINGLISTVC || STRING IS EMPTY/ZERO")
        }
        updateModel()
        scrollViewHideAndUnhide(trueToHideFalseToUnhide: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        scrollViewHideAndUnhide(trueToHideFalseToUnhide: true)
    }
    //MARK:- LAYOUT
    //update bottom lables
    func updateBottomLables(withTexts items : [BottomInformationLabelsInWeeklyShoppingItemsVC : String] ){
        toBuyItemsLbl1.text = items[.toBuyItemsLbl1]
        toBuyItemsLbl2.text = items[.toBuyItemsLbl2]
        boughitemsLbl1.text = items[.boughItemsLbl1]
        boughitemsLbl2.text = items[.boughItemsLbl2]
        toBuyListPriceLbl1.text = items[.toBuyListPriceLbl1]
        toBuyListPriceLbl2.text = items[.toBuyListPriceLbl2]
        boughtListPriceLbl1.text = items[.boughtListPriceLbl1]
        boughtListPriceLbl2.text = items[.boughtListPriceLbl2]
    }
    func scrollViewHideAndUnhide(trueToHideFalseToUnhide value: Bool){
        if value {
            editingInforationScrolView.isHidden = value
            editingInforationScrolView.isScrollEnabled = !value
            textFieldsResignFirstResponder()
            newInformationTxt.text = ""
            price = false
            quantity = false
            registerUnregisterRealTimeTextFieldUpdate(registerTrueAndUnregisterFalse: false, isItPrice: false, isItKiloLiter: false)
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
        if value {
            howItemIsSoldInformation.text = objCtrl.updatingEditingInformationLbls(selectedCell: cell)[0]
            let measure = cell.getFormOfSale().getUnitMeasureNoRawValue()
            if measure == UnitMeasure.averageWeight {
                descriptionInformation.text = "Cada unidade pesa \(Int(cell.getFormOfSale().getStandarWeightValue()*Double(cell.getFormOfSale().getDivisor()[.averageWeight]!)))\ngrama(s)/ml(s), mas o preço\ndeverá ser informado em Kilo/Litro"
            } else {
                descriptionInformation.text = "Informe novo preço\npara \(Int(cell.getFormOfSale().getStandarWeightValue())) \(cell.getFormOfSale().getUnitMeasure())"
            }
        } else {
            descriptionInformation.text = objCtrl.updatingEditingInformationLbls(selectedCell: cell)[1]
        }
    }
    //setting method as target for textfield
    @objc func realTimePriceTextFieldUpdateTripleDigits(){
        newInformationTxt.text = (Double(newInformationTxt.text!.numbersOnly.integerValue)/1000).threeDigits
    }
    @objc func realTimePriceTextFieldUpdateDoubleDigits(){
        newInformationTxt.text = (Double(newInformationTxt.text!.numbersOnly.integerValue)/100).twoDigits
    }
    //MARK:-REGISTRATION
    //setting kilo decimal or other form of sales units in the textfield
    func registerUnregisterRealTimeTextFieldUpdate(registerTrueAndUnregisterFalse value : Bool, isItPrice price: Bool, isItKiloLiter tripleDigits: Bool) {
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
    //MARK:- SEGUEWAYS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemImageExpandedVC = segue.destination as! ItemImageExpandedVC
        itemImageExpandedVC.selectedCellImage = chosenImageForItemImageExpandedVC
    }
    func goToItemImageExpandedVC() {
        performSegue(withIdentifier: "goToItemImageExpandedFromWeeklyShoppingListVC", sender: self)
    }
    //MARK:- START UP/END
    //Conlcude list buttonPressed
    @IBAction func finishListButtonPressed(_ sender: Any) {
        objCtrl.updatingMainArrayForHomeVC(weeklyShoppingListMarketsArray: weeklyVCMarketsArray)
        navigationController?.popViewController(animated: true)
    }
}
