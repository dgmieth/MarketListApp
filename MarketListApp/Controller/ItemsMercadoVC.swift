//
//  ItemsMercadoVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 15/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

protocol updateMainItemsArray {
    func updatingMainItemsArraySaveInHomeVC(withArray ary: [Market])
}

class ItemsMercadoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, addingNewItemsToArray  {
    
    var marketsArray = [Market]()
    var objCtrl = itemsMercadoObjectController()
    var uObjCtrl = UniversalObjectController()
    var delegateHomeVC : updateMainItemsArray?
    var checkmarkForCellAtRow : Int = 0
    var chosenImageForItemImageExpandedVC = UIImage()
    
    @IBOutlet weak var itemsMercadoTableView: UITableView!
    @IBOutlet weak var marketItemsInformationLabel: UILabel!
    @IBOutlet weak var searchBarInTouched: UISearchBar!
    
    //adding item to weekly shopping list
    @IBOutlet weak var qttyInfoScrollView: UIScrollView!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityDetailsLabel: UILabel!
    @IBOutlet weak var quantityValueTextField: UITextField!
    var addressForSelectedItem = Int()
    var itemIsSoldInKilosOrLitters : Bool = false
    
    //decimal keyboard toolbar
    var decimalKeyTooblar : UIToolbar?
    var keyboardHeight = CGFloat()
    
    let marketCell = MarketItemMercadoVCCell()
    let sectorCell = SectorItemMercadoVCCell()
    let itemCell = ItemItemMercadoVCCell ()
    
    //MARK: - VIEWS LOADING
    override func viewWillAppear(_ animated: Bool) {
        if !objCtrl.canLoadItemsOntoTableView(inMarketsArray: marketsArray) {
            goToNewItemVC()
        } else {
            itemsMercadoTableView.reloadData()
        }
        DispatchQueue.main.async {
            self.registerToKeyboardNotifications(registerTrueAndUnregisterFalse: true)
        }
    }
    override func viewDidLoad() {
        initialFunctions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        finalFunctions()
    }
    //MARK:- TABLEVIEWS
    func numberOfSections(in tableView: UITableView) -> Int {
        return objCtrl.getSectionsForTableView(inMarketsArray: marketsArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objCtrl.getRowsForTableView(inMarketsArray: marketsArray, inSection: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowAndSection = uObjCtrl.computeRowAndColum(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: marketsArray)
        let itemIndex = rowAndSection.row
        
        marketItemsInformationLabel.isHidden = false
        marketItemsInformationLabel.text = objCtrl.updatedBottomLableInMercadoVC(atSection: indexPath.section, inMarketsArray: marketsArray)
        
        if itemIndex < 0 && indexPath.row == 0 {
            let mCell = tableView.dequeueReusableCell(withIdentifier: "marketMarketListCell", for: indexPath) as! MarketItemMercadoVCCell
            return objCtrl.returnMarketCell(withCell: mCell, inMarket: indexPath.section, inSector: rowAndSection.section, withMarketsArray: marketsArray)
        } else if itemIndex < 0 {
            let sCell = tableView.dequeueReusableCell(withIdentifier: "sectorMarketListCell", for: indexPath) as! SectorItemMercadoVCCell
            return objCtrl.returnSectorCell(withCell: sCell, inMarket: indexPath.section, inSector: rowAndSection.section, withMarketsArray: marketsArray)
        } else {
            let iCell = tableView.dequeueReusableCell(withIdentifier: "itemMarketListCell", for: indexPath) as! ItemItemMercadoVCCell
            itemsMercadoTableView.separatorStyle = .singleLine
            iCell.checkmarkSign.addTarget(self, action: #selector(addItemToWeeklyShoppingList(sender:)), for: .touchUpInside)
            iCell.itemImageButton.addTarget(self, action: #selector(checkTouchInsideImageView(sender:)), for: .touchUpInside)
            iCell.itemNotes.addTarget(self, action: #selector(getItemNotesItemsVC(sender:)), for: .touchUpInside)
            return objCtrl.returnItemCell(withCell: iCell, inMarket: indexPath.section, inSector: rowAndSection.section, itemIndex: rowAndSection.row, indexPathRow: indexPath.row, withMarketsArray: marketsArray)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objCtrl.returnHeightForCell(atIndexPath: indexPath, usingMarketsArray: marketsArray)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        itemsMercadoTableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK:- TARGETS
    //expand UIImage to expandedImageView
    @objc func checkTouchInsideImageView(sender: UIImageView) {
        uObjCtrl.setTagForCellAddressForOtherFunctionsOutsideTableView(atIndexPath: sender.tag)
        print(sender.tag)
        chosenImageForItemImageExpandedVC = objCtrl.getItemImage(inCellAddress: uObjCtrl.getCellAdress(), inMarketsArray: marketsArray)
        goToItemImageExpandedVC()
    }
    //tap gesture for Item CELL
    @objc func addItemToWeeklyShoppingList(sender: UIButton) {
        uObjCtrl.setTagForCellAddressForOtherFunctionsOutsideTableView(atIndexPath: sender.tag)
        print(sender.tag)
        let cellIndex = uObjCtrl.computeRowAndColum(atSection: uObjCtrl.getCellAdress()[.marketAndSectorIndex]!, atRow: uObjCtrl.getCellAdress()[.itemIndex]!, inMarketArray: marketsArray)
        let selectedCell = marketsArray[uObjCtrl.getCellAdress()[.marketAndSectorIndex]!].getSector()[cellIndex.section].getItem()[cellIndex.row]
        if selectedCell.getAddToBuyList() {
            selectedCell.setAddToBuyList(changeBoolValue: false)
            itemsMercadoTableView.reloadData()
        } else {
            if uObjCtrl.checkIfItemIsSoldInKiloOrLiter(withDescription: selectedCell.getFormOfSale().getUnitMeasure()){
                uObjCtrl.setItemsIsSoldInKilosOrLiters(value: true)
            }
            priceLabel.text = objCtrl.updatingQttyScrollViewInformationLabels(selectedCell: selectedCell)[0]
            quantityDetailsLabel.text = objCtrl.updatingQttyScrollViewInformationLabels(selectedCell: selectedCell)[1]
            scrollViewOutletShow()
        }
    }
    //get item notes
    @objc func getItemNotesItemsVC(sender: UIButton){
        uObjCtrl.setTagForCellAddressForOtherFunctionsOutsideTableView(atIndexPath: sender.tag)
        let cell = objCtrl.getCell(inCellAddress: uObjCtrl.getCellAdress(), inTheArray: marketsArray)
        print(cell.getName())
    }
    //MARK:- TEXTFIELDS
    //textfield delegate method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        enableScrolInScrollView()
        if textField == quantityValueTextField {
            if uObjCtrl.getItemIsSoldInKilosOrLitters() {
                registeringAndUnregisteringTargetForAddingToWeeklyShoppingListButton(registerTrueAndUnregisterFalse: true)
            }
        }
    }
    //textfield delegate method
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == quantityValueTextField {
            if decimalKeyTooblar == nil {
                decimalKeyTooblar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            }
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtn))
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            decimalKeyTooblar?.items = [spacer, doneButton]
            textField.inputAccessoryView = decimalKeyTooblar
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
    //MARK:- BUTTONS
    //button to add quantity and item to weekly shopping list
    @IBAction func addItemToWeeklyShoppingListPressed(_ sender: Any) {
        let cellIndex = uObjCtrl.computeRowAndColum(atSection: uObjCtrl.getCellAdress()[.marketAndSectorIndex]!, atRow: uObjCtrl.getCellAdress()[.itemIndex]!, inMarketArray: marketsArray)
        let selectedCell = marketsArray[uObjCtrl.getCellAdress()[.marketAndSectorIndex]!].getSector()[cellIndex.section].getItem()[cellIndex.row]
        if !quantityValueTextField.text!.isEmpty && uObjCtrl.checkIfInputInformationIsNotZero(price: quantityValueTextField.text!) {
            if uObjCtrl.getItemIsSoldInKilosOrLitters() {
                selectedCell.getFormOfSale().setQuantityInDecimal(howMuchItWeighs: quantityValueTextField.text!)
            } else {
                selectedCell.getFormOfSale().setQuantityInUnits(howManyUnits: quantityValueTextField.text!.numbersOnly.integerValue)
            }
            selectedCell.setAddToBuyList(changeBoolValue: true)
        } else {
            print("ERROR - NOTHING ADDED TO WEEKLY SHOPPING LIST")
        }
        dismissQttyInfoScrollView()
    }
    //button to cancel quantity and item to weekly shopping list
    @IBAction func cancelAddItemToWeeklyListActionPressed(_ sender: Any) {
        dismissQttyInfoScrollView()
    }
    //MARK:- KEYBOARD
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
              self.qttyInfoScrollView.addGestureRecognizer(tapToDimissKeyBoard)
    }
    //tap gesture for view
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFieldsResignFirstResponder()
    }
    //MARK:- LAYOUT
    //setting kilo decimal or other form of sales units in the textfield
    func registeringAndUnregisteringTargetForAddingToWeeklyShoppingListButton(registerTrueAndUnregisterFalse value : Bool) {
        if value {
            quantityValueTextField.text = 0.threeDigits
            quantityValueTextField.addTarget(self, action: #selector(realTimePriceTextFieldUpdate), for: UIControl.Event.editingChanged)
        } else if !value {
            quantityValueTextField.text = ""
            quantityValueTextField.removeTarget(self, action: #selector(realTimePriceTextFieldUpdate), for: UIControl.Event.editingChanged)
        }
    }
    //showing view for addin quatity and item to weekly shopping list
    func scrollViewOutletShow() {
        qttyInfoScrollView.isHidden = false
        enableScrolInScrollView()
    }
    //enable scroll in scrollview
    func enableScrolInScrollView(){
        qttyInfoScrollView.isScrollEnabled = true
    }
    //dismissing view for addin quatity and item to weekly shopping list
    func dismissQttyInfoScrollView() {
        registeringAndUnregisteringTargetForAddingToWeeklyShoppingListButton(registerTrueAndUnregisterFalse: false)
        textFieldsResignFirstResponder()
        qttyInfoScrollView.isHidden = true
        uObjCtrl.setItemsIsSoldInKilosOrLiters(value: false)
        addressForSelectedItem = 0
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
    //MARK: - SEGUEWAYS
    //prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemImageExpandedVC" {
            let destinationVC = segue.destination as! ItemImageExpandedVC
            destinationVC.selectedCellImage = chosenImageForItemImageExpandedVC
        } else if segue.identifier == "goToAddNewItem" {
            let destinationVC = segue.destination as! NewItemVC
            destinationVC.marketsArray = self.marketsArray
            destinationVC.delegate = self
        }
    }
    //adding a new item
    @IBAction func addButtonPressed(_ sender: Any) {
        goToNewItemVC()
    }
    func goToNewItemVC () {
        performSegue(withIdentifier: "goToAddNewItem", sender: self)
    }
    func passingNewArraysOfElements(sendMarketsArray ary: [Market]) {
        marketsArray = ary
    }
    //showing image
    func goToItemImageExpandedVC() {
        performSegue(withIdentifier: "goToItemImageExpandedVC", sender: self)
    }
    //MARK:- START/END
    func initialFunctions(){
        itemsMercadoTableView.delegate = self
        itemsMercadoTableView.dataSource = self
        
        itemsMercadoTableView.register(UINib(nibName: "MarketItemMercadoVCCell", bundle: nil), forCellReuseIdentifier: "marketMarketListCell")
        itemsMercadoTableView.register(UINib(nibName: "SectorItemMercadoVCCell", bundle: nil), forCellReuseIdentifier: "sectorMarketListCell")
        itemsMercadoTableView.register(UINib(nibName: "ItemItemMercadoVCCell", bundle: nil), forCellReuseIdentifier: "itemMarketListCell")
        
        quantityValueTextField.delegate = self
        
        addKeyboardDismissalUponTouchOnScreen()
        
        if let textfield = searchBarInTouched.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor.black
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
        
        registerToKeyboardNotifications(registerTrueAndUnregisterFalse: true)
    }
    func finalFunctions(){
        delegateHomeVC?.updatingMainItemsArraySaveInHomeVC(withArray: marketsArray)
        registerToKeyboardNotifications(registerTrueAndUnregisterFalse: false)
    }
}
