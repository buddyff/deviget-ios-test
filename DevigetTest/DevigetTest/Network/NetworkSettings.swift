//
//  NetworkSettings.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

struct NetworkSetting {
    static var baseURLString: String {
        #if DEBUG
            return "https://www.reddit.com"
        #else
            return "https://www.reddit.com"
        #endif
    }
}
