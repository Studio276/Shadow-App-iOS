//
//  CustomCollectionViewCell.swift
//  SliderView
//
//  Created by Atinderjit Kaur on 27/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var btn_PlayVideo: UIButton!
    @IBOutlet weak var kHeight_BehindDetailView: NSLayoutConstraint!  //191
    @IBOutlet weak var customScrollView: UIScrollView!
    @IBOutlet var view_OnScrollView: UIView!
    @IBOutlet var imgView_Star1: UIImageView!
    @IBOutlet var imgView_Star2: UIImageView!
    @IBOutlet var imgView_Star3: UIImageView!
    @IBOutlet var imgView_Star4: UIImageView!
    @IBOutlet var imgView_Star5: UIImageView!
    @IBOutlet var imgView_ProfilePic: UIImageView!
    @IBOutlet var btn_SocialSite1: UIButton!
    @IBOutlet var btn_SocialSite2: UIButton!
    @IBOutlet var btn_SocialSite3: UIButton!
    @IBOutlet var view_Fields: UIView!
    @IBOutlet var lbl_CompanySchoolUserName: UILabel!
    @IBOutlet var lbl_Location: UILabel!
    @IBOutlet var lbl_Url: UILabel!
    @IBOutlet var lbl_Count_ShadowersVerified: UILabel!
    @IBOutlet var lbl_Count_ShadowedByShadowUser: UILabel!
    @IBOutlet var lbl_Count_CompanySchoolWithOccupations: UILabel!
    @IBOutlet var lbl_Count_NumberOfUsers: UILabel!
    @IBOutlet var txtView_Description: UITextView!
    
    
    @IBOutlet weak var btn_ViewFullProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.imgView_ProfilePic.layer.cornerRadius = 60.0
            self.imgView_ProfilePic.clipsToBounds = true
            self.imgView_ProfilePic.layer.borderColor = UIColor.init(red: 176.0/255.0, green: 93.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
            self.imgView_ProfilePic.layer.borderWidth = 2.0
        }
       
        
    }

    
    
    
    
    
    
    
    
    
}
