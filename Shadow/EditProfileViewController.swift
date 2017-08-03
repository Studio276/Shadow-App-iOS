//
//  EditProfileViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 02/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

var dict_userInfo:NSDictionary = NSDictionary()
class EditProfileViewController: UIViewController, GMSAutocompleteViewControllerDelegate{
    
    
    @IBOutlet weak var img_PlusIconProfile: UIImageView!
    @IBOutlet var scroll_view: UIScrollView!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var txtview_Description: UITextView!
    @IBOutlet weak var lbl_PlaceholderTxtview: UILabel!
    @IBOutlet weak var view_PickerView: UIView!
    @IBOutlet var pickerView_SchoolOccupation: UIPickerView!
    @IBOutlet var view_BlurrView: UIView!
    @IBOutlet var view_Skills: UIView!
    @IBOutlet var search_Bar: UISearchBar!
    @IBOutlet var tblView_MySkills: UITableView!
    @IBOutlet var tblView_ActualSkills: UITableView!
    @IBOutlet var lbl_SchoolCompanyName: UILabel!
    @IBOutlet var txfield_SchoolName: UITextField!
    @IBOutlet var txtfield_Location: UITextField!
    @IBOutlet var txtfield_SchoolName: UITextField!
    @IBOutlet var txtfield_Url: UITextField!
    @IBOutlet var lbl_SchoolCompanyUrl: UILabel!
    @IBOutlet var btn_SchoolComanyName: UIButton!
    @IBOutlet var collection_View_Occupation: UICollectionView!
    @IBOutlet var tblView_SocialSites: UITableView!
    @IBOutlet var view_tableViews_SocialSites: UIView!
    @IBOutlet var search_Bar_SocialSites: UISearchBar!
    @IBOutlet var tblView_UserSites: UITableView!
    @IBOutlet var tblView_ActualSocialSites: UITableView!
    @IBOutlet var k_constraint_Description_Top: NSLayoutConstraint!
    @IBOutlet var k_constraint_Description_Placeholder_Top: NSLayoutConstraint!
    @IBOutlet var k_contraint_ViewFields_Height: NSLayoutConstraint!
    @IBOutlet var btn_Done_Occupations: UIButton!
    @IBOutlet weak var btn_Done_SocialSite: UIButton!
    
    
   fileprivate var arrsearchActualOccupation : NSMutableArray = NSMutableArray()
   fileprivate var temp_arrOccupation : NSMutableArray = NSMutableArray()

    fileprivate var array_ActualOccupations:NSMutableArray = NSMutableArray()
    fileprivate var array_UserOccupations:NSMutableArray = NSMutableArray()
    fileprivate var array_Schools:NSMutableArray = NSMutableArray()
    
    fileprivate var array_ActualSocialSites = [["name":"Facebook","image":UIImage(named: "facebookUrl")! ],["name":"LinkedIn","image":UIImage(named: "linkedInUrl")!],["name":"Twitter","image":UIImage(named: "twitterUrl")! ],["name":"gitHub","image":UIImage(named: "gitHubUrl")!],["name":"Google+","image":UIImage(named: "googlePlusUrl")!],["name":"Instagram","image":UIImage(named: "instagramUrl")!]]
    
    fileprivate var array_UserSocialSites = [[String:Any]]()// = NSMutableArray()
    fileprivate var str_profileImage:String?
    fileprivate var str_latitude:String = ""
    fileprivate var str_longitude:String = ""
    var sender_Tag:Int?
    var dict_Url:NSMutableDictionary = NSMutableDictionary()//from previous view(social sites url)
    
    
    
    
    override func viewDidLayoutSubviews() {
        
        
            scroll_view.contentSize = CGSize.init(width: view.frame.size.width, height:  800)
                
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        DispatchQueue.main.async {
            
            self.imgView_Profile.layer.cornerRadius = 60.0
            self.imgView_Profile.clipsToBounds = true
      
             self.imgView_Profile.layer.borderWidth = 1.0
            self.imgView_Profile.layer.borderColor = Global.macros.themeColor.cgColor

            self.txtview_Description.layer.borderWidth = 1.0
            self.txtview_Description.layer.borderColor = Global.macros.themeColor.cgColor
            self.txtview_Description.layer.cornerRadius = 4.0
            self.txtview_Description.clipsToBounds = true

           
            
            //Save navigation bar button
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "upload-icon"), for: .normal)
            btn1.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 25, height: 25)
            btn1.addTarget(self, action: #selector(self.saveProfile), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            
            self.navigationItem.setRightBarButtonItems([item1], animated: true)
            
            //setting constraints of social table if array is nil
            if self.array_UserSocialSites.count == 0{
                
                self.tblView_SocialSites.isHidden = true
                self.k_constraint_Description_Top.constant = 9.0
                self.k_constraint_Description_Placeholder_Top.constant = 14.0
                self.k_contraint_ViewFields_Height.constant = 235.0
                
            }
            
            self.array_UserOccupations = (dict_userInfo.value(forKey: Global.macros.koccupation) as! NSArray).mutableCopy() as! NSMutableArray
            
            if self.array_UserOccupations.count  > 0{
                self.collection_View_Occupation.reloadData()
            }
            
            //setting profile pic
            let profileurl = dict_userInfo.value(forKey: "profileImageUrl")as? String
            if profileurl != nil {
                self.imgView_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
                self.img_PlusIconProfile.isHidden = true
            }
            
            //setting user social sites
            // print(self.dict_Url)
            if self.dict_Url.count > 0 {
                
                if ((self.dict_Url["facebookUrl"]) != nil)
                {
                    var dict = [String:Any]()
                    dict["name"] = "Facebook"
                    dict["image"] = UIImage(named: "facebookUrl")!
                    dict["url"] = self.dict_Url.value(forKey: "facebookUrl")
                    self.array_UserSocialSites.append(dict)
                }
                
                if ((self.dict_Url["linkedInUrl"]) != nil)
                {
                    var dict = [String:Any]()
                    dict["name"] = "LinkedIn"
                    dict["image"] = UIImage(named: "linkedInUrl")!
                    dict["url"] = self.dict_Url.value(forKey: "linkedInUrl")
                    self.array_UserSocialSites.append(dict)
                    
                }
                
                if ((self.dict_Url["twitterUrl"]) != nil)
                {
                    var dict = [String:Any]()
                    dict["name"] = "Twitter"
                    dict["image"] = UIImage(named: "twitterUrl")!
                    dict["url"] = self.dict_Url.value(forKey: "twitterUrl")
                    self.array_UserSocialSites.append(dict)
                }
                
                if ((self.dict_Url["instagramUrl"]) != nil)
                {
                    var dict = [String:Any]()
                    dict["name"] = "Instagram"
                    dict["image"] = UIImage(named: "instagramUrl")!
                    dict["url"] = self.dict_Url.value(forKey: "instagramUrl")
                    self.array_UserSocialSites.append(dict)
                    
                }
                if ((self.dict_Url["gitHubUrl"]) != nil)
                {
                    var dict = [String:Any]()
                    dict["name"] = "gitHub"
                    dict["image"] = UIImage(named: "gitHubUrl")!
                    dict["url"] = self.dict_Url.value(forKey: "gitHubUrl")
                    self.array_UserSocialSites.append(dict)
                }
                
                if ((self.dict_Url["googlePlusUrl"]) != nil)
                {
                    var dict = [String:Any]()
                    dict["name"] = "Google+"
                    dict["image"] = UIImage(named: "googlePlusUrl")!
                    dict["url"] = self.dict_Url.value(forKey: "googlePlusUrl")
                    self.array_UserSocialSites.append(dict)
                }
            }
            
            //print(self.array_UserSocialSites)
            
            //setting table view height according to array count
            if self.array_UserSocialSites.count > 0 {
                
                var name1:String?
                for value in self.array_UserSocialSites{
                    
                    let temp_dict = value as NSDictionary
                    name1 = temp_dict.value(forKey: "name") as? String
                    
                    for (idx,val) in self.array_ActualSocialSites.enumerated(){
                        
                        let dict = val as NSDictionary
                        let name2 = dict.value(forKey: "name") as? String
                        
                        if name2 == name1 {
                            
                            self.array_ActualSocialSites.remove(at: idx)
                            break
                            
                        }
                    }
                }
                
                self.tblView_SocialSites.isHidden = false
                self.tblView_SocialSites.isScrollEnabled = false
                
                if self.array_UserSocialSites.count == 1{
                    self.k_constraint_Description_Top.constant = 50.0
                    self.k_constraint_Description_Placeholder_Top.constant = 55.0
                    self.k_contraint_ViewFields_Height.constant = 264.0
                }
                else if self.array_UserSocialSites.count == 2{
                    self.k_constraint_Description_Top.constant = 94.0
                    self.k_constraint_Description_Placeholder_Top.constant = 99.0
                    self.k_contraint_ViewFields_Height.constant = 308.0
                }
                else if self.array_UserSocialSites.count == 3{
                    
                    self.k_constraint_Description_Top.constant = 138.0
                    self.k_constraint_Description_Placeholder_Top.constant = 143.0
                    self.k_contraint_ViewFields_Height.constant = 352.0
                    
                }
                self.tblView_SocialSites.reloadData()
            } else{
                
                self.tblView_SocialSites.isHidden = true
                self.k_constraint_Description_Top.constant = 9.0
                self.k_constraint_Description_Placeholder_Top.constant = 14.0
                self.k_contraint_ViewFields_Height.constant = 235.0
            }
            
            self.txtfield_Url.text = dict_userInfo.value(forKey: Global.macros.kCompanyURL) as? String
            self.txtview_Description.text = dict_userInfo.value(forKey: Global.macros.kbio) as? String
            if self.txtview_Description.text == "" {
                self.lbl_PlaceholderTxtview.isHidden = false
            }
            else {
                self.lbl_PlaceholderTxtview.isHidden = true
            }
            
            let role = SavedPreferences.value(forKey: Global.macros.krole) as? String
            if role == "COMPANY"{
                
                self.title = dict_userInfo.value(forKey: Global.macros.kcompanyName) as? String

                self.lbl_SchoolCompanyName.text = "Company Name:"
                self.btn_SchoolComanyName.isHidden = true
                self.lbl_SchoolCompanyUrl.text  = "Company URL:"
                self.txtfield_SchoolName.text = dict_userInfo.value(forKey: Global.macros.kcompanyName) as? String
                //self.txtfield_SchoolName.isUserInteractionEnabled = false
                self.txtfield_Location.text = dict_userInfo.value(forKey: Global.macros.klocation) as? String
                
            }else{
                
                self.title = dict_userInfo.value(forKey: Global.macros.kschoolName) as? String

                self.lbl_SchoolCompanyName.text = "School Name:"
                self.btn_SchoolComanyName.isHidden = true
                self.lbl_SchoolCompanyUrl.text  = "School URL:"
                self.txtfield_SchoolName.text = dict_userInfo.value(forKey: Global.macros.kschoolName) as? String
                self.txtfield_Location.text = dict_userInfo.value(forKey: Global.macros.klocation) as? String
            }
            
            //social site done button
            self.btn_Done_SocialSite.layer.cornerRadius = 5.0
            self.btn_Done_SocialSite.layer.borderWidth = 1.0
            self.btn_Done_SocialSite.layer.borderColor = Global.macros.themeColor.cgColor
            
           

            self.CustomBorder(searchbar : self.search_Bar)
            
            //for Occupation
            self.tblView_MySkills.tableFooterView = UIView()
            self.tblView_ActualSkills.tableFooterView = UIView()
            
            self.btn_Done_Occupations.layer.cornerRadius = 5.0
            self.btn_Done_Occupations.layer.borderWidth = 1.0
            self.btn_Done_Occupations.layer.borderColor = Global.macros.themeColor.cgColor
            
            
            
            
            self.view_Skills.layer.cornerRadius = 8.0
            self.view_Skills.clipsToBounds = true
            self.view_Skills.layer.borderColor = Global.macros.themeColor.cgColor
            self.view_Skills.layer.borderWidth = 1.0
            self.tblView_MySkills.layer.cornerRadius = 5.0
            self.tblView_MySkills.clipsToBounds = true
            self.tblView_ActualSkills.layer.cornerRadius = 5.0
            self.tblView_ActualSkills.clipsToBounds = true
            
            self.tblView_ActualSkills.layer.borderWidth = 1.0
            self.tblView_ActualSkills.layer.borderColor = Global.macros.themeColor.cgColor
            self.tblView_MySkills.layer.borderWidth = 1.0
            self.tblView_MySkills.layer.borderColor = Global.macros.themeColor.cgColor
            
            self.tblView_MySkills.delegate = self
            self.tblView_MySkills.dataSource = self
            self.tblView_ActualSkills.delegate = self
            self.tblView_ActualSkills.dataSource = self
            
            //social sites table in main view
            self.tblView_SocialSites.delegate = self
            self.tblView_SocialSites.dataSource = self
            
            //social sites tables in social view
            self.tblView_UserSites.tableFooterView = UIView()
            self.tblView_ActualSocialSites.tableFooterView = UIView()
            
            self.view_tableViews_SocialSites.layer.cornerRadius = 5.0
            self.view_tableViews_SocialSites.clipsToBounds = true
            self.view_tableViews_SocialSites.layer.borderColor = Global.macros.themeColor.cgColor
            self.view_tableViews_SocialSites.layer.borderWidth = 1.0
            self.tblView_ActualSocialSites.layer.cornerRadius = 5.0
            self.tblView_ActualSocialSites.clipsToBounds = true
            self.tblView_UserSites.layer.cornerRadius = 5.0
            self.tblView_UserSites.clipsToBounds = true
            
            self.tblView_UserSites.layer.borderWidth = 1.0
            self.tblView_UserSites.layer.borderColor = Global.macros.themeColor.cgColor
            self.tblView_ActualSocialSites.layer.borderWidth = 1.0
            self.tblView_ActualSocialSites.layer.borderColor = Global.macros.themeColor.cgColor
            
        }
        
        let tap = UITapGestureRecognizer()
        self.view_BlurrView.addGestureRecognizer(tap)
        tap.delegate = self
        self.getallOccupation()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true

        //Creating back button
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToProfile), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        
        self.navigationController?.navigationBar.isOpaque = true
        self.scroll_view.contentOffset = CGPoint.init(x: 0, y: 0)
        
    }
    
    func PopToProfile()
    {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func CustomBorder(searchbar : UISearchBar){
        
        if let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.frame = CGRect(x: 40, y: glassIconView.frame.origin.y , width: 16, height: 16)
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            glassIconView.tintColor = UIColor.purple
            
            
            
            textFieldInsideSearchBar.layer.borderColor =  Global.macros.themeColor.cgColor
            textFieldInsideSearchBar.layer.cornerRadius = 6.0
            textFieldInsideSearchBar.layer.borderWidth = 1.0
            textFieldInsideSearchBar.clearButtonMode = .never

            
        }
        
        let searchTextField:UITextField = searchbar.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "customsearch")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = imageView
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                   attributes: [NSForegroundColorAttributeName: Global.macros.themeColor])
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.rightView = nil

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    //MARK: - FUNCTIONS
    
    func takeNewPhotoFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.allowsEditing = false
            controller.delegate = self
            
            self.navigationController?.present(controller, animated: true, completion: nil)
            
        }
    }
    
    func choosePhotoFromExistingImages()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let controller = UIImagePickerController()
            controller.sourceType = .savedPhotosAlbum
            controller.allowsEditing = false
            controller.delegate = self
            self.navigationController!.present(controller, animated: true, completion: { _ in })
            
        }
    }
    
    
    
//    func getallSchools(){
//        
//        
//        let dict = NSMutableDictionary()
//        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId), forKey: Global.macros.kUserId)
//        dict.setValue("0", forKey: Global.macros.api_param_pageIndex)
//        dict.setValue("2", forKey: Global.macros.api_param_pageSize)
//        
//        if checkInternetConnection(){
//            
//            DispatchQueue.main.async {
//                self.pleaseWait()
//                
//                ProfileAPI.sharedInstance.getListOfSchools(postDict: dict, completion_Block: { (dictionary) in
//                    DispatchQueue.main.async {
//                        self.clearAllNotice()
//                        self.array_Schools = ((dictionary.value(forKey: "data") as! NSDictionary).value(forKey: "schoolList") as! NSArray).mutableCopy() as! NSMutableArray
//                        
//                        DispatchQueue.main.async {
//                            self.view_PickerView.isHidden  = false
//                            self.pickerView_SchoolOccupation.reloadAllComponents()
//                        }
//                        
//                    }
//                }, error_Block: { (err) in
//                    DispatchQueue.main.async {
//                        self.clearAllNotice()
//                        self.showAlert(Message: Global.macros.kError, vc: self)
//                        
//                    }
//                })
//            }
//            
//        }else{
//            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
//        }
//    }
    
    func getallOccupation(){
        
        let dict = NSMutableDictionary()
       
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
        
        if checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
                
                ServerCall.sharedInstance.postService({ (response) in
                    print(response!)
                    
                    self.clearAllNotice()
                    let status =  ((response as! NSDictionary).value(forKey: "status")) as! NSNumber
                    
                    switch(status){
                        
                    case 200:
                        self.array_ActualOccupations.removeAllObjects()
                        self.array_ActualOccupations = ((((response as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "occupations") as! NSArray).mutableCopy() as? NSMutableArray)!
                        
                        var name1:String?
                        if self.array_UserOccupations.count > 0{
                            
                            for value in self.array_UserOccupations {
                                
                                let temp_dict = value as! NSDictionary
                                name1 = temp_dict.value(forKey: "name") as? String
                                
                                for (idx,val) in self.array_ActualOccupations.enumerated(){
                                    
                                    let dict = val as! NSDictionary
                                    let name2 = dict.value(forKey: "name") as? String
                                    
                                    if name2 == name1 {
                                        self.array_ActualOccupations.removeObject(at: idx)
                                        break
                                        
                                    }
                                }
                            }
                                           }
                        
                         self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray
                        DispatchQueue.main.async {
                        self.tblView_ActualSkills.reloadData()
                        }
                        break
                    default:
                        break
                        
                    }
                    
                }, error_block: { (error) in
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.showAlert(Message: (error?.localizedDescription)!, vc: self)
                    }
                    
                }, paramDict: dict, is_synchronous: false, url: Global.macros.api_getoccupation)
            }
            
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
    }
    
    
    func lat_long(string:String){
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(string, completionHandler: {
            
            (placemark,error) -> Void in
            
            if (error != nil) {
                
                print("Error" + (error?.localizedDescription)!)
                self.showAlert(Message: "Invalid address.Can't find your location.", vc: self)
            }
                
            else if (placemark?.count)! > 0 {
                let pl = (placemark?.last)! as CLPlacemark
                let numLat = NSNumber(value: (pl.location?.coordinate.latitude)! as Double)
                self.str_latitude = numLat.stringValue
                let numLong = NSNumber(value: (pl.location?.coordinate.longitude)! as Double)
                self.str_longitude = numLong.stringValue
                print("latitude:\(latitude) longitude:\(longitude)")
            }
                
            else{
                
                self.showAlert(Message: "Can't find your location.Try again later.", vc: self)
            }
        })
    }
    
    func hit_EditProfile(dict:NSMutableDictionary)  {
        if checkInternetConnection(){//companyName
            
            DispatchQueue.main.async{
                
                self.pleaseWait()
            }
            ServerCall.sharedInstance.postService({ (response) in
                //print(response!)
               
                let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
                switch Int(status!){
                    
                case 200:
                    
                    DispatchQueue.main.async{
                        self.clearAllNotice()
                    }
                    DispatchQueue.main.async{
                        
                        
                        if  SavedPreferences.value(forKey: Global.macros.krole) as? String == "COMPANY" {
                            
                            SavedPreferences.set(self.txtfield_SchoolName.text!, forKey: Global.macros.kcompanyName)
                        }
                        
                            let TitleString = NSAttributedString(string: "Shadow", attributes: [
                                NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                                NSForegroundColorAttributeName : Global.macros.themeColor
                                ])
                            let MessageString = NSAttributedString(string: "Profile has been updated successfully.", attributes: [
                                NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                                NSForegroundColorAttributeName : Global.macros.themeColor
                                ])
                            
                            let alert = UIAlertController(title: "Shadow", message: "Profile has been updated successfully.", preferredStyle: .alert)
                            
                            alert.view.layer.cornerRadius = 10.0
                            alert.view.clipsToBounds = true
                            alert.view.backgroundColor = UIColor.white
                            alert.view.tintColor = Global.macros.themeColor
                            
                            alert.setValue(TitleString, forKey: "attributedTitle")
                            alert.setValue(MessageString, forKey: "attributedMessage")
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                                (action) in
                                _ =  self.navigationController?.popToRootViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        
                    }
                    break
                    
                    
                    
                case 401:
                    DispatchQueue.main.async{
                        self.clearAllNotice()
                    }
                   self.AlertSessionExpire()
                    break
                    
                default:
                    DispatchQueue.main.async{
                        self.clearAllNotice()
                        self.showAlert(Message: Global.macros.kError, vc: self)
                    }
                    break
                }
                
                
            }, error_block: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
                
                
            }, paramDict: dict, is_synchronous: false, url: "editProfile")
            
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
    }
    
    func saveProfile(){
        
        
        let dict = NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
        dict.setValue(str_profileImage, forKey: Global.macros.kprofileImage)
        let role = SavedPreferences.value(forKey: Global.macros.krole) as? String
        if role == "COMPANY"{
            
            if txtfield_SchoolName.text! != SavedPreferences.value(forKey: Global.macros.kcompanyName) as? String
            {
                dict.setValue(self.txtfield_SchoolName.text!, forKey: Global.macros.kcompanyName)
                
            }
            
            dict.setValue(self.txtfield_Url.text!, forKey: Global.macros.kCompanyURL)
            
            
        }else if role == "SCHOOL"{
            dict.setValue(self.txtfield_SchoolName.text!, forKey: Global.macros.kschoolName)
            dict.setValue(self.txtfield_Url.text!, forKey: Global.macros.kSchoolURL)
            
        }
        dict.setValue(self.txtfield_Location.text!, forKey: Global.macros.klocation)
        dict.setValue(self.txtview_Description.text!, forKey: Global.macros.kbio)
        dict.setValue(array_UserOccupations, forKey: Global.macros.koccupation)
        
        if array_UserSocialSites.count > 0{
            for value in array_UserSocialSites{
                
                let temp_d = value as NSDictionary
                let url = temp_d.value(forKey: "url") as? String
                let n = temp_d.value(forKey: Global.macros.kname) as? String
                
                if n == "Facebook"{
                    dict.setValue(url, forKey: Global.macros.kfacebookURL)
                }
                else if n == "Twitter"
                {
                    dict.setValue(url, forKey: Global.macros.ktwitterURL)
                }
                else if n == "LinkedIn"
                {
                    dict.setValue(url, forKey: Global.macros.klinkedInURL)
                }
                else if n == "GitHub"
                {
                    dict.setValue(url, forKey: Global.macros.kgitHubURL)
                }
                else if n == "Instagram"
                {
                    dict.setValue(url, forKey: Global.macros.kinstagramURL)
                }
                else if n == "Google+"
                {
                    dict.setValue(url, forKey: Global.macros.kgooglePlusURL)
                }
            }
        }
        
        print(dict)
        
        if self.verifyUrl(urlString: self.txtfield_Url.text!){
            if array_UserSocialSites.count > 0{
                for value in  array_UserSocialSites{
                    
                    let dic = value
                    if (dic["url"] as? String)?.characters.count != 0 && (dic["url"] as? String) != nil{
                        
                        if self.verifyUrl(urlString: dic["url"] as? String){
                            self.hit_EditProfile(dict: dict)
                        } else{
                            self.showAlert(Message: "Please fill valid url.", vc: self)
                            break
                        }
                    }
                    else{
                        self.showAlert(Message: "Please fill url.", vc: self)
                        break
                    }
                }
            }
            else{
                self.hit_EditProfile(dict: dict)
            }
        }
        else{
            self.showAlert(Message: "Please fill valid company url.", vc: self)
            
        }
        
        
    }
    
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func Action_SelectProfile(_ sender: Any) {
        
        ///calling UIAction Sheet
        let actionSheet1 = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet1.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) -> Void in
            // take photo button tapped.
            self.takeNewPhotoFromCamera()
        }))
        actionSheet1.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) -> Void in
            // choose photo button tapped.
            self.choosePhotoFromExistingImages()
        }))
        actionSheet1.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(action: UIAlertAction) -> Void in
            // Destructive button tapped.
            
        }))
        DispatchQueue.main.async {
            self.present(actionSheet1, animated: true, completion: { _ in })
        }
    }
    
    
    @IBAction func Action_RecordVideo(_ sender: Any) {
        
        bool_PlayFromProfile = false
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func Action_SelectSchool(_ sender: UIButton) {
        sender_Tag = sender.tag
       // getallSchools()
    }
    
    
    @IBAction func Action_GiveLocation(_ sender: UIButton) {
        
    }
    
    
    @IBAction func Action_AddOccupation(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.getallOccupation()

            self.navigationController?.navigationBar.isHidden = true
            self.scroll_view.isHidden = true
            self.view_BlurrView.isHidden = false
            self.view_Skills.isHidden = false
            self.view_tableViews_SocialSites.isHidden = true
            self.tblView_ActualSkills.reloadData()
            self.tblView_MySkills.reloadData()
        }
    }
    
    
    @IBAction func Action_Done_Occupation(_ sender: UIButton) {
        
        self.navigationController?.navigationBar.isHidden = false
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        self.search_Bar.text = ""

        self.scroll_view.isHidden = false
        self.scroll_view.isScrollEnabled = true
        view_BlurrView.isHidden = true
        view_Skills.isHidden = true
        self.collection_View_Occupation.reloadData()
        
    }
    
    
    @IBAction func Action_MySkillsMinus(_ sender: UIButton) {
        
        let value = array_UserOccupations[sender.tag]
        array_UserOccupations.removeObject(at: sender.tag)
        array_ActualOccupations.insert(value, at: 0)
        tblView_ActualSkills.reloadData()
        tblView_MySkills.reloadData()
    }
    
    @IBAction func Action_ActualSkillsPlus(_ sender: UIButton) {
        
        let value = array_ActualOccupations[sender.tag]
        array_ActualOccupations.removeObject(at: sender.tag)
        array_UserOccupations.insert(value, at: 0)
        tblView_ActualSkills.reloadData()
        tblView_MySkills.reloadData()
        
    }
    
    @IBAction func Action_DonePickerview(_ sender: UIButton) {
        
        view_PickerView.isHidden = true
    }
    
    @IBAction func Action_CancelPickerview(_ sender: UIButton) {
        
        view_PickerView.isHidden = true
    }
    
    @IBAction func Action_SocialSites(_ sender: UIButton) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.scroll_view.isHidden = true
        self.view_BlurrView.isHidden = false
        self.view_tableViews_SocialSites.isHidden = false
        self.view_Skills.isHidden = true
        self.tblView_UserSites.reloadData()
        self.tblView_ActualSocialSites.reloadData()
        
        
    }
    
    @IBAction func Action_Done_SocialSites(_ sender: UIButton) {
        
        self.navigationController?.navigationBar.isHidden = false
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        self.scroll_view.isHidden = false
        self.scroll_view.isScrollEnabled = true
        view_BlurrView.isHidden = true
        
        if array_UserSocialSites.count == 0 {
            
            self.tblView_SocialSites.isHidden = true
            self.k_constraint_Description_Top.constant = 9.0
            self.k_constraint_Description_Placeholder_Top.constant = 14.0
            self.k_contraint_ViewFields_Height.constant = 235.0
        }
        
        
        
        if array_UserSocialSites.count > 0 {
            
            tblView_SocialSites.isHidden = false
            tblView_SocialSites.isScrollEnabled = false
            
            if array_UserSocialSites.count == 1{
                self.k_constraint_Description_Top.constant = 50.0
                self.k_constraint_Description_Placeholder_Top.constant = 55.0
                self.k_contraint_ViewFields_Height.constant = 264.0
            }
            else if array_UserSocialSites.count == 2{
                self.k_constraint_Description_Top.constant = 94.0
                self.k_constraint_Description_Placeholder_Top.constant = 99.0
                self.k_contraint_ViewFields_Height.constant = 308.0
            }
            else if array_UserSocialSites.count == 3{
                
                self.k_constraint_Description_Top.constant = 138.0
                self.k_constraint_Description_Placeholder_Top.constant = 143.0
                self.k_contraint_ViewFields_Height.constant = 352.0
                
            }
            
            self.tblView_SocialSites.reloadData()
        }
        
        
        
        
    }
    
    @IBAction func Action_SocialSitesMinus(_ sender: UIButton) {
        
        
        
        
    }
    
    
    @IBAction func Action_SocialSitesPlus(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func Action_Done(_ sender: UIButton) {
        
        
    }
    
    //MARK: - Google Location Delegate
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        txtfield_Location.text = "\(place.name)"
        self.lat_long(string: txtfield_Location.text!)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        //handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}




//MARK: - CLASS EXTENSIONS

extension EditProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let orientationFixedImage = image?.fixOrientation()

        let imageData = UIImageJPEGRepresentation(orientationFixedImage! , 0.1)
        let resultiamgedata = imageData!.base64EncodedData(options: NSData.Base64EncodingOptions.lineLength64Characters)
        self.str_profileImage = (NSString(data: resultiamgedata, encoding: String.Encoding.utf8.rawValue) as String?)!
        
        self.img_PlusIconProfile.isHidden = true

        self.imgView_Profile.image = image
        DispatchQueue.main.async {
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = Int()
        
        if tableView == tblView_MySkills{
            count = array_UserOccupations.count
        }
            
        else if tableView == tblView_ActualSkills{
            count = array_ActualOccupations.count
        }
            //on main view
        else if tableView == tblView_SocialSites{
            count = array_UserSocialSites.count
        }
            //on social sites table view
        else if tableView == tblView_UserSites{
            count = array_UserSocialSites.count
            
        }
        else if tableView == tblView_ActualSocialSites{
            count = array_ActualSocialSites.count
            
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        //Occupation view tables
        if tableView == tblView_MySkills {
            
            let Myskill_cell = tableView.dequeueReusableCell(withIdentifier: "tableView1", for: indexPath)as! MySkillsTableViewCell
            Myskill_cell.DataOfMySkills(dict: (self.array_UserOccupations[indexPath.row]as! NSDictionary ))
            cell = Myskill_cell
        }
        
        if tableView == self.tblView_ActualSkills {
            
            let Actualskill_cell  = tableView.dequeueReusableCell(withIdentifier: "tableView2", for: indexPath) as! ActualSkillsTableViewCell
            Actualskill_cell.DataOfActualSkills(dict:(self.array_ActualOccupations[indexPath.row] as! NSDictionary ))
            cell = Actualskill_cell
        }
        
        //For social sites
        //On MAIN VIEW
        if tableView == self.tblView_SocialSites {
            
            let Socialsites_cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SocialSitesTableViewCell
            Socialsites_cell.imgView_SocialSites.image = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            Socialsites_cell.txtfield_SocialSiteUrl.text = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "url") as? String
            Socialsites_cell.txtfield_SocialSiteUrl.tag = indexPath.row
            cell = Socialsites_cell
        }
        
        if tableView == self.tblView_UserSites {
            
            let UserSites_cell  = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! UserSocialSitesTableViewCell
            UserSites_cell.lbl_UserSocialSites.text = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "name") as? String
            UserSites_cell.img_View_UserSocialSites.image = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            
            cell = UserSites_cell
        }
        
        
        if tableView == self.tblView_ActualSocialSites {
            
            let ActualSocialSites  = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ActualSocialSitesTableViewCell
            ActualSocialSites.lbl_UserSocialSites.text = (array_ActualSocialSites[indexPath.row] as NSDictionary).value(forKey: "name") as? String
            ActualSocialSites.img_View_UserSocialSites.image = (array_ActualSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            cell = ActualSocialSites
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Social Sites Tables
        if tableView == tblView_ActualSocialSites{
            
            if array_UserSocialSites.count < 3{
                
                let value = array_ActualSocialSites[indexPath.row]
                array_ActualSocialSites.remove(at: indexPath.row)
                array_UserSocialSites.insert(value, at: 0)
                tblView_ActualSocialSites.reloadData()
                tblView_UserSites.reloadData()
                
            }
        }
            
        else if tableView == tblView_UserSites{
            
            let value = array_UserSocialSites[indexPath.row]
            array_UserSocialSites.remove(at: indexPath.row)
            array_ActualSocialSites.insert(value , at: 0)
            tblView_ActualSocialSites.reloadData()
            tblView_UserSites.reloadData()
            
        }
            
            //Occupations
        else if tableView == tblView_MySkills{
            
            let value = array_UserOccupations[indexPath.row]
            array_UserOccupations.removeObject(at: indexPath.row)
            array_ActualOccupations.insert(value , at: 0)
            self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray
            tblView_MySkills.reloadData()
            tblView_ActualSkills.reloadData()
            
        }
        else if tableView == tblView_ActualSkills{
            
            let value = array_ActualOccupations[indexPath.row]
            array_ActualOccupations.removeObject(at: indexPath.row)
            array_UserOccupations.insert(value, at: 0)
            self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray
            tblView_MySkills.reloadData()
            tblView_ActualSkills.reloadData()
            
        }
        
        
        
        
        
    }
}



extension EditProfileViewController:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        self.view.endEditing(true)
        self.navigationController?.navigationBar.isHidden = false
        self.scroll_view.isHidden = false
        self.scroll_view.isScrollEnabled = true
        view_BlurrView.isHidden = true
        view_Skills.isHidden = true
        self.collection_View_Occupation.reloadData()
        self.search_Bar.text = ""
        
        if array_UserSocialSites.count == 0 {
            
            self.tblView_SocialSites.isHidden = true
            self.k_constraint_Description_Top.constant = 9.0
            self.k_constraint_Description_Placeholder_Top.constant = 14.0
            self.k_contraint_ViewFields_Height.constant = 235.0
        }
        
        if array_UserSocialSites.count > 0 {
            
            tblView_SocialSites.isHidden = false
            tblView_SocialSites.isScrollEnabled = false
            
            if array_UserSocialSites.count == 1{
                self.k_constraint_Description_Top.constant = 50.0
                self.k_constraint_Description_Placeholder_Top.constant = 55.0
                self.k_contraint_ViewFields_Height.constant = 264.0
            }
            else if array_UserSocialSites.count == 2{
                self.k_constraint_Description_Top.constant = 94.0
                self.k_constraint_Description_Placeholder_Top.constant = 99.0
                self.k_contraint_ViewFields_Height.constant = 308.0
            }
            else if array_UserSocialSites.count == 3{
                
                self.k_constraint_Description_Top.constant = 138.0
                self.k_constraint_Description_Placeholder_Top.constant = 143.0
                self.k_contraint_ViewFields_Height.constant = 352.0
                
            }
            
            self.tblView_SocialSites.reloadData()
        }
        
        return true
        
    }
}



extension EditProfileViewController :  UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lbl_PlaceholderTxtview.isHidden = true
        
        if Global.DeviceType.IS_IPHONE_5 || Global.DeviceType.IS_IPHONE_4_OR_LESS{
            self.animateTextView(textView: textView, up: true, movementDistance: textView.frame.maxY, scrollView:self.scroll_view)
        }
        else{
            self.animateTextView(textView: textView, up: true, movementDistance: 210, scrollView:self.scroll_view)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtview_Description.text == ""
        {
            lbl_PlaceholderTxtview.isHidden = false
        }
        else {
            
            lbl_PlaceholderTxtview.isHidden = true
        }
        
        self.animateTextView(textView: textView, up: true, movementDistance: textView.frame.minY, scrollView:self.scroll_view)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        lbl_PlaceholderTxtview.isHidden = !textView.text.isEmpty
    }
}


/* These are delegate methods for UITextFieldDelegate */


extension  EditProfileViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtfield_Location {
            txtfield_Location.resignFirstResponder()
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
            
        }
        
        if Global.DeviceType.IS_IPHONE_5 || Global.DeviceType.IS_IPHONE_4_OR_LESS
        {
            if  textField == txtfield_Url {
                
                self.animateTextField(textField: textField, up:true,movementDistance: 100,scrollView: self.scroll_view)  //scroll up when keyboard appears
            }
            else if textField != txtfield_Url && textField != txtfield_SchoolName && textField != txtfield_Location{
                
                self.animateTextField(textField: textField, up:true,movementDistance: 180,scrollView: self.scroll_view)
            }
            
        }
        else{
            
            if  textField != txtfield_Url && textField != txtfield_SchoolName && textField != txtfield_Location{
                
                self.animateTextField(textField: textField, up:true,movementDistance: 150,scrollView: self.scroll_view)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtfield_SchoolName{
            txtfield_Location.becomeFirstResponder()
        }
        else if textField == txtfield_Location{
            txtfield_Url.becomeFirstResponder()
        }
        else if textField == txtfield_Url{
            txtfield_Url.resignFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if textField == txtfield_SchoolName {
            
            if (string.length <= 30) {
                
                return true
            }
            else{
                return false
            }
        }
            
        else if textField == txtfield_Url {
            if (string.length <= 30) {
                
                return true
            }
            else{
                return false
            }
        }
        
        
        let index = textField.tag
        switch index {
        case 0:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = string
            array_UserSocialSites[index] = dic
            // print(array_UserSocialSites)
            break
            
        case 1:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = string
            array_UserSocialSites[index] = dic
            // print(array_UserSocialSites)
            break
            
        case 2:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = string
            array_UserSocialSites[index] = dic
            // print(array_UserSocialSites)
            
            break
            
        default:
            break
        }
        
        return true
    }
    
}

extension EditProfileViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return array_Schools.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if sender_Tag == 0{
            txtfield_SchoolName.text = "Community College of the Air Force"
        }
        let str = (array_Schools[row] as! NSDictionary).value(forKey: "name")as! String
        return str
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if sender_Tag == 0{
            
            self.txtfield_SchoolName.text = (array_Schools[row] as! NSDictionary).value(forKey: "name") as? String
        }
    }
}

extension EditProfileViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Com_SchoolOccupationCollectionViewCell
        
        if array_UserOccupations.count > 0 {
            
            cell.lbl_Occupationname.text = (array_UserOccupations[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array_UserOccupations.count
    }
    
    
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
}
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

extension EditProfileViewController:UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        
        var txtAfterUpdate = searchBar.text! as NSString
        txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
        
        if(txtAfterUpdate.length == 0) {
            
           self.getallOccupation()
        }
        else {
            
            let predicate = NSPredicate(format: "(name contains[cd] %@)", txtAfterUpdate)
            temp_arrOccupation.removeAllObjects()
            temp_arrOccupation.addObjects(from: self.arrsearchActualOccupation.filtered(using: predicate))
            
            
            array_ActualOccupations.removeAllObjects()
            array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
            self.tblView_ActualSkills.reloadData()
        }

        return true

}
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        temp_arrOccupation = NSMutableArray()
        temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
        
        array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
        self.tblView_ActualSkills.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchBar.resignFirstResponder()
        
    }
    
    
}
