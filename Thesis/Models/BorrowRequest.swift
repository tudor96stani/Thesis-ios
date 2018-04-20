//
//  BorrowRequest.swift
//  Thesis
//
//  Created by Tudor Stanila on 20/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import SwiftyJSON
class BorrowRequest {
    var book : Book!
    var borrower: User!
    
    init(json:JSON){
        self.book = Book(json:json["book"])
        self.borrower = User(json:json["borrower"])
    }
}
