//
//  LoginViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 04/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var viewModel:LoginViewModel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameField.delegate=self
        passwordField.delegate=self
        usernameField.tag=0
        passwordField.tag=1
        
        usernameField.setBottomBorder()
        passwordField.setBottomBorder()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }

    //MARK: Actions
    
    @IBAction func loginBtnPress(_ sender: Any) {
        if let username = usernameField.text, let password = passwordField.text
        {
            viewModel.Login(username: username, password: password, completion: { (success) in
                if success{
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "tabctrl")
                    self.navigationController?.pushViewController(next!, animated: true);
                }
                else{
                    AlertMessageHelper.displayMessage(message: self.viewModel.errorMessage!, title: "Login", controller: self)
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
