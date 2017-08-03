

//
//  SkillsNInterestCollectionViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 09/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class SkillsNInterestCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lbl_Skill: UILabel!
    
    override func awakeFromNib() {
        
        
        lbl_Skill.layer.cornerRadius = 8.0
        lbl_Skill.layer.borderWidth = 2.0
        lbl_Skill.layer.borderColor = Global.macros.themeColor.cgColor
        lbl_Skill.clipsToBounds = true
        

    }

    
}
