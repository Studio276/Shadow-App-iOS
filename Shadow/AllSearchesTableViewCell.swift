//
//  AllSearchesTableViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 26/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class AllSearchesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var imgStar_One: UIImageView!
    @IBOutlet weak var imgStar_Two: UIImageView!
    @IBOutlet weak var imgStar_Three: UIImageView!
    @IBOutlet weak var imgStar_Four: UIImageView!
    @IBOutlet weak var imgStar_Five: UIImageView!
    
    @IBOutlet weak var btn_DidSelectRow: UIButton!
    @IBOutlet weak var lbl_Time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        DispatchQueue.main.async {
            self.imgView_Profile.layer.cornerRadius = 25.0
            self.imgView_Profile.clipsToBounds = true
            self.imgView_Profile.layer.borderColor = UIColor.init(red: 176.0/255.0, green: 93.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
            self.imgView_Profile.layer.borderWidth = 2.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
