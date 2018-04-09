//
//  GoogleResultCollectionViewCell.swift
//  Thesis
//
//  Created by Tudor Stanila on 08/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class GoogleResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleAuthorLabel: UILabel!
    @IBOutlet weak var coverView: UIImageView!
    var bookId:UUID!
}
