//
//  RegaisterExplanationViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 19/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class RegaisterExplanationViewController: UIViewController {
    
    public var str_Title : String?
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var txtview_Explanation: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.navigationItem.hidesBackButton = true //Hide default back button

        DispatchQueue.main.async {
            
        self.lbl_Title.text = self.str_Title
        self.CreateNavigationBackBarButton() //Create custom ack button
   

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}