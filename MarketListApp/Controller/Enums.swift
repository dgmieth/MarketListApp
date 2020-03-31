//
//  Enums.swift
//  MarketListApp
//
//  Created by Diego Mieth on 19/11/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation

enum CellAddressDictionary {
    case cellAddress
    case constantForCellAddress
    case marketAndSectorIndex
    case itemIndex
}
enum RowForPickerInNewItemVC{
    case first
    case last
    case other
}
enum BottomInformationLabelsInWeeklyShoppingItemsVC{
    case toBuyItemsLbl1
    case boughItemsLbl1
    case toBuyListPriceLbl1
    case boughtListPriceLbl1
    case toBuyItemsLbl2
    case boughItemsLbl2
    case toBuyListPriceLbl2
    case boughtListPriceLbl2
}
enum Divisors: Int{
    case allOtherDivisors = 1
    case gramMililiterDivisor = 100
    case avgWeightDivisor = 1_000
}
enum Constants:Int{
    case constantForCurrency = 100
    case constantForQuantity = 1_000
}
//MARK:- enumeration for results in NEWITEMVC
enum ValueFor {
    case market
    case sector
    case name
    case brand
    case soldBy
    case avgWeight
    case price
    case cold
    case image
}
//MARK: - Table View Cell Type
enum TVCellType{
    case market
    case sector
    case item
    case searchBar
    case noItem
}
