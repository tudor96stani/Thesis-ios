//
//  User.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
public class User:Hashable {
    public var hashValue: Int
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.Id==rhs.Id
    }
    
    var Id:String
    var Username:String
    
    init(id:String,username:String){
        Id=id
        Username=username
        hashValue=Id.hashValue
    }
    
    init(json: JSON)
    {
        if let id = json["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"].string,id != ""{
                self.Id = id
        }else{
            self.Id = json["id"].stringValue
        }
        if let username = json["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"].string, username != ""{
            Username = username
        }else{
            Username = json["name"].stringValue
        }
        hashValue=Id.hashValue
    }
}
