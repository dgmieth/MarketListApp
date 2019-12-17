//
//  NewItemVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 18/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

protocol addingNewItemsToArray {
    func passingNewArraysOfElements(sendMarketsArray ary: [Market])
}

class NewItemVC : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var marketsArray = [Market]()
    var sectorsArray = [Sector]()
    var chosenMarketIndex : Int = -1
    var chosenSectorIndex : Int = -1
    var viewHeight : CGFloat = 0
    var refrigeratedItem : Bool = false
    var gramOrMlSelected : Bool = false
    let emptyItemCell = Item()
    //decimal keyboard toolbar
    var decimalKeyTooblar : UIToolbar?
    var keyboardHeight = CGFloat()
    
    //New Market and New Sector View
    @IBOutlet weak var newMarketAndSectorSuperView: UIView!
    @IBOutlet weak var newMarketandNewSectorLabel: UILabel!
    @IBOutlet weak var newMarketAndNewSectorTextField: UITextField!
    var pickerTag = Int()
    var saveSectorInMarket = Int()
    @IBOutlet weak var saveNewMarketAndSectorButton: UIButton!
    
    var delegate : addingNewItemsToArray?
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var scrolViewOutlet: UIScrollView!
    
    @IBOutlet weak var marketPicker: UIPickerView!
    @IBOutlet weak var sectorPicker: UIPickerView!
    @IBOutlet weak var formOfSalePicker: UIPickerView!
    
    @IBOutlet weak var sectorLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var brandTextField: UITextField!
    
    @IBOutlet weak var formOfSaleLbl: UILabel!
    @IBOutlet weak var standardQttyLbl: UILabel!
    @IBOutlet weak var standarWeightTextField: UITextField!
    @IBOutlet weak var fixedUnitMeasureLbl: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var coldItemLbl: UILabel!
    @IBOutlet weak var coldItemChooser: UISwitch!
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    //MARK:- VEIW LOADING
    override func viewWillAppear(_ animated: Bool) {
        registerToKeyboardNotificationsInNewItemVC(registerTrueAndUnregisterFalse: true)
    }
    override func viewDidLoad() {
        initializationProcedures()
    }
    override func viewDidDisappear(_ animated: Bool) {
        beforeViewDisappearFunctions()
    }
    //MARK:- PICKER VIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return returnNumberOfRowsForComponent(inPicker: pickerView)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView.tag == 1 {
            return retunrViewForRow(inPicker: pickerView, atRow: row, usingTextFromAry: marketsArray)
        } else if pickerView.tag == 2 {
            return retunrViewForRow(inPicker: pickerView, atRow: row, usingTextFromAry: sectorsArray)
        } else if pickerView.tag == 3 {
            return retunrViewForRow(inPicker: pickerView, atRow: row, usingTextFromAry: UnitMeasure.allCases)
        } else {
            let lable = UILabel()
            return lable
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return retunrFontSizeForPickerViewViews()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        actionsForDidSelectRowAt(withPicker: pickerView, atRow: row)
    }
    //MARK:- BUTTONS
    //canceling add market/sector call and dimissing superview
    @IBAction func cancelNewMarketAndNewSectorPressed(_ sender: Any) {
        newMarketAndSectorSuperView.isHidden = true
        if pickerTag == 1 {
            marketPicker.selectRow(0, inComponent: 0, animated: true)
            pickerTag = 0
        } else if pickerTag == 2 {
            sectorPicker.selectRow(0, inComponent: 0, animated: true)
            pickerTag = 0
        }
        newMarketAndNewSectorTextField.resignFirstResponder()
    }
    //saving add market/sector call and dimissing superview
    @IBAction func saveNewMarketAndNewSectorPressed(_ sender: Any) {
        newMarketAndSectorSuperView.isHidden = true
        if pickerTag == 1 {
            if !newMarketAndNewSectorTextField.text!.isEmpty {
                let newMarket = Market(marketName: newMarketAndNewSectorTextField.text!)
                marketsArray.append(newMarket)
                reloadMarketPickerView()
            } else {
                emptyTextField()
            }
            pickerTag = 0
        } else if pickerTag == 2 {
            if !newMarketAndNewSectorTextField.text!.isEmpty {
                let newSector = Sector(sectorName: newMarketAndNewSectorTextField.text!)
                marketsArray[chosenMarketIndex].setSector(sector: newSector)
                sectorsArray = marketsArray[chosenMarketIndex].getSector()
                reloadSectorPickerView()
            } else {
                emptyTextField()
            }
            pickerTag = 0
        }
        newMarketAndNewSectorTextField.text = ""
        newMarketAndNewSectorTextField.resignFirstResponder()
    }
    //adding new item in array
    @IBAction func addButtonPressed(_ sender: Any) {
        if returnCanSaveItem() {
            //item name
            let newItem = Item(itemName: nameTextField.text!)
            //item brand
            if let brand = brandTextField.text {
                newItem.setBrand(itsBrandIs: brand)
            }
            //item form of sale
            newItem.getFormOfSale().setUnitMeasure(howItIsSold: UnitMeasure.allCases[formOfSalePicker.selectedRow(inComponent: 0)])
            newItem.getFormOfSale().setItemPrice(howMuchIsIt: priceTextField.text!)
            if formOfSalePicker.selectedRow(inComponent: 0) == 1 {
                let decimaValue = NSDecimalNumber(string: standarWeightTextField.text!)
                newItem.getFormOfSale().setStandarWeightValue(standarWeightIs: Double(decimaValue.intValue))
            } else {
                newItem.getFormOfSale().setStandarWeightValue()
            }
            newItem.setItemTemp(isItCold: refrigeratedItem)
            if let image = itemImageView.image {
                newItem.setImage(useImage: image)
            }
            marketsArray[chosenMarketIndex].getSector()[chosenSectorIndex].setItem(item: newItem)
            self.delegate?.passingNewArraysOfElements(sendMarketsArray: marketsArray)
            navigationController?.popViewController(animated: true)
        } else {
            print("ERROR in addButtonPressed code")
        }
    }
    //cancelling new item and dimissing newItemVC
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.delegate?.passingNewArraysOfElements(sendMarketsArray: marketsArray)
    }
    //button to add picture to item
    @IBAction func addImagePressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    //refrigerated itens switch
    @IBAction func refrigeratedItemTick(_ sender: Any) {
        refrigeratedItem = !refrigeratedItem
        print(refrigeratedItem.self)
    }
    //MARK:- TEXTFIELD
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        if textField.tag == 4 {
            priceTextField.text = 0.twoDigits
            priceTextField.addTarget(self, action: #selector(realTimePriceTextFieldUpdateDoubleDigitisNewItemVC), for: UIControl.Event.editingChanged)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let centralTag = 2
        if textField.tag <= centralTag || textField.tag == 5 {
            return true
        } else if textField.tag > centralTag {
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.resignFirstResponder()
            brandTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            textField.resignFirstResponder()
            if formOfSalePicker.selectedRow(inComponent: 0) == 1 {
                standarWeightTextField.becomeFirstResponder()
            } else {
                priceTextField.becomeFirstResponder()
            }
        } else if textField.tag == 3 {
            textField.resignFirstResponder()
            priceTextField.becomeFirstResponder()
        } else if textField.tag == 4 {
            textField.resignFirstResponder()
        }
        if textField.tag == 5 {
            textField.resignFirstResponder()
            newMarketAndSectorSuperView.isHidden = true
            if chosenMarketIndex == -1 {
                reloadMarketPickerView()
            } else if chosenSectorIndex == -1 {
                reloadSectorPickerView()
            }
        }
        return true
    }
    func textFieldsResignFirstResponder(){
        nameTextField.resignFirstResponder()
        brandTextField.resignFirstResponder()
        standarWeightTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        newMarketAndNewSectorTextField.resignFirstResponder()
    }
    //MARK:- CONTROLLERS
    
    
    
    //MARK:... FOR PICKERS
    //number of row in component
    func returnNumberOfRowsForComponent(inPicker picker : UIPickerView) -> Int {
        if picker.tag == 1 {
            return marketsArray.count + 2
        } else if picker.tag == 2 {
            return sectorsArray.count + 2
        } else if picker.tag == 3{
            return UnitMeasure.allCases.count
        } else {
            return 0
        }
    }
    //return views
    func retunrViewForRow<T>(inPicker picker: UIPickerView, atRow row: Int, usingTextFromAry ary: [T]) -> UILabel {
        let genericLbl = UILabel()
        genericLbl.textAlignment = .center
        genericLbl.textColor = .black
        
        if picker.tag == 1 {
            let marketsTempAry = ary as! [Market]
            switch row {
            case let x where x==0:
                return lableForFirstRowInMarketsAndSectorPicker(withLbl: genericLbl, withText: "mercado")
            case let x where x == marketsTempAry.count + 1:
                return lableForNewMarketOrSector(withLbl: genericLbl, withText: "mercado")
            default:
                return lableForAllOtherRowsInPicker(withLbl: genericLbl, atRow: row, withText: marketsTempAry[row - 1].getName(), forPicker: picker)
            }
        } else if picker.tag == 2 {
            let sectorsTempAry = ary as! [Sector]
            switch row {
            case let x where x==0:
                return lableForFirstRowInMarketsAndSectorPicker(withLbl: genericLbl, withText: "setor")
            case let x where x == sectorsTempAry.count + 1:
                return lableForNewMarketOrSector(withLbl: genericLbl, withText: "setor")
            default:
                return lableForAllOtherRowsInPicker(withLbl: genericLbl, atRow: row, withText: sectorsTempAry[row - 1].getName(), forPicker: picker)
            }
        } else if picker.tag == 3 {
            print(picker.selectedRow(inComponent: 0))
            return lableForAllOtherRowsInPicker(withLbl: genericLbl, atRow: row, withText: UnitMeasure.allCases[row].rawValue, forPicker: picker)
        }
        return genericLbl
    }
    //return font size for text in pickerView
    func retunrFontSizeForPickerViewViews() -> CGFloat {
        return 23
    }
    //return lable for picker view rows
    func lableForFirstRowInMarketsAndSectorPicker(withLbl useLbl : UILabel, withText text: String) -> UILabel {
        useLbl.font = UIFont(name: "Charter-Italic", size: self.retunrFontSizeForPickerViewViews())
        useLbl.text = "Escolha um \(text)"
        return useLbl
    }
    func lableForNewMarketOrSector(withLbl useLbl : UILabel, withText text: String) -> UILabel {
        useLbl.font = UIFont(name: "Charter-Italic", size: self.retunrFontSizeForPickerViewViews())
        useLbl.text = "Novo \(text)"
        return useLbl
    }
    func lableForAllOtherRowsInPicker(withLbl useLabl: UILabel, atRow row : Int, withText text: String, forPicker picker: UIPickerView) -> UILabel {
        if picker.tag == 3 && row == 1 {
            useLabl.font = UIFont(name: "Charter-Bold", size: self.retunrFontSizeForPickerViewViews()-3)
            useLabl.text = text
            return useLabl
        }
        useLabl.font = UIFont(name: "Charter-Bold", size: self.retunrFontSizeForPickerViewViews())
        useLabl.text = text
        return useLabl
    }
    //return selected row at
    func actionsForDidSelectRowAt(withPicker pickerView: UIPickerView, atRow row: Int){
        if pickerView.tag == 1 {
            if row == 0 {
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else if row == marketsArray.count + 1 {
                creatingNewMarket()
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else {
                prepareSectorsPickerViewForShowing(atRow: row)
                updateUserInferface(atCase: 2)
            }
        } else if pickerView.tag == 2 {
            if row == 0 {
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else if row == sectorsArray.count + 1 {
                creatingNewSector(inMarketAtRow: chosenMarketIndex)
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else {
                chosenSectorIndex = row - 1
                updatePriceAndQuantityLblInfo()
                updateUserInferface(atCase: 4)
            }
        } else if pickerView.tag == 3{
            updatePriceAndQuantityLblInfo(atRow: row)
            switch row {
            case 1:
                updateUserInferface(atCase: 6)
            default:
                updateUserInferface(atCase: 5)
            }
        }
    }
    //updating sectors array after new market created
    func prepareSectorsPickerViewForShowing(atRow row : Int){
        sectorsArray = marketsArray[row - 1].getSector()
        chosenMarketIndex = row - 1
        updateUserInferface(atCase: 8)
        reloadSectorPickerView()
    }
    //reload market picker
    func reloadMarketPickerView(){
        marketPicker.reloadAllComponents()
        marketPicker.selectRow(0, inComponent: 0, animated: true)
    }
    //reload sectors picker
    func reloadSectorPickerView(){
        sectorPicker.reloadAllComponents()
        sectorPicker.selectRow(0, inComponent: 0, animated: true)
    }
    //MARK:... NEW MARKET/SECTOR
    //creating new sector
    func creatingNewSector(inMarketAtRow row : Int){
        updateUserInferface(atCase: 9)
        pickerTag = 2
        preparingLabelInNewMarketNewSectorView(withText: "setor")
    }
    //creating new Market
    func creatingNewMarket(){
        updateUserInferface(atCase: 9)
        pickerTag = 1
        preparingLabelInNewMarketNewSectorView(withText: "mercado")
    }
    //MARK:... FOR NEW ITEM
    func returnCanSaveItem() -> Bool {
        var counter : Int = 0
        if chosenMarketIndex <= -1 {
            alertForEmptyNecessaryTextFields(title: "Mercado não selecionado", message: "Selecione o mercado")
        }
        if chosenSectorIndex <= -1 {
            alertForEmptyNecessaryTextFields(title: "Setor não selecionado", message: "Selecione o setor")
        }
        
        if !nameTextField.text!.isEmpty {
            let letter = NSCharacterSet.letters
            let range = nameTextField.text!.rangeOfCharacter(from: letter)
            if range != nil {
                counter = counter + 1
            }
        } else {
            alertForEmptyNecessaryTextFields(title: "Item sem nome", message: "Informe o nome do item")
        }
        if formOfSalePicker.selectedRow(inComponent: 0) == 1 {
            if !standarWeightTextField.text!.isEmpty {
                counter = counter + 1
            } else {
                alertForEmptyNecessaryTextFields(title: "Item sem peso médio", message: "Informe o peso médio de cada unidade")
            }
        }
        let price = (Double(priceTextField.text!.numbersOnly.integerValue))
        if price > 0 {
            counter = counter + 1
        } else {
            alertForEmptyNecessaryTextFields(title: "Item sem preço", message: "Informe o preço do item")
        }
        if counter >= 2 {
            return true
        } else {
            return false
        }
    }

    //MARK:... FOR IMAGE PICKER
    //did finish picking imagem and image resizing and imagepicker dismissal
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let x = info[UIImagePickerController.InfoKey.originalImage] {
            if let data = resize(image: x as! UIImage) {
                itemImageView.image = UIImage(data: data)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //picture resizing function
    func resize(image: UIImage, maxHeight: Float = 500, maxWidth: Float = 500, compressionQuality: Float = 0.8) -> Data? {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in:rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return imageData
    }
    //MARK:- LAYOUT
    //upadting lables: standardQttyLbl and itemPriceLabel
    func updatePriceAndQuantityLblInfo(atRow row : Int = 0) {
        if row == 1 {
            standardQttyLbl.text = "Gramas/ml por unidade:"
            itemPriceLabel.text = ("Preço (em kilo/litro)")
        } else {
            standardQttyLbl.text = "Peso/volume padrão: "
            switch UnitMeasure.allCases[row] {
            case .gram:
                fixedUnitMeasureLbl.text = "\(Int(emptyItemCell.getFormOfSale().getDivisor()[.gram]!)) \(UnitMeasure.allCases[row].rawValue)s"
                itemPriceLabel.text = ("Preço (\(UnitMeasure.allCases[row].rawValue))")
            case .mililiter:
                fixedUnitMeasureLbl.text = "\(Int(emptyItemCell.getFormOfSale().getDivisor()[.mililiter]!)) \(UnitMeasure.allCases[row].rawValue)s"
                itemPriceLabel.text = ("Preço (\(UnitMeasure.allCases[row].rawValue))")
            default:
                fixedUnitMeasureLbl.text = "1 \(UnitMeasure.allCases[row].rawValue)"
                itemPriceLabel.text = ("Preço (\(UnitMeasure.allCases[row].rawValue))")
            }
        }
    }
    //first row of market and sector pickerView - message displaying "select market/sector"
    func hideUserLayoutIfPickerRowIsZero(inPicker picker: UIPickerView){
        if picker.tag == 1 {
            chosenMarketIndex = -1
            updateUserInferface(atCase: 1)
        } else if picker.tag == 2 {
            chosenSectorIndex = -1
            updateUserInferface(atCase: 3)
        }
    }
    //updating lable for creating new market/sector
    func preparingLabelInNewMarketNewSectorView(withText text: String) {
        newMarketandNewSectorLabel.text = "Informe o nome do \(text)"
        newMarketandNewSectorLabel.textColor = .black
        newMarketandNewSectorLabel.font = UIFont(name: "Charter-Bold", size: 20)
        newMarketAndNewSectorTextField.textAlignment = .center
    }
    //message when save button is hit, but textfield is empty
    func emptyTextField () {
        let alert = UIAlertController(title: "Cadastramento cancelado", message: "Nada foi cadastrado", preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirmar", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    //hide/unhide elements
    func updateUserInferface(atCase index: Int){
        switch index {
        case 1:
            sectorLbl.isHidden = true
            sectorPicker.isHidden = true
            nameLbl.isHidden = true
            nameTextField.isHidden = true
            brandLbl.isHidden = true
            brandTextField.isHidden = true
            formOfSaleLbl.isHidden = true
            formOfSalePicker.isHidden = true
            standardQttyLbl.isHidden = true
            standarWeightTextField.isHidden = true
            fixedUnitMeasureLbl.isHidden = true
            itemPriceLabel.isHidden = true
            priceTextField.isHidden = true
            coldItemLbl.isHidden = true
            coldItemChooser.isHidden = true
            addImageButton.isHidden = true
            itemImageView.isHidden = true
            scrolViewOutlet.isScrollEnabled = false
            clearDataFormFields()
        case 2:
            sectorLbl.isHidden = false
            sectorPicker.isHidden = false
        case 3:
            nameLbl.isHidden = true
            nameTextField.isHidden = true
            brandLbl.isHidden = true
            brandTextField.isHidden = true
            formOfSaleLbl.isHidden = true
            formOfSalePicker.isHidden = true
            standardQttyLbl.isHidden = true
            standarWeightTextField.isHidden = true
            fixedUnitMeasureLbl.isHidden = true
            itemPriceLabel.isHidden = true
            priceTextField.isHidden = true
            coldItemLbl.isHidden = true
            coldItemChooser.isHidden = true
            itemImageView.isHidden = true
            addImageButton.isHidden = true
            clearDataFormFields()
        case 4:
            nameLbl.isHidden = false
            nameTextField.isHidden = false
            brandLbl.isHidden = false
            brandTextField.isHidden = false
            formOfSaleLbl.isHidden = false
            formOfSalePicker.isHidden = false
            standardQttyLbl.isHidden = false
            fixedUnitMeasureLbl.isHidden = false
            itemPriceLabel.isHidden = false
            priceTextField.isHidden = false
            coldItemLbl.isHidden = false
            itemImageView.isHidden = false
            coldItemChooser.isHidden = false
            addImageButton.isHidden = false
        case 5:
            standardQttyLbl.isHidden = false
            standarWeightTextField.isHidden = true
            fixedUnitMeasureLbl.isHidden = false
            itemPriceLabel.isHidden = false
            priceTextField.isHidden = false
            coldItemLbl.isHidden = false
            coldItemChooser.isHidden = false
            addImageButton.isHidden = false
            standarWeightTextField.reloadInputViews()
        case 6:
            standardQttyLbl.isHidden = false
            standarWeightTextField.isHidden = false
            fixedUnitMeasureLbl.isHidden = true
            itemPriceLabel.isHidden = false
            priceTextField.isHidden = false
            coldItemLbl.isHidden = false
            coldItemChooser.isHidden = false
            addImageButton.isHidden = false
            standarWeightTextField.reloadInputViews()
        case 7:
            fixedUnitMeasureLbl.isHidden = true
        case 8:
            sectorPicker.isHidden = false
        case 9:
            newMarketAndSectorSuperView.isHidden = false
            newMarketAndNewSectorTextField.text = ""
            newMarketAndNewSectorTextField.becomeFirstResponder()
        default:
            print("error")
        }
    }
    //clearing textfields/etc. when user doesnt follow the logical line for adding a new market/sector
    func clearDataFormFields() {
        nameTextField.text = ""
        brandTextField.text = ""
        formOfSalePicker.selectRow(0, inComponent: 0, animated: false)
        standarWeightTextField.text = ""
        priceTextField.text = 0.twoDigits
        itemImageView.image = nil
        newMarketAndNewSectorTextField.text = ""
    }
    //button for top bar in decimal keyboard
    @objc func doneBtn() {
        if standarWeightTextField.isFirstResponder {
            standarWeightTextField.resignFirstResponder()
            priceTextField.becomeFirstResponder()
        } else {
            textFieldsResignFirstResponder()
        }
    }
    //upadting price textField in realTime
    @objc func realTimePriceTextFieldUpdateDoubleDigitisNewItemVC(){
        priceTextField.text = (Double(priceTextField.text!.numbersOnly.integerValue)/100).twoDigits
    }
    //standard alert for missing information in the new item
    func alertForEmptyNecessaryTextFields(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirmar", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK:- KEYBOARD
    @objc func keyboardWillShow(notification: Notification) {
        scrolViewOutlet.isScrollEnabled = true
        scrolViewOutlet.bounces = false
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        self.keyboardHeight = keyboardSize!.height*(keyboardSize!.height/self.view.frame.height)
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        self.scrolViewOutlet.contentInset = contentInsets
    }
    @objc func keyboadFrame(notification: Notification) {
        DispatchQueue.main.async {
            if self.priceTextField.isFirstResponder || self.standarWeightTextField.isFirstResponder || self.newMarketAndNewSectorTextField.isFirstResponder {
                self.scrolViewOutlet.setContentOffset(CGPoint(x: 0, y: self.keyboardHeight), animated: true)
            } else {
                self.scrolViewOutlet.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    @objc func keyboardWillDisappear(notification: Notification) {
        self.scrolViewOutlet.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        scrolViewOutlet.isScrollEnabled = false
    }
    func registerToKeyboardNotificationsInNewItemVC(registerTrueAndUnregisterFalse value : Bool){
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
    func addKeyboardDismissalUponTouchOnScreen(){
        let tapToDimissKeyBoard = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapToDimissKeyBoard)
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFieldsResignFirstResponder()
    }
    //MARK:- START UP/END
    func initializationProcedures(){
        imagePicker.delegate = self
        
        marketPicker.dataSource = self
        marketPicker.delegate = self
        sectorPicker.dataSource = self
        sectorPicker.delegate = self
        formOfSalePicker.dataSource = self
        formOfSalePicker.delegate = self
        nameTextField.delegate = self
        brandTextField.delegate = self
        standarWeightTextField.delegate = self
        
        priceTextField.delegate = self
        
        newMarketAndNewSectorTextField.delegate = self
        
        addKeyboardDismissalUponTouchOnScreen()
        
        updateUserInferface(atCase: 1)
    }
    func beforeViewDisappearFunctions() {
        self.delegate?.passingNewArraysOfElements(sendMarketsArray: marketsArray)
        registerToKeyboardNotificationsInNewItemVC(registerTrueAndUnregisterFalse: false)
    }
}
