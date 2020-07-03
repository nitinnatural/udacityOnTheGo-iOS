//
//  ViewController.swift
//  On the Map
//
//  Created by Nitin Anand on 03/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        UdacityApi.getSession()
    }
    
    func openUrl(url:String){
        guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }

    @IBAction func handleLoginClick(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! {
            showToast("Email is required")
            return
        }
        
        if (passwordTextField.text?.isEmpty)! {
            showToast("Password is required")
            return
        }
        
        if isValidEmail(emailTextField.text!)  {
            if Reachability.isConnectedToNetwork() {
                UdacityApi.getSession()
            } else {
                showToast("No internet")
            }
        } else {
            showToast("Enter valid email")
        }
    }
    
    @IBAction func handleSignUpClick(_ sender: Any) {
        openUrl(url: "https://auth.udacity.com/sign-up")
    }
    
    func isValidEmail(_ email:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func showToast(_ message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

