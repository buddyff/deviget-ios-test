//
//  FileHelper.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 03/02/2021.
//

import Foundation

final class FileHelper {
    
    static func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }

}
