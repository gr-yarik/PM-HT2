//
//  RegisterTableViewController.swift
//  PM HT2
//
//  Created by Yaroslav Hrytsun on 16.12.2020.
//

import UIKit

class RegisterTableViewController: UITableViewController {
    
    @IBOutlet weak var statusPicker: UIPickerView!
    
    var getStatusPickerValue: UserStatus! {
        get {
            switch statusPicker.selectedRow(inComponent: 0) {
            case 0:
                return .regular
            case 1:
                return .admin
            default:
                return nil
            }
        }
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBarButtonItem.isEnabled     = false
        statusPicker.delegate               = self
        createDismissKeyboardTapGesture()
    }
    
    
    @IBAction func textFieldsChanged(_ sender: UITextField) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            registerBarButtonItem.isEnabled = false
        } else {
            registerBarButtonItem.isEnabled = true
        }
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
        do {
            try BettingSystem.shared.registerNewUser(status: getStatusPickerValue, username: usernameTextField.text!, password: passwordTextField.text!)
            performSegue(withIdentifier: "registerSegue", sender: nil)
        } catch let error as PMError {
            self.presentAlertOnMainThread(message: error.rawValue)
        } catch { }
        
    }
}


extension RegisterTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "Regular user"
        case 1:
            return "Admin user"
        default:
            return nil
        }
    }
}
