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
    
    func Search(by query:String,completion:@escaping ([Book]?)->Void){
        let url = Urls.Search + query;
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
}

