//
//  MainView_UserSocialSitesTableViewCell.swift
//  Shadow
//
//  Created by Aditi on 03/07/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class MainView_UserSocialSitesTableViewCell: UITableViewCell {

    
    @IBOutlet var imgView_SocialSite: UIImageView!
    
    @IBOutlet var txtField_SocialSiteURL: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   

}