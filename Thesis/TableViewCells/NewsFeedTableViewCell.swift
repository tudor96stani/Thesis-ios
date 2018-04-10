//
//  NewsFeedTableViewCell.swift
//  Thesis
//
//  Created by Tudor Stanila on 10/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerActionLabel: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
