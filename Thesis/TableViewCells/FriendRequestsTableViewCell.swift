//
//  FriendRequestsTableViewCell.swift
//  Thesis
//
//  Created by Tudor Stanila on 11/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class FriendRequestsTableViewCell: UITableViewCell {

    var userId : String!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var declineBtn: UIButton!
    
    var acceptAction: (()->Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptBtnPress(_ sender: Any) {
        if let unwrappedAcceptAction = self.acceptAction {
            unwrappedAcceptAction()
        }
    }
    
    

}
