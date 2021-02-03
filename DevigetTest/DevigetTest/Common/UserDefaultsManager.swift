//
//  UserDefaultsManager.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import Foundation

protocol UserDefaultsProtocol {
    func readPostWith(id: String)
    func dismissPostWith(id: String)
}

final class UserDefaultsManager: UserDefaultsProtocol {
    func readPostWith(id: String) {
        UserDefaults.standard.setValue(true, forKey: id)
    }
    
    func dismissPostWith(id: String) {
        UserDefaults.standard.setValue(true, forKey: "d\(id)")
    }    
}
