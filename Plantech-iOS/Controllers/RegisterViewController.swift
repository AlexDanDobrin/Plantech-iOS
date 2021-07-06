//
//  RegisterViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 08/06/2021.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        if let firstPassword = passwordTextField.text, let secondPassword = repeatPasswordTextField.text, let username = usernameTextField.text {
            if firstPassword == secondPassword {
                CallManager.shared.createUser(username: username, password: firstPassword) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let message):
                        let message = message
                        print(message)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "registerSuccess", sender: self)
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.showToast(controller: self, message: "Username is taken already!", seconds: 2.5)
                        }
                    }
                }
            } else {
                showToast(controller: self, message: "Passwords don't match", seconds: 2.5)
            }
        }
        
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = UIColor.red
            alert.view.alpha = 0.6
            alert.view.layer.cornerRadius = 15
            
            controller.present(alert, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
            }
        }

}
