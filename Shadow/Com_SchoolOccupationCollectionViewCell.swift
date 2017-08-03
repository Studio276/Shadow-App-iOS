//
//  Com_SchoolOccupationCollectionViewCell.swift
//  Shadow
//
//  Created by Aditi on 27/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class Com_SchoolOccupationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var lbl_Occupationname: UILabel!
    
    override func awakeFromNib() {
        
        
        lbl_Occupationname.layer.cornerRadius = 8.0
        lbl_Occupationname.layer.borderWidth = 2.0
        lbl_Occupationname.layer.borderColor = Global.macros.themeColor.cgColor
        lbl_Occupationname.clipsToBounds = true
        
    }
    
    
}
