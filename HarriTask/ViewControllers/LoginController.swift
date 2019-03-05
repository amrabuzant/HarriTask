//
//  LoginController.swift
//  HarriTask
//
//  Created by Amr Abu Zant on 3/5/19.
//  Copyright © 2019 Amr Abu Zant. All rights reserved.
//

import UIKit
import Keyboardy

class LoginController: UIViewController {
    
    @IBOutlet weak var textFieldContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak internal var titleLable: UILabel!
    @IBOutlet weak internal var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

        let status = UserDefaults.standard.bool(forKey: "userlogin")
        
        if status {
            goNext()
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //to manage scroll view for keyboard
        registerForKeyboardNotifications(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //unregister as we are going out of view
        unregisterFromKeyboardNotifications()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let decoder = JSONDecoder()
        let json = "{\"username\": \"\(emailTextField.text!)\" ,\"password\": \"\(passwordTextField.text!)\"}".data(using: .utf8)!
        let info = try! decoder.decode(LoginObj.self, from: json)
        self.view.endEditing(true)
        doLogin(cred: info)
    }
    
    func doLogin(cred: LoginObj){
        
        APIMethods.doLogin(credentials: cred) { [weak self](data, error) in
            if error == nil {
                UserDefaults.standard.set(true, forKey: "userlogin")
                self?.goNext()
                print(data!)
            } else {
                debugPrint(error!)
            }
        }
    }
    
    func goNext(){
        performSegue(withIdentifier: "AuthSuccess", sender: nil)
    }
}

extension LoginController: KeyboardStateDelegate {
    
    func keyboardWillTransition(_ state: KeyboardState) {
        // keyboard will show or hide
        switch state {
        case .activeWithHeight(_):
            titleLable.isHidden = true
            loginButton.isHidden = false
        case .hidden:
            titleLable.isHidden = false
            loginButton.isHidden = true
        }
    }
    
    func keyboardTransitionAnimation(_ state: KeyboardState) {
        switch state {
        case .activeWithHeight(let height):
            textFieldContainerBottomConstraint.constant = height + 44
            loginButtonBottomConstraint.constant = height
        case .hidden:
            textFieldContainerBottomConstraint.constant = 20.5
            loginButtonBottomConstraint.constant = 0
        }
        
        // heigh = 10
        // 
        
        view.layoutIfNeeded()
    }
    
    func keyboardDidTransition(_ state: KeyboardState) {
        // keyboard animation finished
    }
}
