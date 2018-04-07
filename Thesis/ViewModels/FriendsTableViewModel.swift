//
//  FriendsTableViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class FriendsTableViewModel:NSObject{
    var friends: [User]?
    @IBOutlet var apiClient:ApiClientUsers!
    
    func GetFriends(completion:@escaping ()->Void){
        apiClient.GetFriends { (users) in
            DispatchQueue.main.async {
                self.friends = users
                completion()
            }
        }
    }
    
    func GetFriendName(for indexPath:IndexPath) -> String{
        return (friends?[indexPath.row].Username) ?? ""
    }
    
    func GetCount() -> Int{
        return friends?.count ?? 0
    }
}
