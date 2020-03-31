////
////  SingleItemInfoVC.swift
////  MarketListApp
////
////  Created by Diego Mieth on 15/09/19.
////  Copyright © 2019 dgmieth. All rights reserved.
////
//
import UIKit
import CoreData

class SingleItemInfoVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var passedItem : Item?
    var itemObj : (Item, Int, Int, Int)?
    var marketsArray = [Market]()
    var sectorsAryForPkr = [Sector]()
    var mkt : Int = 0
    var sct : Int = 0
    var fos : Int = 0
    var it : Int = 0
    var itemTempSelectedValue : Bool?
    var itemImageSelectedImage : UIImage?
    //controller
    var objCtrlSIVC = SingleItemController()
    var uObjCtrl = UniversalObjectController()
    var dataController : DataController!
    //User interface elements
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTxtF: UITextField!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var brandTxtF: UITextField!
    @IBOutlet weak var marketLbl: UILabel!
    @IBOutlet weak var marketPkr: UIPickerView!
    @IBOutlet weak var sectorLbl: UILabel!
    @IBOutlet weak var formOfSaleLbl: UILabel!
    @IBOutlet weak var sectorPkr: UIPickerView!
    @IBOutlet weak var formOfsalePkr: UIPickerView!
    @IBOutlet weak var standardWeightLbl: UILabel!
    @IBOutlet weak var setStandardWeightTxtF: UITextField!
    @IBOutlet weak var unitMeasureLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceTxtF: UITextField!
    @IBOutlet weak var coldLbl: UILabel!
    @IBOutlet weak var coldSwt: UISwitch!
    @IBOutlet weak var pictureImg: UIImageView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var purchasedHistoryBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var sceneScrolView: UIScrollView!
    
    //decimal keyboard toolbar
    var decimalKeyTooblar : UIToolbar?
    var keyboardHeight = CGFloat()
    //image picker
    let imagePicker = UIImagePickerController()
    
    //MARK:- VIEW LOADING
    override func viewWillAppear(_ animated: Bool) {
        if let hasItem = passedItem {
            itemObj = objCtrlSIVC.getItemInfo(fromItem: hasItem, inMakertsArray: marketsArray)
            prepareSectorPicker(inCase: 3)
            gettingRowNumberForPikers(fromCellInformation: itemObj!)
            keyboardNotificationRegistration(registerTrueAndUnregisterFalse: true)
            userInterfaceUpdateFunction(giveUpdateIdentifier: 1)
        } else {
            print("ERROR | SINGLEITEMINFOVC | VIEWWILLAPPEAR | selectedCellInformation had NIL")
        }
    }
    override func viewDidLoad() {
        settingTheDelegates()
    }
    override func viewWillDisappear(_ animated: Bool) {
        keyboardNotificationRegistration(registerTrueAndUnregisterFalse: false)
    }
    //MARK:- PICKER VIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            prepareSectorPicker(inCase: 1)
            return objCtrlSIVC.returnNumberOfRowsInComponent(withPicker: pickerView, inMarketsArray: marketsArray)
        } else if pickerView.tag == 2 {
            return objCtrlSIVC.returnNumberOfRowsInComponent(withPicker: pickerView, inMarketsArray: sectorsAryForPkr)
        } else if pickerView.tag == 3 {
            return objCtrlSIVC.returnNumberOfRowsInComponent(withPicker: pickerView, inMarketsArray: UnitMeasure.allCases)
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView.tag == 1 {
            return objCtrlSIVC.returnViewForRows(withPicker: pickerView, inMarketsArray: marketsArray, inRow: row)
        } else if pickerView.tag == 2 {
            return objCtrlSIVC.returnViewForRows(withPicker: pickerView, inMarketsArray: sectorsAryForPkr, inRow: row)
        } else {
            return objCtrlSIVC.returnViewForRows(withPicker: pickerView, inMarketsArray: marketsArray, inRow: row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            prepareSectorPicker(inCase: 2)
        } else if pickerView.tag == 3 {
            updateLablesAccordingToFormOfSalePickerViewInformation(atRow: row)
        }
    }
    //MARK:- LAYOUT
    func userInterfaceUpdateFunction(giveUpdateIdentifier x: Int, withBool vl: Bool = true){
        let cell = itemObj!.0
        switch x {
        //user inteface when view Loads
        case 1:
            nameTxtF.text = cell.getName()
            if cell.getBrand().hasValue {
                brandTxtF.text = cell.getBrand().Value
            }
            switch cell.getFormOfSale().getUnitMeasureNoRawValue() {
            case .averageWeight:
                unitMeasureLbl.isHidden = true
                setStandardWeightTxtF.isHidden = false
                standardWeightLbl.text = "Gramas/ml por unidade:"
                setStandardWeightTxtF.text = "\(Int((cell.getFormOfSale().getStandarWeightValue()*Double(cell.getFormOfSale().getDivisor()[.averageWeight]!)))) "
            case .gram, .mililiter:
                unitMeasureLbl.isHidden = false
                setStandardWeightTxtF.isHidden = true
                unitMeasureLbl.text = "\(String(Int(cell.getFormOfSale().getStandarWeightValue()))) \(uObjCtrl.returnUnitMeasureInString(forNumber: cell.getFormOfSale().getUnitMeasure()))s"
                standardWeightLbl.text = "Peso/volume padrao:"
            default:
                unitMeasureLbl.isHidden = false
                setStandardWeightTxtF.isHidden = true
                unitMeasureLbl.text = "\(Int(cell.getFormOfSale().getStandarWeightValue())) \(uObjCtrl.returnUnitMeasureInString(forNumber: cell.getFormOfSale().getUnitMeasure()))"
                standardWeightLbl.text = "Peso/volume padrao:"
            }
            gettingRowNumberForPikers(fromCellInformation: itemObj!, animated: true)
            //            (withInformationFromCell: itemObj!, animated: true)
            priceTxtF.text = cell.getFormOfSale().getItemPriceDoubleToString()
            //                cell.getFormOfSale().getItemPrice()
            coldSwt.isOn = cell.getItemTemp()
            if let img = itemImageSelectedImage {
                pictureImg.image = img
            } else {
                pictureImg.image = cell.getImage()
            }
        //user interface when edit is pressed
        case 2:
            nameTxtF.isEnabled = true
            nameTxtF.backgroundColor = UIColor.white
            nameTxtF.borderStyle = .roundedRect
            brandTxtF.isEnabled = true
            brandTxtF.backgroundColor = UIColor.white
            brandTxtF.borderStyle = .roundedRect
            priceTxtF.isEnabled = true
            priceTxtF.backgroundColor = UIColor.white
            priceTxtF.borderStyle = .roundedRect
            if itemObj!.0.getFormOfSale().getUnitMeasureNoRawValue() == UnitMeasure.averageWeight {
                setStandardWeightTxtF.isEnabled = true
                setStandardWeightTxtF.backgroundColor = UIColor.white
                setStandardWeightTxtF.borderStyle = .roundedRect
            }
            marketPkr.isUserInteractionEnabled = true
            sectorPkr.isUserInteractionEnabled = true
            formOfsalePkr.isUserInteractionEnabled = true
            coldSwt.isEnabled = true
            photoBtn.isHidden = false
            editBtn.isEnabled = false
            saveBtn.isHidden = false
            cancelBtn.isHidden = false
            purchasedHistoryBtn.isHidden = true
            purchasedHistoryBtn.isEnabled = false
            deleteBtn.isHidden = false
        //cancel pressed
        case 3:
            nameTxtF.isEnabled = false
            nameTxtF.backgroundColor = nil
            nameTxtF.borderStyle = .none
            brandTxtF.isEnabled = false
            brandTxtF.backgroundColor = nil
            brandTxtF.borderStyle = .none
            priceTxtF.isEnabled = false
            priceTxtF.backgroundColor = nil
            priceTxtF.borderStyle = .none
            if itemObj!.0.getFormOfSale().getUnitMeasureNoRawValue() == UnitMeasure.averageWeight {
                setStandardWeightTxtF.isEnabled = false
                setStandardWeightTxtF.backgroundColor = nil
                setStandardWeightTxtF.borderStyle = .none
            }
            marketPkr.isUserInteractionEnabled = false
            sectorPkr.isUserInteractionEnabled = false
            formOfsalePkr.isUserInteractionEnabled = false
            coldSwt.isEnabled = false
            photoBtn.isHidden = true
            editBtn.isEnabled = true
            saveBtn.isHidden = true
            cancelBtn.isHidden = true
            purchasedHistoryBtn.isHidden = false
            purchasedHistoryBtn.isEnabled = true
            deleteBtn.isHidden = true
        //update interface depeding on the row from FormOfSale Picker
        case 4:
            if vl {
                unitMeasureLbl.isHidden = vl
                setStandardWeightTxtF.isHidden = !vl
                setStandardWeightTxtF.isEnabled = vl
                setStandardWeightTxtF.backgroundColor = UIColor.white
                setStandardWeightTxtF.borderStyle = .roundedRect
            } else {
                unitMeasureLbl.isHidden = vl
                setStandardWeightTxtF.isHidden = !vl
                setStandardWeightTxtF.isEnabled = vl
                setStandardWeightTxtF.backgroundColor = nil
                setStandardWeightTxtF.borderStyle = .none
            }
        default:
            print("ERROR | SINGLEITEMINFOVC | userInterfaceUpdateFunction | no parameter passed or passed parameter did not find match")
        }
    }
    //update lables according to formOfsale Picker information
    func updateLablesAccordingToFormOfSalePickerViewInformation (atRow row : Int = 0) {
        let cell = itemObj!.0
        if row == 1 {
            userInterfaceUpdateFunction(giveUpdateIdentifier: 4, withBool: true)
            standardWeightLbl.text = "Gramas/ml por unidade:"
            priceLbl.text = ("Preço (em kilo/litro)")
            if cell.getFormOfSale().getUnitMeasureNoRawValue() != UnitMeasure.averageWeight {
                setStandardWeightTxtF.text = ""
            } else {
                setStandardWeightTxtF.text = "\(Int((cell.getFormOfSale().getStandarWeightValue()*Double(cell.getFormOfSale().getDivisor()[.averageWeight]!)))) "
            }
        } else {
            userInterfaceUpdateFunction(giveUpdateIdentifier: 4, withBool: false)
            standardWeightLbl.text = "Peso/volume padrão: "
            switch UnitMeasure.allCases[row] {
            case .gram, .mililiter:
                unitMeasureLbl.text = "\(Int(cell.getFormOfSale().getDivisor()[.gram]!)) \(uObjCtrl.returnUnitMeasureInString(forNumber: row))s"
                priceLbl.text = ("Preço (\(uObjCtrl.returnUnitMeasureInString(forNumber: row)))")
            default:
                unitMeasureLbl.text = "1 \(uObjCtrl.returnUnitMeasureInString(forNumber: row))"
                priceLbl.text = ("Preço (\(uObjCtrl.returnUnitMeasureInString(forNumber: row))))")
            }
        }
    }
    
    //MARK:- BUTTONS
    //allow edition
    @IBAction func editPressed(_ sender: Any) {
        userInterfaceUpdateFunction(giveUpdateIdentifier: 2)
    }
    //save changes
    @IBAction func savePressed(_ sender: Any) {
        checkNewInformation()
        userInterfaceUpdateFunction(giveUpdateIdentifier: 3)
        saveModel()
    }
    //discaBrd changes
    @IBAction func cancelPressed(_ sender: Any) {
        clearEdittedInformationWhenCancelledPressed()
        userInterfaceUpdateFunction(giveUpdateIdentifier: 3)
        userInterfaceUpdateFunction(giveUpdateIdentifier: 1)
    }
    //purchase history
    @IBAction func purchaseHistoryPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToPurchaseHistoryVC", sender: self)
    }
    //take picture
    @IBAction func takePhotoPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    //cold switch
    @IBAction func coldSwitchPressed(_ sender: Any) {
        let cell = itemObj!.0
        itemTempSelectedValue = !cell.getItemTemp()
    }
    //expand image
    @IBAction func expandImagePressed(_ sender: Any) {
        performSegue(withIdentifier: "goToImageExpandedSIVC", sender: self)
    }
    //delete item
    @IBAction func deleteBtnPressed(_ sender: Any) {
        deleteFromModel(item: itemObj!.0, goToItemsMercadoVC: true)
    }
    //MARK:- TEXTFIELDS
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        if textField.tag == 4 {
            priceTxtF.addTarget(self, action: #selector(realTimePriceTextFieldUpdateDoubleDigitisSingleItemVC), for: UIControl.Event.editingChanged)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag < 3 {
            return true
        } else if textField.tag >= 3  {
            textField.keyboardType = .numberPad
            if decimalKeyTooblar == nil {
                decimalKeyTooblar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
            }
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnSingleItemVC))
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
            brandTxtF.becomeFirstResponder()
        } else if textField.tag == 2 {
            textField.resignFirstResponder()
            if formOfsalePkr.selectedRow(inComponent: 0) == 1 {
                setStandardWeightTxtF.becomeFirstResponder()
            } else {
                priceTxtF.becomeFirstResponder()
            }
        } else if textField.tag == 3 {
            textField.resignFirstResponder()
            priceTxtF.becomeFirstResponder()
        } else if textField.tag == 4 {
            textField.resignFirstResponder()
        }
        return true
    }
    //upadting price textField in realTime
    @objc func realTimePriceTextFieldUpdateDoubleDigitisSingleItemVC(){
        priceTxtF.text = (Double(priceTxtF.text!.numbersOnly.integerValue)/100).twoDigits
    }
    //MARK:- KEYBOARD
    @objc func keyboardWillShow(notification: Notification) {
        sceneScrolView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        self.keyboardHeight = keyboardSize!.height*(keyboardSize!.height/self.view.frame.height)
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        self.sceneScrolView.contentInset = contentInsets
    }
    @objc func keyboadFrame(notification: Notification) {
        DispatchQueue.main.async {
            if self.priceTxtF.isFirstResponder || self.setStandardWeightTxtF.isFirstResponder {
                self.sceneScrolView.setContentOffset(CGPoint(x: 0, y: self.keyboardHeight), animated: true)
            } else {
                self.sceneScrolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
    @objc func keyboardWillDisappear(notification: Notification) {
        self.sceneScrolView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        sceneScrolView.isScrollEnabled = false
    }
    func keyboardNotificationRegistration(registerTrueAndUnregisterFalse value : Bool){
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
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) { textFieldsResignFirstResponder() }
    //button for top bar in decimal keyboard
    @objc func doneBtnSingleItemVC() {
        if setStandardWeightTxtF.isFirstResponder {
            setStandardWeightTxtF.resignFirstResponder()
            priceTxtF.becomeFirstResponder()
        } else { textFieldsResignFirstResponder() }
    }
    func textFieldsResignFirstResponder(){
        nameTxtF.resignFirstResponder()
        brandTxtF.resignFirstResponder()
        setStandardWeightTxtF.resignFirstResponder()
        priceTxtF.resignFirstResponder()
    }
    //MARK:- IMAGE PICKER
    //did finish picking imagem and image resizing and imagepicker dismissal
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let x = info[UIImagePickerController.InfoKey.originalImage] {
            if let data = objCtrlSIVC.resize(image: x as! UIImage) {
                itemImageSelectedImage = UIImage(data: data)!
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //MARK:- DATA MANIPULATION
    func clearEdittedInformationWhenCancelledPressed(){
        itemTempSelectedValue = nil
        itemImageSelectedImage = nil
    }
    func checkNewInformation(){
        let cell = itemObj!.0
        //check if names are equal
        if nameTxtF.text! != cell.getName() {
            cell.setName(itsNameIs: nameTxtF.text!)
        }
        //check if there is brand and/or brands are equal
        if !brandTxtF.text!.isEmpty && !cell.getBrand().hasValue {
            cell.setBrand(itsBrandIs: brandTxtF.text!)
        } else if cell.getBrand().hasValue {
            if brandTxtF.text! != cell.getBrand().Value {
                cell.setBrand(itsBrandIs: brandTxtF.text!)
            }
        }
        //check if marketIndex or sector index is equal to the one passed from itemsMercadoVC
        if itemObj!.1 != marketPkr.selectedRow(inComponent: 0) || itemObj!.2 != sectorPkr.selectedRow(inComponent: 0) {
            itemObj = objCtrlSIVC.updateAryIfMarketOrSectorIndexDifFromSelectedItem(inMarketArray: marketsArray, withItem: (itemObj!, marketPkr.selectedRow(inComponent: 0) , sectorPkr.selectedRow(inComponent: 0), formOfsalePkr.selectedRow(inComponent: 0)))
            saveModel()
        }
        //if user changed formOfSale
        if itemObj!.0.getFormOfSale().getUnitMeasure() != formOfsalePkr.selectedRow(inComponent: 0){
            cell.getFormOfSale().setUnitMeasure(howItIsSold: UnitMeasure.allCases[formOfsalePkr.selectedRow(inComponent: 0)])
            if formOfsalePkr.selectedRow(inComponent: 0) == 1 {
                cell.getFormOfSale().setStandardWeight(standarWeightIs: setStandardWeightTxtF.text!)
            } else {
                cell.getFormOfSale().setStandardWeight()
            }
        }
        //check if user change price
        if uObjCtrl.isTherePrice(inTextField: priceTxtF.text).0 {
            if uObjCtrl.isTherePrice(inTextField: priceTxtF.text).1 != cell.getFormOfSale().getItemPriceDoubleToString() {
                cell.getFormOfSale().setItemPriceStringToDouble(howMuchIsIt: priceTxtF.text!)
            }
        }
        //check if item is sold in average weight
        if formOfsalePkr.selectedRow(inComponent: 0) == 1 {
              cell.getFormOfSale().setStandardWeight(standarWeightIs: setStandardWeightTxtF.text!)
          } else {
              cell.getFormOfSale().setStandardWeight()
          }
        //check if user changed temp value
        if let temp = itemTempSelectedValue {
            cell.setItemTemp(isItCold: temp)
        }
        //check if user changed picture
        if let photo = itemImageSelectedImage {
            cell.setImage(useImage: photo)
        }
    }
    func prepareSectorPicker(inCase x: Int){
        if x == 1 {
            sectorsAryForPkr = marketsArray[marketPkr.selectedRow(inComponent: 0)].getSector()
        } else if x == 2 {
            sectorsAryForPkr = marketsArray[marketPkr.selectedRow(inComponent: 0)].getSector()
            sectorPkr.reloadComponent(0)
            sectorPkr.selectRow(0, inComponent: 0, animated: true)
        } else if x==3 {
            sectorsAryForPkr = marketsArray[itemObj!.1].getSector()
            sectorPkr.selectRow(itemObj!.2, inComponent: 0, animated: true)
        }
    }
    //MARK:- SEGUEWAYS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImageExpandedSIVC" {
            let destinationVC = segue.destination as! ItemImageExpandedVC
            destinationVC.selectedCellImage = itemObj!.0.getImage()
        } else if segue.identifier == "goToPurchaseHistoryVC" {
            let destinationVC = segue.destination as! ItemPurchaseHistoryVC
            destinationVC.passedItem = itemObj!.0
        }
    }
    //MARK: START UP/END
    func gettingRowNumberForPikers(fromCellInformation info: (Item, Int, Int, Int), animated vl : Bool = false) {
        prepareSectorPicker(inCase: 3)
        marketPkr.selectRow(info.1, inComponent: 0, animated: vl)
        sectorPkr.selectRow(info.2, inComponent: 0, animated: vl)
        formOfsalePkr.selectRow(info.3, inComponent: 0, animated: vl)
    }
    func settingTheDelegates(){
        marketPkr.delegate = self
        marketPkr.dataSource = self
        sectorPkr.delegate = self
        sectorPkr.dataSource = self
        formOfsalePkr.delegate = self
        formOfsalePkr.dataSource = self
        nameTxtF.delegate = self
        brandTxtF.delegate = self
        priceTxtF.delegate = self
        setStandardWeightTxtF.delegate = self
        
        imagePicker.delegate = self
        
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
    }
}
//MARK:- COREDATA
extension SingleItemInfoVC{
    func saveModel(goToItemsMercadoVC value: Bool = false){
        do{
            try dataController.viewContext.save()
            print("saved")
        } catch {
            print(error.localizedDescription)
            print("notsaved")
        }
        updateArray()
        value ? navigationController?.popViewController(animated: true) : nil
    }
    func updateArray(){
        let fetchRequest = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderingID", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            marketsArray = results
        }
    }
    func deleteFromModel(item: Item, goToItemsMercadoVC value: Bool = false){
        dataController.viewContext.delete(item)
        saveModel(goToItemsMercadoVC: value)
    }
}

