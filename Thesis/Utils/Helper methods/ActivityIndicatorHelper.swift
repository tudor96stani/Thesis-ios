//
//  ActivityIndicatorHelper.swift
//  Thesis
//
//  Created by Tudor Stanila on 06/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
class ActivityIndicatorHelper{
    static func start(activityIndicator:UIActivityIndicatorView,controller:UIViewController){
        activityIndicator.center = controller.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    static func stop(activityIndicator:UIActivityIndicatorView){
        activityIndicator.stopAnimating()
    }
}
