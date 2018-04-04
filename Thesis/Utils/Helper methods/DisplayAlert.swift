//
//  DisplayAlert.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class AlertMessageHelper{
    static func displayMessage(message:String,title:String,controller:UIViewController){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
}
