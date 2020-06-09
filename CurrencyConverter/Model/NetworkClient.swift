//
//  NetworkClient.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 5/17/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class NetworkClient: NSObject{
    
    let session = URLSession.shared
    
    
    func getDataMethod(_ method: String?, parameters: [String:AnyObject], completionHandlerforGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let apiParameters = parameters
        
        let request = URLRequest(url: sessionURLFromParameters(apiParameters, withPathExtension: method))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else{
                print("There was an error in the get request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else{
                print("There was no statusCode returned")
                return
            }
            
            guard let data = data else{
                print("There was no data for your request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerforGET)
        }
        
        task.resume()
        
        return task
        
    }
    
    private func sessionURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
                
        var components = URLComponents()
        components.scheme = "https"
        components.host = "free.currconv.com"
        components.path = "/api/v7/" + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        //print(components.url!)
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    class func sharedInstance() -> NetworkClient {
        struct Singleton {
            static var sharedInstance = NetworkClient()
        }
        return Singleton.sharedInstance
    }
    
}
