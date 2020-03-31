////
////  SingleItemController.swift
////  MarketListApp
////
////  Created by Diego Mieth on 05/12/19.
////  Copyright © 2019 dgmieth. All rights reserved.
////
//
import UIKit


class SingleItemController {

    var uObjCtrl = UniversalObjectController()

//MARK:- LOADING/UNLOADING
    func getItemInfo(fromItem item: Item, inMakertsArray ary : [Market])->(Item, Int, Int, Int){
        var market = 0
        var sector = 0
        var soldBy = 0
        for m in 0..<ary.count {
            if item.sector!.market!.objectID == ary[m].objectID {
                market = m
                break
            }
        }
        for s in 0..<ary[market].getSector().count {
            print(ary[market].getName())
            if item.sector! == ary[market].getSector()[s] {
                sector = s
                print(sector)
                print(ary[market].getSector()[s].getName())
                break
            }
        }
        soldBy = item.getFormOfSale().getUnitMeasure()
//        let market = Int(tag/uObjCtrl.getConstantForCellAddress())
//        let index = Int(tag%uObjCtrl.getConstantForCellAddress())
//        let rowAndSection = uObjCtrl.sectionSubsectionForItemInTableView(atSection: market, atRow: index, inMarketArray: ary)
//        let cell = ary[market].getSector()[sector].getItem()[0]
//        let unitMeasureIndex = cell.getFormOfSale().getUnitMeasure()
        return (item, market, sector, soldBy)
    }
}
//MARK:- PICKER VIEW
extension SingleItemController{
    func returnNumberOfRowsInComponent<T>(withPicker pkr : UIPickerView, inMarketsArray aryT: [T]) -> Int {
            if pkr.tag == 1 {
                let ary = aryT as! [Market]
                return ary.count
            } else if pkr.tag == 2 {
                let ary = aryT as! [Sector]
                return ary.count
            } else if pkr.tag == 3 {
                return UnitMeasure.allCases.count
            } else {
                 return 0
            }
        }
        func returnViewForRows<T>(withPicker pkr : UIPickerView, inMarketsArray aryT: [T], inRow row: Int) -> UILabel {
            let genericLbl = UILabel()
            genericLbl.textAlignment = .center
            genericLbl.textColor = .black
            genericLbl.font = UIFont(name: "Charter-Bold", size: retunrFontSizeForPickerViewViews())
    //        pkr.subviews[1].backgroundColor = UIColor.darkGray
    //        pkr.subviews[2].backgroundColor = UIColor.darkGray
            if pkr.tag == 1 {
                let ary = aryT as! [Market]
                genericLbl.text = ary[row].getName()
                return genericLbl
            } else if pkr.tag == 2 {
                let ary = aryT as! [Sector]
                genericLbl.text = ary[row].getName()
                return genericLbl
            } else if pkr.tag == 3 {
                if row == 1 {
                    genericLbl.font = UIFont(name: "Charter-Bold", size: retunrFontSizeForPickerViewViews() - 3)
                    genericLbl.text = uObjCtrl.returnUnitMeasureInString(forNumber: UnitMeasure.allCases[row].rawValue)
                    return genericLbl
                } else {
                    genericLbl.text = uObjCtrl.returnUnitMeasureInString(forNumber: UnitMeasure.allCases[row].rawValue)
                    return genericLbl
                }
            } else {
                return genericLbl
            }
        }
        //return font size for text in pickerView
        private func retunrFontSizeForPickerViewViews() -> CGFloat {
            return 23
        }
        //MARK:- DATA MANIPULATION
    func updateAryIfMarketOrSectorIndexDifFromSelectedItem(inMarketArray ary: [Market], withItem cell : ((Item, Int, Int, Int), Int, Int, Int))->(Item, Int, Int, Int){
        let newMarket = ary[cell.1]
        let newSector = ary[cell.1].getSector()[cell.2]
        let newSolBy = UnitMeasure.allCases[cell.3]
        let item = cell.0.0
        if item.sector!.market! != newMarket {
            item.sector! = newSector
            item.sector!.market! = newMarket
        } else if item.sector! != newSector {
            item.sector! = newSector
        } else if item.getFormOfSale().getUnitMeasure() != newSolBy.rawValue {
            item.getFormOfSale().setUnitMeasure(howItIsSold: newSolBy)
        }
//            var returnArray = [Market]()
//            for m in 0..<ary.count {
//                let market = Market(marketName: ary[m].getName())
//                for s in 0..<ary[m].getSector().count {
//                    let sector = Sector(sectorName: ary[m].getSector()[s].getName())
//                    var itemAry = [Item]()
//                    for i in 0..<ary[m].getSector()[s].getItem().count {
//                        if ary[m].getSector()[s].getItem()[i].getID() != cell.getID() {
//                            itemAry.append(ary[m].getSector()[s].getItem()[i])
//                        }
//                    }
//                    if itemAry.count > 0 {
//                        for item in 0..<itemAry.count {
//                            sector.setItem(item: itemAry[item])
//                        }
//                    }
//                    market.setSector(sector: sector)
//                }
//                returnArray.append(market)
//            }
        return (item, cell.1, cell.2, cell.3)
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
    
