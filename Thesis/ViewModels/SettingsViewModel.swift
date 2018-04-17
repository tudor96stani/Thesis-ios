//
//  SettingsViewModel.swift
//  Thesis
//
//  Created by Tudor Stanila on 11/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
class SettingsViewModel:NSObject {
    @IBOutlet var apiClient : ApiClientUsers!
    var friendRequests : Int = 0
    
    func GetFriendRequestsNumber(completion:@escaping ()->Void){
        apiClient.GetFriendRequestsNumber { (result) in
            self.friendRequests = result
            completion()
        }
    }
}
