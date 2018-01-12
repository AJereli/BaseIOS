//
//  ApiManager.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 11/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {

    static var headers:HTTPHeaders = [:]
    
    func call (url: URL, method:HTTPMethod, parameters: Parameters?,
               encoding:ParameterEncoding = URLEncoding.default, headers:HTTPHeaders = ApiManager.headers){
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(response.result.value)
                }
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
        }
        
    }
    
    
}
