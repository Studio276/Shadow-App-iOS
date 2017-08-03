//
//  ShadowOptionVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class ShadowOptionVC: UIViewController {

    @IBOutlet var btn_Next: UIButton!
    @IBOutlet var imageView_No: UIImageView!
    @IBOutlet var imageView_Yes: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

     //   self.navigationItem.hidesBackButton = true //Hide default back button
        CreateNavigationBackBarButton() //Create custom back button
        
        self.SetButtonCustomAttributesPurple(btn_Next)
        allowShadow = true
        
        
        imageView_Yes.image = UIImage(named:"purple")
        imageView_No.image = UIImage(named:"blank")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:- Button Actions
    
    @IBAction func Action_SelectShadowOptions(_ sender: UIButton) {
        
        if sender.tag == 0
        {
           imageView_Yes.image = UIImage(named:"purple")
            imageView_No.image = UIImage(named:"blank")
            allowShadow = true


        }
        else
        {
            imageView_Yes.image = UIImage(named:"blank")
            imageView_No.image = UIImage(named:"purple")
            allowShadow = false

        }
        
       
        
    }
    
    @IBAction func Action_Next(_ sender: UIButton) {
        if self.checkInternetConnection()
        {
           self.CreateAlert()
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)

        }
    }
    

}
