//
//  HttpApiManager.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import Foundation
import Alamofire
import RxSwift

public class HttpAPIManager: NSObject {
    
    class var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }
    
    public class func call<T, E>(api: String, method: Alamofire.HTTPMethod, encodable: E, headers: HTTPHeaders, responseClass:T.Type, completion: @escaping (_ result: T?, _ error: NSError?) -> Void) where T: Decodable , E: Encodable {
        
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(encodable)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                
                self.call(api: api, method: method, parameters: jsonObject, headers: headers, responseClass: responseClass, completion: completion)
            } else {
                completion(nil, nil)
            }
        } catch {
            debugPrint("\(error)")
            completion(nil, error as NSError)
        }
        
        
    }
    
    public class func call<T>(api: String, method: Alamofire.HTTPMethod, parameters:[String: Any]? = nil, headers:HTTPHeaders, responseClass:T.Type, completion: @escaping (_ result: T?, _ error: NSError?) -> Void) where T: Decodable {
        
        
        let urlString: String = api
        let method = method
        
        var request: DataRequest
        let params: [String: Any] = parameters != nil ? parameters! : [:]
        
        if method == .get {
            var urlComponents = URLComponents(string: urlString)
            var urlQueryItems: [URLQueryItem] = []
            for (key, value) in params {
                urlQueryItems.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            
            if urlQueryItems.count > 0 {
                urlComponents?.queryItems = urlQueryItems
            }
            
            guard let url = urlComponents?.url else {
                completion(nil, NSError(domain: "Invalid url", code: -1, userInfo: nil))
                return
            }
            
            var urlRequest = try! URLRequest(url: url, method: method, headers: headers)
            urlRequest.timeoutInterval = 30
            
            request = AF.request(urlRequest)
        } else {
            let url = URL(string: urlString)!
            var urlRequest = try! URLRequest(url: url, method: method, headers: headers)
            
            
            let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            urlRequest.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
            
            urlRequest.timeoutInterval = 30
            
            request = AF.request(urlRequest)
        }
        
        request.responseData { (responseData) in
            DispatchQueue.global().async {
                
                guard let response = responseData.response else {
                    DispatchQueue.main.async {
                        completion(nil, responseData.error as NSError?)
                    }
                    return
                }
                
                guard responseData.error == nil else {
                    DispatchQueue.main.async {
                        completion(nil, responseData.error as NSError?)
                    }
                    return
                }
                
                let jsonDecoder = HttpAPIManager.jsonDecoder
                
                if response.statusCode > 199 && response.statusCode < 300 {
                    do {
                        let result = try jsonDecoder.decode(responseClass, from: responseData.data!)
                        
                        DispatchQueue.main.async {
                            completion(result, nil)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(nil, error as NSError?)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "iOS", code: response.statusCode, userInfo: nil))
                    }
                }
            }
        }
    }
}
