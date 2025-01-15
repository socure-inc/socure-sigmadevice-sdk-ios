//
//  Webcalls.swift
//  SampleApp
//
//  Copyright © 2025 Socure. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public class Webcalls: NSObject {
    let idPlusAPIURL = "https://service.socure.com/api/3.0/EmailAuthScore"
    
    var socureIDPlusKey:String
    
    init(idPlusKey:String) {
        socureIDPlusKey = idPlusKey
        
        super.init()
    }
    
    private func post(params : Parameters, url : String,onCompletion: @escaping ((Any) -> Void), onError: ((Error?) -> Void)? = nil) {
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "application/json","Authorization":"SocureApiKey \(socureIDPlusKey)"
        ]
        
        AF.request(url, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
                response in
                
                switch response.result {
                    
                case .success(let value):
                    onCompletion(value)
                    break

                case .failure(let error):
                    onError!(error)
                    break
                }
        }
    }
    
    func deviceRiskValidationAPICall(sessionToken:String, clientInfo:[String:String], onCompletion: @escaping ((Any) -> Void), onError: @escaping ((Error?) -> Void)) {
        
        let moduleArray = ["devicerisk"]
        
        var params:Parameters = Parameters()
        params["modules"] = moduleArray
        params["deviceSessionId"] = sessionToken
        params["userConsent"] = true
        if let firstName = clientInfo["firstName"] {
            params["firstName"] = firstName
        }
        
        if let lastName = clientInfo["surName"] {
            params["surName"] = lastName
        }
        
        if let email = clientInfo["email"] {
            params["email"] = email
        }
        
        if let physicalAddress = clientInfo["physicalAddress"] {
            params["physicalAddress"] = physicalAddress
        }
        
        if let city = clientInfo["city"] {
            params["city"] = city
        }
        
        if let state = clientInfo["state"] {
            params["state"] = state
        }
        
        if let email = clientInfo["email"] {
            params["email"] = email
        }
        
        if let country = clientInfo["country"] {
            params["country"] = country
        }
        
        if let state = clientInfo["state"] {
            params["state"] = state
        }
        
        if let zip = clientInfo["zip"] {
            params["zip"] = zip
        }
        if let mobileNumber = clientInfo["mobileNumber"] {
            params["mobileNumber"] = mobileNumber
        }
        
        post(params: params, url: self.idPlusAPIURL, onCompletion: { (response) in
              
              onCompletion(response)
              
          }, onError: { (err) in
              onError(err)
          })
        
    }
}
