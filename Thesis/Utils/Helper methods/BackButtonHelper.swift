//
//  BackButtonHelper.swift
//  Thesis
//
//  Created by Tudor Stanila on 07/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class BackButtonHelper{
    static func GetBackButton(controller: UIViewController,selector:Selector) -> UIButton{
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "backbtn"), for:[]) // Image can be downloaded from here below link
        backbutton.setTitle(" Back", for: [])
        backbutton.setTitleColor(backbutton.tintColor, for: []) // You can change the TitleColor
        backbutton.addTarget(controller, action: selector, for: .touchUpInside)
        return backbutton
    }
}
