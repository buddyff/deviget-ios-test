//
//  NetworkConfigurator.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]

enum HttpMethod: String {
    case get
    case post
    case put
    case PATCH
    case delete
}

protocol NetworkConfiguration {
    var path: String {get}
    var httpMethod: HttpMethod { get }
    var additionalHeaders: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var needAuthentication: Bool { get }
}

extension NetworkConfiguration {
    var url: URL? {
        return URL(string: "")
    }
}

