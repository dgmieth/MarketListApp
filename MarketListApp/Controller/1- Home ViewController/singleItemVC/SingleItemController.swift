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
    
    private var uObjCtrl = UniversalObjectController()
    
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
            if item.sector! == ary[market].getSector()[s] {
                sector = s
                break
            }
        }
        soldBy = item.getFormOfSale().getUnitMeasure()
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
        genericLbl.textColor = UIColor.init(named: "textColor")
        genericLbl.font = UIFont(name: "Charter-Bold", size: retunrFontSizeForPickerViewViews())
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
        let newSoldBy = UnitMeasure.allCases[cell.3]
        let item = cell.0.0
        var oldAry = item.sector!.getItem()
        var index = 0
        var newAry = newSector.getItem()
        for i in 0..<oldAry.count {
            if oldAry[i] == item {
                index = i
                break
            }
        }
        if item.sector!.market! != newMarket {
            item.subtractItemFromMarketAndSectorCounter()
            item.sector! = newSector
            item.sector!.market! = newMarket
            item.addOneitemInMarketAndSectorCounter()
            index >= 0 ? oldAry.remove(at: index) : nil
            newAry.append(item)
        } else if item.sector! != newSector {
            item.sector!.subtractOneItem()
            item.sector! = newSector
            item.sector!.addOneItem()
            index >= 0 ? oldAry.remove(at: index) : nil
            newAry.append(item)
        } else if item.getFormOfSale().getUnitMeasure() != newSoldBy.rawValue {
            item.getFormOfSale().setUnitMeasure(howItIsSold: newSoldBy)
        }
        for i in 0..<oldAry.count {
            print("old arry called")
            if i != oldAry[i].getOrderingID() {
                print("old arry entered")
                oldAry[i].setOredringId(setAt: i)
            }
        }
        for i in 0..<newAry.count {
            print("new arry called")
            if i != newAry[i].getOrderingID(){
                print("new arry entered")
                newAry[i].setOredringId(setAt: i)
            }
        }
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

