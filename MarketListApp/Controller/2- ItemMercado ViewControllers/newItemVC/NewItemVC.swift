//
//  NewItemVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 18/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit
import CoreData

class NewItemVC : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var marketsArray = [Market]()
    var sectorsArray = [Sector]()
    var chosenMarketIndex : Int = -1
    var chosenSectorIndex : Int = -1
    var pickerTag = Int()
    let fontSizePkrView : CGFloat = 23
    let uObjCtrl = UniversalObjectController()
    var dataController:DataController!
    let imagePicker = UIImagePickerController()
    //decimal keyboard toolbar
    var decimalKeyTooblar : UIToolbar?
    var keyboardHeight = CGFloat()
 
    @IBOutlet weak var scrolViewOutlet: UIScrollView!
    @IBOutlet weak var newMarketAndSectorSuperView: UIView!
    @IBOutlet weak var newMarketandNewSectorLabel: UILabel!
    @IBOutlet weak var newMarketAndNewSectorTextField: UITextField!
    @IBOutlet weak var saveNewMarketAndSectorButton: UIButton!
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
}
//MARK:- VC INATE FUNCTIONS
extension NewItemVC{
    override func viewDidLoad() {
        loadFunction()
    }
    override func viewDidDisappear(_ animated: Bool) {
        beforeViewDisappearFunctions()
    }
}
//MARK:- PICKER VIEW
extension NewItemVC{
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
            return UILabel()
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return fontSizePkrView
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        actionsForDidSelectRowAt(withPicker: pickerView, atRow: row)
    }
}
//MARK: PICKERVIEW SUBFUNCTIONS
extension NewItemVC {
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
        if picker.tag == 1 {
            let ary = ary as! [Market]
            switch row {
            case 0:
                return lblForPickerRows(forPkrRow: .first, inPkr: picker, withText: "mercado")
            case ary.count + 1:
                return lblForPickerRows(forPkrRow: .last, inPkr: picker, withText: "mercado")
            default:
                return lblForPickerRows(forPkrRow:.other, inPkr: picker, withText: ary[row - 1].getName())
            }
        } else if picker.tag == 2 {
            let ary = ary as! [Sector]
            switch row {
            case 0:
                return lblForPickerRows(forPkrRow: .first, inPkr: picker, withText: "setor")
            case ary.count + 1:
                return lblForPickerRows(forPkrRow: .last, inPkr: picker, withText: "setor")
            default:
                return lblForPickerRows(forPkrRow: .other, inPkr: picker, withText: ary[row - 1].getName())
            }
        } else /*if picker.tag == 3*/ {
            return lblForPickerRows(forPkrRow: .other, inPkr: picker, withText: uObjCtrl.returnUnitMeasureInString(forNumber: UnitMeasure.allCases[row].rawValue), atRow: row)
        }
    }
    //return lable for picker view rows
    func lblForPickerRows(forPkrRow row : RowForPickerInNewItemVC, inPkr pkr: UIPickerView, withText text: String, atRow rowPkr3 : Int = 0) -> UILabel {
        let genericLbl = UILabel()
        genericLbl.textAlignment = .center
        genericLbl.textColor = .black
        genericLbl.font = UIFont(name: "Charter-Italic", size: fontSizePkrView)
        switch row {
        case .first:
            genericLbl.text = "Escolha um \(text)"
        case .last:
            genericLbl.text = "Novo \(text)"
        case .other:
            if pkr.tag == 3 && rowPkr3 == 1 {
                genericLbl.font = UIFont(name: "Charter-Bold", size: fontSizePkrView-3)
                genericLbl.text = text
            } else {
                genericLbl.font = UIFont(name: "Charter-Bold", size: fontSizePkrView)
                genericLbl.text = text
            }
        }
        return genericLbl
    }
    //return selected row at
    func actionsForDidSelectRowAt(withPicker pickerView: UIPickerView, atRow row: Int){
        if pickerView.tag == 1 {
            if row == 0 {
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else if row == marketsArray.count + 1 {
                newMarketNewSector(informarMarketOrSector: "market")
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else {
                reloadPicker(informMarketOrPicker: "sector", withRow: row)
                updateUserInferface(atCase: 2)
            }
        } else if pickerView.tag == 2 {
            if row == 0 {
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else if row == sectorsArray.count + 1 {
                newMarketNewSector(informarMarketOrSector: "sector")
                hideUserLayoutIfPickerRowIsZero(inPicker: pickerView)
            } else {
                chosenSectorIndex = row - 1
                updatePriceAndQuantityLblInfo()
                updateUserInferface(atCase: 4)
            }
        } else if pickerView.tag == 3{
            updatePriceAndQuantityLblInfo(atRow: row)
            if row == 1 {
                updateUserInferface(atCase: 6)
            } else {
                updateUserInferface(atCase: 5)
            }
        }
    }
    //reload market picker
    func reloadPicker(informMarketOrPicker info : String, withRow row : Int = 0) {
        if info == "market" {
            marketPicker.reloadAllComponents()
            marketPicker.selectRow(0, inComponent: 0, animated: true)
        }else if info == "sector" {
            if row > 0 {
                sectorsArray = marketsArray[row - 1].getSector()
                chosenMarketIndex = row - 1
                updateUserInferface(atCase: 8)
            }
            sectorPicker.reloadAllComponents()
            sectorPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
}
//MARK:- BUTTONS
extension NewItemVC {
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
        if !newMarketAndNewSectorTextField.text!.isEmpty {
            if pickerTag == 1 {
                let newMarket = Market(context: dataController.viewContext)
                newMarket.name = newMarketAndNewSectorTextField.text!
                newMarket.setOredringId(setAt: marketsArray.count)
                saveModel()
                reloadPicker(informMarketOrPicker: "market")
            }  else if pickerTag == 2 {
                let newSector = Sector(context: dataController.viewContext)
                newSector.name = newMarketAndNewSectorTextField.text!
                newSector.market = marketsArray[chosenMarketIndex]
                newSector.setOredringId(setAt: marketsArray[chosenMarketIndex].getSector().count)
                saveModel()
                sectorsArray = marketsArray[chosenMarketIndex].getSector()
                reloadPicker(informMarketOrPicker: "sector")
            }
        }   else {
            emptyTextFieldAlert()
        }
        pickerTag = 0
        newMarketAndNewSectorTextField.text = ""
        newMarketAndNewSectorTextField.resignFirstResponder()
    }
    //adding new item in array
    @IBAction func addButtonPressed(_ sender: Any) {
        if returnCanSaveItem().canSave {
            let ary = returnCanSaveItem().ary
            let newItem = Item(context: dataController.viewContext)
            newItem.sector = marketsArray[chosenMarketIndex].getSector()[chosenSectorIndex]
            newItem.setOredringId(setAt: marketsArray[chosenMarketIndex].getSector()[chosenSectorIndex].getItem().count)
            newItem.setName(itsNameIs: ary[.name]!.value)
            newItem.brand = ary[.brand]!.hasValue ? ary[.brand]!.value : ""
            let newFormOfSale = FormOfSale(context: dataController.viewContext)
            newFormOfSale.item = newItem
            newFormOfSale.setUnitMeasure(howItIsSold: UnitMeasure.allCases[Int(ary[.soldBy]!.value)!])
            newFormOfSale.setItemPriceStringToDouble(howMuchIsIt: ary[.price]!.value)
            newFormOfSale.setStandardWeight(standarWeightIs: ary[.avgWeight]!.value)
            newItem.setItemTemp(isItCold: coldItemChooser.isOn)
            if let image = itemImageView.image {
                newItem.setImage(useImage: image)
            }
            newItem.addOneitemInMarketAndSectorCounter()
            saveModel(goToItemsMercadoVC: true)
        } else {
            print("ERROR in addButtonPressed code")
        }
    }
    //cancelling new item and dimissing newItemVC
    @IBAction func cancelButtonPressed(_ sender: Any) {
        saveModel(goToItemsMercadoVC: true)
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
        
    }
}
//MARK:- BUTTONS SUBFUNCTIONS
extension NewItemVC{
    //creating new sector
    func newMarketNewSector(informarMarketOrSector value : String){
        updateUserInferface(atCase: 9)
        if value == "sector" {
            pickerTag = 2
            textForPopUpWindowNewMarketSector(withText: "setor")
        } else if value == "market" {
            pickerTag = 1
            textForPopUpWindowNewMarketSector(withText: "mercado")
        }
    }
    //creating new item
    func returnCanSaveItem() -> (canSave: Bool, ary: [ValueFor : (hasValue: Bool, value: String)]) {
        let results = getInformationFromFields()
        if !results[.market]!.hasValue {
            alertForEmptyNecessaryTextFields(title: "Mercado não selecionado", message: "Selecione o mercado")
            return (false, results)
        } else if !results[.sector]!.hasValue {
            alertForEmptyNecessaryTextFields(title: "Setor não selecionado", message: "Selecione o setor")
            return (false, results)
        } else if !results[.name]!.hasValue {
            alertForEmptyNecessaryTextFields(title: "Item sem nome", message: "Informe o nome do item")
            return (false, results)
        } else if !results[.sector]!.hasValue {
            alertForEmptyNecessaryTextFields(title: "Setor não selecionado", message: "Selecione o setor")
            return (false, results)
        } else if formOfSalePicker.selectedRow(inComponent: 0) == 1 {
            if !results[.avgWeight]!.hasValue {
                alertForEmptyNecessaryTextFields(title: "Item sem peso médio", message: "Informe o peso médio por unidade")
                return (false, results)
            }
        } else if !results[.price]!.hasValue {
            alertForEmptyNecessaryTextFields(title: "Item sem preço", message: "Informe o preço do item")
            return (false, results)
        }
            return (true, results)
    }
    func getInformationFromFields()->[ValueFor : (hasValue: Bool, value: String)]{
        var ary = [ValueFor : (hasValue: Bool, value: String)]()
        ary[.market] = marketPicker.selectedRow(inComponent: 0) > 0 ? (true, "\(marketPicker.selectedRow(inComponent: 0)-1)") :(false, "")
        ary[.sector] = sectorPicker.selectedRow(inComponent: 0) > 0 ? (true, "\(sectorPicker.selectedRow(inComponent: 0)-1)") :(false, "")
        ary[.name] = uObjCtrl.isThereText(inTextField: nameTextField.text)
        ary[.brand] = uObjCtrl.isThereText(inTextField: brandTextField.text)
        ary[.soldBy] = formOfSalePicker.selectedRow(inComponent: 0) >= 0 ? (true, "\(formOfSalePicker.selectedRow(inComponent: 0))") :(false, "")
        ary[.avgWeight] = uObjCtrl.isThereText(inTextField: standarWeightTextField.text)
        ary[.price] = uObjCtrl.isTherePrice(inTextField: priceTextField.text).0 ? (true, priceTextField.text!) : (false, "")
        print(ary[.price])
        ary[.cold] = coldItemChooser.isOn ? (true, "") : (false, "")
        return ary
    }
}
//MARK:- CORE DATA
extension NewItemVC{
    func saveModel(goToItemsMercadoVC value: Bool = false){
        do{
            try dataController.viewContext.save()
            print("saved")
        } catch {
            print("notsaved")
        }
        updateArray()
        if value {
            navigationController?.popViewController(animated: true)
        }
    }
    func updateArray(){
        let fetchRequest = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderingID", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            marketsArray = results
        }
    }
}
//MARK:- TEXTFIELD
extension NewItemVC{
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
                reloadPicker(informMarketOrPicker: "market")
            } else if chosenSectorIndex == -1 {
                reloadPicker(informMarketOrPicker: "sector")
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
}
//MARK:- ALERTS CONTROLLER
extension NewItemVC{
    //standard alert for missing information in the new item
    func alertForEmptyNecessaryTextFields(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirmar", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
//MARK:- KEYBOARD
extension NewItemVC {
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
}
//MARK:- NOTIFICATIONS REGISTRATION
extension NewItemVC{
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
}
//MARK:- @OBJ METHODS
extension NewItemVC{
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFieldsResignFirstResponder()
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
}
//MARK:- IMAGE PICKER CONTROLLER
extension NewItemVC{
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
}
//MARK:- LOADING/UNLOADING FUNCTIONS
extension NewItemVC{
    func loadFunction(){
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
        
        registerToKeyboardNotificationsInNewItemVC(registerTrueAndUnregisterFalse: true)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
        updateUserInferface(atCase: 1)
    }
    func beforeViewDisappearFunctions() {
        saveModel()
//        saveAndCallDelegate()
        registerToKeyboardNotificationsInNewItemVC(registerTrueAndUnregisterFalse: false)
    }
}
//MARK:- LAYOUT
extension NewItemVC{
    //upadting lables: standardQttyLbl and itemPriceLabel
    func updatePriceAndQuantityLblInfo(atRow row : Int = 0) {
        if row == 1 {
            standardQttyLbl.text = "Gramas/ml por unidade:"
            itemPriceLabel.text = ("Preço (em kilo/litro)")
        } else {
            standardQttyLbl.text = "Peso/volume padrão: "
            let text = uObjCtrl.returnUnitMeasureInString(forNumber: row)
            switch UnitMeasure.allCases[row] {
            case .gram, .mililiter:
                fixedUnitMeasureLbl.text = "\(Int(Divisors.gramMililiterDivisor.rawValue)) \(text)s"
            default:
                fixedUnitMeasureLbl.text = "1 \(text)"
            }
            itemPriceLabel.text = ("Preço (\(text))")
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
    func textForPopUpWindowNewMarketSector(withText text: String) {
        newMarketandNewSectorLabel.text = "Informe o nome do \(text)"
        newMarketandNewSectorLabel.textColor = .black
        newMarketandNewSectorLabel.font = UIFont(name: "Charter-Bold", size: 20)
        newMarketAndNewSectorTextField.textAlignment = .center
    }
    //message when save button is hit, but textfield is empty
    func emptyTextFieldAlert () {
        let alert = UIAlertController(title: "Cadastramento cancelado", message: "Nada foi cadastrado", preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirmar", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    //hide/unhide elements
    func updateUserInferface(atCase index: Int, withPiker pkr : UIPickerView = UIPickerView()){
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
}
