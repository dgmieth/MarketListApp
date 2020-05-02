////
////  WeeklyShoppingListController.swift
////  MarketListApp
////
////  Created by Diego Mieth on 19/11/19.
////  Copyright © 2019 dgmieth. All rights reserved.
////
//
import UIKit
import CoreData

class WeeklyShoppingListObjectController {
    private var mIndex : [Int] = []
    private let marketCell = MarketHeaderCell()
    private let sectorCell = CellForSectorInTableViews()
    private let itemCell = CellForItemInTableViews ()
    //variables for getting cell address outside tableview functions
    private let constantForCellAddress: Int = 1_0000
    //univesarlObjectController
    private var uObjCtrl = UniversalObjectController()
    //bottom price and item quantity labels
    //    private var returnString = [BottomInformationLabelsInWeeklyShoppingItemsVC : String]()
    
    private var totalQttyBought = 0.00
    private var totalPriceBought = 0.00
}
//MARK:- START UP/END
extension WeeklyShoppingListObjectController {
    func hasItemsToBuy(lookInArray ary : [Market])->Bool{
        var itemsCounter = 0
        for m in ary {
            for s in m.getSector() {
                for i in s.getItem() { itemsCounter += i.getAddToBuyList() ? 1 : 0
                }       }       }
        return itemsCounter > 0 ? true : false
    }
}
//MARK:- LOADING MARKETS IDEXES WITH TO BUY ITEMS
extension WeeklyShoppingListObjectController{
    func fillMIndex(withArray ary: [Market]) {
        var index = [Int]()
        for m in 0..<ary.count {
            var itemCounter = 0
            for s in 0..<ary[m].getSector().count {
                for i in 0..<ary[m].getSector()[s].getItem().count {
                    itemCounter += ary[m].getSector()[s].getItem()[i].getAddToBuyList() ? 1 : 0   }
            }
            itemCounter > 0 ? index.append(m) : nil
        }
        mIndex = index
    }
    func returnMarketIndex(inSection section : Int)->(Bool, Int){
        return mIndex.count > 0 ? (true, mIndex[section]) : (false, 0)
    }
}
//MARK:- TABLEVIEW
extension WeeklyShoppingListObjectController {
    func returnNumberOfSections(inMarketsArray ary: [Market])-> Int{
        return mIndex.count > 0 ? mIndex.count : 1
    }
    func returnNumberOfRows(inMarketsArray ary : [Market], inSection section: Int)-> Int{
        var counter = 0
        if mIndex.count > 0 {
            for s in ary[mIndex[section]].getSector() {
                var hasItems = false
                for i in s.getItem() {
                    if i.getAddToBuyList() {
                        counter += 1
                        hasItems = true
                    }       }
                counter += hasItems ? 1 : 0
            }
            if counter > 0 {      return ary[mIndex[section]].isOpened() ? counter : 0
            }
        }
        return 1
    }
    //return cell height and header
    func returnHeightForCell(atIndexPath indexPath : IndexPath, usingMarketsArray ary: [Market]) -> CGFloat {
        let rowAndSection = returnItemObjIndexPath(inMarketsArray: ary, inSection: indexPath.section, inRow: indexPath.row)
        if ary[indexPath.section].getSector()[rowAndSection.section].isOpened(){
            return rowAndSection.row < 0 ? sectorCell.hValue : itemCell.hValue
        } else {
            return rowAndSection.row < 0 ? sectorCell.hValue+10 : CGFloat(0)    }
    }
    func returnHeighForHeader(inSection section : Int, usingMarketsArray ary : [Market])->CGFloat {
        return ary[section].isOpened() ? marketCell.hValue : marketCell.hValue + 10
    }
    //CELL VIEWS
    func returnCell(withCell cell : Any, cellType type : TVCellType, itemInArray ary: [Market] = [Market](), inIndexPath indexPath: IndexPath, itemIndexPath: IndexPath, searchBarArray searchAry: [Item] = [Item]())->Any {
        if type == .market {
            let mCell = cell as! MarketHeaderCell
            mCell.marketNameLbl.text = ary[indexPath.section].getName()
            mCell.itemsQttLbl.text = "\(totalAmountAndQttyToBuy(marketOrSector: .market, usingArray: ary, atIndexPath: indexPath).qtty) item(s) \n Total: \(totalAmountAndQttyToBuy(marketOrSector: .market, usingArray: ary, atIndexPath: indexPath).amount)"
            mCell.tappedBtn.tag = indexPath.section
            return mCell
        } else if type == .sector {
            let sCell = cell as! CellForSectorInTableViews
            sCell.sectorNameLbl.text = ary[indexPath.section].getSector()[itemIndexPath.section].getName()
            let sectorIndexPath = IndexPath(row: itemIndexPath.section, section: indexPath.section)
            sCell.sideLable.text = "\(totalAmountAndQttyToBuy(marketOrSector: .sector, usingArray: ary, atIndexPath: sectorIndexPath).qtty) item(s) \n Total: \(totalAmountAndQttyToBuy(marketOrSector: .sector, usingArray: ary, atIndexPath: sectorIndexPath).amount)"
            sCell.sideLable.textAlignment = .right
            return sCell
        } else if type == .item {
            let iCell = cell as! CellForItemInTableViews
            let item = ary[indexPath.section].getSector()[itemIndexPath.section].getItem()[itemIndexPath.row]
            let soldBy = uObjCtrl.returnUnitMeasureInString(forNumber: Int(item.getFormOfSale().getUnitMeasure()))
            
            iCell.namLbl.text = "\(item.getOrderingID())- \(item.getName())"
            if item.getBrand().hasValue {
                iCell.information1InfoLbl.text = item.getBrand().Value
                iCell.information1InfoLbl.font = UIFont(name: "Charter", size: 15)
            } else {
                iCell.information1InfoLbl.text = "nao informada"
                iCell.information1InfoLbl.font = UIFont(name: "Charter-Italic", size: 15)
            }
            iCell.information2InfoLbl.text = item.getFormOfSale().getItemPriceDoubleToString()
            iCell.imageImgView.image = item.getImage()
            switch item.getFormOfSale().getUnitMeasure() {
            case UnitMeasure.averageWeight.rawValue:
                iCell.information2Lbl.text = ("Preço (kilo/litro):")
            case UnitMeasure.gram.rawValue, UnitMeasure.mililiter.rawValue:
                iCell.information2Lbl.text = ("Preço (\(Int(item.getFormOfSale().getStandarWeightValue())) \(soldBy)s):")
            default:
                iCell.information2Lbl.text = ("Preço (1 \(soldBy)):")
            }
            if !item.getIsAlreadyPurchased() {
                iCell.cellViewView.backgroundColor = nil
                iCell.checkMarkBtn.setImage(nil, for: .normal)
            } else {
                iCell.checkMarkBtn.setImage(UIImage(named: "checkmark"), for: .normal)
                iCell.cellViewView.backgroundColor = uObjCtrl.getUIColorForSelectedTableViewCells()
            }
            iCell.coldImg.isHidden = item.getItemTemp() ? false : true
            if item.getItemInformation().hasValue {
                iCell.notesBtn.isHidden = false
                iCell.notesBtn.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
            } else {
                iCell.notesBtn.isHidden = true
            }
            iCell.information3Lbl.text = "Comprar:"
            if item.getFormOfSale().getUnitMeasure() == UnitMeasure.averageWeight.rawValue {
                iCell.information3InfoLbl.text = "\(Int(item.getFormOfSale().getItemQtty())) unidade(s)"
            } else {
                iCell.information3InfoLbl.text = (item.getFormOfSale().getUnitMeasure() == 4 || item.getFormOfSale().getUnitMeasure() == 5) ? "\(uObjCtrl.numberByLocalityDoubleToString(valueToFormat: item.getFormOfSale().getItemQtty())) \(soldBy)(s)" : "\(Int(item.getFormOfSale().getItemQtty())) \(soldBy)(s)"
            }
            iCell.information4Lbl.isHidden = false
            iCell.information4InfoLbl.isHidden = false
            iCell.information4Lbl.text = "Total:"
            iCell.information4InfoLbl.text = item.getFormOfSale().getFormattedFinalQuantityPrice()
            let tagNumber = indexPath.section*uObjCtrl.getConstantForCellAddress()+indexPath.row
            iCell.checkMarkBtn.tag = tagNumber
            iCell.imageBtn.tag = tagNumber
            iCell.notesBtn.tag = tagNumber
            return iCell
        } else if type == .searchBar {
            let iCell = cell as! CellForItemInTableViews
            let item = searchAry[indexPath.row]
            let soldBy = uObjCtrl.returnUnitMeasureInString(forNumber: Int(item.getFormOfSale().getUnitMeasure()))
            
            iCell.namLbl.text = item.getName()
            if item.getBrand().hasValue {
                iCell.information1InfoLbl.text = item.getBrand().Value
                iCell.information1InfoLbl.font = UIFont(name: "Charter", size: 15)
            } else {
                iCell.information1InfoLbl.text = "nao informada"
                iCell.information1InfoLbl.font = UIFont(name: "Charter-Italic", size: 15)
            }
            iCell.information2InfoLbl.text = item.getFormOfSale().getItemPriceDoubleToString()
            iCell.imageImgView.image = item.getImage()
            switch item.getFormOfSale().getUnitMeasure() {
            case UnitMeasure.averageWeight.rawValue:
                iCell.information2Lbl.text = ("Preço (kilo/litro):")
            case UnitMeasure.gram.rawValue, UnitMeasure.mililiter.rawValue:
                iCell.information2Lbl.text = ("Preço (\(Int(item.getFormOfSale().getStandarWeightValue())) \(soldBy))s:")
            default:
                iCell.information2Lbl.text = ("Preço (1 \(soldBy)):")
            }
            if !item.getIsAlreadyPurchased() {
                iCell.cellViewView.backgroundColor = nil
                iCell.checkMarkBtn.setImage(nil, for: .normal)
            } else {
                iCell.checkMarkBtn.setImage(UIImage(named: "checkmark"), for: .normal)
                iCell.cellViewView.backgroundColor = uObjCtrl.getUIColorForSelectedTableViewCells()
            }
            iCell.coldImg.isHidden = item.getItemTemp() ? false : true
            if item.getItemInformation().hasValue {
                iCell.notesBtn.isHidden = false
                iCell.notesBtn.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
            } else {
                iCell.notesBtn.isHidden = true
            }
            iCell.information3Lbl.text = "Comprar:"
            if item.getFormOfSale().getUnitMeasure() == UnitMeasure.averageWeight.rawValue {
                iCell.information3InfoLbl.text = "\(Int(item.getFormOfSale().getItemQtty())) unidade(s)"
            } else {
                iCell.information3InfoLbl.text = (item.getFormOfSale().getUnitMeasure() == 4 || item.getFormOfSale().getUnitMeasure() == 5) ? "\(uObjCtrl.numberByLocalityDoubleToString(valueToFormat: item.getFormOfSale().getItemQtty())) \(soldBy)(s)" : "\(Int(item.getFormOfSale().getItemQtty())) \(soldBy)(s)"
            }
            iCell.information4Lbl.isHidden = false
            iCell.information4InfoLbl.isHidden = false
            iCell.information4Lbl.text = "Total:"
            iCell.information4InfoLbl.text = item.getFormOfSale().getFormattedFinalQuantityPrice()
            iCell.checkMarkBtn.tag = indexPath.row
            iCell.imageBtn.tag = indexPath.row
            iCell.notesBtn.tag = indexPath.row
            return iCell
        }
        return cell
    }
}
//MARK:- LAYOUT
extension WeeklyShoppingListObjectController{
    func qttyAndPriceStandardTextForAlerts(selectedCell: Item) -> [String] {
        var priceLabel = String()
        var quantityDetailsLabel = String()
        let soldBy = uObjCtrl.returnUnitMeasureInString(forNumber: selectedCell.getFormOfSale().getUnitMeasure())
        if selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[4].rawValue ||
            selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[5].rawValue {
            priceLabel = "Vendido em \(soldBy)"
            quantityDetailsLabel = "Informe quantos \(soldBy)s comprar"
        } else if selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[0].rawValue {
            priceLabel = "Vendido emunidade"
            quantityDetailsLabel = "Informe quantas unidades comprar"
        } else if selectedCell.getFormOfSale().getUnitMeasure() == UnitMeasure.allCases[1].rawValue {
            priceLabel = "Vendido em kilo/litro"
            quantityDetailsLabel = "Cada unidade pesa: \n \(Int(selectedCell.getFormOfSale().getStandarWeightValue()*Double(selectedCell.getFormOfSale().getDivisor()[.averageWeight]!))) grama(s)/ml(s). Informe \nquantas unidades comprar"
        } else {
            priceLabel = "Preço por \(soldBy)"
            quantityDetailsLabel = "Informe quantos \(soldBy)s comprar"
        }
        return [priceLabel, quantityDetailsLabel]
    }
}
//MARK:- TARGET METHODS
extension WeeklyShoppingListObjectController{
    //    //set cell as purchased
    func setOrUnsetCellAsPurhcase(withTagForCell tag : Int, withMarketsArray ary: [Market]) {
        let section = Int(tag/uObjCtrl.getConstantForCellAddress())
        let row = Int(tag%uObjCtrl.getConstantForCellAddress())
        let cellIndex = returnItemObjIndexPath(inMarketsArray: ary, inSection: section, inRow: row)
        ary[section].getSector()[cellIndex.section].getItem()[cellIndex.row].getPurchase() ? ary[section].getSector()[cellIndex.section].getItem()[cellIndex.row].setPurchase(value: false) : ary[section].getSector()[cellIndex.section].getItem()[cellIndex.row].setPurchase(value: true)
    }
    func getItemImage(usingTag tag : Int, inMarketsArray ary: [Market]) -> UIImage {
        let section = Int(tag/uObjCtrl.getConstantForCellAddress())
        let row = Int(tag%uObjCtrl.getConstantForCellAddress())
        let cellIndex = returnItemObjIndexPath(inMarketsArray: ary, inSection: section, inRow: row)
        return ary[section].getSector()[cellIndex.section].getItem()[cellIndex.row].getImage()
    }
}
//MARK:- DATA MANIPULTAION
extension WeeklyShoppingListObjectController{
    func getItemObj(usingTag tag : Int = -1, indexPath: IndexPath = IndexPath(row: -1, section: -1), inMarketsArray ary: [Market], dataControler : DataController) -> Item {
        if tag > -1 {
            let section = Int(tag/uObjCtrl.getConstantForCellAddress())
            let row = Int(tag%uObjCtrl.getConstantForCellAddress())
            let cellIndex = returnItemObjIndexPath(inMarketsArray: ary, inSection: section, inRow: row)
            return ary[section].getSector()[cellIndex.section].getItem()[cellIndex.row]
        } else if indexPath.row > -1 {
            let cellIndex = returnItemObjIndexPath(inMarketsArray: ary, inSection: indexPath.section, inRow: indexPath.row)
            return ary[indexPath.section].getSector()[cellIndex.section].getItem()[cellIndex.row]
        }
        return Item(context: dataControler.viewContext)
    }
    func checkMarketHasItemsInHeaders(inMarketsArray ary: [Market], inSection section: Int)->Bool{
        var counter = 0
        if ary.count == 0 {
            return false
        }
        for s in ary[section].getSector() {
            for i in s.getItem() {
                counter += i.getAddToBuyList() ? 1 : 0
            }       }
        return counter > 0 ? true : false
    }
    func returnItemObjIndexPath(inMarketsArray ary: [Market], inSection section: Int, inRow x : Int)->IndexPath{
        let sectors = ary[section].getSector()
        var section = 0
        var row = x
        for s in 0..<sectors.count {
            row -= 1
            var hasItems = false
            for i in 0..<sectors[s].getItem().count {
                if sectors[s].getItem()[i].getAddToBuyList() {  hasItems = true     }
            }
            if hasItems {
                if row < 0 {
                    section = s
                    break
                } else {
                    var itemsToBuy = [Int]()
                    for i in 0..<sectors[s].getItem().count {
                        if sectors[s].getItem()[i].getAddToBuyList() {  itemsToBuy.append(i)    }
                    }
                    if row < itemsToBuy.count {
                        section = s
                        row = itemsToBuy[row]
                        break
                    } else {    row -= itemsToBuy.count     }
                }
            } else {        row += 1        }
        }
        return IndexPath(row: row, section: section)
    }
    func totalAmountAndQttyToBuy(marketOrSector value : TVCellType, usingArray ary: [Market], atIndexPath indexPath: IndexPath) -> (amount: String, qtty: String){
        var amount = Double()
        var quantity = Double()
        if value == .market {
            for s in 0..<ary[indexPath.section].getSector().count {
                for i in 0..<ary[indexPath.section].getSector()[s].getItem().count{
                    let item = ary[indexPath.section].getSector()[s].getItem()[i]
                    if item.getAddToBuyList() {
                        switch item.getFormOfSale().getUnitMeasureNoRawValue() {
                        case .single, .averageWeight:
                            quantity += item.getFormOfSale().getItemQtty()
                        default:
                            quantity += 1
                        }
                        amount += item.getFormOfSale().getFinalQuantityPrice()
                    }       }       }
        } else if value == .sector {
            for i in 0..<ary[indexPath.section].getSector()[indexPath.row].getItem().count{
                let item = ary[indexPath.section].getSector()[indexPath.row].getItem()[i]
                if item.getAddToBuyList() {
                    switch item.getFormOfSale().getUnitMeasureNoRawValue() {
                    case .single, .averageWeight:
                        quantity += item.getFormOfSale().getItemQtty()
                    default:
                        quantity += 1
                    }
                    amount += item.getFormOfSale().getFinalQuantityPrice()
                }       }
        }
        return (amount: uObjCtrl.currencyDoubleToString(usingNumber: amount), qtty: "\(Int(quantity))")
    }
    func totalAmountAndQttyBought(withArray ary: [Market]) -> (amount: String, qtty: String, amountDouble: Double, qttyDouble: Double){
        var amount = 0.00
        var quantity = 0.00
        totalPriceBought = 0.0
        totalQttyBought = 0.0
        for m in ary {
            for s in m.getSector() {
                for i in s.getItem() {
                    if i.getAddToBuyList() {
                        if i.getIsAlreadyPurchased(){
                            switch i.getFormOfSale().getUnitMeasureNoRawValue() {
                            case .single, .averageWeight:
                                quantity += i.getFormOfSale().getItemQtty()
                            default:
                                quantity += 1
                            }
                            amount += i.getFormOfSale().getFinalQuantityPrice()
                            totalPriceBought = amount
                            totalQttyBought = quantity
                        }       }       }       }       }
        return (uObjCtrl.currencyDoubleToString(usingNumber: amount), qtty: "\(Int(quantity))", totalPriceBought, totalQttyBought)
    }
    func finishLists(withMarketsArray marketsArray: [Market], withDataController dataController: DataController, withFinishedListsArray ary: [PurchasedList])->PurchasedList? {
        let purchasedItems = PurchasedList(context: dataController.viewContext)
        purchasedItems.setListFinishedDate(date: Date())
        purchasedItems.setTotalAmountSpent(price: totalPriceBought)
        purchasedItems.setBoughtItemsQtty(itemQtty: totalQttyBought)
        for m in 0..<marketsArray.count {
            for s in 0..<marketsArray[m].getSector().count {
                for i in 0..<marketsArray[m].getSector()[s].getItem().count {
                    if marketsArray[m].getSector()[s].getItem()[i].getAddToBuyList(){
                        if marketsArray[m].getSector()[s].getItem()[i].getIsAlreadyPurchased() {
                            let hItem = PurchasedItem(context: dataController.viewContext)
                            let item = marketsArray[m].getSector()[s].getItem()[i]
                            hItem.setItemName(name: item.getName())
                            hItem.setItemPrice(price: item.getFormOfSale().getItemPriceDouble())
                            hItem.setItemFormOfSale(rawValue: item.getFormOfSale().getUnitMeasure())
                            hItem.setBoughtQtty(qtty: item.getFormOfSale().getItemQtty())
                            hItem.setMarket(market: item.sector!.market!.getName())
                            hItem.setTotalAmmount(value: item.getFormOfSale().getFinalQuantityPrice())
                            var array = [String]()
                            var dArray = [Double]()
                            array.append(uObjCtrl.currentSystemDate())
                            let soldBy = item.getFormOfSale()
                            switch soldBy.getUnitMeasureNoRawValue() {
                            case .kilogram, .liter:
                                array.append(uObjCtrl.returnUnitMeasureInString(forNumber: soldBy.getUnitMeasure()))
                                dArray.append(soldBy.getItemQtty())
                                dArray.append(soldBy.getItemPriceDouble())
                            default:
                                array.append(uObjCtrl.returnUnitMeasureInString(forNumber: soldBy.getUnitMeasure()))
                                dArray.append(soldBy.getItemQtty())
                                dArray.append(soldBy.getItemPriceDouble())
                            }
                            dArray.append( soldBy.getFinalQuantityPrice())
                            item.setPurchaseHistoryString(withText: array)
                            item.setPurchaseHistoryDouble(withText: dArray)
                            hItem.purchasedList = purchasedItems
                            item.setAddToBuyList(changeBoolValue: false)
                            item.setIsAlreadyPurchased(value: false)
                        }   }   }   }
        }
        if purchasedItems.getBoughItems().count > 0 {
            return purchasedItems
        } else {
            dataController.viewContext.delete(purchasedItems)
        }
        return nil
    }
}




