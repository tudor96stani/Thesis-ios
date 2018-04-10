//
//  Activity.swift
//  Thesis
//
//  Created by Tudor Stanila on 10/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
class Activity{
    var id : UUID!
    var dateTime:Date!
    var book:Book!
    var owner:User!
    var type:ActivityType!
    
    init(json:JSON){
        id = UUID(uuidString:json["id"].string ?? "00000000-0000-0000-0000-000000000000")!
        //let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let stringValueOfDate = json["dateTimeUtc"].stringValue
        if let date = stringValueOfDate.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SS"){
            self.dateTime = date
        }
        book = Book(json: json["book"])
        owner = User(json: json["owner"])
        type = ActivityType(rawValue: json["type"].intValue)
    }
}
