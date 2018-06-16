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
    
    func Register(username:String,password:String,completion:@escaping (Bool) -> Void){
        let params : Parameters = [
            "Username":username,
            "Password":password
        ]
        Alamofire.request(Urls.Register,method:.post,parameters:params,encoding:URLEncoding.httpBody)
            .validate()
            .response { (response) in
                switch response.response?.statusCode{
                case 200?:
                    completion(true)
                default:
                    completion(false)
                }
        }
    }
    
    func GetFriends(completion:@escaping ([User]?)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let url = Urls.GetFriends + self.defaultValues.string(forKey: UserDefaults.Keys.UserId)!
        
        Alamofire.request(url,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let users = json.handleUserArray()
                    completion(users)
                case .failure( _):
                    completion(nil)
                }
        }
        
    }
    
    func GetNewsFeed(page:Int,completion:@escaping ([Activity]?)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let url = Urls.GetNewsFeed + String(page)
        Alamofire.request(url,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    var activities = [Activity]()
                    for(_,subJson) in json{
                        activities.append(Activity(json: subJson))
                    }
                    completion(activities)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func GetFriendRequests(completion:@escaping ([User]?,[Int]?)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        
        Alamofire.request(Urls.GetFriendRequests,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    var users = [User]()
                    var count = [Int]()
                    for(_,subJson) in json{
                        users.append(User(json: subJson["user"]))
                        count.append(subJson["commonFriendsCount"].intValue)
                    }
                    
                    completion(users,count)
                    
                case .failure( _):
                    completion(nil,nil)
                }
        }
    }
    
    func GetFriendRequestsNumber(completion:@escaping (Int)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        
        Alamofire.request(Urls.GetFriendRequestsNumber,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let result = json["count"].intValue
                    completion(result)
                case .failure( _):
                    completion(0)
                }
        }
    }
    
    func AcceptRequest(userId:String,completion:@escaping (Bool)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let url = Urls.AcceptFriendRequest + userId
        Alamofire.request(url,method:.post,headers:headers)
            .validate()
            .response { (response) in
                switch response.response?.statusCode{
                case 200?:
                    completion(true)
                default:
                    completion(false)
                }
            }
        
    }
    
    func FindFriends(query:String, completion:@escaping ([User]?)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let url = Urls.FindUsers + query
        Alamofire.request(url,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let users = json.handleUserArray()
                    completion(users)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func AddFriend(userId:String,completion:@escaping (Bool)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let url = Urls.AddFriend + userId
        Alamofire.request(url,method:.post,headers:headers)
            .validate()
            .response { (response) in
                switch response.response?.statusCode{
                case 200?:
                    completion(true)
                default:
                    completion(false)
                }
        }
        
    }
    
    func GetNumberOfCommonFriends(userId:String, completion: @escaping (Int) -> Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)!
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token)"
        ]
        let url = Urls.NumberOfCommonFriends + userId
        Alamofire.request(url, headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let result = json["Count"].intValue
                    completion(result)
                case .failure( _):
                    completion(-1)
                }
        }
    }
    
}
