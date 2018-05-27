//
//  AbstractAPI.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON

typealias AlamofireError = (statusCode: Int, body: Data)
typealias AlamofireJsonTask = Task<Progress, JSON, AlamofireError>
typealias AlamofireUrlResponseTask = Task<Progress, HTTPURLResponse, AlamofireError>

struct AlamofireModelTask<M: Mappable> {
    typealias T = Task<Progress, M, AlamofireError>
}

struct AlamofireModelArrayTask<M: Mappable> {
    typealias T = Task<Progress, [M], AlamofireError>
}

struct AlamofireImmutableModelTask<M: ImmutableMappable> {
    typealias T = Task<Progress, M, AlamofireError>
}

struct AlamofireImmutableModelArrayTask<M: ImmutableMappable> {
    typealias T = Task<Progress, [M], AlamofireError>
}

class AbstractAPI {
    
    static private let rootUrl: String = {
        let path = Bundle.main.path(forResource: "EnvConfiguration", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        if let keyStr =  dict?.object(forKey: "Environment") as? String {
            return dict!.object(forKey: keyStr) as! String
        }else {
            assertionFailure("Please enter Environment item's value in EnvConfiguration.plist")
            return ""
        }
    }()
    
    static private let userAgent: String = ""
    
    class func createJSONTask(_ url: String,
                              method: HTTPMethod = .get,
                              parameters: Parameters? = nil,
                              encoding: ParameterEncoding = JSONEncoding.default,
                              headers: HTTPHeaders = createHeaders()) -> AlamofireJsonTask {
        let task = AlamofireJsonTask { progress, fulfill, reject, configure in
            
            log?.debug("====request: \(method.rawValue) \(url) \nheaders: \n\(createHeaders()) \nparams: \n\(parameters ?? [:])")
            
            let request = Alamofire
                .request(rootUrl + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            request
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                .validate()
                .responseJSON(completionHandler: { (response) in
                    if let value = response.value {
                        log?.debug("Response OK \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.response!)")
                        fulfill(JSON(value))
                    } else {
                        if let data = response.data {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                            let statusCode = response.response?.statusCode ?? 999
                            reject((statusCode: statusCode, body: data))
                        } else {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                            reject((statusCode: 1999, body: Data()))
                        }
                    }
                })
            
            configRequestTask(configure, request: request)
        }
        
        return task
    }
    
    class func createJSONTask(_ url: String,
                              method: HTTPMethod = .post,
                              data: Data,
                              name: String = "file") -> AlamofireJsonTask {
        let task = AlamofireJsonTask { progress, fulfill, reject, configure in
            let multipartFormData: (MultipartFormData) -> Void = { multipartFormData in
                multipartFormData.append(data, withName: name, fileName: "image", mimeType: "image/png")
            }
            
            let encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)? = { encodingResult in
                switch encodingResult {
                case .success(let request, _, _):
                    request
                        .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                        .validate()
                        .responseJSON(completionHandler: { (response) in
                            if let value = response.value {
                                log?.debug("Response OK \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.response!)")
                                fulfill(JSON(value))
                            } else {
                                if let data = response.data {
                                    log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                                    let statusCode = response.response?.statusCode ?? 999
                                    reject((statusCode: statusCode, body: data))
                                } else {
                                    log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                                    reject((statusCode: 1999, body: Data()))
                                }
                            }
                        })
                    
                    configRequestTask(configure, request: request)
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
            
//            let headers: HTTPHeaders = [
//                "access_token": Account.default.accessToken!
//            ]
            
            let headers: HTTPHeaders = [:]
            
            Alamofire.upload(multipartFormData: multipartFormData,
                             to: rootUrl + url,
                             method: method,
                             headers: headers,
                             encodingCompletion: encodingCompletion)
        }
        
        return task
    }
    
    class func createURLResponseTask(_ url: String,
                                     method: HTTPMethod = .get,
                                     parameters: Parameters? = nil,
                                     encoding: ParameterEncoding = JSONEncoding.default,
                                     headers: HTTPHeaders = createHeaders()) -> AlamofireUrlResponseTask {
        let task = AlamofireUrlResponseTask { progress, fulfill, reject, configure in
            
            log?.debug("====request: \(method.rawValue) \(url) \nheaders: \n\(createHeaders()) \nparams: \n\(parameters ?? [:])")
            
            let request = Alamofire.request(rootUrl + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                .validate()
                .responseJSON(completionHandler: { (response) in
                    if let _ = response.value, let _response = response.response {
                        log?.debug("Response OK \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.response!)")
                        fulfill(_response)
                    } else {
                        if let data = response.data {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                            let statusCode = response.response?.statusCode ?? 999
                            reject((statusCode: statusCode, body: data))
                        } else {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                            reject((statusCode: 1999, body: Data()))
                        }
                    }
                })
            
            configRequestTask(configure, request: request)
        }
        
        return task
    }
    
    class func createModelTask<T: Mappable>(_ url: String,
                                            method: HTTPMethod = .get,
                                            parameters: Parameters? = nil,
                                            encoding: ParameterEncoding = JSONEncoding.default,
                                            headers: HTTPHeaders = createHeaders()) -> AlamofireModelTask<T>.T {
        let task = AlamofireModelTask<T>.T { progress, fulfill, reject, configure in
            log?.debug("====request: \(method.rawValue) \(url) \nheaders: \n\(createHeaders()) \nparams: \n\(parameters ?? [:])")
            
            let request = Alamofire.request(rootUrl + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                .validate()
                .responseObject(completionHandler: { (response: DataResponse<T>) in
                    if let value = response.value {
                        fulfill(value)
                    } else {
                        if let data = response.data {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                            let statusCode = response.response?.statusCode ?? 999
                            reject((statusCode: statusCode, body: data))
                        } else {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                            reject((statusCode: 1999, body: Data()))
                        }
                    }
                })
            
            configRequestTask(configure, request: request)
        }
        
        return task
    }
    
    class func createModelArrayTask<T: Mappable>(_ url: String,
                                                 method: HTTPMethod = .get,
                                                 parameters: Parameters? = nil,
                                                 encoding: ParameterEncoding = URLEncoding.default,
                                                 headers: HTTPHeaders = createHeaders()) -> AlamofireModelArrayTask<T>.T {
        let task = AlamofireModelArrayTask<T>.T { progress, fulfill, reject, configure in
            log?.debug("====request: \(method.rawValue) \(url) \nheaders: \n\(createHeaders()) \nparams: \n\(parameters ?? [:])")
            
            let request = Alamofire.request(rootUrl + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            request
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                .validate()
                .responseArray(keyPath: "data", completionHandler: { (response: DataResponse<[T]>) in
                    if let value = response.value {
                        fulfill(value)
                    } else {
                        if let data = response.data {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                            let statusCode = response.response?.statusCode ?? 999
                            reject((statusCode: statusCode, body: data))
                        } else {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                            reject((statusCode: 1999, body: Data()))
                        }
                    }
                })
            configRequestTask(configure, request: request)
        }
        
        return task
    }
}

extension AbstractAPI {
    class func createModelTask<T: ImmutableMappable>(_ url: String,
                                                     method: HTTPMethod = .post,
                                                     parameters: Parameters? = nil,
                                                     encoding: ParameterEncoding = JSONEncoding.default,
                                                     headers: HTTPHeaders = createHeaders(),
                                                     keyPath: String? = "data") -> AlamofireImmutableModelTask<T>.T {
        let task = AlamofireImmutableModelTask<T>.T { progress, fulfill, reject, configure in
            log?.debug("====request: \(method.rawValue) \(url) \nheaders: \n\(createHeaders()) \nparams: \n\(parameters ?? [:])")
            
            let request = Alamofire.request(rootUrl + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            request
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                .validate()
                .responseObject(keyPath: keyPath, completionHandler: { (response: DataResponse<T>) in
                    if let value = response.value {
                        fulfill(value)
                    } else {
                        if let data = response.data {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                            let statusCode = response.response?.statusCode ?? 999
                            reject((statusCode: statusCode, body: data))
                        } else {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                            reject((statusCode: 1999, body: Data()))
                        }
                    }
                })
            
            configRequestTask(configure, request: request)
        }
        
        return task
    }
    
    class func createModelArrayTask<T: ImmutableMappable>(_ url: String,
                                                          method: HTTPMethod = .post,
                                                          parameters: Parameters? = nil,
                                                          encoding: ParameterEncoding = JSONEncoding.default,
                                                          headers: HTTPHeaders = createHeaders(),
                                                          keyPath: String? = "data") -> AlamofireImmutableModelArrayTask<T>.T {
        let task = AlamofireImmutableModelArrayTask<T>.T { progress, fulfill, reject, configure in
            log?.debug("====request: \(method.rawValue) \(url) \nheaders: \n\(createHeaders()) \nparams: \n\(parameters ?? [:])")
            
            let request = Alamofire.request(rootUrl + url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            log?.debug("====Request: \(request)")
            
            request
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                .validate()
                .responseArray(keyPath: keyPath, completionHandler: { (response: DataResponse<[T]>) in
                    if let value = response.value {
                        fulfill(value)
                    } else {
                        if let data = response.data {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                            let statusCode = response.response?.statusCode ?? 999
                            reject((statusCode: statusCode, body: data))
                        } else {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                            reject((statusCode: 1999, body: Data()))
                        }
                    }
                })
            configRequestTask(configure, request: request)
        }
        
        return task
    }
    
    class func _createModelArrayTask<T: ImmutableMappable>(_ url: String,
                                                           method: HTTPMethod = .get,
                                                           parameters params: Parameters? = nil,
                                                           encoding: ParameterEncoding = URLEncoding.default,
                                                           headers: HTTPHeaders = createHeaders(),
                                                           keyPath: String = "data") -> AlamofireImmutableModelArrayTask<T>.T {
        let task = AlamofireImmutableModelArrayTask<T>.T { progress, fulfill, reject, configure in
            log?.debug("====request: \(method.rawValue) \(url) \nheaders: \n\(createHeaders()) \nparams: \n\(params ?? [:])")
            
            let request = Alamofire.request(rootUrl + url, method: method, parameters: params, encoding: encoding, headers: headers)
            
            request
                .downloadProgress(queue: DispatchQueue.global(qos: .utility), closure: { progress($0) })
                .validate()
                .responseJSON(completionHandler: { (response) in
                    if let dict = response.value as? Dictionary<String, Any> {
                        if let matched = dict[keyPath] as? [Dictionary<String, Any>] {
                            let values = matched
                                .map { Map(mappingType: .fromJSON, JSON: $0) }
                                .map { try! T(map: $0) }
                            
                            fulfill(values)
                        } else {
                            fulfill([])
                        }
                    } else {
                        if let data = response.data {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)\njson: \n\(String(describing: try? JSON(data: data)))")
                            let statusCode = response.response?.statusCode ?? 999
                            reject((statusCode: statusCode, body: data))
                        } else {
                            log?.debug("Response failed \(response.request?.url?.absoluteString ?? "")\nresponse: \n\(response.error!)")
                            reject((statusCode: 1999, body: Data()))
                        }
                    }
                })
            configRequestTask(configure, request: request)
        }
        
        return task
    }
}

extension AbstractAPI {
    private class func configRequestTask(_ configure: TaskConfiguration, request: Request) {
        configure.cancel = { request.cancel() }
        configure.pause = { request.suspend() }
        configure.resume = { request.resume() }
    }
    
    private class func createHeaders(addHeaders: HTTPHeaders? = nil) -> HTTPHeaders {
        var headers = addHeaders ?? HTTPHeaders()
        headers["accept"] = "application/json"
        headers["Content-Type"] = "application/json"
//        if Account.default.isRegistered {
//            headers["access_token"] = Account.default.accessToken!
//        }
        
        return headers
    }
}
