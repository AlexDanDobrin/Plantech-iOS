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
                    case .failure(let error):
                        print(error)
                        
                    }
                }
            }
        }
        
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
