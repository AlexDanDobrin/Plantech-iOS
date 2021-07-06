//
//  LoginViewController.swift
//  Plantech-iOS
//
//  Created by Alex Dobrin on 08/06/2021.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        if let password = passwordTextField.text, let username = usernameTextField.text {
            CallManager.shared.loginUser(username: username, password: password) { [weak self] result in
                guard let self = self else { return }
                    
                switch result {
                case .success(let message):
                    let message = message
                    print(message)
                    Account.username = username
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.showToast(controller: self, message: "Username or password incorrect!", seconds: 2.5)
                    }
                }
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToRegister", sender: self)
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
