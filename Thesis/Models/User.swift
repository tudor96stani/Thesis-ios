//
//  User.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
public class User {
    var Id:String
    var Username:String
    
    init(id:String,username:String){
        Id=id
        Username=username
    }
    
    init(json: JSON)
    {
        Id = json["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"].stringValue
        Username = json["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"].stringValue
    }
}
