//
//  RegisterViewController.swift
//  Thesis
//
//  Created by Tudor Stanila on 12/04/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var viewModel : RegisterViewModel!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        usernameField.delegate=self
        passwordField.delegate=self
        confirmPasswordField.delegate=self
        usernameField.tag=0
        passwordField.tag=1
        confirmPasswordField.tag=2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtnPress(_ sender: Any) {
        if let username = usernameField.text,!username.isEmpty{
            if let password = passwordField.text,!password.isEmpty,let confirmPassword = confirmPasswordField.text,password==confirmPassword{
                self.viewModel.Register(username: username, password: password) { (ok) in
                    if ok {
                        AlertMessageHelper.displayMessage(message: "Successfully registered!", title: "Register", controller: self)
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        AlertMessageHelper.displayMessage(message: "Something went wrong", title: "Register", controller: self)
                    }
                }
            }else{
                AlertMessageHelper.displayMessage(message: "Confirm password does not match", title: "Register", controller: self)
            }
        }else{
            AlertMessageHelper.displayMessage(message: "Please enter a username", title: "Register", controller: self)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
