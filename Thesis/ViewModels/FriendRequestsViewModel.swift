//
//  FriendRequestsViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 11/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class FriendRequestsViewModel:NSObject{
    
    @IBOutlet var apiClient : ApiClientUsers!
    var requests : [User]?
    
    func GetFriendName(for indexPath:IndexPath) -> String{
        return (requests?[indexPath.row].Username) ?? ""
    }
    
    func GetFriendId(for indexPath:IndexPath) -> String{
        return (requests?[indexPath.row].Id) ?? ""
    }
    
    func GetCount() -> Int{
        return requests?.count ?? 0
    }
    
    func AcceptRequest(for indexPath:IndexPath,completion:@escaping (Bool) -> Void){
        if let userId = self.requests?[indexPath.row].Id{
            self.apiClient.AcceptRequest(userId: userId) { (ok) in
                DispatchQueue.main.async {
                    completion(ok)
                }
            }
        }
    }
    
    func GetFriendRequests(completion:@escaping ()->Void){
        apiClient.GetFriendRequests{ (users) in
            DispatchQueue.main.async {
                self.requests = users
                completion()
            }
        }
    }
    
    func RemoveFromArray(at indexPath:IndexPath){
        self.requests?.remove(at: indexPath.row)
    }
}
