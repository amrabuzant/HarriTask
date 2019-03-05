//
//  HomeController.swift
//  HarriTask
//
//  Created by Amr Abu Zant on 3/5/19.
//  Copyright © 2019 Amr Abu Zant. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Harri"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
        customizeNavigationController()
    }
    
    func customizeNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "HeaderColor")
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: "userlogin")
        self.navigationController?.popViewController(animated: true)
        
        APIMethods.doLogout{(data, error) in
            if error == nil {
                print(data!)
            } else {
                debugPrint(error!)
            }
        }
        
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
