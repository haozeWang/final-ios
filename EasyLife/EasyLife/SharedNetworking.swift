//
//  SharedNetworking.swift
//  hello map
//
//  Created by Meng Wang on 3/9/17.
//  Copyright © 2017 Meng Wang. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

// singleton class
class SharedNetworking {
    
    static let networkInstance = SharedNetworking()
    
    func googleMapDirectionResults(url: String, completion:@escaping ([AnyObject], Bool) -> Void) {
        
        // check if network is connected
        if !ReachAbility.isInternetAvailable() {
            return
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // initialize the results
        var routes = [AnyObject]()
        
        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            completion(routes, false)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            return
        }
        
        
        
        // Create a url session
        let urlconfig = URLSessionConfiguration.default
        let session = URLSession(configuration: urlconfig)
        
        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            
            // Print out the response (for debugging purpose)
            print("Response: \(response)")
            
            
            // Ensure there were no errors returned from the request
            guard error == nil else {
                print("error")
                completion(routes, false)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                return
            }
            
            // Ensure there is data and unwrap it
            guard let data = data else {
                completion(routes, false)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                return
            }
            
            // We received raw data, print it out for debugging
            // It needs to be converted to JSON
            print("Raw data: \(data)")
            
            // Serialize the raw data into JSON using `NSJSONSerialization`.  The "do-let" is
            // part of
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("-------------------------")
                print(json)
                
                
                // Cast JSON as an array of dictionaries
                guard let jsonTemp = json as? [String: AnyObject] else {
                    completion(routes, false)
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    return
                }
                
                guard let tempRoutes = jsonTemp["routes"] as? [AnyObject] else {
                    completion(routes, false)
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    return
                }
                
                routes = tempRoutes
                
                completion(routes, true)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            } catch {
                completion(routes, false)
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                return
            }
        })
        // Tasks start off in suspended state, we need to kick it off
        task.resume()
    }
    
    
    
    
}
