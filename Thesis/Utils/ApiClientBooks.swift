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
                    let books = json.handleBookArray()
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
                    let books = json.handleBookArray()
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
                    let resultArray = json["items"]
                    let books = resultArray.handleBookArrayFromGoogle()
                    completion(books)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func GetOwners(of bookId:UUID,completion:@escaping ([User]?)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        let url = Urls.GetOwnersOfBook + bookId.uuidString
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
    
    func GetNumberOfBorrowRequest(completion: @escaping (Int) -> Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        Alamofire.request(Urls.GetNumberOfBorrowRequests,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let result = json["number"].intValue
                    completion(result)
                case .failure( _):
                    completion(0)
                }
        }
    }
    
    func GetBorrowRequests(completion: @escaping ([BorrowRequest]?) -> Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        Alamofire.request(Urls.GetBorrowRequests,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let requests = json.handleBorrowRequestArray()
                    completion(requests)
                case .failure( _):
                    completion(nil)
                }
        }
    }
    
    func AcceptBorrowRequest(userId : String, bookId: UUID, completion: @escaping (Bool)->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        
        let params : Parameters = [
            "From":userId.lowercased(),
            "BookId":bookId.uuidString
        ]
        Alamofire.request(Urls.AcceptBorrowRequest,method:.post,parameters:params,encoding:URLEncoding.httpBody, headers: headers)
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
    
    func SendBorrowRequest(from userId: String, bookId: UUID,completion:@escaping (Bool) ->Void){
        let token = self.keychain.get(KeychainSwift.Keys.Token)
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer \(token!)"
        ]
        
        let params : Parameters = [
            "From":userId.lowercased(),
            "BookId":bookId.uuidString
        ]
        
        Alamofire.request(Urls.SendBorrowRequest,method:.post,parameters:params,encoding:URLEncoding.httpBody,headers:headers)
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
    
    func CallOCR(imageData: NSData, completion: @escaping (String?) -> Void){
        let api_key = Constants.OCR_API_KEY;
        let headers : HTTPHeaders = [
            "apikey":api_key
        ]
        let base64img = imageData.base64EncodedString()
        //print(base64img)
        let param = "data:image/png;base64,"+base64img
        let params : Parameters = [
            "base64Image":param
        ]
        Alamofire.request(Urls.OCR, method:.post,parameters:params,encoding:URLEncoding.httpBody,headers:headers)
            .validate()
            .responseJSON { (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    let text = json.handleOCRResult()
                    completion(text)
                case .failure( _):
                    completion(nil)
                }
        }
    }
}

