//
//  Extensions.swift
//  MarketListApp
//
//  Created by Diego Mieth on 06/11/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import Foundation
import UIKit
//MARK:- textField on time edition extensions
extension Double {
    struct number {
        static let formatter = NumberFormatter()
    }
    var twoDigits : String {
        number.formatter.numberStyle = .currency
        number.formatter.minimumFractionDigits = 2
        number.formatter.maximumFractionDigits = 3
        return number.formatter.string(for: self)!
    }
    var threeDigits : String {
        number.formatter.numberStyle = .decimal
        number.formatter.minimumFractionDigits = 3
        number.formatter.maximumFractionDigits = 3
        return number.formatter.string(for: self)!
    }
}
extension String {
    var numbersOnly : String {
        return self.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).split(separator: ",").joined()
    }
    var integerValue : Int {
        return decimalNumber.intValue
    }
    var decimalNumber : NSNumber {
        return NSDecimalNumber(string: self)
    }
}
extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
