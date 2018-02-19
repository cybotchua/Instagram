//
//  ViewController.swift
//  Instagram
//
//  Created by Terence Chua on 19/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import Pastel
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton! {
        didSet {
            logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.cornerRadius = 5
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.clear.cgColor
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.clear.cgColor
        
        ref = Database.database().reference()
        
        animateLoginBackground()
        
        //skip login page if user is already logged in
        if Auth.auth().currentUser != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
            
            present(vc, animated: true, completion: nil)
        }
            
            //Facebook Login Button
            let fbLoginButton = FBSDKLoginButton()
            fbLoginButton.delegate = self
            let centerY = view.center.y
            fbLoginButton.frame = CGRect(x: 16, y: centerY + 190, width: view.frame.width - 32, height: 50)
            view.addSubview(fbLoginButton)
            fbLoginButton.readPermissions = ["public_profile", "email"]
            
            //Check for existing token if they have already logged in with facebook before
            if FBSDKAccessToken.current() != nil {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                
                self.present(vc, animated: true, completion: nil)
            }
        
    }
    
    @objc func logInButtonTapped() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.showAlert(withTitle: "Error", message: validError.localizedDescription)
            }
            if user != nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    func animateLoginBackground() {
        let pastelView = PastelView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3.8))
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }



}

//Facebook Login Button Delegate
extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                
                //Getting details based on FB Credentials
                if let validResult = result as? [String : Any] {
                    let id = validResult["id"]
                    let name = validResult["name"]
                    let email = validResult["email"]
                    
                    if let picture = validResult["picture"] as? [String : Any],
                        let data = picture["data"] as? [String : Any],
                        let url = data["url"] as? [String : Any] {
                        let pictureURL = picture["url"]
                    }
                    
                    //Create user ID in database
                    if let validUser = user {
                        let fbUser : [String : Any] = ["email" : email, "username" : name]
                        
                        self.ref.child("users").child(validUser.uid).setValue(fbUser)
                        
                        guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                        
                        self.navigationController?.popViewController(animated: false)
                        
                        self.present(navVC, animated: false, completion: nil)
                    }
                    
                    
                    
                }
            }
            )}
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }


}

