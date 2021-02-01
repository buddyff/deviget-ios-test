//
//  Float+Extension.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

extension Float {
    
    func toDate() -> Date {
        let epocTime = TimeInterval(self)
        return Date(timeIntervalSince1970: epocTime)
    }
}
