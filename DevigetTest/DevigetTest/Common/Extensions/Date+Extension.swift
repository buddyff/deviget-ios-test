//
//  Date+Extension.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

extension Date {
    
    func hoursDiff(date: Date) -> Int {
        let cal = Calendar.current
        let components = cal.dateComponents([.hour], from: date, to: Date())
        return components.hour ?? 0
    }
}
