//
//  WeeklyShoppingListController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 19/11/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class WeeklyShoppingListObjectController {
    private var rowForTableView : Int = 0
    private var sectionForTableView : Int = 0
    private var marketsCounter : Int = 0
    private var sectorsCounter : Int = 0
    private var itemsCounter : Int = 0
    let marketCell = MarketItemWeeklyShoppingList()
    let sectorCell = SectorItemWeeklyShoppingList()
    let itemCell = ItemItemWeeklyShoppingListVC ()
    //variables for getting cell address outside tableview functions
    private let constantForCellAddress: Int = 10000
    private var cellAddress : Int = -1
    //univesarlObjectController
    private var uObjCtrlWeeklyVC = UniversalObjectController()
    //bottom price and item quantity labels
    private var returnString = [BottomInformationLabelsInWeeklyShoppingItemsVC : String]()
    private var toBuyPrice = 0.0
    private var toBuyQtty = 0.0
    private var boughtPrice = 0.0
    private var boughtQtty = 0.0
    
    //MARK:- START UP/END
    func getOnlyToBuyItems(withMarketsArray ary : [Market]) -> [Market] {
        var newMarketArray = [Market]()
        for m in 0..<ary.count {
            var sectorArray = [Sector]()
            for s in 0..<ary[m].getSector().count {
                var itemArrays = [Item]()
                if ary[m].getSector()[s].getItem().count > 0 {
                    for i in 0..<ary[m].getSector()[s].getItem().count {
                        print(ary[m].getSector()[s].getItem()[i].getPurchaseHistory())
                        if ary[m].getSector()[s].getItem()[i].getAddToBuyList() {
                            itemArrays.append(ary[m].getSector()[s].getItem()[i])
                        }
                    }
                }
                if itemArrays.count > 0 {
                    let sector = Sector(sectorName: ary[m].getSector()[s].getName())
                    for item in 0..<itemArrays.count {
                        sector.setItem(item: itemArrays[item])
                    }
                    sectorArray.append(sector)
                }
            }
            if sectorArray.count > 0 {
                let market = Market(marketName: ary[m].getName())
                for sector in 0..<sectorArray.count {
                    market.setSector(sector: sectorArray[sector])
                }
                newMarketArray.append(market)
            }
        }
        return newMarketArray
    }
    func emptyOnlyToBuyArray(usingMarketsArray ary : [Market]) -> [Market]{
        let emptyArray = [Market]()
        toBuyQtty = 0
        toBuyPrice = 0
        boughtPrice = 0
        boughtQtty = 0
        return emptyArray
    }
    //function for viewWillAppear
    func canLoadItemsOntoTableView(inMarketsArray ary : [Market]) -> Bool {
        itemsCounter = 0
        for m in 0..<ary.count {
            for s in 0..<ary[m].getSector().count {
                itemsCounter = itemsCounter + ary[m].getSector()[s].getItem().count
            }
        }
        print(itemsCounter)
        if itemsCounter > 0 {
            return true
        } else {
            return false
        }
    }
    //MARK:- TABLEVIEW
    //sections
    func getSectionsForTableView(inMarketsArray ary : [Market]) -> Int {
        if self.itemsCounter > 0 {
            return ary.count
        } else {
            return 0
        }
    }
    //rows
    func getRowsForTableView(inMarketsArray ary : [Market], inSection section : Int ) -> Int {
        let sectionsInMarket = ary[section].getSector()
        var numberOfRows = 0
        
        for s in 0 ..< sectionsInMarket.count {
            if sectionsInMarket[s].getItem().count > 0 {
                numberOfRows = numberOfRows + sectionsInMarket[s].getItem().count
                numberOfRows = numberOfRows + 1
            }
        }
        
        if itemsCounter == 0 {
            return 0
        } else {
            return numberOfRows
        }
    }
    //return cell height
    func returnHeightForCell(atIndexPath indexPath : IndexPath, usingMarketsArray ary: [Market]) -> CGFloat {
        let rowAndSection = uObjCtrlWeeklyVC.computeRowAndColum(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: ary)
        let itemIndex = rowAndSection.row
        if itemIndex < 0 && indexPath.row == 0 {
            return CGFloat(marketCell.hValue)
        } else if itemIndex < 0 {
            return CGFloat(sectorCell.hValue)
        } else {
            return CGFloat(itemCell.hValue)
        }
    }
    //CELL VIEWS
    func returnMarketCell(withCell cell: MarketItemWeeklyShoppingList, inMarket mkt: Int, inSector str: Int, withMarketsArray ary : [Market]) ->
        MarketItemWeeklyShoppingList {
            cell.marketName.text = ary[mkt].getName()
            cell.sectorName1stCell.text = ary[mkt].getSector()[str].getName()
            return cell
    }
    //cell for sector
    func returnSectorCell(withCell cell: SectorItemWeeklyShoppingList, inMarket mkt: Int, inSector str: Int, withMarketsArray ary : [Market]) -> SectorItemWeeklyShoppingList {
        cell.sectorName.text = ary[mkt].getSector()[str].getName()
        return cell
    }
    //cell for item
    func returnItemCell(withCell cell: ItemItemWeeklyShoppingListVC, inMarket mkt: Int, inSector str: Int, itemIndex item: Int, indexPathRow row: Int, withMarketsArray ary : [Market]) -> ItemItemWeeklyShoppingListVC {
        let itemsInfo = ary[mkt].getSector()[str].getItem()[item]
        
        cell.itemNameLbl.text = itemsInfo.getName()
        cell.quantityLbl.text = "Comprar:"
        if itemsInfo.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[1].rawValue {
            cell.quantityTxtField.text = "\(Int(itemsInfo.getFormOfSale().getItemQuantityInWeight())) unidade(s)"
        } else {
            if uObjCtrlWeeklyVC.checkIfItemIsSoldInKiloOrLiter(withDescription: itemsInfo.getFormOfSale().getUnitMeasure()) {
                cell.quantityTxtField.text = "\(itemsInfo.getFormOfSale().getItemQuantityInWeight()) \(itemsInfo.getFormOfSale().getUnitMeasure())(s)"
            } else {
                cell.quantityTxtField.text = "\(Int(itemsInfo.getFormOfSale().getItemQuantityInWeight())) \(itemsInfo.getFormOfSale().getUnitMeasure())(s)"
            }
        }
        if !itemsInfo.getPurchase() {
            cell.cellView.backgroundColor = nil
            cell.purchasedButton.setImage(nil, for: .normal)
        } else {
            cell.purchasedButton.setImage(UIImage(named: "checkMarkAppAdded"), for: .normal)
            cell.cellView.backgroundColor = uObjCtrlWeeklyVC.getUIColorForSelectedTableViewCells()
        }
        cell.singleItemPriceTxtField.text = itemsInfo.getFormOfSale().getItemPrice()
        switch itemsInfo.getFormOfSale().getUnitMeasure() {
        case UnitMeasure.averageWeight.rawValue:
            cell.singleItemPriceLbl.text = ("Preço de 1 kilo/litro:")
        case UnitMeasure.gram.rawValue, UnitMeasure.mililiter.rawValue:
            cell.singleItemPriceLbl.text = ("Preço de \(Int(itemsInfo.getFormOfSale().getStandarWeightValue())) \(itemsInfo.getFormOfSale().getUnitMeasure())s:")
        default:
            cell.singleItemPriceLbl.text = ("Preço de 1 \(itemsInfo.getFormOfSale().getUnitMeasure()):")
        }
        cell.priceTimesQuantityLbl.text = "Total:"
        cell.priceTimesQuantityTxtField.text = "\(itemsInfo.getFormOfSale().getFormattedFinalQuantityPrice())"
        cell.itemImageView.image = itemsInfo.getImage()
        let tagNumber = mkt*uObjCtrlWeeklyVC.getCellAdress()[.constantForCellAddress]!+row
        cell.purchasedButton.tag = tagNumber
        cell.seeImageButton.tag = tagNumber
        cell.itemNotes.tag = tagNumber
        return cell
    }
    //MARK:- DATA MANIPULATION
    //create array of items
    func createArrayOfItems(withMarketsArray ary: [Market]) -> [Item] {
        var itemsArray = [Item]()
        for m in 0..<ary.count{
            for s in 0..<ary[m].getSector().count {
                let counter = ary[m].getSector()[s].getItem().count
                if counter > 0 {
                    for i in 0..<ary[m].getSector()[s].getItem().count {
                        itemsArray.append(ary[m].getSector()[s].getItem()[i])
                    }
                }
            }
        }
        return itemsArray
    }
    //UPDATE MAIN ARRAY
    func updatingMainArrayForHomeVC(weeklyShoppingListMarketsArray ary: [Market]) {
        let itemsArray = createArrayOfItems(withMarketsArray: ary)
        for m in 0..<ary.count {
            for s in 0..<ary[m].getSector().count{
                if ary[m].getSector()[s].getItem().count > 0 {
                    for i in 0..<ary[m].getSector()[s].getItem().count {
                        let item = ary[m].getSector()[s].getItem()[i]
                        for ni in 0..<itemsArray.count {
                            if item.getID() == itemsArray[ni].getID() {
                                if itemsArray[ni].getPurchase() {
                                    item.setPurchase(value: false)
                                    item.setAddToBuyList(changeBoolValue: false)
                                    var array = [String]()
                                    array.append(uObjCtrlWeeklyVC.returnFormattedCurrentSystemDate())
                                    array.append(uObjCtrlWeeklyVC.returnFormattedCurrentSystemDate())
                                    if item.getFormOfSale().getUnitMeasure() == UnitMeasure.averageWeight.rawValue {
                                        array.append("\(Int(item.getFormOfSale().getItemQuantityInWeight())) unidade(s)")
                                    } else {
                                        if uObjCtrlWeeklyVC.checkIfItemIsSoldInKiloOrLiter(withDescription: item.getFormOfSale().getUnitMeasure()) {
                                            array.append("\(item.getFormOfSale().getItemQuantityInWeight()) \(item.getFormOfSale().getUnitMeasure())(s)")
                                        } else {
                                            array.append("\(Int(item.getFormOfSale().getItemQuantityInWeight())) \(item.getFormOfSale().getUnitMeasure())(s)")
                                        }
                                    }
                                    array.append(String(item.getFormOfSale().getItemPrice()))
                                    array.append(String(item.getFormOfSale().getFormattedFinalQuantityPrice()))
                                    item.setPurchaseHistory(withText: array)
                                } else {
                                    item.setPurchase(value: false)
                                    item.setAddToBuyList(changeBoolValue: false)
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    //getting cell
    func getCell(inCellAddress index : [CellAddressDictionary : Int], inTheArray ary: [Market])-> Item {
        let cellIndex = uObjCtrlWeeklyVC.computeRowAndColum(atSection: index[.marketAndSectorIndex]!, atRow: index[.itemIndex]!, inMarketArray: ary)
        let selectedCell = ary[index[.marketAndSectorIndex]!].getSector()[cellIndex.section].getItem()[cellIndex.row]
        return selectedCell
    }
    //update bottom lable when view will appear
    func setResetBottomLableVariables(usingArray ary: [Market]) -> [BottomInformationLabelsInWeeklyShoppingItemsVC : String]{
        returnVariablesToZero()
        let itemsaArray = self.createArrayOfItems(withMarketsArray: ary)
        for ni in 0..<itemsaArray.count {
            switch itemsaArray[ni].getFormOfSale().getUnitMeasureNoRawValue() {
            case .averageWeight, .single:
                if itemsaArray[ni].getPurchase() {
                    boughtQtty += itemsaArray[ni].getFormOfSale().getItemQuantityInWeight()
                    boughtPrice += itemsaArray[ni].getFormOfSale().getFinalQuantityPrice()
                }
                toBuyQtty += itemsaArray[ni].getFormOfSale().getItemQuantityInWeight()
            case .gram, .kilogram, .liter, .mililiter:
                if itemsaArray[ni].getPurchase() {
                    boughtQtty += 1
                    boughtPrice += itemsaArray[ni].getFormOfSale().getFinalQuantityPrice()
                }
                toBuyQtty += 1
            }
            toBuyPrice += itemsaArray[ni].getFormOfSale().getFinalQuantityPrice()
        }
        return updateStrinForBottomLableInformation()
    }
    //set varibales back to zero
    func returnVariablesToZero(){
        toBuyPrice = 0.0
        toBuyQtty = 0.0
        boughtPrice = 0.0
        boughtQtty = 0.0
    }
    //update bottom lable when target method for button is triggered
    func updateBottomLableInsideTargetForButton(inCellAddress index : [CellAddressDictionary : Int], withMarketsArray ary: [Market]) -> [BottomInformationLabelsInWeeklyShoppingItemsVC : String] {
        let selectedCell = self.getCell(inCellAddress: index, inTheArray: ary)
        if selectedCell.getPurchase() {
            switch selectedCell.getFormOfSale().getUnitMeasureNoRawValue() {
            case .averageWeight, .single:
                boughtQtty += selectedCell.getFormOfSale().getItemQuantityInWeight()
            default:
                boughtQtty += 1
            }
            boughtPrice += selectedCell.getFormOfSale().getFinalQuantityPrice()
        } else {
            switch selectedCell.getFormOfSale().getUnitMeasureNoRawValue() {
            case .averageWeight, .single:
                boughtQtty -= selectedCell.getFormOfSale().getItemQuantityInWeight()
            default:
                boughtQtty -= 1
            }
            boughtPrice -= selectedCell.getFormOfSale().getFinalQuantityPrice()
        }
        return updateStrinForBottomLableInformation()
    }
    //update bottomLable texts
    private func updateStrinForBottomLableInformation() -> [BottomInformationLabelsInWeeklyShoppingItemsVC : String] {
        returnString[.toBuyItemsLbl1] = "Lista contém:"
        returnString[.boughItemsLbl1] = "Já foram comprados:"
        returnString[.toBuyListPriceLbl1] = "Lista custa:"
        returnString[.boughtListPriceLbl1] = "Items comprados custam:"
        returnString[.toBuyItemsLbl2] = "\(String(uObjCtrlWeeklyVC.returnFormattedQttyInInt(formatQtty: toBuyQtty))) item(s)"
        returnString[.boughItemsLbl2] = "\(String(uObjCtrlWeeklyVC.returnFormattedQttyInInt(formatQtty: boughtQtty))) item(s)"
        returnString[.toBuyListPriceLbl2] = uObjCtrlWeeklyVC.returnFormattedCurrency(usingNumber: toBuyPrice)
        returnString[.boughtListPriceLbl2] = uObjCtrlWeeklyVC.returnFormattedCurrency(usingNumber: boughtPrice)
        return returnString
    }
    //MARK:- LAYOUT
    func updatingEditingInformationLbls(selectedCell: Item) -> [String] {
        var priceLabel = String()
        var quantityDetailsLabel = String()
        if selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[4].rawValue ||
            selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[5].rawValue {
//            itemIsSoldInKilosOrLitters = true
            priceLabel = "Preço por \(selectedCell.getFormOfSale().getUnitMeasure())"
            quantityDetailsLabel = "Informe quantos \(selectedCell.getFormOfSale().getUnitMeasure())s comprar"
        } else if selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[0].rawValue {
            priceLabel = "Preço por \(selectedCell.getFormOfSale().getUnitMeasure())"
            quantityDetailsLabel = "Informe quantas \(selectedCell.getFormOfSale().getUnitMeasure())s comprar"
        } else if selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[1].rawValue {
            priceLabel = "Preço por kilo/litro"
            quantityDetailsLabel = "Cada unidade pesa: \n \(Int(selectedCell.getFormOfSale().getStandarWeightValue()*Double(selectedCell.getFormOfSale().getDivisor()[.averageWeight]!))) grama(s)/ml(s). Informe \nquantas unidades comprar"
        } else {
            priceLabel = "Preço por \(selectedCell.getFormOfSale().getUnitMeasure())"
            quantityDetailsLabel = "Informe quantos \(selectedCell.getFormOfSale().getUnitMeasure())s comprar"
        }
        var ary = [String]()
        ary.append(priceLabel)
        ary.append(quantityDetailsLabel)
        return ary
    }
    //MARK:- TARGET METHODS
    //get image for itemImageExpandedVC
    func getItemImage(inCellAddress index : [CellAddressDictionary : Int], inMarketsArray ary: [Market]) -> UIImage {
        let selectedCell = self.getCell(inCellAddress: index, inTheArray: ary)
        return selectedCell.getImage()
    }
    //set cell as purchased
    func setOrUnsetCellAsPurhcase(inCellAddress index : [CellAddressDictionary : Int], withMarketsArray ary: [Market]) {
        let selectedCell = self.getCell(inCellAddress: index, inTheArray: ary)
        if selectedCell.getPurchase() {
            selectedCell.setPurchase(value: false)
        } else {
            selectedCell.setPurchase(value: true)
        }
    }
}
