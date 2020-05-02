//
//  ItemsMercadoVCController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 05/10/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import CoreData
import UIKit

class itemsMercadoObjectController {
    private var uObjCtrl = UniversalObjectController()
    private let marketCell = MarketHeaderCell()
    private let sectorCell = CellForSectorInTableViews()
    private let itemCell = CellForItemInTableViews ()
    //universal object Controller
    private var dataController : DataController?
    
    
    //MARK:- START UP/END
    func getArrayWithItemsOnly(inMarketsArray ary : [Market]) -> [Market]? {
        if checkMarketHasItems(inArray: ary) {
            var fullArray = [Market]()
            for m in 0..<ary.count {
                if ary[m].getHasItems() {
                    let market = ary[m]
                    fullArray.append(market)
                }
            }
            return fullArray
        }
        return nil
    }
}
//MARK:- TABLEVIEW
extension itemsMercadoObjectController{
    func getSectionsForTableView(inMarketsArray ary : [Market]) -> Int {
        return checkMarketHasItems(inArray: ary) ? ary.count : 1
    }
    func getRowsForTableView(inMarketsArray ary : [Market], inSection section : Int ) -> Int {
        var numberOfRows = 0
        if checkMarketHasItems(inArray: ary) {
            for s in 0 ..< ary[section].getSector().count {
                if ary[section].getSector()[s].getItem().count > 0 {
                    numberOfRows = numberOfRows + ary[section].getSector()[s].getItem().count
                    numberOfRows = numberOfRows + 1 }   }
            return ary[section].isOpened() ? numberOfRows : 0 }
        return 1
    }
    
    func returnCell(withCell cell: Any, withCellType type: TVCellType, withArray ary : [Market] = [Market](), searchBarArray searchAry: [Item] = [Item](), inMarket market: Int = 0, inSector sector: Int = 0, itemLocator item: Int = 0, rowForCellTag row: Int = 0) -> Any {
        if type == .market {
            let mCell = cell as! MarketHeaderCell
            mCell.marketNameLbl.text = ary[market].getName()
            mCell.tappedBtn.tag = market
            mCell.itemsQttLbl.text = "\(ary[market].getQttOfItems()) item(s)"
            return mCell
        } else if type == .sector {
            let sCell = cell as! CellForSectorInTableViews
            sCell.sectorNameLbl.text = ary[market].getSector()[sector].getName()
            sCell.sideLable.text = !ary[market].getSector()[sector].isOpened() ? "\(ary[market].getSector()[sector].qttyOfItems) item(s)" : "Comprar \n↓"
            return sCell
        } else if type == .item {
            let iCell = cell as! CellForItemInTableViews
            let item = ary[market].getSector()[sector].getItem()[item]
            let soldBy = uObjCtrl.returnUnitMeasureInString(forNumber: Int(item.getFormOfSale().getUnitMeasure()))
            
            iCell.namLbl.text = "\(item.getOrderingID())- \(item.getName())"
            if item.getBrand().hasValue {
                iCell.information1InfoLbl.text = item.getBrand().Value
                iCell.information1InfoLbl.font = UIFont(name: "Charter", size: 15)
            } else {
                iCell.information1InfoLbl.text = "nao informada"
                iCell.information1InfoLbl.font = UIFont(name: "Charter-Italic", size: 15)
            }
            iCell.information1InfoLbl.text = item.getBrand().hasValue ? item.getBrand().Value : "nao informada"
            iCell.information1InfoLbl.font = UIFont(name: "Charter-Italic", size: 15)
            iCell.information3InfoLbl.text = item.getFormOfSale().getItemPriceDoubleToString()
            iCell.information2InfoLbl.text = String(soldBy)
            iCell.imageImgView.image = item.getImage()
            switch item.getFormOfSale().getUnitMeasure() {
            case UnitMeasure.averageWeight.rawValue:
                iCell.information3Lbl.text = ("Preço de 1 kilo/litro:")
            case UnitMeasure.gram.rawValue, UnitMeasure.mililiter.rawValue:
                iCell.information3Lbl.text = ("Preço de \(Int(item.getFormOfSale().getStandarWeightValue())) \(soldBy)s:")
            default:
                iCell.information3Lbl.text = ("Preço de 1 \(soldBy):")
            }
            iCell.coldImg.isHidden = item.getItemTemp() ? false : true
            if item.getAddToBuyList() {
                iCell.checkMarkBtn.setImage(UIImage(named: "checkmark"), for: .normal)
                iCell.information4Lbl.isHidden = false
                iCell.information4InfoLbl.isHidden = false
                if item.getFormOfSale().getUnitMeasure() == UnitMeasure.averageWeight.rawValue {
                    iCell.information4InfoLbl.text = "\(Int(item.getFormOfSale().getItemQtty())) unidade(s)"
                } else {
                    iCell.information4InfoLbl.text = (item.getFormOfSale().getUnitMeasure() == 4 || item.getFormOfSale().getUnitMeasure() == 5) ? "\(uObjCtrl.numberByLocalityDoubleToString(valueToFormat: item.getFormOfSale().getItemQtty())) \(soldBy)(s)" : "\(Int(item.getFormOfSale().getItemQtty())) \(soldBy)(s)"
                }
                iCell.cellViewView.backgroundColor = uObjCtrl.getUIColorForSelectedTableViewCells()
            } else {
                iCell.information4Lbl.isHidden = true
                iCell.information4InfoLbl.isHidden = true
                iCell.checkMarkBtn.setImage(nil, for: .normal)
                iCell.cellViewView.backgroundColor = nil
            }
            item.getItemInformation().hasValue ? iCell.notesBtn.setImage(UIImage(systemName: "info.circle.fill"), for: .normal) : iCell.notesBtn.setImage(UIImage(systemName: "info.circle"), for: .normal)
            let tagNumber = market*uObjCtrl.getConstantForCellAddress()+row
            iCell.checkMarkBtn.tag = tagNumber
            iCell.imageBtn.tag = tagNumber
            iCell.notesBtn.tag = tagNumber
            return iCell
        } else if type == .searchBar {
            let tagNumber = item
            let iCell = cell as! CellForItemInTableViews
            let item = searchAry[item]
            let soldBy = uObjCtrl.returnUnitMeasureInString(forNumber: Int(item.getFormOfSale().getUnitMeasure()))
            
            iCell.namLbl.text = item.getName()
            if item.getBrand().hasValue {
                iCell.information1InfoLbl.text = item.getBrand().Value
                iCell.information1InfoLbl.font = UIFont(name: "Charter", size: 15)
            } else {
                iCell.information1InfoLbl.text = "nao informada"
                iCell.information1InfoLbl.font = UIFont(name: "Charter-Italic", size: 15)
            }
            iCell.information1InfoLbl.text = item.getBrand().hasValue ? item.getBrand().Value : "nao informada"
            iCell.information1InfoLbl.font = UIFont(name: "Charter-Italic", size: 15)
            iCell.information3InfoLbl.text = item.getFormOfSale().getItemPriceDoubleToString()
            iCell.information2InfoLbl.text = String(soldBy)
            iCell.imageImgView.image = item.getImage()
            switch item.getFormOfSale().getUnitMeasure() {
            case UnitMeasure.averageWeight.rawValue:
                iCell.information3Lbl.text = ("Preço de 1 kilo/litro:")
            case UnitMeasure.gram.rawValue, UnitMeasure.mililiter.rawValue:
                iCell.information3Lbl.text = ("Preço de \(Int(item.getFormOfSale().getStandarWeightValue())) \(soldBy)s:")
            default:
                iCell.information3Lbl.text = ("Preço de 1 \(soldBy):")
            }
            iCell.coldImg.isHidden = item.getItemTemp() ? false : true
            if item.getAddToBuyList() {
                iCell.checkMarkBtn.setImage(UIImage(named: "checkmark"), for: .normal)
                iCell.information4Lbl.isHidden = false
                iCell.information4InfoLbl.isHidden = false
                if item.getFormOfSale().getUnitMeasure() == UnitMeasure.averageWeight.rawValue {
                    iCell.information4InfoLbl.text = "\(Int(item.getFormOfSale().getItemQtty())) unidade(s)"
                } else {
                    iCell.information4InfoLbl.text = (item.getFormOfSale().getUnitMeasure() == 4 || item.getFormOfSale().getUnitMeasure() == 5) ? "\(uObjCtrl.numberByLocalityDoubleToString(valueToFormat: item.getFormOfSale().getItemQtty())) \(soldBy)(s)" : "\(Int(item.getFormOfSale().getItemQtty())) \(soldBy)(s)"
                }
                iCell.cellViewView.backgroundColor = uObjCtrl.getUIColorForSelectedTableViewCells()
            } else {
                iCell.information4Lbl.isHidden = true
                iCell.information4InfoLbl.isHidden = true
                iCell.checkMarkBtn.setImage(nil, for: .normal)
                iCell.cellViewView.backgroundColor = nil
            }
            item.getItemInformation().hasValue ? iCell.notesBtn.setImage(UIImage(systemName: "info.circle.fill"), for: .normal) : iCell.notesBtn.setImage(UIImage(systemName: "info.circle"), for: .normal)
            iCell.checkMarkBtn.tag = tagNumber
            iCell.imageBtn.tag = tagNumber
            iCell.notesBtn.tag = tagNumber
            return iCell
        }
        return cell
    }
    func returnHeightForCell(atIndexPath indexPath : IndexPath, usingMarketsArray ary: [Market]) -> CGFloat {
        let rowAndSection = uObjCtrl.sectionSubsectionForItemInTableView(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: ary)
        if ary[indexPath.section].getSector()[rowAndSection.section].isOpened(){
            return rowAndSection.row < 0 ? sectorCell.hValue : itemCell.hValue
        } else {
            return rowAndSection.row < 0 ? sectorCell.hValue+10 : CGFloat(0)    }
    }
    func returnHeighForHeader(inSection section : Int, usingMarketsArray ary : [Market])->CGFloat {
        return ary[section].isOpened() ? marketCell.hValue : marketCell.hValue + 10
    }
}
//MARK:- DATA MANIPULATION
extension itemsMercadoObjectController{
    //getting cell
    func getCellForTargets(inCellAddress index : [CellAddressDictionary : Int], inTheArray ary: [Market])-> Item {
        let cellIndex = uObjCtrl.sectionSubsectionForItemInTableView(atSection: index[.marketAndSectorIndex]!, atRow: index[.itemIndex]!, inMarketArray: ary)
        let selectedCell = ary[index[.marketAndSectorIndex]!].getSector()[cellIndex.section].getItem()[cellIndex.row]
        return selectedCell
    }
    func getCellForDidSelectRowAt(withIndexPath indexPath: IndexPath, withMarketsArray ary: [Market])->(selectedCell: Item, mktIndex: Int, sctIndex: Int, itemIndex: Int, formOfSaleIndex: Int) {
        let rowAndSection = uObjCtrl.sectionSubsectionForItemInTableView(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: ary)
        let itemsInfo = ary[indexPath.section].getSector()[rowAndSection.section].getItem()[rowAndSection.row]
        return (itemsInfo, indexPath.section, rowAndSection.section, rowAndSection.row, returnIndexForFormOfSale(withItem: itemsInfo))
    }
    func returnIndexForFormOfSale(withItem item : Item) -> Int {
        for i in 0..<UnitMeasure.allCases.count {
            if item.getFormOfSale().getUnitMeasureNoRawValue() == UnitMeasure.allCases[i] {
                return i
            }
        }
        return -1
    }
    func checkMarketHasItems(inArray ary: [Market])->Bool{
        for m in 0..<ary.count {
            return ary[m].getHasItems() ? true : false }
        return false
    }
    func checkMarketHasItemsInHeaders(inArray ary: [Market], inSection section: Int)-> Bool{
        if ary.count == 0 {
            return false 
        }
        return ary[section].getHasItems() ? true : false
    }
    func aryHasTwoOrMoreItems(withAry ary: [Market]) -> Bool{
        var items = 0
        for m in ary {
            for s in m.getSector() {
                items += s.getItem().count
                print("items = \(items)")
                if items >= 2 {
                    return true
                }       }
        }
        return false
    }
    func returnSectorsArray(marketsArray ary: [Market])->[Sector]{
        var sAry = [Sector]()
        for m in 0..<ary.count{
            for s in 0..<ary[m].getSector().count {
                if ary[m].getSector()[s].getHasItems(){
                    sAry.append(ary[m].getSector()[s])
                }
            }
        }
        return sAry
    }
    //MARK:- LAYOUT
    func getTextForPopUpToAddItemToShoppingList(item: Item) -> [String] {
        var priceLabel = String()
        var quantityDetailsLabel = String()
        let solbBy = uObjCtrl.returnUnitMeasureInString(forNumber: item.getFormOfSale().getUnitMeasure())
        if item.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[4].rawValue ||
            item.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[5].rawValue {
            priceLabel = "Preço por \(solbBy)"
            quantityDetailsLabel = "Informe quantos \(solbBy)s comprar"
        } else if item.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[0].rawValue {
            priceLabel = "Preço por \(solbBy)"
            quantityDetailsLabel = "Informe quantas \(solbBy)s comprar"
        } else if item.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[1].rawValue {
            priceLabel = "Preço por kilo/litro"
            quantityDetailsLabel = "Cada unidade pesa: \n \(Int(item.getFormOfSale().getStandarWeightValue()*Double(item.getFormOfSale().getDivisor()[.averageWeight]!))) grama(s)/ml(s). Informe \nquantas unidades comprar"
        } else {
            priceLabel = "Preço por \(solbBy)"
            quantityDetailsLabel = "Informe quantos \(solbBy)s comprar"
        }
        var ary = [String]()
        ary.append(priceLabel)
        ary.append(quantityDetailsLabel)
        return ary
    }
    //MARK:- SEGUEWAYS
    //get item image for ItemImageExpandedVC
    func getItemImage(usingTag tag : Int, inMarketsArray ary: [Market]) -> UIImage {
        let section = Int(tag/uObjCtrl.getConstantForCellAddress())
        let row = Int(tag%uObjCtrl.getConstantForCellAddress())
        let cellIndex = uObjCtrl.sectionSubsectionForItemInTableView(atSection: section, atRow: row, inMarketArray: ary)
        return ary[section].getSector()[cellIndex.section].getItem()[cellIndex.row].getImage()
    }
    func getItemObject(usingTag tag : Int, inMarketsArray ary: [Market]) -> Item {
        let section = Int(tag/uObjCtrl.getConstantForCellAddress())
        let row = Int(tag%uObjCtrl.getConstantForCellAddress())
        let cellIndex = uObjCtrl.sectionSubsectionForItemInTableView(atSection: section, atRow: row, inMarketArray: ary)
        return ary[section].getSector()[cellIndex.section].getItem()[cellIndex.row]
    }
}
