//
//  ApiClientBooks.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainSwift
class ApiClientBooks:NSObject{
    
    let keychain = KeychainSwift()
    
    func GetLibrary(for userId:UUID,completion:@escaping ([Book]?)->Void){
        let url = Urls.GetLibrary + userId.uuidString;
        
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        
        Alamofire.request(url,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    var books = [Book]()
                    for(_,subJson):(String,JSON) in json
                    {
                        books.append(Book(json:subJson))
                    }
                    completion(books)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func CheckIfInLibrary(bookId:UUID,completion:@escaping (Bool) -> Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        let url = Urls.CheckIfInLibrary + bookId.uuidString
        Alamofire.request(url,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let result = json["inLibrary"].boolValue
                    completion(result)
                case .failure( _):
                    completion(false)
                }
        }
    }
    
    func Search(by query:String,completion:@escaping ([Book]?)->Void){
        let url = Urls.Search + query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!;
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        
        Alamofire.request(url,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    var books = [Book]()
                    for(_,subJson):(String,JSON) in json
                    {
                        books.append(Book(json:subJson))
                    }
                    completion(books)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func AddBookToLibrary(bookId:UUID,completion:@escaping (Bool,String)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        let params : Parameters = [
            "Param":bookId.uuidString
        ]
        
        Alamofire.request(Urls.AddToLibrary, method: .post, parameters: params, headers: headers)
            .validate()
            .response { (response) in
                switch response.response?.statusCode{
                case 200?:
                    completion(true,"")
                default:
                    guard let data = response.data
                        else{
                            return;
                    }
                    let json = JSON(data)
                    completion(false,json.stringValue)
                }
        }
    }
    
    func AddNewBookToLibrary(title:String,year:Int,publisher:String,authors:[String]?,cover:String,completion:@escaping (Bool,String?)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]

            let params : Parameters = [
                "Title":title,
                "Year":year,
                "Publisher":publisher,
                "CoverUrl":cover,
                "Authors":authors!
            ]
        
            
            Alamofire.request(Urls.AddNewBookToLibrary, method: .post, parameters: params,encoding:URLEncoding.httpBody, headers: headers)
                .validate()
                .response { (response) in
                    switch response.response?.statusCode{
                    case 200?:
                        completion(true,nil)
                    default:
                        guard let data = response.data
                            else{
                                return;
                        }
                        let json = JSON(data)
                        completion(false,json.stringValue)
                    }
            }
            
    }
    
    func SearchGoogleApi(query:String,pageToDisplay: Int, completion:@escaping ([Book]?) -> Void){
        let startIndex = String((pageToDisplay-1)*10)
        let url = Urls.GoogleApiSearch + query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "&startIndex=" + startIndex + "&maxResults=10"
        Alamofire.request(url)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    var books = [Book]()
                    let resultArray = json["items"].arrayValue
                    for(subJson):(JSON) in resultArray
                    {
                        books.append(Book(googleJson: subJson))
                    }
                    completion(books)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    
}

