//
//  Author.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
class Author{
    var Id:UUID
    var FirstName:String
    var LastName:String
    var FullName:String
    
    init(id:UUID,first:String,last:String,full:String){
        Id=id
        FirstName=first
        LastName=last
        FullName=full
    }
    
    init(json:JSON){
        Id=UUID(uuidString: json["id"].string ?? "00000000-0000-0000-0000-000000000000")!
        FirstName=json["firstName"].stringValue
        LastName=json["lastName"].stringValue
        FullName=json["fullName"].stringValue
    }
}
