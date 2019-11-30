//
//  ItemsMercadoVCController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 05/10/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import UIKit

class itemsMercadoObjectController {
    private var rowForTableView : Int = 0
    private var sectionForTableView : Int = 0
    private var marketsCounter : Int = 0
    private var sectorsCounter : Int = 0
    private var itemsCounter : Int = 0
    private var uObjCtrl = UniversalObjectController()
    let marketCell = MarketItemMercadoVCCell()
    let sectorCell = SectorItemMercadoVCCell()
    let itemCell = ItemItemMercadoVCCell ()
    //universal object Controller
    var uObjCtrlItemsVC = UniversalObjectController()
    
    
    //MARK:- START UP/END
    func canLoadItemsOntoTableView(inMarketsArray ary : [Market]) -> Bool {
        itemsCounter = 0
        for m in 0..<ary.count {
            for s in 0..<ary[m].getSector().count {
                itemsCounter = itemsCounter + ary[m].getSector()[s].getItem().count
            }
        }
        
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
    //cell for market&sector
    func returnMarketCell(withCell cell: MarketItemMercadoVCCell, inMarket mkt: Int, inSector str: Int, withMarketsArray ary : [Market]) -> MarketItemMercadoVCCell {
        cell.marketName.text = ary[mkt].getName()
        cell.sectorName1stCell.text = ary[mkt].getSector()[str].getName()
        return cell
    }
    //cell for sector
    func returnSectorCell(withCell cell: SectorItemMercadoVCCell, inMarket mkt: Int, inSector str: Int, withMarketsArray ary : [Market]) -> SectorItemMercadoVCCell {
        cell.sectorName.text = ary[mkt].getSector()[str].getName()
        return cell
    }
    //cell for item
    func returnItemCell(withCell cell: ItemItemMercadoVCCell, inMarket mkt: Int, inSector str: Int, itemIndex item: Int, indexPathRow row: Int, withMarketsArray ary : [Market]) -> ItemItemMercadoVCCell {
        let itemsInfo = ary[mkt].getSector()[str].getItem()[item]
        
        cell.itemName.text = itemsInfo.getName()
        cell.itemPriceAmount.text = itemsInfo.getFormOfSale().getItemPrice()
        switch itemsInfo.getFormOfSale().getUnitMeasure() {
        case UnitMeasure.averageWeight.rawValue:
            cell.itemPriceLabel.text = ("Preço de 1 kilo/litro:")
        case UnitMeasure.gram.rawValue, UnitMeasure.mililiter.rawValue:
            cell.itemPriceLabel.text = ("Preço de \(Int(itemsInfo.getFormOfSale().getStandarWeightValue())) \(itemsInfo.getFormOfSale().getUnitMeasure())s:")
        default:
            cell.itemPriceLabel.text = ("Preço de 1 \(itemsInfo.getFormOfSale().getUnitMeasure()):")
        }
        cell.itemFormOfSale.text = itemsInfo.getFormOfSale().getUnitMeasure()
        cell.itemImage.image = itemsInfo.getImage()
        if itemsInfo.getAddToBuyList() {
            cell.checkmarkSign.setImage(UIImage(named: "checkMarkAppAdded"), for: .normal)
            cell.addedToWeeklyShoppingListLab.isHidden = false
            cell.addedToWeeklyListTextField.isHidden = false
            if itemsInfo.getFormOfSale().getUnitMeasure() == UnitMeasure.averageWeight.rawValue {
                cell.addedToWeeklyListTextField.text = "\(Int(itemsInfo.getFormOfSale().getItemQuantityInWeight())) unidade(s)"
            } else {
                if uObjCtrl.checkIfItemIsSoldInKiloOrLiter(withDescription: itemsInfo.getFormOfSale().getUnitMeasure()) {
                    cell.addedToWeeklyListTextField.text = "\(itemsInfo.getFormOfSale().getItemQuantityInWeight()) \(itemsInfo.getFormOfSale().getUnitMeasure())(s)"
                } else {
                    cell.addedToWeeklyListTextField.text = "\(Int(itemsInfo.getFormOfSale().getItemQuantityInWeight())) \(itemsInfo.getFormOfSale().getUnitMeasure())(s)"
                }
            }
            cell.cellView.backgroundColor = uObjCtrlItemsVC.getUIColorForSelectedTableViewCells()
        } else {
            cell.addedToWeeklyListTextField.isHidden = true
            cell.addedToWeeklyShoppingListLab.isHidden = true
            cell.checkmarkSign.setImage(nil, for: .normal)
            cell.cellView.backgroundColor = nil
        }
        cell.checkmarkSign.tag = mkt*uObjCtrl.getCellAdress()[.constantForCellAddress]!+row
        cell.itemImageButton.tag = mkt*uObjCtrl.getCellAdress()[.constantForCellAddress]!+row
//         iCell.checkmarkSign.tag = (indexPath.section*objCtrl.getCellAdress()[.constaForCellAddress]!)+indexPath.row
        return cell
    }
    //Mreturn cell height
    func returnHeightForCell(atIndexPath indexPath : IndexPath, usingMarketsArray ary: [Market]) -> CGFloat {
        let rowAndSection = uObjCtrlItemsVC.computeRowAndColum(atSection: indexPath.section, atRow: indexPath.row, inMarketArray: ary)
        let itemIndex = rowAndSection.row
        if itemIndex < 0 && indexPath.row == 0 {
            return CGFloat(marketCell.hValue)
        } else if itemIndex < 0 {
            return CGFloat(sectorCell.hValue)
        } else {
            return CGFloat(itemCell.hValue)
        }
    }
    //MARK:- LAYOUT
    func updatingQttyScrollViewInformationLabels(selectedCell: Item) -> [String] {
        var priceLabel = String()
        var quantityDetailsLabel = String()
        if selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[4].rawValue ||
            selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[5].rawValue {
            uObjCtrl.setItemsIsSoldInKilosOrLiters(value: true)
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
    func updatedBottomLableInMercadoVC(atSection i : Int, inMarketsArray ary : [Market] ) -> String {
        let sectorsArray = ary[i].getSector()
        var totalItemsPerMarket : Int = 0
        for counter in 0..<sectorsArray.count {
            totalItemsPerMarket = totalItemsPerMarket + sectorsArray[counter].getItem().count
        }
        return "Total: \(itemsCounter) item(s) | \(ary[i].getName()): \(totalItemsPerMarket) item(s)"
    }
    //MARK:- SEGUEWAYS
    //get item image for ItemImageExpandedVC
    func getItemImage(inCellAddress index : [CellAddressDictionary : Int], inMarketsArray ary: [Market]) -> UIImage {
        let cellIndex = uObjCtrlItemsVC.computeRowAndColum(atSection: index[.marketAndSectorIndex]!, atRow: index[.itemIndex]!, inMarketArray: ary)
        let selectedCell = ary[index[.marketAndSectorIndex]!].getSector()[cellIndex.section].getItem()[cellIndex.row]
        return selectedCell.getImage()
    }
}
