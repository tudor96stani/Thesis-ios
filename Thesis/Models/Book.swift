//
//  Book.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
class Book{
    var Id:UUID
    var Title:String
    var Year:Int
    var Publisher:String
    var Authors:[Author]?
    var Cover:NSData?
    
    init(id:UUID,title:String,year:Int,pub:String){
        Id=id
        Title=title
        Year=year
        Publisher=pub
        Authors = [Author]()
    }
    
    init(json:JSON){
        Id=UUID(uuidString:json["id"].string ?? "00000000-0000-0000-0000-000000000000")!
        Title = json["title"].string ?? ""
        Year = json["year"].intValue
        Publisher = json["publisher"].stringValue
        Authors=[Author]()
        for(_,object) in json["authors"]{
            Authors?.append(Author(json:object))
        }
        let base64String = json["cover"].stringValue
        if base64String != ""
        {
            //let imageString = base64String as NSString
            self.Cover = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))
            
        }
    }
}
