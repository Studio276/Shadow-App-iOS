//
//  ProfileVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit


var video_url : URL?
var bool_PlayFromProfile : Bool?
var user_Id :NSNumber?

public var bool_UserIdComingFromSearch : Bool?
public var userIdFromSearch : NSNumber?
public var dic_DataOfProfileForOtherUser : NSMutableDictionary = NSMutableDictionary()

class ProfileVC: UIViewController {
    
    @IBOutlet weak var lbl_Placeholder: UILabel!
    @IBOutlet var btn_VideoIcon: UIButton!
    @IBOutlet var collectionView_Skills: UICollectionView!
    @IBOutlet var lbl_Description: UILabel!
    @IBOutlet var lbl_shadowedTo: UILabel!
    @IBOutlet var lbl_ShadowedBy: UILabel!
    @IBOutlet var lbl_School: UILabel!
    @IBOutlet var lbl_ProfileName: UILabel!
    @IBOutlet var imageView_ProfilePic: UIImageView!
    @IBOutlet var scrollbar:UIScrollView!
    @IBOutlet var lbl_Company: UILabel!
    @IBOutlet var collectionView_Interests: UICollectionView!
    @IBOutlet var lbl_NoOccupationsYet: UILabel!
    @IBOutlet var lbl_NoInterestsYet: UILabel!
    @IBOutlet var btn_SocialSite1: UIButton!
    @IBOutlet var btn_SocialSite2: UIButton!
    @IBOutlet var btn_SocialSite3: UIButton!
    
    var imageView1 : UIImageView?
    var imageView2 : UIImageView?
    var imageView3 : UIImageView?
    var imageView4 : UIImageView?
    var imageView5 : UIImageView?
    var linkForOpenWebsite : String?
    var rating_number  : String?

    
    
    //var dict_userInfo:NSDictionary = NSDictionary()
    var dicUrl: NSMutableDictionary = NSMutableDictionary()
    let array_URL = ["facebookUrl","linkedInUrl","instagramUrl","googlePlusUrl","gitHubUrl","twitterUrl"]
    
    //Array that stores actual list of skills
    fileprivate var array_UserSkills:NSMutableArray = [["name":"Actors","id":7],["name":"Actuaries","id":5],["name":"Fundraisers","id":3],["name":"Lawyers","id":6],["name":"Legislators","id":4],["name":"Surveyors","id":5]]//:NSMutableArray = NSMutableArray()
    
    fileprivate var array_UserInterests:NSMutableArray = NSMutableArray()
    
    
    
    
   // private let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "81z5oc5mkeruaf", clientSecret: "0spVIGwX50eVrhzp", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://www.shadow.com"))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
            self.imageView_ProfilePic.layer.cornerRadius = 75.0
            self.imageView_ProfilePic.clipsToBounds = true
            self.imageView_ProfilePic.layer.borderColor = Global.macros.themeColor.cgColor
            self.imageView_ProfilePic.layer.borderWidth = 2.0
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.custom_StarView ()
        self.scrollbar.contentInset = UIEdgeInsets.init(top: 1, left: 0, bottom: 0, right: 0)

        
        if bool_UserIdComingFromSearch == true {
            
            DispatchQueue.main.async {
                
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.CreateNavigationBackBarButton() //Create custom back button
                
                self.lbl_Description.layer.borderWidth = 1.0
                self.lbl_Description.layer.borderColor = Global.macros.themeColor.cgColor
                self.lbl_Description.layer.cornerRadius = 4.0
                self.lbl_Description.clipsToBounds = true
                
                
                self.tabBarController?.tabBar.isHidden = true
                //user_Id = userIdFromSearch
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
                
                
                
                self.lbl_ProfileName.text = dic_DataOfProfileForOtherUser["name"] as? String
                self.rating_number = "\(dic_DataOfProfileForOtherUser["avgRating"]!)"
                
                if ratingview_ratingNumber == "" {
                ratingview_ratingNumber = self.rating_number!
                }
                
                
                ratingview_name = self.lbl_ProfileName.text
                
                self.SetRatingView(Number:ratingview_ratingNumber)
                
                
                let dict_Temp = dic_DataOfProfileForOtherUser["userDTO"] as? NSDictionary
                
                
                let str_video =  dict_Temp?.value(forKey: "videoUrl") as? String
                if str_video != nil {
                    video_url = NSURL(string: str_video!) as URL?
                }
                let companyName =  dict_Temp?.value(forKey: "companyName") as! String
                let schoolName = dict_Temp?.value(forKey: "schoolName") as! String
                
                if companyName != ""{
                    self.lbl_Company.text = companyName
                }
                else{
                    self.lbl_Company.text = "NA"
                }
                
                
                if schoolName != ""
                {
                    self.lbl_School.text = schoolName
                }
                else {
                    self.lbl_School.text = "NA"
                }
                
                self.lbl_shadowedTo.text = "\((dict_Temp?.value(forKey: "shadowersVerified") as! NSDictionary)["count"]!)"
                self.lbl_ShadowedBy.text = "\((dict_Temp?.value(forKey: "shadowedByShadowUser") as! NSDictionary)["count"]!)"
                
                //  profileImageUrl
                var profileurl = dict_Temp?.value(forKey: "profileImageUrl") as? String
                profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                ratingview_imgurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                if profileurl != nil {
                    self.imageView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
                }
                
                let str_bio = dict_Temp?.value(forKey: "bio") as? String
                
                if str_bio == "" || str_bio == nil {
                    self.lbl_Placeholder.isHidden = false
                    
                }
                else {
                    
                    self.lbl_Description.text = " " + str_bio!
                    self.lbl_Placeholder.isHidden = true
                    
                }
                
                
                if dict_Temp?.value(forKey: "occupations")as? NSArray != nil {
                    
                    self.array_UserSkills = (dict_Temp?.value(forKey: "occupations") as? NSArray)?.mutableCopy() as! NSMutableArray
                    
                    
                    
                    
                    
                    
                    
                    if self.array_UserSkills.count > 0{
                        
                        self.collectionView_Skills.reloadData()
                        
                    }
                    else{
                        self.collectionView_Skills.isHidden = true
                        self.lbl_NoOccupationsYet.isHidden = false
                    }
                }
                else {
                    self.collectionView_Skills.isHidden = true
                    self.lbl_NoOccupationsYet.isHidden = false
                    
                }
                
                if dict_Temp?.value(forKey: "interest")as? NSArray != nil {
                    
                    self.array_UserInterests = (dict_Temp?.value(forKey: "interest") as? NSArray)?.mutableCopy() as! NSMutableArray
                    
                    if self.array_UserInterests.count > 0{
                        self.collectionView_Interests.reloadData()
                        
                    }
                    else{
                        self.collectionView_Interests.isHidden = true
                        self.lbl_NoInterestsYet.isHidden = false
                    }
                }
                else {
                    self.collectionView_Interests.isHidden = true
                    self.lbl_NoInterestsYet.isHidden = false
                    
                }
                
                
                for index in self.array_URL
                {
                    
                    if ( dict_Temp?[index] != nil && dict_Temp?.value(forKey: index) as? String != "" )
                    {
                        self.dicUrl.setValue(dict_Temp?.value(forKey: index)!, forKey: index)
                    }
                    
                    
                }
                print(self.dicUrl)
                
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
                self.lbl_Description.layer.borderWidth = 1.0
                self.lbl_Description.layer.borderColor = Global.macros.themeColor.cgColor
                self.lbl_Description.layer.cornerRadius = 4.0
                self.lbl_Description.clipsToBounds = true
                
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
                    
                    self.GetUserProfile()
                    
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
       
        dicUrl.removeAllObjects()
        ratingview_ratingNumber = ""
    }
    
    override func viewWillLayoutSubviews() {
        
        DispatchQueue.main.async {
            
            self.scrollbar.contentSize = CGSize(width: self.view.frame.size.width, height: self.collectionView_Skills.frame.origin.y + self.collectionView_Skills.frame.size.height + 350.0)
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
        
        
        let  btn_actionRating = UIButton(type: .custom)
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
        
        self.performSegue(withIdentifier: "userProfile_to_usereditProfile", sender: self)
        
        //        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "editView") as! EditProfileViewController
        //        vc.dict_user_Info = self.dict_userInfo
        //        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        
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
    
    
    
    //MARK: - Button Actions
    
    @IBAction func Open_ProfileImage(_ sender: UIButton) {
        
        let imgdata = UIImageJPEGRepresentation(imageView_ProfilePic.image!, 0.5)
        let photos = self.ArrayOfPhotos(data: imgdata!)
        let vc: NYTPhotosViewController = NYTPhotosViewController(photos: photos as? [NYTPhoto])
        vc.rightBarButtonItem = nil
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    func ArrayOfPhotos(data:Data)->(NSArray)
    {
        self.scrollbar.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
 
        
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
    
    @IBAction func Action_LogOut(_ sender: UIButton) {
        
           }
    
    @IBAction func Action_SelectSocialIcons(_ sender: UIButton) {
        
//        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
//            print("success called!")
//            
//        }) { (error) -> Void in
//            print("Error: \(error)")
//        }
        
        /* linkedinHelper.authorizeSuccess({ (token) in
         
         print(token)
         self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
         
         print(response)
         //parse this response which is in the JSON format
         }) {(error) -> Void in
         
         print(error.localizedDescription)
         //handle the error
         }
         
         
         //This token is useful for fetching profile info from LinkedIn server
         }, error: { (error) in
         
         print(error.localizedDescription)
         //show respective error
         }) {
         //show sign in cancelled event
         } */
        
    }
    
    @IBAction func Action_PlayVideo(_ sender: UIButton) {
        if video_url != nil {

        bool_PlayFromProfile = true
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
            self.showAlert(Message: "No video to play yet.", vc: self)

        }
    }
    
    
    
    @IBAction func ActionSocialMedia1(_ sender: Any) {
        SetWebViewUrl (index: 0)
        
    }
    
    @IBAction func ActionSocialMedia2(_ sender: Any) {
        
        SetWebViewUrl (index: 1)
        
    }
    
    
    @IBAction func ActionSocialMedia3(_ sender: Any) {
        
        SetWebViewUrl (index: 2)
        
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

    
    //MARK: - Functions
    
    func GetUserProfile()
    {
        let dict =  NSMutableDictionary()
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        
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
                        
                        //let url_array = NSMutableArray()
                        dictionary_user_Info = response.1
                        
                        for value in self.array_URL
                        {
                            
                           
                            
                            if (response.1[value] != nil && response.1.value(forKey: value) as? String != "")
                            {
                                self.dicUrl.setValue((response.1).value(forKey: value)!, forKey: value)
                            }
                           
                        }
                        
                        print(self.dicUrl)
                        let tempArray = self.dicUrl.allKeys as! [String]
                        
                        if (self.dicUrl.count > 0)
                        {
                            if tempArray.count >= 1 {
                                
                                self.btn_SocialSite1.isHidden = false
                                self.btn_SocialSite1.setImage(UIImage(named:tempArray[0]), for: UIControlState.normal)
                                self.btn_SocialSite2.isHidden = true
                                self.btn_SocialSite3.isHidden = true
                                
                            }
                            if tempArray.count >= 2 {
                                
                                self.btn_SocialSite2.isHidden = false
                                self.btn_SocialSite2.setImage(UIImage(named:tempArray[1]), for: UIControlState.normal)
                                self.btn_SocialSite3.isHidden = true
                            }
                            if tempArray.count == 3  {
                                
                                self.btn_SocialSite3.isHidden = false
                                self.btn_SocialSite3.setImage(UIImage(named:tempArray[2] ), for: UIControlState.normal)
                                
                            }
                            
                            
                        }
                        else {
                            self.btn_SocialSite1.isHidden = true
                            self.btn_SocialSite2.isHidden = true
                            self.btn_SocialSite3.isHidden = true
                            
                        }
                        
                        
                         self.rating_number = "\((response.1).value(forKey: "avgRating")!)"
                        self.SetRatingView (Number:self.rating_number!)
                        
                        
                        ratingview_name = ((response.1).value(forKey: Global.macros.kUserName)as? String)!
                        self.lbl_ProfileName.text = ((response.1).value(forKey: Global.macros.kUserName)as? String)!
                        
                        //  profileImageUrl
                        var profileurl = (response.1).value(forKey: "profileImageUrl")as? String
                        profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        ratingview_imgurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        
                        if profileurl != nil {
                            self.imageView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
                        }
                        
                        
                        let str =  (response.1).value(forKey: "videoUrl") as? String
                        if str != nil {
                            video_url = NSURL(string: str!) as URL?
                        }
                        else{
                            video_url = nil
                        }
                        
                        if (response.1).value(forKey: "schoolName")as? String != "" {
                            self.lbl_School.text = (response.1).value(forKey: "schoolName")as? String
                        }
                        else {
                            self.lbl_School.text = "NA"
                        }
                        
                        if (response.1).value(forKey: "companyName")as? String != "" {
                            self.lbl_Company.text = (response.1).value(forKey: "companyName")as? String
                        }
                        else {
                            
                            self.lbl_Company.text = "NA"
                            
                        }
                        
                        if (response.1).value(forKey: "bio")as? String != nil {
                            self.lbl_Description.text = " " + "\((response.1).value(forKey: "bio") as! String)"
                            self.lbl_Placeholder.isHidden = true
                        }
                        else {
                            self.lbl_Placeholder.isHidden = false
                            
                        }
                        
                        if (response.1).value(forKey: "occupations")as? NSArray != nil {
                            
                            self.array_UserSkills = ((response.1).value(forKey: "occupations") as? NSArray)?.mutableCopy() as! NSMutableArray
                            
                            if self.array_UserSkills.count > 0{
                                
                                self.collectionView_Skills.isHidden = false
                                self.lbl_NoOccupationsYet.isHidden = true
                                self.collectionView_Skills.reloadData()
                                
                            }
                            else{
                                
                                self.collectionView_Skills.isHidden = true
                                self.lbl_NoOccupationsYet.isHidden = false
                                
                            }
                        }
                        else {
                            self.collectionView_Skills.isHidden = true
                            self.lbl_NoOccupationsYet.isHidden = false
                            
                        }
                        
                        if (response.1).value(forKey: "interest")as? NSArray != nil {
                            
                            self.array_UserInterests = ((response.1).value(forKey: "interest") as? NSArray)?.mutableCopy() as! NSMutableArray
                            
                            if self.array_UserInterests.count > 0{
                                
                                self.collectionView_Interests.isHidden = false
                                self.lbl_NoInterestsYet.isHidden = true
                                self.collectionView_Interests.reloadData()
                                
                            }
                            else{
                                self.collectionView_Interests.isHidden = true
                                self.lbl_NoInterestsYet.isHidden = false
                            }
                        }
                        else {
                            self.collectionView_Interests.isHidden = true
                            self.lbl_NoInterestsYet.isHidden = false
                            
                        }
                    }
                    
                case 401:
                   self.AlertSessionExpire()
                    
                    
                    
                default:
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "userProfile_to_usereditProfile"{
            
            let vc = segue.destination as! UserEditProfileViewController
            
           // vc.dict_user_Info = dict_userInfo
            vc.dict_Url = self.dicUrl
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
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
        
        
        var cell = UICollectionViewCell()
        
        if collectionView == collectionView_Skills{
            let skills_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "skill", for: indexPath)as! SkillsNInterestCollectionViewCell
            
            if array_UserSkills.count > 0 {
                
                skills_cell.lbl_Skill.text = (array_UserSkills[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            }
            
            cell = skills_cell
            
        }
        
        if collectionView == collectionView_Interests{
            let interest_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "interest_cell", for: indexPath)as! Profile_UserInterestsCollectionViewCell
            
            if array_UserInterests.count > 0 {
                
                interest_cell.lbl_InterestName.text = (array_UserInterests[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            }
            
            cell = interest_cell
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count:Int?
        
        if collectionView == collectionView_Skills{
            count = array_UserSkills.count
        }
        
        if collectionView == collectionView_Interests{
            count = array_UserInterests.count
        }
        
        return count!
    }
    
}

