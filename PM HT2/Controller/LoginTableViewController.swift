//
//  LoginTableViewController.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import UIKit

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBarButtonItem.isEnabled = false
        createDismissKeyboardTapGesture()
        usernameTextField.becomeFirstResponder()
    }

    @IBAction func textFieldsChanged(_ sender: UITextField) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            loginBarButtonItem.isEnabled = false
        } else {
            loginBarButtonItem.isEnabled = true
        }
    }
   
    @IBAction func loginBarButtonItemPressed(_ sender: UIBarButtonItem) {
        do {
            try BettingSystem.shared.logIn(username: usernameTextField.text!, password: passwordTextField.text!)
        } catch let error as PMError {
            presentAlertOnMainThread(message: error.rawValue)
            return
        } catch { }
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let destinationVC = (segue.destination as! UINavigationController).topViewController as! MainMenuTableViewController
            destinationVC.username = usernameTextField.text!
        }
    }
}
