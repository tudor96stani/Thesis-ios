//
//  BorrowRequestsViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 20/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class BorrowRequestsViewModel : NSObject {
    @IBOutlet var apiClient : ApiClientBooks!
    var requests : [BorrowRequest]?
    
    func GetRequests(completion:@escaping () -> Void) {
        apiClient.GetBorrowRequests { (result) in
            DispatchQueue.main.async {
                self.requests = result
                completion()
            }
        }
    }
    
    func GetCount() -> Int {
        return self.requests?.count ?? 0
    }
    
    func GetUsernameFor(requestAt indexPath:IndexPath) -> String {
        return self.requests?[indexPath.row].borrower.Username ?? ""
    }
    
    func GetTitle(requestAt indexPath:IndexPath) -> String {
        return self.requests?[indexPath.row].book.Title ?? ""
    }
    
    func AcceptRequest(at indexPath:IndexPath,completion:@escaping (Bool)->Void){
        if let userid = requests?[indexPath.row].borrower.Id,
            let bookid = requests?[indexPath.row].book.Id {
                self.apiClient.AcceptBorrowRequest(userId: userid, bookId: bookid) { (ok) in
                DispatchQueue.main.async {
                    completion(ok)
                }
            }
        }
        
    }
}
