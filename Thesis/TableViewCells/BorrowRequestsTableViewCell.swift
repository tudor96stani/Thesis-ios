//
//  BorrowRequestsTableViewCell.swift
//  Thesis
//
//  Created by Tudor Stanila on 19/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class BorrowRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var acceptAction: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func acceptBtnPress(_ sender: Any) {
        acceptAction?()
    }
    
}
