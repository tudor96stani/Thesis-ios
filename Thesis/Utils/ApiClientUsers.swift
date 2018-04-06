//
//  ApiClientUsers.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainSwift

class ApiClientUsers:NSObject{
    
    let keychain = KeychainSwift()
    let defaultValues = UserDefaults.standard
    
    func RefreshTokenIfNecessary(token: String,outercompletion: @escaping () -> Void){
        
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        Alamofire.request(Urls.RefreshURL,headers:headers).response { (response) in
            switch response.response?.statusCode{
            case 200?:
                //token still valid
                outercompletion()
                
            default:
                //token no longer valid
                let username = self.keychain.get(KeychainSwift.Keys.Username)!
                let password = self.keychain.get(KeychainSwift.Keys.Password)!
                self.Login(username: username, password: password, completion: { (user, message, success) in
                    if success{
                        outercompletion()
                    }
                })
            }
        }
    }
    
    
    func Login(username:String,password:String,completion: @escaping (User?,String?,Bool)->Void){
        let params : Parameters = [
            "username":username,
            "password":password,
            "grant_type":"password"
        ]
        
        Alamofire.request(Urls.LoginUrl,method:.post,parameters:params,encoding:URLEncoding.httpBody)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let user = User(json:json)
                    let token = json["access_token"].stringValue
                    
                    self.keychain.set(token,forKey:KeychainSwift.Keys.Token)
                    self.keychain.set(username,forKey:KeychainSwift.Keys.Username)
                    self.keychain.set(password,forKey:KeychainSwift.Keys.Password)
                    self.defaultValues.set(user.Id,forKey:UserDefaults.Keys.UserId)
                    
                    
                    completion(user,nil,true)
                    
                case .failure(let error):
                    let message : String
                    if let httpStatusCode = response.response?.statusCode {
                        switch(httpStatusCode) {
                        case 400:
                            message = "Incorrect username or password."
                        default:
                            message = "There was an error"
                        }
                    } else {
                        message = error.localizedDescription
                    }
                    completion(nil,message,false)
                }
            }
        
    }
}
