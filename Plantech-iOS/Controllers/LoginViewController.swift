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
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    }
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToRegister", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
