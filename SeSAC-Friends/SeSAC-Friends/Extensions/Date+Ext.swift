//
//  Date+Ext.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/01/23.
//

import Foundation

extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
}
