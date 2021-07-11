//
//  Network.swift
//  cleancode_rxswift_swinject
//
//  Created by Nabin Shrestha on 7/10/21.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

final class Network<T: Codable> {
    
    private let endpoint: String = NetworkConfig.baseURL
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    init() {
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
    }
    
    func getItems(_ path: String) -> Observable<[T]> {
        let absolutePath = "\(endpoint)/\(path)"
        return RxAlamofire
            .data(.get, absolutePath)
            .debug()
            .observe(on: scheduler)
            .map({ data -> [T] in
                return try JSONDecoder().decode([T].self, from: data)
            })
    }

    func getItem(_ path: String) -> Observable<T> {
        print("---------------------------------------------\n")
        let absolutePath = "\(endpoint)/\(path)"
        print("GET: ------> \(absolutePath)")
        print("\n---------------------------------------------\n")
        print("Headers: ----->")
        let headers: [String: String] = ["Content-Type": "application/json", "Accept": "application/json"]
        headers.printAsJSON()
        print("\n---------------------------------------------\n")
        return RxAlamofire
            .request(.get, absolutePath, encoding: JSONEncoding.default, headers: .init(headers))
            .debug()
            .observe(on: scheduler)
            .responseString()
            .flatMap { (response, string) -> Observable<T> in
                if 200...300 ~= response.statusCode {
                    if string.isEmpty {
                        if let returnTextData = #"{"success": true}"#.data(using: .utf8), let mappedResponse = try? JSONDecoder().decode(T.self, from: returnTextData) {
                            return Observable.just(mappedResponse)
                        }
                    } else {
                        if let returnTextData = string.data(using: .utf8), let mappedResponse = try? JSONDecoder().decode(T.self, from: returnTextData) {
                            print ("Response <-- " + absolutePath)
                            return Observable.just(mappedResponse)
                        }
                    }
                } else {
                    let data = Data(string.utf8)
                    do {
                        // make sure this JSON is in the format we expect
                        if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            dictionary.printAsJSON()
                            let message = dictionary[Constants.MESSAGE] as? String ?? "Error processing request!"
                            return Observable.error(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: message, Constants.ERRORS: dictionary[Constants.ERRORS] ?? "Error processing request!"]))
                        }
                    } catch let error as NSError {
                        return Observable.error(NSError(domain: response.statusCode.description, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to load: \(error.localizedDescription)"]))
                    }

                }
                return Observable.error(NSError(domain: response.statusCode.description, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error processing request!"]))
            }
    }

    func postItem(_ path: String, parameters: [String: Any]) -> Observable<T> {
        let absolutePath = "\(endpoint)/\(path)"
        print("POST: ------>\(absolutePath)")
        print("Headers: ----->")
        let headers: [String: String] = ["Content-Type": "application/json", "Accept": "application/json"]
        headers.printAsJSON()
        print("Request: ---->")
        parameters.printAsJSON()
        
        return RxAlamofire
            .request(.post, absolutePath, parameters: parameters, encoding: JSONEncoding.default, headers: .init(headers))
            .debug()
            .observe(on: scheduler)
            .responseString()
            .flatMap { (response, string) -> Observable<T> in
                if 200...300 ~= response.statusCode {
                    if string.isEmpty {
                        if let returnTextData = #"{"success": true}"#.data(using: .utf8), let mappedResponse = try? JSONDecoder().decode(T.self, from: returnTextData) {
                            return Observable.just(mappedResponse)
                        }
                    } else {
                        if let returnTextData = string.data(using: .utf8), let mappedResponse = try? JSONDecoder().decode(T.self, from: returnTextData) {
                            print ("Response <-- " + absolutePath)
                            if let dictionary = try JSONSerialization.jsonObject(with: returnTextData, options: []) as? [String: Any] {
                                dictionary.printAsJSON()
                            }
                            return Observable.just(mappedResponse)
                        }
                    }
                } else {
                    let data = Data(string.utf8)
                    do {
                        // make sure this JSON is in the format we expect
                        if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            dictionary.printAsJSON()
                            let message = dictionary[Constants.MESSAGE] as? String ?? "Error processing request!"
                            return Observable.error(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: message, Constants.ERRORS: dictionary[Constants.ERRORS] ?? "Error processing request!"]))
                        }
                    } catch let error as NSError {
                        return Observable.error(NSError(domain: response.statusCode.description, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to load: \(error.localizedDescription)"]))
                    }

                }
                return Observable.error(NSError(domain: response.statusCode.description, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error processing request!"]))
            }
    }

    func updateItem(_ path: String, itemId: String, parameters: [String: Any]) -> Observable<T> {
        let absolutePath = "\(endpoint)/\(path)/\(itemId)"
        return RxAlamofire
            .request(.put, absolutePath, parameters: parameters)
            .debug()
            .observe(on: scheduler)
            .data()
            .map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            })
    }

    func deleteItem(_ path: String, itemId: String) -> Observable<T> {
        let absolutePath = "\(endpoint)/\(path)/\(itemId)"
        
        print("DELETE: ------>\(absolutePath)")
        print("Headers: ----->")
        let headers: [String: String] = ["Content-Type": "application/json", "Accept": "application/json"]
        headers.printAsJSON()
        print("Request: ---->")
        print("Item ID: ----> \(itemId)")
        
        return RxAlamofire
            .request(.delete, absolutePath, headers: .init(headers))
            .debug()
            .observe(on: scheduler)
            .responseString()
            .flatMap { (response, string) -> Observable<T> in
                if 200...300 ~= response.statusCode {
                    if string.isEmpty {
                        if let returnTextData = #"{"success": true}"#.data(using: .utf8), let mappedResponse = try? JSONDecoder().decode(T.self, from: returnTextData) {
                            return Observable.just(mappedResponse)
                        }
                    } else {
                        if let returnTextData = string.data(using: .utf8), let mappedResponse = try? JSONDecoder().decode(T.self, from: returnTextData) {
                            print ("Response <-- " + absolutePath)
                            if let dictionary = try JSONSerialization.jsonObject(with: returnTextData, options: []) as? [String: Any] {
                                dictionary.printAsJSON()
                            }
                            return Observable.just(mappedResponse)
                        }
                    }
                } else {
                    let data = Data(string.utf8)
                    do {
                        // make sure this JSON is in the format we expect
                        if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            dictionary.printAsJSON()
                            let message = dictionary[Constants.MESSAGE] as? String ?? "Error processing request!"
                            return Observable.error(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: message, Constants.ERRORS: dictionary[Constants.ERRORS] ?? "Error processing request!"]))
                        }
                    } catch let error as NSError {
                        return Observable.error(NSError(domain: response.statusCode.description, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to load: \(error.localizedDescription)"]))
                    }

                }
                return Observable.error(NSError(domain: response.statusCode.description, code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error processing request!"]))
            }
    }
}
public extension Dictionary {
    
    func printAsJSON() {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("\(theJSONText)")
        }
    }
    
    func returnJSONAsString() -> String {
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            return "\(theJSONText)"
        }
        return ""
    }
}
