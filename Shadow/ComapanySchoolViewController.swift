//
//  ComapanySchoolViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 28/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit



class ComapanySchoolViewController: UIViewController{
    
    
    @IBOutlet var Scroll_View: UIScrollView!
    @IBOutlet var imgView_ProfilePic: UIImageView!
    @IBOutlet var btn_SocialSite1: UIButton!
    @IBOutlet var btn_SocialSite2: UIButton!
    @IBOutlet var btn_SocialSite3: UIButton!
    @IBOutlet var lbl_company_schoolName: UILabel!
    @IBOutlet var lbl_company_schoolLocation: UILabel!
    @IBOutlet var lbl_company_schoolUrl: UILabel!
    @IBOutlet var lbl_CountverifiedShadowers: UILabel!
    @IBOutlet var lbl_CountshadowedYou: UILabel!
    @IBOutlet var lbl_Count_cmpnyschool_withthesesoccupation: UILabel!
    @IBOutlet var lbl_Count_Users: UILabel!
    @IBOutlet var lbl_title__cmpnyschool_withthesesoccupation: UILabel!
    @IBOutlet var lbl_title_Users: UILabel!
    @IBOutlet var lbl_description: UILabel!
    @IBOutlet var lbl_Placeholder_description: UILabel!
    @IBOutlet var lbl_NoOccupationYet: UILabel!
    @IBOutlet var collection_View: UICollectionView!
    var linkForOpenWebsite : String?
    var rating_number  : String?

    
    fileprivate var array_UserOccupations:NSArray = NSArray()
    fileprivate var array_User_SocialSites:NSMutableArray = NSMutableArray()
    
    var dicUrl: NSMutableDictionary = NSMutableDictionary()
    let array_URL = ["facebookUrl","linkedInUrl","instagramUrl","googlePlusUrl","gitHubUrl","twitterUrl"]

    
    var imageView1 : UIImageView?
    var imageView2 : UIImageView?
    var imageView3 : UIImageView?
    var imageView4 : UIImageView?
    var imageView5 : UIImageView?

    
    
    override func viewDidLayoutSubviews() {
        
        //if Global.DeviceType.IS_IPHONE_5{
            
            Scroll_View.contentSize = CGSize.init(width: view.frame.size.width, height:  900)
      //  }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.imgView_ProfilePic.layer.cornerRadius = 75.0
            self.imgView_ProfilePic.clipsToBounds = true
            self.imgView_ProfilePic.layer.borderColor = Global.macros.themeColor.cgColor
            self.imgView_ProfilePic.layer.borderWidth = 2.0
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        dicUrl.removeAllObjects()
        ratingview_ratingNumber = ""

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.custom_StarView ()
        self.Scroll_View.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)

        
        if bool_UserIdComingFromSearch == true {
            
              DispatchQueue.main.async {
                
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationItem.setHidesBackButton(false, animated:true)
            self.CreateNavigationBackBarButton() //Create custom back button
            self.tabBarController?.tabBar.isHidden = true
            
                self.lbl_description.layer.borderWidth = 1.0
                self.lbl_description.layer.borderColor = Global.macros.themeColor.cgColor
                self.lbl_description.layer.cornerRadius = 4.0
                self.lbl_description.clipsToBounds = true
            
            let btn2 = UIButton(type: .custom)
            btn2.setImage(UIImage(named: "chat-icon"), for: .normal)
            btn2.frame = CGRect(x: self.view.frame.size.width - 70, y: 0, width: 25, height: 25)
            btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
            let item2 = UIBarButtonItem(customView: btn2)
            
            let btn3 = UIButton(type: .custom)
            btn3.setImage(UIImage(named: "shadow-icon-1"), for: .normal)
            btn3.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 25, height: 25)
            btn3.addTarget(self, action: #selector(self.shadowBtnPressed), for: .touchUpInside)
            let item3 = UIBarButtonItem(customView: btn3)
            self.navigationItem.setRightBarButtonItems([item2,item3], animated: true)
        //    user_Id = userIdFromSearch
            
            
            self.lbl_company_schoolName.text = dic_DataOfProfileForOtherUser["name"] as? String
             self.rating_number = "\(dic_DataOfProfileForOtherUser["avgRating"]!)"
                
                if ratingview_ratingNumber == "" {
                    ratingview_ratingNumber = self.rating_number!
                }
            
            self.SetRatingView(Number:ratingview_ratingNumber)
                
                ratingview_ratingNumber = self.rating_number!
                ratingview_name = dic_DataOfProfileForOtherUser["name"] as? String

    
            
            let dict_Temp = dic_DataOfProfileForOtherUser["userDTO"] as? NSDictionary
                
                
                let str_video =  dict_Temp?.value(forKey: "videoUrl") as? String
                if str_video != nil {
                    video_url = NSURL(string: str_video!) as URL?
                }
                else{
                    video_url = nil
                }

                
            let location =  dict_Temp?.value(forKey: "location") as? String
            let str_role = dict_Temp?.value(forKey: "role") as? String
            let url : String?

            if str_role == "COMPANY" {
            
            url = dict_Temp?.value(forKey: "companyUrl") as? String
                
            }
            
            else {
                
              url = dict_Temp?.value(forKey: "schoolUrl") as? String

            }
            
            if url != "" && url != nil
            {
                self.lbl_company_schoolUrl.text = url
            }
            else {
                self.lbl_company_schoolUrl.text = "NA"
            }
            
            if location != "" && location != nil
            {
                self.lbl_company_schoolLocation.text = location
            }
            else {
                self.lbl_company_schoolLocation.text = "NA"
            }
            
            //  profileImageUrl
            var profileurl = dict_Temp?.value(forKey: "profileImageUrl") as? String
            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ratingview_imgurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                if profileurl != nil {

            self.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
                }
            
            self.lbl_CountverifiedShadowers.text = "\((dict_Temp?.value(forKey: "shadowersVerified") as! NSDictionary)["count"]!)"
            self.lbl_CountshadowedYou.text = "\((dict_Temp?.value(forKey: "shadowedByShadowUser") as! NSDictionary)["count"]!)"
            self.lbl_Count_Users.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseUsers") as! NSDictionary)["count"]!)"
                if (dict_Temp?.value(forKey: "schoolOrCompanyWithTheseOccupations") as? NSDictionary)?["count"] != nil {
            self.lbl_Count_cmpnyschool_withthesesoccupation.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary)["count"]!)"
                }
            
            let str_bio = dict_Temp?.value(forKey: "bio") as? String
            
            if str_bio == "" || str_bio == nil {
                self.lbl_description.text   = " " + "No biography to show..."
                
            }
            else {
                self.lbl_description.text = " " + (str_bio)!
            }
            
            
        if dict_Temp?.value(forKey: "occupations")as? NSArray != nil {
                
                 self.array_UserOccupations = (dict_Temp?.value(forKey: "occupations") as? NSArray)?.mutableCopy() as! NSMutableArray
                if  self.array_UserOccupations.count > 0{
                    
                    self.collection_View.reloadData()
                    
                }
                else{
                    self.collection_View.isHidden = true
                    self.lbl_NoOccupationYet.isHidden = false
                }
            }
            else {
                self.collection_View.isHidden = true
                self.lbl_NoOccupationYet.isHidden = false
                
            }
                
                for index in self.array_URL
                {
                    
                    if ( dict_Temp?[index] != nil && dict_Temp?.value(forKey: index) as? String != "" )
                    {
                        self.dicUrl.setValue(dict_Temp?.value(forKey: index)!, forKey: index)
                    }

                }
                
                let tempArray = self.dicUrl.allKeys as! [String]
                
                if (self.dicUrl.count > 0)
                {
                    if tempArray.count >= 1 {
                        
                        self.btn_SocialSite1.isHidden = false
                        self.btn_SocialSite1.setImage(UIImage(named:tempArray[0]), for: UIControlState.normal)
                        
                        
                    }
                    if tempArray.count >= 2 {
                        
                        self.btn_SocialSite2.isHidden = false
                        self.btn_SocialSite2.setImage(UIImage(named:tempArray[1]), for: UIControlState.normal)
                        
                    }
                    if tempArray.count == 3  {
                        
                        self.btn_SocialSite3.isHidden = false
                        self.btn_SocialSite3.setImage(UIImage(named:tempArray[2] ), for: UIControlState.normal)
                        
                    }
                    
                    
                }
                
            
            }

        }
        else {
            
            DispatchQueue.main.async {
                self.tabBarController?.tabBar.isHidden = false

                self.lbl_description.layer.borderWidth = 1.0
                self.lbl_description.layer.borderColor = Global.macros.themeColor.cgColor
                self.lbl_description.layer.cornerRadius = 4.0
                self.lbl_description.clipsToBounds = true

                let btn1 = UIButton(type: .custom)
                btn1.setImage(UIImage(named: "notifications-button"), for: .normal)
                btn1.frame = CGRect(x: -5, y: 0, width: 25, height: 25)
                btn1.addTarget(self, action: #selector(self.notificationBtnPressed), for: .touchUpInside)
                let item1 = UIBarButtonItem(customView: btn1)
                
                let btn2 = UIButton(type: .custom)
                btn2.setImage(UIImage(named: "chat-icon"), for: .normal)
                btn2.frame = CGRect(x: 25, y: 0, width: 25, height: 25)
                btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                let item2 = UIBarButtonItem(customView: btn2)
                
                let btn3 = UIButton(type: .custom)
                btn3.setImage(UIImage(named: "shadow-icon-1"), for: .normal)
                btn3.frame = CGRect(x: 50, y: 0, width: 25, height: 25)
                btn3.addTarget(self, action: #selector(self.shadowBtnPressed), for: .touchUpInside)
                let item3 = UIBarButtonItem(customView: btn3)
                self.navigationItem.setLeftBarButtonItems([item1,item2,item3], animated: true)
                
                let btn4 = UIButton(type: .custom)
                btn4.setImage(UIImage(named: "three-horizontal-lines"), for: .normal)
                btn4.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 25, height: 25)
                btn4.addTarget(self, action: #selector(self.menuBtnPressed), for: .touchUpInside)
                let item4 = UIBarButtonItem(customView: btn4)
                
                let btn5 = UIButton(type: .custom)
                btn5.setImage(UIImage(named: "pencil-edit-button"), for: .normal)
                btn5.frame = CGRect(x: self.view.frame.size.width - 70, y: 0, width: 25, height: 25)
                btn5.addTarget(self, action: #selector(self.editProfileBtnPressed), for: .touchUpInside)
                let item5 = UIBarButtonItem(customView: btn5)

                self.navigationItem.setRightBarButtonItems([item4,item5], animated: true)
                self.navigationController?.navigationBar.isHidden = false
                self.tabBarController?.tabBar.isHidden = false
                user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
                
                
                DispatchQueue.global(qos: .background).async {
                    
                    self.GetCompanySchoolProfile()
                    
                }
            }
            
        }
        
      
        
        
    }
    
    
    
    func SetRatingView (Number:String) {
        
        switch Number {
            
        case "0":
            imageView1?.image = UIImage(named: "StarEmpty")
            imageView2?.image = UIImage(named: "StarEmpty")
            imageView3?.image = UIImage(named: "StarEmpty")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "1":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarEmpty")
            imageView3?.image = UIImage(named: "StarEmpty")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "2":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarEmpty")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "3":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarFull")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "4":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarFull")
            imageView4?.image = UIImage(named: "StarFull")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "5":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarFull")
            imageView4?.image = UIImage(named: "StarFull")
            imageView5?.image = UIImage(named: "StarFull")
            
            
            
        default:
            break
        }
        
        
        
    }

    
   
    
    // Rating stars on navigation bar
    func custom_StarView () {
        
        let view_stars = UIView()
        view_stars.frame = CGRect(x: 0, y: 10, width: 110, height: 25)
        view_stars.backgroundColor = UIColor.clear
        self.view.addSubview(view_stars)
        
        let imageName = "star-icon"
        let image = UIImage(named: imageName)
        imageView1 = UIImageView(image: image!)
        imageView1?.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        
        imageView2 = UIImageView(image: image!)
        imageView2?.frame = CGRect(x: 25, y: 0, width: 20, height: 20)
        
        imageView3 = UIImageView(image: image!)
        imageView3?.frame = CGRect(x: 45, y: 0, width: 20, height: 20)
        
        
        imageView4 = UIImageView(image: image!)
        imageView4?.frame = CGRect(x: 65, y: 0, width: 20, height: 20)
        
        
       imageView5 = UIImageView(image: image!)
        imageView5?.frame = CGRect(x: 85, y: 0, width: 20, height: 20)
        
        let btn_actionRating = UIButton(type: .custom)
        btn_actionRating.frame = CGRect(x: 0, y: 0, width: 110, height: 25)
        btn_actionRating.addTarget(self, action: #selector(ratingBtnPressed), for: .touchUpInside)
        
        view_stars.addSubview(imageView1!)
        view_stars.addSubview(imageView2!)
        view_stars.addSubview(imageView3!)
        view_stars.addSubview(imageView4!)
        view_stars.addSubview(imageView5!)
        view_stars.addSubview(btn_actionRating)
        
        self.navigationItem.titleView = view_stars
        
    }
    
    func ratingBtnPressed(sender: AnyObject){
        
               let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
       
        
        
    }

  
    //MARK: - Functions
    
    func notificationBtnPressed(sender: AnyObject){
        self.showAlert(Message: "Coming Soon", vc: self)
    }
    
    func chatBtnPressed(sender: AnyObject){
        self.showAlert(Message: "Coming Soon", vc: self)
    }
    
    func shadowBtnPressed(sender: AnyObject){
        self.showAlert(Message: "Coming Soon", vc: self)
    }
    
    func editProfileBtnPressed(sender: AnyObject){
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "editView") as! EditProfileViewController
        vc.dict_Url = self.dicUrl
       // vc.dict_user_Info = self.dict_user_Info
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func menuBtnPressed(sender: AnyObject){
        let dict = NSMutableDictionary()
        let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        
        
        let TitleString = NSAttributedString(string: "Shadow", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName : Global.macros.themeColor
            ])
        let MessageString = NSAttributedString(string: "Are you sure you want to log Out?", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName : Global.macros.themeColor
            ])
        
        DispatchQueue.main.async {
            self.clearAllNotice()
            
            let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
                
                if self.checkInternetConnection()
                {
                    DispatchQueue.main.async {
                        self.pleaseWait()
                    }
                    AuthenticationAPI.sharedInstance.LogOut(dict: dict, completion: {(response) in
                        
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                            
                            
                            bool_fromMobile = false
                            bool_NotVerified = false
                            bool_LocationFilter = false
                            bool_PlayFromProfile = false
                            bool_AllTypeOfSearches = false
                            bool_CompanySchoolTrends = false
                            bool_fromVerificationMobile = false
                            bool_UserIdComingFromSearch = false
                            video_url = nil
                            
                            SavedPreferences.set(nil, forKey: "user_verified")
                            SavedPreferences.set(nil, forKey: "sessionToken")
                            SavedPreferences.removeObject(forKey: Global.macros.kUserId)
                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                            Global.macros.kAppDelegate.window?.rootViewController = vc
                            
                        }
                    }, errorBlock: {(err) in
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                            self.showAlert(Message: Global.macros.kError, vc: self)
                        }
                    })
                }
                else{
                    
                    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                }
            }))
            
            alert.addAction(UIAlertAction.init(title: "No", style: .default, handler:nil))
            alert.view.layer.cornerRadius = 10.0
            alert.view.clipsToBounds = true
            alert.view.backgroundColor = UIColor.white
            alert.view.tintColor = Global.macros.themeColor
            
            alert.setValue(TitleString, forKey: "attributedTitle")
            alert.setValue(MessageString, forKey: "attributedMessage")
            self.present(alert, animated: true, completion: nil)
            
        }

    }
    
    
    
    func GetCompanySchoolProfile()
    {
        let dict =  NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
        
        if self.checkInternetConnection()
        {
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            ProfileAPI.sharedInstance.RetrieveUserProfile(dict: dict, completion: { (response) in
                
                switch response.0
                {
                case 200:
                    DispatchQueue.main.async {
                        
                        dict_userInfo = response.1
                      
                      

                        
                        let str =  (response.1).value(forKey: "videoUrl") as? String
                        if str != nil {
                            video_url = NSURL(string: str!) as URL?
                        }
                        
                        if SavedPreferences.value(forKey: Global.macros.krole) as? String == "COMPANY"{
                            
                            self.lbl_company_schoolName.text = (response.1).value(forKey: Global.macros.kcompanyName) as? String
                            self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kCompanyURL) as? String
                           // let array_CompanyList = ((response.1).value(forKey: Global.macros.kschoolCompanyWithTheseOccupations) as? NSDictionary)?.value(forKey: Global.macros.kcompanyList) as? NSArray
                            
                            
                            self.rating_number = "\((response.1).value(forKey: "avgRating")!)"
                            self.SetRatingView (Number:self.rating_number!)
                            ratingview_name = (response.1).value(forKey: Global.macros.kcompanyName) as? String

                            
                        }else{
                            
                            self.lbl_company_schoolName.text = (response.1).value(forKey: Global.macros.kschoolName) as? String
                            self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kSchoolURL) as? String
                            
                            //let array_SchoolList = ((response.1).value(forKey: Global.macros.kschoolCompanyWithTheseOccupations) as? NSDictionary)?.value(forKey: Global.macros.kschoolList) as? NSArray
                            
                            let rating_number = "\((response.1).value(forKey: "avgRating")!)"
                            self.SetRatingView (Number:rating_number)
                            ratingview_name = (response.1).value(forKey: Global.macros.kschoolName) as? String


                            
                        }
                        
                        //  profileImageUrl
                        var profileurl = (response.1).value(forKey: "profileImageUrl")as? String
                        profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        ratingview_imgurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                         if profileurl != nil {
                        self.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
                        }
                        
                        
                    for index in self.array_URL
                    {
                        
                        if (response.1[index] != nil && response.1.value(forKey: index) as? String != "")
                        {
                            self.dicUrl.setValue((response.1).value(forKey: index)!, forKey: index)
                        }

                        
                        }
                        
                        let tempArray = self.dicUrl.allKeys as! [String]
                        // let tempforValues = self.dicUrl.allValues as! [String]
                        
                        if (self.dicUrl.count > 0)
                        {
                            if tempArray.count >= 1 {
                                
                                self.btn_SocialSite1.isHidden = false
                                self.btn_SocialSite2.isHidden = true
                                self.btn_SocialSite3.isHidden = true
                                self.btn_SocialSite1.setImage(UIImage(named:tempArray[0]), for: UIControlState.normal)
                                
                                
                            }
                            if tempArray.count >= 2 {
                                
                                self.btn_SocialSite2.isHidden = false
                                self.btn_SocialSite3.isHidden = true
                                self.btn_SocialSite2.setImage(UIImage(named:tempArray[1]), for: UIControlState.normal)
                                
                            }
                            if tempArray.count == 3  {
                                
                                self.btn_SocialSite3.isHidden = false
                                self.btn_SocialSite3.setImage(UIImage(named:tempArray[2] ), for: UIControlState.normal)
                                
                            }
                            
                            
                        }
                        else{
                            
                            self.btn_SocialSite1.isHidden = true
                            self.btn_SocialSite2.isHidden = true
                            self.btn_SocialSite3.isHidden = true
                        }
                        
                        
                        self.lbl_company_schoolLocation.text = (response.1).value(forKey: Global.macros.klocation) as? String
                        
                        self.lbl_Count_cmpnyschool_withthesesoccupation.text = (((response.1).value(forKey: Global.macros.kschoolCompanyWithTheseOccupations) as? NSDictionary)?.value(forKey: Global.macros.kcount) as? NSNumber)?.stringValue

                         self.lbl_Count_Users.text = (((response.1).value(forKey: Global.macros.kschoolCompanyWithTheseUsers) as? NSDictionary)?.value(forKey: Global.macros.kcount) as? NSNumber)?.stringValue
                        
                        if (response.1).value(forKey: Global.macros.kbio) as? String
                            != nil {
                            
                            self.lbl_description.text = " " + "\((response.1).value(forKey: Global.macros.kbio) as! String)"
                            self.lbl_Placeholder_description.isHidden = true
                        }
                        else{
                            self.lbl_Placeholder_description.isHidden = false
                        }
                        
                        self.array_UserOccupations = (response.1).value(forKey: Global.macros.koccupation) as! NSArray
                        
                        if self.array_UserOccupations.count > 0{
                             self.collection_View.isHidden = false
                            self.collection_View.reloadData()
                        }
                        else{
                            self.lbl_NoOccupationYet.isHidden = false
                            self.collection_View.isHidden = true
                        }
                       
                    }
                    
                case 401:
                   self.AlertSessionExpire()
                    
                default:
                    self.showAlert(Message: Global.macros.kError, vc: self)
                    break
                    
                }
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
            }, errorBlock: {(err) in
                
                DispatchQueue.main.async
                    {
                        self.clearAllNotice()
                        self.showAlert(Message: Global.macros.kError ,vc: self)
                }
            })
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func Action_OpenCompaniesSchoolList(_ sender: UIButton) {
    }

    
    @IBAction func Open_ProfileImage(_ sender: UIButton) {
        
        let imgdata = UIImageJPEGRepresentation(imgView_ProfilePic.image!, 0.5)
        let photos = self.ArrayOfPhotos(data: imgdata!)
        let vc: NYTPhotosViewController = NYTPhotosViewController(photos: photos as? [NYTPhoto])
        vc.rightBarButtonItem = nil
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func ArrayOfPhotos(data:Data)->(NSArray)
    {
        
        
        let photos:NSMutableArray = NSMutableArray()
        let photo:NYTExamplePhoto = NYTExamplePhoto()
        photo.imageData = data
        photos.add(photo)
        return photos
        /*NSMutableArray *photos = [NSMutableArray array];
         
         NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
         photo.imageData = data;
         [photos addObject:photo];
         return photos;*/
        
    }
    
    @IBAction func PlayVideo(_ sender: Any) {
        if video_url != nil {
            
            bool_PlayFromProfile = true
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
            _ = self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
            self.showAlert(Message: "No video to play yet.", vc: self)
            
        }

    }
    
    
    
    @IBAction func ActionSocialMedia1(_ sender: UIButton) {
        
       
       SetWebViewUrl (index: 0)
       // print(sender.currentImage!)

    
    }
    
    
    
    
    @IBAction func ActionSocialMedia2(_ sender: UIButton) {
        
        SetWebViewUrl (index: 1)
       // print(sender.currentImage!)
        
        
    }
    
    
    @IBAction func ActionSocialMedia3(_ sender: UIButton) {
        
        SetWebViewUrl (index: 2)
        //print(sender.currentImage!)

        
        
    }
    
    func SetWebViewUrl (index:Int) {
        
        
        let tempArray = self.dicUrl.allKeys as! [String]
     
   
        let socialStr:String = tempArray[index]
        
        switch socialStr {
        case "facebookUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "facebookUrl") as? String
        case "linkedInUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "linkedInUrl") as? String

        case "twitterUrl":
             linkForOpenWebsite = self.dicUrl.value(forKey: "twitterUrl") as? String

        case "googlePlusUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "googlePlusUrl") as? String


        case "instagramUrl":
           linkForOpenWebsite = self.dicUrl.value(forKey: "instagramUrl") as? String

        case "gitHubUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "gitHubUrl") as? String

        default: break
           
        }
    

        if let checkURL = NSURL(string: linkForOpenWebsite!) {
            if  UIApplication.shared.openURL(checkURL as URL){
                print("URL Successfully Opened")
                linkForOpenWebsite = ""
            }
        } else {
            print("Invalid URL")
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ComapanySchoolViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let size:CGSize?
        if Global.DeviceType.IS_IPHONE_6 || Global.DeviceType.IS_IPHONE_6P{
            size = CGSize(width: ((collectionView.frame.width/3 - 5) ), height: 45)
        }
        else{
            size = CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
            
        }
        return size!
       // return CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "skill", for: indexPath)as! SkillsNInterestCollectionViewCell

        if array_UserOccupations.count > 0 {
            
            cell.lbl_Skill.text = (array_UserOccupations[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_UserOccupations.count
    }
    
    
}
