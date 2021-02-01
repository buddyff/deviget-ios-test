//
//  NetworkConnector.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import Foundation

enum Result<Model:Decodable> {
    case success(Model)
    case failure(ErrorModel)
}

private enum NetworkResponse {
    case success
    case failure(String)
}

private enum ResponseModel<Model:Decodable> {
    case success(Model)
    case failure(ErrorModel)
}

struct ErrorModel: Decodable {
    let message: String
    var status: Int? = nil
}

protocol NetworkConnectorProtocol {
    associatedtype Configuration: NetworkConfiguration
    associatedtype Model: Decodable
    func request(_ route: NetworkConfiguration, completion: @escaping (Result<Model>) -> Void)
    func cancel()
}

final class NetworkConnector<Configuration: NetworkConfiguration, Model: Decodable>: NetworkConnectorProtocol {
    
    let baseURL = URL(string: NetworkSetting.baseURLString)!
    
    private var task: URLSessionTask?
    
    final func request(_ route: NetworkConfiguration, completion: @escaping (Result<Model>)->Void) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let response = response as? HTTPURLResponse {
                    self.printResponse(response, data: data)
                    let networkResult = self.handleNetworkResponse(response)
                    do {
                        switch networkResult {
                        case NetworkResponse.success:
                            let responseModel = try self.handleResponseModel(data: data)
                            switch responseModel {
                            case .success(let model):
                                completion(Result.success(model))
                            case .failure(let error):
                                completion(Result.failure(error))
                            }
                        case .failure(let error):
                            let errorModel: ErrorModel = try self.handleErrorModel(data: data, defaultMessage: error)
                            completion(Result.failure(errorModel))
                            
                        }
                    } catch (let error) {
                        print(error.localizedDescription)
                        completion(Result.failure(ErrorModel(message: "Parse error message")))
                    }
                } else {
                    completion(Result.failure(ErrorModel(message: "Network error message")))
                }
            })
        } catch {
            completion(Result.failure(ErrorModel(message: "Network error message")))
        }
        self.task?.resume()
    }
    
    final func cancel() {
        self.task?.cancel()
    }
}

//MARK: Configuration
extension NetworkConnector {
    private func buildRequest(from configuration: NetworkConfiguration) throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(configuration.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = configuration.httpMethod.rawValue
        
        if configuration.httpMethod == .get {
            self.addQueryParameters(configuration.parameters, request: &request)
        } else if configuration.httpMethod == .post || configuration.httpMethod == .put || configuration.httpMethod == .PATCH {
            self.addHTTPBody(configuration.parameters, urlRequest: &request)
        }
        
        self.addHeaders(configuration.additionalHeaders, needAuthentication: configuration.needAuthentication, request: &request)
        
        printRequest(request)
        
        return request
    }
    
    private func addQueryParameters(_ parameters: Parameters?, request: inout URLRequest) {
        guard var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            else { return }
        
        urlComponents.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key,value) in parameters {
                let encodeValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let queryItem = URLQueryItem(name: key, value: encodeValue)
                urlComponents.queryItems?.append(queryItem)
            }
        }
        
        request.url = urlComponents.url
    }
    
    func addHTTPBody(_ parameters: Parameters?, urlRequest: inout URLRequest) {
        guard let parameters = parameters else { return }
        let jsonAsData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        urlRequest.httpBody = jsonAsData
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    private func addHeaders(_ headers: HTTPHeaders?, needAuthentication: Bool, request: inout URLRequest) {
        if let headers = headers {
            for (key,value) in headers {
                request.setValue(key, forHTTPHeaderField: value)
            }
        }
        
        //Default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Default query parameters
        if needAuthentication {
            // TODO
        }
    }
    
    func printRequest(_ request: URLRequest) {
        guard let url = request.url,
            let httpMethod = request.httpMethod,
            let headers = request.allHTTPHeaderFields else { return }
            
        var str: String = ""
        if let body = request.httpBody {
            str = "\nBODY\n\(String(decoding: body, as: UTF8.self))"
        }
        
        Log.info.log("\n\n------------------NETWORK------------------\n\n\(httpMethod)\n\(url)\n\(str)\n\nHEADERS\n\(headers)\n\n------------------NETWORK------------------\n")
    }
    
    func printResponse(_ response: URLResponse, data: Data?) {
        guard let data = data else { return }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                Log.info.log("\n\n------------------RESPONSE------------------\n\(prettyString)")
            }
        } catch {
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print(string)
            }
        }
    }
}

//MARK: Handlers
extension NetworkConnector {
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResponse {
        switch response.statusCode {
        case 200...299: return NetworkResponse.success
        case 401...500: return NetworkResponse.failure("Client error message")
        case 501...599: return NetworkResponse.failure("Server error message")
        case 600: return NetworkResponse.failure("Outdated request message")
        default: return NetworkResponse.failure("Network error message")
        }
    }
    
    private func handleResponseModel(data: Data?) throws -> ResponseModel<Model> {
        guard let data = data else {return ResponseModel.failure(ErrorModel(message: "Parse model error message")) }
        let decoder = JSONDecoder()
        let model = try decoder.decode(Model.self, from: data)
        return ResponseModel.success(model)
    }
    
    private func handleErrorModel(data: Data?, defaultMessage: String) throws -> ErrorModel {
        guard let data = data else { return ErrorModel(message: defaultMessage) }
        let decoder = JSONDecoder()
        let model = try decoder.decode(ErrorModel.self, from: data)
        return model
    }
}

