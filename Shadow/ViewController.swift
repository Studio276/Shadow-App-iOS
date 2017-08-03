//
//  ViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 29/05/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

public var bool_fromMobile : Bool = false
public var bool_fromVerificationMobile : Bool = false

public var bool_NotVerified: Bool = false
public var str_messageInWrongCeredentials: String?


class ViewController: UIViewController {
    
    //Outlets of UI Objects
    @IBOutlet weak var imgView_Logo: UIImageView!
    @IBOutlet weak var txtView_Email: UITextField!
    @IBOutlet weak var txtview_Password: UITextField!
    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var btn_NeedAnAccount: UIButton!
    @IBOutlet weak var btn_ForgotPassword: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
            self.ButtonCustomAttributes() // call func to update UI
            self.Validation()//TO disbale login button interaction
            self.add_padding(textfield: self.txtView_Email)
            self.add_padding(textfield: self.txtview_Password)
        }
        
        
    }
    
    
    
    
    //MARK: - UI updation of screen
    fileprivate  func ButtonCustomAttributes() {
        
        btn_Login.layer.cornerRadius = 6.0
        btn_Login.layer.masksToBounds = true
        
        self.SetButtonCustomAttributes(btn_NeedAnAccount)
        
        
    }
    //    //Validation
    fileprivate   func Validation()
    {
        if txtView_Email.text != "" && txtview_Password.text !=  ""
        {
            btn_Login.isUserInteractionEnabled = true
            
        }
        else
        {
            btn_Login.isUserInteractionEnabled = false
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //To hide Keyboard from the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    //MARK:- Button Actions
    @IBAction func Action_ForgotPassword(_ sender: UIButton) {
        if self.checkInternetConnection()
        {
            //self.performSegue(withIdentifier: "FirstToRegister", sender: self)
            
            let alert = UIAlertController(title: "Shadow", message: "Choose option to reset your password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "via Email", style: .default, handler: {(action) in
                
                self.performSegue(withIdentifier: "LoginToForgotEmail", sender: self)
                
            }))
            alert.addAction(UIAlertAction(title: "via Phone", style: .default, handler: {(action) in
                
                self.performSegue(withIdentifier: "LoginToForgotPhone", sender: self)
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
        
    }
    @IBAction func Action_Register(_ sender: UIButton) {
        if self.checkInternetConnection()
        {
            self.performSegue(withIdentifier: "FirstToRegister", sender: self)
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
        
        
    }
    @IBAction func Action_Login(_ sender: UIButton) {
        
        if txtView_Email.text != "" {
            if txtview_Password.text != "" {
                
                
                if (txtView_Email.text?.characters.count)! > 5 {
                    
                    if (txtview_Password.text?.characters.count)! > 5 {
                        
                        
                        let dict = NSMutableDictionary()
                        dict.setValue(txtView_Email.text, forKey: Global.macros.kUserName)
                        dict.setValue(txtview_Password.text, forKey: Global.macros.kPassword)
                        dict.setValue("1.1", forKey: Global.macros.kAppVersion)
                        dict.setValue("1.1.1", forKey: Global.macros.kAppBuildNumber)
                        
                        print(dict)
                        
                        if self.checkInternetConnection()
                        {
                            //API To login
                            DispatchQueue.main.async {
                                self.pleaseWait()
                            }
                            
                            AuthenticationAPI.sharedInstance.Login(dict: dict, completion: {(response) in
                                
                                switch response.0
                                {
                                case 200:
                                    
                                    SavedPreferences.set(true, forKey: "user_loggedIn")
                                    
                                   
                                        
                                        if (SavedPreferences.value(forKey: "email")) == nil {
                                            str_Confirmation = "true"
                                             DispatchQueue.main.async {
                                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Email") as! EnterEmailVC
                                                _ = self.navigationController?.pushViewController(vc, animated: true) }
                                            
                                        }
                                            
                                        else if (SavedPreferences.value(forKey: "mobileNumber")) == nil {
                                            str_Confirmation = "true"
                                             DispatchQueue.main.async {
                                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "PhoneNumber") as! EnterPhoneNumberVC
                                                _ = self.navigationController?.pushViewController(vc, animated: true) }
                                            
                                        }
                                            
                                        else   {
                                            
                                            let role = (response.1).value(forKey: "role") as? String
                                            SavedPreferences.setValue(role, forKey: Global.macros.krole)
                                            SavedPreferences.set("yes", forKey: "user_verified")

                                             DispatchQueue.main.async {
                                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "TabBar")as! TabbarController
                                            Global.macros.kAppDelegate.window?.rootViewController = vc
                                            
                                                vc.selectedIndex = 1
                                            }
                                            
                                        }
                                   
                                    
                                case 210:
                                    
                                    bool_NotVerified = true
                                    SavedPreferences.set((response.1).value(forKey: "userId"), forKey: Global.macros.kUserId)
                                    self.CreateAlert()
                                    
                                case 400:
                                    self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                                    
                               
                                    
                                default:
                                    break
                                }
                                
                                self.clearAllNotice()
                                
                            }, errorBlock: {(err) in
                                DispatchQueue.main.async {
                                    self.clearAllNotice()
                                    self.showAlert(Message:Global.macros.kError, vc: self)
                                    
                                }
                            })
                        }
                        else
                        {
                            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                        }
                    }
                    else {
                        self.showAlert(Message: Global.macros.KPasswordLength, vc: self)
                    }
                }
                else {
                    self.showAlert(Message: Global.macros.KUsernameLength, vc: self)
                }
            }
            else {
                
                self.showAlert(Message: "Please enter password.", vc: self)
                
            }
        }
            
            
        else {
            
            
            self.showAlert(Message: "Please enter username.", vc: self)
            
        }
    }
    
    
    
}




/* UITextfield extension for the methods of UITextFieldDelegate */


extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtView_Email {
            txtview_Password.becomeFirstResponder()
        }
        if textField == txtview_Password
        {
            txtview_Password.resignFirstResponder()
            // self.Validation()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //   textField.text?.capitalizeFirstLetter()
        
        let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        
        if (string.length > 0) {
            btn_Login.isUserInteractionEnabled = true
            
            return string.length <= 30
        }
        
        
        return true
        
    }
    
    
}

