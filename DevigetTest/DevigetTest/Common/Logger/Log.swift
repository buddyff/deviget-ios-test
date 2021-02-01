//
//  Log.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

enum Log: Int {
    case error
    case info
    case debug
    case verbose
    case warning
    case severe
    
    private static var logLevel: Log = Log.debug
    private static var dateFormat: String = "yyyy-MM-dd hh:mm:ssSSS"
    
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    func log(_ object: Any,
               filename: String = #file,
               line: Int = #line,
               column: Int = #column,
               funcName: String = #function) {
        #if DEBUG
        guard Log.logLevel.rawValue >= self.rawValue else { return }
        print("\(Log.toString(date: Date())) \(self.symbol())[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        #endif
    }
    
    private func symbol() -> String {
        switch self {
        case Log.error: return "[‼️]"
        case Log.info: return "[ℹ️]"
        case Log.debug: return "[💬]"
        case Log.verbose: return "[🔬]"
        case Log.warning: return "[⚠️]"
        case Log.severe: return "[🔥]"
        }
    }
    
    private static func toString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    private func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

func print(_ object: Any) {
    #if DEBUG
    Swift.print(object)
    #endif
}

