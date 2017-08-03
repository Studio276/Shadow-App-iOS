//
//  UserEditProfileViewController.swift
//  Shadow
//
//  Created by Aditi on 28/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

var dictionary_user_Info:NSDictionary = NSDictionary()

class UserEditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileDummyImage: UIImageView!
    @IBOutlet var scroll_view: UIScrollView!
    @IBOutlet var view_Container: UIView!
    @IBOutlet var imgView_ProfilePic: UIImageView!
    @IBOutlet var view_Fields: UIView!
    @IBOutlet var CollectionView_Occupation: UICollectionView!
    @IBOutlet var txtfield_Name: UITextField!
    @IBOutlet var txtfield_School: UITextField!
    @IBOutlet var txtfield_Company: UITextField!
    @IBOutlet var tblView_SocialSites: UITableView!
    @IBOutlet var txtView_Desrciption: UITextView!
    @IBOutlet var lbl_Description_Placeholder: UILabel!
    @IBOutlet var collectionview_Interests: UICollectionView!
    @IBOutlet var pickerView_SchoolComapny: UIPickerView!
    @IBOutlet var view_BlurrView: UIView!
    @IBOutlet var view_Occupations: UIView!
    @IBOutlet var serachBar_Occupation: UISearchBar!
    @IBOutlet var view_SocialSites: UIView!
    @IBOutlet var view_PickerView: UIView!
    @IBOutlet var tblView_ActualSocialSites: UITableView!
    @IBOutlet var tblView_UserSocialSites: UITableView!
    @IBOutlet var tblView_UserOccupations: UITableView!
    @IBOutlet var tblView_ActualOccupations: UITableView!
    @IBOutlet var view_Interests: UIView!
    @IBOutlet var search_interest: UISearchBar!
    @IBOutlet var tblView_UserInterests: UITableView!
    @IBOutlet var tblView_ActualInterests: UITableView!
    @IBOutlet var k_Constraint_TxtviewDesription_Top: NSLayoutConstraint!
    @IBOutlet var k_Constraint_TxtviewDesription_PlaceholderTop: NSLayoutConstraint!
    @IBOutlet var k_Constraint_ViewFields_Height: NSLayoutConstraint!
    @IBOutlet var lbl_NoOccupationsYet: UILabel!
    @IBOutlet var lbl_NoInterestsYet: UILabel!
    @IBOutlet var view_SchoolSearch: UIView!
    @IBOutlet var txtfield_SchoolSearch: UITextField!
    @IBOutlet var tblView_SchoolSearch: UITableView!
    @IBOutlet var btn_Done_Occupation: UIButton!
    @IBOutlet var btn_Done_Interests: UIButton!
    @IBOutlet weak var btn_Done_SocialSite: UIButton!
    
    
    
    
    fileprivate var arrsearchActualOccupation : NSMutableArray = NSMutableArray()
    fileprivate var temp_arrOccupation : NSMutableArray = NSMutableArray()
    
    fileprivate var sender_Tag:Int?
    fileprivate var str_profileImage:String?
    var str_searchText: NSString?
    var dict_Url:NSMutableDictionary = NSMutableDictionary()//from previous view(social sites url)
    
    fileprivate var array_ActualOccupations:NSMutableArray = NSMutableArray()
    fileprivate var array_UserOccupations:NSMutableArray = NSMutableArray()
    fileprivate var array_ActualInterests:NSMutableArray = NSMutableArray()
    fileprivate var array_UserInterests:NSMutableArray = NSMutableArray()
    fileprivate var array_Schools_Company:NSMutableArray = NSMutableArray()//picker
    fileprivate var array_UserSocialSites = [[String:Any]]()
    
    fileprivate var array_ActualSocialSites = [["name":"Facebook","image":UIImage(named: "facebookUrl")! ],["name":"LinkedIn","image":UIImage(named: "linkedInUrl")!],["name":"Twitter","image":UIImage(named: "twitterUrl")! ],["name":"gitHub","image":UIImage(named: "gitHubUrl")!],["name":"Google+","image":UIImage(named: "googlePlusUrl")!],["name":"Instagram","image":UIImage(named: "instagramUrl")!]]
    
    
    override func viewWillLayoutSubviews() {
        
        
        
        DispatchQueue.main.async {
            
            if Global.DeviceType.IS_IPHONE_6P || Global.DeviceType.IS_IPHONE_6P{
            self.scroll_view.contentSize = CGSize(width: self.view.frame.size.width, height: 1100)
            }
            else {
                self.scroll_view.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
 
            }
        }
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        
        self.title = "Edit Profile"
        super.viewDidLoad()
        getallOccupation()
        getallInterests()
        
        //setting profile pic
        let profileurl = dictionary_user_Info.value(forKey: "profileImageUrl")as? String
        if profileurl != nil {
            self.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
            self.profileDummyImage.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        self.tblView_SchoolSearch.tableFooterView = UIView()
        //occupation done button
        self.btn_Done_Occupation.layer.cornerRadius = 8.0
        self.btn_Done_Occupation.layer.borderWidth = 1.0
        self.btn_Done_Occupation.layer.borderColor = Global.macros.themeColor.cgColor
        
        //Interests done button
        self.btn_Done_Interests.layer.cornerRadius = 8.0
        self.btn_Done_Interests.layer.borderWidth = 1.0
        self.btn_Done_Interests.layer.borderColor = Global.macros.themeColor.cgColor
        
        //Social site done button
        self.btn_Done_SocialSite.layer.cornerRadius = 8.0
        self.btn_Done_SocialSite.layer.borderWidth = 1.0
        self.btn_Done_SocialSite.layer.borderColor = Global.macros.themeColor.cgColor
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.title = (dictionary_user_Info.value(forKey: Global.macros.kUserName) as? String)?.capitalizingFirstLetter()
        
        
        
        CustomBorder(searchbar : self.serachBar_Occupation)
        CustomBorder(searchbar : self.search_interest)
        
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToProfile), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        
        DispatchQueue.main.async{
            
            self.imgView_ProfilePic.layer.cornerRadius = 60
            self.imgView_ProfilePic.clipsToBounds = true
            self.imgView_ProfilePic.layer.borderWidth = 1.0
            self.imgView_ProfilePic.layer.borderColor = Global.macros.themeColor.cgColor
            
            self.txtView_Desrciption.layer.borderWidth = 1.0
            self.txtView_Desrciption.layer.borderColor = Global.macros.themeColor.cgColor
            self.txtView_Desrciption.layer.cornerRadius = 4.0
            self.txtView_Desrciption.clipsToBounds = true

            
            //Save button
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "upload-icon"), for: .normal)
            btn1.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 25, height: 25)
            btn1.addTarget(self, action: #selector(self.saveProfile), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            
            self.navigationItem.setRightBarButtonItems([item1], animated: true)
            
            // print(self.dict_user_Info)
            self.txtfield_Name.text  = dictionary_user_Info.value(forKey: Global.macros.kUserName) as? String
            self.txtfield_Name.isUserInteractionEnabled = false
            self.txtfield_School.text = dictionary_user_Info.value(forKey: Global.macros.kschoolName) as? String
            self.txtfield_Company.text = dictionary_user_Info.value(forKey: Global.macros.kcompanyName) as? String
            
            if dictionary_user_Info.value(forKey: Global.macros.kbio) as? String != nil{
                
                self.txtView_Desrciption.text = dictionary_user_Info.value(forKey: Global.macros.kbio) as? String
                self.lbl_Description_Placeholder.isHidden = true
                
            }
            else{
                self.lbl_Description_Placeholder.isHidden = false
            }
           
            
            //getting user occupation
            let tmp_arr_occ = (dictionary_user_Info.value(forKey: Global.macros.koccupation) as? NSArray)?.mutableCopy() as! NSMutableArray
            for value in tmp_arr_occ{
                
                let name_interest = (value as! NSDictionary).value(forKey: "name") as? String
                let dict = NSMutableDictionary()
                dict.setValue(name_interest, forKey: "name")
                if self.array_UserOccupations.contains(dict) {
                    break
                }
                else{
                    self.array_UserOccupations.add(dict)
                    
                }
            }
            
            //getting user interests
            let tmp_arr_Int = (dictionary_user_Info.value(forKey: Global.macros.kinterest) as! NSArray).mutableCopy() as! NSMutableArray
            
            for value in tmp_arr_Int{
                
                let name_interest = (value as! NSDictionary).value(forKey: "name") as? String
                let dict = NSMutableDictionary()
                dict.setValue(name_interest, forKey: "name")
                if self.array_UserInterests.contains(dict) {
                    break
                }
                else{
                    self.array_UserInterests.add(dict)
                }
            }
            
            //setting user occupation in collection view
            if self.array_UserOccupations.count  > 0{
                self.CollectionView_Occupation.reloadData()
                self.lbl_NoOccupationsYet.isHidden = true
            }
            else{
                
                self.CollectionView_Occupation.isHidden = true
                self.lbl_NoOccupationsYet.isHidden = false
            }
            
            //setting user interests in collection view
            if self.array_UserInterests.count  > 0{
                self.collectionview_Interests.reloadData()
                self.lbl_NoInterestsYet.isHidden = true
            }
            else{
                
                self.collectionview_Interests.isHidden = true
                self.lbl_NoInterestsYet.isHidden = false
            }
            
            // print(self.dict_Url)
            if self.dict_Url.count > 0 {
                
                //making same array from dict from previous view as array_userSocialSites
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
            
            //   print(self.array_UserSocialSites)
            
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
                
                //setting social table view acc to count
                if self.array_UserSocialSites.count == 1{
                    self.k_Constraint_TxtviewDesription_Top.constant = 50.0
                    self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 55.0
                    self.k_Constraint_ViewFields_Height.constant = 264.0
                }
                else if self.array_UserSocialSites.count == 2{
                    self.k_Constraint_TxtviewDesription_Top.constant = 94.0
                    self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 99.0
                    self.k_Constraint_ViewFields_Height.constant = 308.0
                }
                else if self.array_UserSocialSites.count == 3{
                    self.k_Constraint_TxtviewDesription_Top.constant = 138.0
                    self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 143.0
                    self.k_Constraint_ViewFields_Height.constant = 352.0
                }
                self.tblView_SocialSites.reloadData()
                
            }
            else{
                
                self.tblView_SocialSites.isHidden = true
                self.k_Constraint_TxtviewDesription_Top.constant = 9.0
                self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 14.0
                self.k_Constraint_ViewFields_Height.constant = 235.0
                
            }
            
            
            //social sites tables in social view
            self.tblView_UserSocialSites.tableFooterView = UIView()
            self.tblView_ActualSocialSites.tableFooterView = UIView()
            
            self.view_SocialSites.layer.cornerRadius = 8.0
            self.view_SocialSites.clipsToBounds = true
            
            self.view_SocialSites.layer.borderColor = Global.macros.themeColor.cgColor
            self.view_SocialSites.layer.borderWidth = 1.0
            
            self.tblView_ActualSocialSites.layer.cornerRadius = 5.0
            self.tblView_ActualSocialSites.clipsToBounds = true
            self.tblView_UserSocialSites.layer.cornerRadius = 5.0
            self.tblView_UserSocialSites.clipsToBounds = true
            
            self.tblView_UserSocialSites.layer.borderWidth = 1.0
            self.tblView_UserSocialSites.layer.borderColor = Global.macros.themeColor.cgColor
            self.tblView_ActualSocialSites.layer.borderWidth = 1.0
            self.tblView_ActualSocialSites.layer.borderColor = Global.macros.themeColor.cgColor
            
            //occupation tables
            self.tblView_UserOccupations.tableFooterView = UIView()
            self.tblView_ActualOccupations.tableFooterView = UIView()
            
            self.view_Occupations.layer.cornerRadius = 8.0
            self.view_Occupations.clipsToBounds = true
            self.view_Occupations.layer.borderColor = Global.macros.themeColor.cgColor
            self.view_Occupations.layer.borderWidth = 1.0
            
            self.tblView_ActualOccupations.layer.cornerRadius = 5.0
            self.tblView_ActualOccupations.clipsToBounds = true
            self.tblView_UserOccupations.layer.cornerRadius = 5.0
            self.tblView_UserOccupations.clipsToBounds = true
            
            self.tblView_UserOccupations.layer.borderWidth = 1.0
            self.tblView_UserOccupations.layer.borderColor = Global.macros.themeColor.cgColor
            self.tblView_ActualOccupations.layer.borderWidth = 1.0
            self.tblView_ActualOccupations.layer.borderColor = Global.macros.themeColor.cgColor
            
            
            //interest tables
            self.tblView_UserInterests.tableFooterView = UIView()
            self.tblView_ActualInterests.tableFooterView = UIView()
            
            self.view_Interests.layer.cornerRadius = 8.0
            self.view_Interests.clipsToBounds = true
            
            self.view_Interests.layer.borderColor = Global.macros.themeColor.cgColor
            self.view_Interests.layer.borderWidth = 1.0
            
            self.tblView_ActualInterests.layer.cornerRadius = 5.0
            self.tblView_ActualInterests.clipsToBounds = true
            self.tblView_UserInterests.layer.cornerRadius = 5.0
            self.tblView_UserInterests.clipsToBounds = true
            
            self.tblView_UserInterests.layer.borderWidth = 1.0
            self.tblView_UserInterests.layer.borderColor = Global.macros.themeColor.cgColor
            self.tblView_ActualInterests.layer.borderWidth = 1.0
            self.tblView_ActualInterests.layer.borderColor = Global.macros.themeColor.cgColor
            
            let tap = UITapGestureRecognizer()
            self.view_BlurrView.addGestureRecognizer(tap)
            tap.delegate = self
        }
        
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
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    
    @IBAction func Action_SelectProfilePic(_ sender: UIButton) {
        
        
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
    
    @IBAction func Action_SelectSocialMedia(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.navigationController?.navigationBar.isHidden = true
        //self.scroll_view.isHidden = true
        
        self.view_BlurrView.isHidden = false
        self.view_SocialSites.isHidden = false
        // self.view_Occupations.isHidden = true
        // self.view_Interests.isHidden = true
        
        
        self.view.bringSubview(toFront:  self.view_BlurrView)
        self.view.bringSubview(toFront:  self.view_SocialSites)
        
        
        self.tblView_UserSocialSites.reloadData()
        self.tblView_ActualSocialSites.reloadData()
        
    }
    
    
    @IBAction func Action_Done_SocialSites(_ sender: UIButton) {
        
        self.scroll_view.isHidden = false
        self.view_BlurrView.isHidden = true
        self.view_SocialSites.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        if self.array_UserSocialSites.count == 0{
            
            self.tblView_SocialSites.isHidden = true
            self.k_Constraint_TxtviewDesription_Top.constant = 9.0
            self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 14.0
            self.k_Constraint_ViewFields_Height.constant = 235.0
            
        }
        
        if array_UserSocialSites.count > 0 {
            
            tblView_SocialSites.isHidden = false
            tblView_SocialSites.isScrollEnabled = false
            
            //setting table view height according to array count
            if array_UserSocialSites.count == 1{
                self.k_Constraint_TxtviewDesription_Top.constant = 50.0
                self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 55.0
                self.k_Constraint_ViewFields_Height.constant = 264.0
            }
            else if array_UserSocialSites.count == 2{
                self.k_Constraint_TxtviewDesription_Top.constant = 94.0
                self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 99.0
                self.k_Constraint_ViewFields_Height.constant = 308.0
            }
            else if array_UserSocialSites.count == 3{
                self.k_Constraint_TxtviewDesription_Top.constant = 138.0
                self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 143.0
                self.k_Constraint_ViewFields_Height.constant = 352.0
            }
            self.tblView_SocialSites.reloadData()
        }
    }
    
    
    
    @IBAction func Action_SelectSchool(_ sender: UIButton) {
        
        
        self.txtfield_SchoolSearch.text = ""
        
        self.view_BlurrView.isHidden = false
        self.view_SchoolSearch.isHidden = false
        self.view.bringSubview(toFront:  self.view_BlurrView)
        self.view.bringSubview(toFront:  self.view_SchoolSearch)
        
        self.navigationController?.navigationBar.isHidden = true
        // self.scroll_view.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 1, 1)
        
        
        
    }
    
    
    @IBAction func Action_SelectCompany(_ sender: UIButton) {
        sender_Tag = sender.tag
        
        
        
        
        
    }
    
    @IBAction func Action_EditOccupation(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
        
        self.getallOccupation()

        self.view.endEditing(true)
        self.navigationController?.navigationBar.isHidden = true
        // self.scroll_view.isHidden = true
        
        self.view.bringSubview(toFront:  self.view_BlurrView)
        self.view.bringSubview(toFront:  self.view_Occupations)
        
        
        self.view_Occupations.isHidden = false
        self.view_BlurrView.isHidden = false
        self.view_SocialSites.isHidden = true
        self.view_Interests.isHidden = true
        self.tblView_ActualOccupations.reloadData()
        self.tblView_UserOccupations.reloadData()
       
        }
        
        
    }
    
    
    @IBAction func Action_Done_Occupation(_ sender: UIButton) {
        
        
        
        self.view.endEditing(true)
       // self.arrsearchActualOccupation.removeAllObjects()
        self.temp_arrOccupation.removeAllObjects()
        
        self.scroll_view.isHidden = false
        self.view_BlurrView.isHidden = true
        self.view_Occupations.isHidden = true
        
        self.serachBar_Occupation.text = ""
        
        
        self.navigationController?.navigationBar.isHidden = false
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        
        if array_UserOccupations.count > 0{
            self.CollectionView_Occupation.isHidden = false
            self.lbl_NoOccupationsYet.isHidden = true
            self.CollectionView_Occupation.reloadData()
            
        }
        else{
            self.CollectionView_Occupation.isHidden = true
            self.lbl_NoOccupationsYet.isHidden = false
        }
        
    }
    
    
    @IBAction func Action_EditInterests(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            
        self.getallInterests()
        self.view.endEditing(true)
        self.navigationController?.navigationBar.isHidden = true
        // self.scroll_view.isHidden = true
        
        self.view.bringSubview(toFront:  self.view_BlurrView)
        self.view.bringSubview(toFront:  self.view_Interests)
        
        self.view_BlurrView.isHidden = false
        self.view_Interests.isHidden = false
        self.view_Occupations.isHidden = true
        self.view_SocialSites.isHidden = true
        self.tblView_UserInterests.reloadData()
        self.tblView_ActualInterests.reloadData()
        }
        
    }
    
    
    @IBAction func Action_Done_Interests(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.temp_arrOccupation.removeAllObjects()
        self.view_Interests.isHidden = true
        self.search_interest.text = ""

        self.navigationController?.navigationBar.isHidden = false
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        self.scroll_view.isHidden = false
        self.view_BlurrView.isHidden = true
        if array_UserInterests.count > 0{
            self.collectionview_Interests.isHidden = false
            self.lbl_NoInterestsYet.isHidden = true
            self.collectionview_Interests.reloadData()
        }
        else{
            self.collectionview_Interests.isHidden = true
            self.lbl_NoInterestsYet.isHidden = false
        }
        
    }
    
    
    
    @IBAction func Action_CancelPicker(_ sender: UIButton) {
        view_PickerView.isHidden = true
    }
    
    @IBAction func Action_DonePicker(_ sender: UIButton) {
        view_PickerView.isHidden = true
    }
    
    
    @IBAction func RecordVideo(_ sender: Any) {
        
        bool_PlayFromProfile = false
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Functions
    
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
                        let tmp_arr = ((((response as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "occupations") as! NSArray).mutableCopy() as? NSMutableArray)!
                        
                        for value in tmp_arr{
                            
                            let name_interest = (value as! NSDictionary).value(forKey: "name") as? String
                            let dict = NSMutableDictionary()
                            dict.setValue(name_interest, forKey: "name")
                            if self.array_ActualOccupations.contains(dict) {
                                break
                            }
                            else{
                                self.array_ActualOccupations.add(dict)
                            }
                        }
                        
                        var name1:String?
                        if self.array_UserOccupations.count > 0{
                            
                            for value in self.array_UserOccupations{
                                
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
                            self.tblView_ActualOccupations.reloadData()
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
    
    func getallInterests(){
        
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
                        self.array_ActualInterests.removeAllObjects()
                        let tmp_arr = ((((response as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "occupations") as! NSArray).mutableCopy() as? NSMutableArray)!
                        
                        for value in tmp_arr{
                            
                            let name_interest = (value as! NSDictionary).value(forKey: "name") as? String
                            let dict = NSMutableDictionary()
                            dict.setValue(name_interest, forKey: "name")
                            if self.array_ActualInterests.contains(dict) {
                                break
                            }
                            else{
                                self.array_ActualInterests.add(dict)
                            }
                        }
                        
                        var name1:String?
                        if self.array_UserInterests.count > 0{
                            
                            for value in self.array_UserInterests{
                                
                                let temp_dict = value as! NSDictionary
                                name1 = temp_dict.value(forKey: "name") as? String
                                
                                for (idx,val) in self.array_ActualInterests.enumerated(){
                                    
                                    let dict = val as! NSDictionary
                                    let name2 = dict.value(forKey: "name") as? String
                                    
                                    if name2 == name1 {
                                        self.array_ActualInterests.removeObject(at: idx)
                                        break
                                        
                                    }
                                }
                            }
                            
                           
                        }
                         self.arrsearchActualOccupation = self.array_ActualInterests.mutableCopy() as! NSMutableArray
                        
                        DispatchQueue.main.async {
                            self.tblView_ActualInterests.reloadData()
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
    
    
    
    func getallSchools(){
        
        
        if self.checkInternetConnection()
        {
            //API To login
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
            dic.setValue(user_Id, forKey: Global.macros.kUserId)
            dic.setValue(str_searchText, forKey: "searchKeyword")
            print(dic)
            
            
            ProfileAPI.sharedInstance.getListOfSchools(dict: dic, completion: {(response) in
                
                switch response.0
                {
                case 200:
                    print("success")
                    
                    self.array_Schools_Company = ((response.1).value(forKey: "schoolList") as? NSArray)?.mutableCopy() as! NSMutableArray
                    //((Response as! NSDictionary).value(forKey: "CommentRepliesData") as? NSArray)?.mutableCopy() as! NSMutableArray
                    DispatchQueue.main.async {
                        self.tblView_SchoolSearch.isHidden = false
                        self.tblView_SchoolSearch.reloadData()
                        
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.tblView_SchoolSearch.isHidden = true
                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    
                    self.array_Schools_Company.removeAllObjects()
                    DispatchQueue.main.async {
                        self.tblView_SchoolSearch.isHidden = true
                        self.tblView_SchoolSearch.reloadData()
                    }
                    
                case 401:
                    
                    
                    self.array_Schools_Company.removeAllObjects()
                    DispatchQueue.main.async {
                        self.tblView_SchoolSearch.isHidden = true
                        self.tblView_SchoolSearch.reloadData()
                    }
                    
                default:
                    break
                }
                
                self.clearAllNotice()
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message:(err?.localizedDescription)!, vc: self)
                    
                    
                }
                
                
                
            })
            
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
            
        }
    }
    
    func hitEditProfile(dict:NSMutableDictionary)  {
        if checkInternetConnection(){
            
            DispatchQueue.main.async{
                self.pleaseWait()
            }
            ServerCall.sharedInstance.postService({ (response) in
                DispatchQueue.main.async{
                    self.clearAllNotice()
                }
                let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
                switch Int(status!){
                    
                case 200:
                    DispatchQueue.main.async{
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
                    self.AlertSessionExpire()
                    break
                    
                default:
                    DispatchQueue.main.async{
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
        dict.setValue(self.txtfield_School.text!, forKey: Global.macros.kschoolName)
        dict.setValue(self.txtfield_Company.text!, forKey: Global.macros.kcompanyName)
        dict.setValue(self.txtView_Desrciption.text!, forKey: Global.macros.kbio)
        dict.setValue(array_UserOccupations, forKey: Global.macros.koccupation)
        dict.setValue(array_UserInterests, forKey: Global.macros.kinterest)
        
        if array_UserSocialSites.count > 0{
            for value in array_UserSocialSites{
                
                let temp_d = value as NSDictionary
                let url = temp_d.value(forKey: "url") as? String
                let n = temp_d.value(forKey: Global.macros.kname) as? String
                
                if n == "Facebook"
                {
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
                else if n == "gitHub"
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
        
        if array_UserSocialSites.count > 0{
            
            for value in  array_UserSocialSites{
                
                
                let dic = value
                if (dic["url"] as? String)?.characters.count != 0 && (dic["url"] as? String) != nil{
                    
                    if self.verifyUrl(urlString: dic["url"] as? String){
                        
                        self.hitEditProfile(dict: dict)
                        
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
            self.hitEditProfile(dict: dict)
        }
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

extension UserEditProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func takeNewPhotoFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.allowsEditing = false
            controller.delegate = self
            DispatchQueue.main.async {
                self.navigationController?.present(controller, animated: true, completion: nil)
            }
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
            DispatchQueue.main.async {
                self.navigationController!.present(controller, animated: true, completion: { _ in })
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let orientationFixedImage = image?.fixOrientation()
        
        let imageData = UIImageJPEGRepresentation(orientationFixedImage! , 0.1)
        let resultiamgedata = imageData!.base64EncodedData(options: NSData.Base64EncodingOptions.lineLength64Characters)
        self.str_profileImage = (NSString(data: resultiamgedata, encoding: String.Encoding.utf8.rawValue) as String?)!
        self.profileDummyImage.isHidden = true
        self.imgView_ProfilePic.image = image
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

extension UserEditProfileViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return array_Schools_Company.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if sender_Tag == 0{
            
            txtfield_School.text = "Community College of the Air Force"
        }
        if sender_Tag == 1{
            
            txtfield_Company.text = "Community College of the Air Force"
        }
        
        let str = (array_Schools_Company[row] as! NSDictionary).value(forKey: "name")as! String
        return str
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if sender_Tag == 0{
            
            self.txtfield_School.text = (array_Schools_Company[row] as! NSDictionary).value(forKey: "name") as? String
        }
        
        if sender_Tag == 1{
            
            self.txtfield_Company.text = (array_Schools_Company[row] as! NSDictionary).value(forKey: "name") as? String
        }
    }
}


extension UserEditProfileViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell:UICollectionViewCell!
        
        if collectionView == self.CollectionView_Occupation {
            
            let Occupation_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "Occupation_cell", for: indexPath) as! MainViewUser_OccupationCollectionViewCell
            
            if array_UserOccupations.count > 0 {
                
                Occupation_cell.lbl_OccupationName.text = (array_UserOccupations[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            }
            
            cell = Occupation_cell
        }
            
        else  if collectionView == self.collectionview_Interests {
            
            let Interests_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "Interests_cell", for: indexPath) as! MainView_User_InterestsCollectionViewCell
            
            if array_UserInterests.count > 0 {
                
                Interests_cell.lbl_InterestName.text = (array_UserInterests[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            }
            
            cell = Interests_cell
        }
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count:Int?
        
        if collectionView == self.CollectionView_Occupation {
            
            count = array_UserOccupations.count
        }
            
        else if collectionView == self.collectionview_Interests {
            
            count = array_UserInterests.count
        }
        
        return count!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
      //  return CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
        let size:CGSize?
        if Global.DeviceType.IS_IPHONE_6 || Global.DeviceType.IS_IPHONE_6P{
            size = CGSize(width: ((collectionView.frame.width/3 - 5) ), height: 45)
        }
        else{
            size = CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
            
        }
        return size!
    }
    
    
    
    
}
extension UserEditProfileViewController:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        self.navigationController?.navigationBar.isOpaque = true
        self.scroll_view.contentInset = UIEdgeInsets.init(top: 60, left: 0, bottom: 0, right: 0)

        
        
        self.view.endEditing(true)
        
        self.navigationController?.navigationBar.isHidden = false
        self.scroll_view.isHidden = false
        self.view_BlurrView.isHidden = true
        self.view_SocialSites.isHidden = true
        self.view_SchoolSearch.isHidden = true
        self.view_Occupations.isHidden = true
        self.view_Interests.isHidden = true
        self.search_interest.text = ""
        self.serachBar_Occupation.text = ""
        
        
        if self.array_UserSocialSites.count == 0{
            
            self.tblView_SocialSites.isHidden = true
            self.k_Constraint_TxtviewDesription_Top.constant = 9.0
            self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 14.0
            self.k_Constraint_ViewFields_Height.constant = 235.0
        }
        
        if array_UserSocialSites.count > 0 {
            
            tblView_SocialSites.isHidden = false
            tblView_SocialSites.isScrollEnabled = false
            
            //setting table view height according to array count
            if array_UserSocialSites.count == 1{
                self.k_Constraint_TxtviewDesription_Top.constant = 50.0
                self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 55.0
                self.k_Constraint_ViewFields_Height.constant = 264.0
            }
            else if array_UserSocialSites.count == 2{
                self.k_Constraint_TxtviewDesription_Top.constant = 94.0
                self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 99.0
                self.k_Constraint_ViewFields_Height.constant = 308.0
            }
            else if array_UserSocialSites.count == 3{
                self.k_Constraint_TxtviewDesription_Top.constant = 138.0
                self.k_Constraint_TxtviewDesription_PlaceholderTop.constant = 143.0
                self.k_Constraint_ViewFields_Height.constant = 352.0
            }
            self.tblView_SocialSites.reloadData()
        }
        
        if array_UserOccupations.count > 0{
            self.CollectionView_Occupation.isHidden = false
            self.lbl_NoOccupationsYet.isHidden = true
            self.CollectionView_Occupation.reloadData()
            
        }
        else{
            self.CollectionView_Occupation.isHidden = true
            self.lbl_NoOccupationsYet.isHidden = false
        }
        
        if array_UserInterests.count > 0{
            self.collectionview_Interests.isHidden = false
            self.lbl_NoInterestsYet.isHidden = true
            self.collectionview_Interests.reloadData()
        }
        else{
            self.collectionview_Interests.isHidden = true
            self.lbl_NoInterestsYet.isHidden = false
        }
        return true
    }
}

extension UserEditProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        //social sites table views
        if tableView == tblView_SocialSites{
            count = array_UserSocialSites.count
        }
        
        if tableView == tblView_UserSocialSites{
            count = array_UserSocialSites.count
        }
        
        if tableView == tblView_ActualSocialSites{
            count =  array_ActualSocialSites.count
        }
        
        //Occupation table views
        if tableView == tblView_UserOccupations{
            count = array_UserOccupations.count
        }
        
        if tableView == tblView_ActualOccupations{
            count =  array_ActualOccupations.count
        }
        //Interests table views
        if tableView == tblView_UserInterests{
            count = array_UserInterests.count
        }
        
        if tableView == tblView_ActualInterests{
            count =  array_ActualInterests.count
        }
        
        //school search table view
        if tableView == tblView_SchoolSearch{
            
            count = self.array_Schools_Company.count
        }
        
        return count!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        //Social sites Table views
        if tableView == tblView_SocialSites{
            
            let socialSites_cell = tableView.dequeueReusableCell(withIdentifier: "socialSites_cell", for: indexPath) as! MainView_UserSocialSitesTableViewCell
            socialSites_cell.imgView_SocialSite.image = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            socialSites_cell.txtField_SocialSiteURL.text = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "url") as? String
            socialSites_cell.txtField_SocialSiteURL.tag = indexPath.row
            cell = socialSites_cell
            
        }
        
        if tableView == tblView_UserSocialSites{
            
            let userSocialSites_cell = tableView.dequeueReusableCell(withIdentifier: "userSocialSites_cell", for: indexPath) as! User_SocialSitesTableViewCell
            userSocialSites_cell.lbl_SocialSiteName.text = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "name") as? String
            userSocialSites_cell.imgView_SocialSite.image = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            cell = userSocialSites_cell
            
            
        }
        
        if tableView == tblView_ActualSocialSites{
            
            let actualSocialSites_cell = tableView.dequeueReusableCell(withIdentifier: "actualSocialSites_cell", for: indexPath) as! Actual_SocialSitesTableViewCell
            actualSocialSites_cell.lbl_SocialSiteName.text = (array_ActualSocialSites[indexPath.row] as NSDictionary).value(forKey: "name") as? String
            actualSocialSites_cell.imgView_SocialSite.image = (array_ActualSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            cell = actualSocialSites_cell
            
        }
        
        //Ocuupations table views
        if tableView == tblView_UserOccupations{
            
            let UserOccupations_cell = tableView.dequeueReusableCell(withIdentifier: "UserOccupations_cell", for: indexPath) as! User_OccupationsTableViewCell
            UserOccupations_cell.lbl_occupationName.text = (array_UserOccupations[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            cell = UserOccupations_cell
            
            
        }
        
        if tableView == tblView_ActualOccupations{
            
            let ActualOccupations_cell = tableView.dequeueReusableCell(withIdentifier: "ActualOccupations_cell", for: indexPath) as! Actual_OccupationsTableViewCell
            if array_ActualOccupations.count > 0{
                ActualOccupations_cell.lbl_occupationName.text = (array_ActualOccupations[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            }
            cell = ActualOccupations_cell
        }
        
        //Interests table views
        if tableView == tblView_UserInterests
        {
            
            let UserInterest_cell = tableView.dequeueReusableCell(withIdentifier: "UserInterest_cell", for: indexPath) as! User_InterestsTableViewCell
            UserInterest_cell.lbl_InterestName.text = (array_UserInterests[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            cell = UserInterest_cell
            
            
        }
        
        if tableView == tblView_ActualInterests{
            
            let ActualInterest_cell = tableView.dequeueReusableCell(withIdentifier: "ActualInterest_cell", for: indexPath) as! Actual_InterestsTableViewCell
            if array_ActualInterests.count > 0{
                ActualInterest_cell.lbl_InterestName.text = (array_ActualInterests[indexPath.row] as! NSDictionary).value(forKey: "name") as? String
            }
            cell = ActualInterest_cell
        }
        
        //School search
        if tableView == tblView_SchoolSearch{
            
            let school_cell = tableView.dequeueReusableCell(withIdentifier: "schoolcell", for: indexPath) as? SearchTableViewCell
            school_cell?.textLabel?.text = (self.array_Schools_Company[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            cell = school_cell!
            
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Socialsites tableviews
        if tableView == tblView_ActualSocialSites{
            if array_UserSocialSites.count < 3{
                
                let value = array_ActualSocialSites[indexPath.row]
                array_ActualSocialSites.remove(at: indexPath.row)
                array_UserSocialSites.insert(value, at: 0)
                tblView_ActualSocialSites.reloadData()
                tblView_UserSocialSites.reloadData()
            }
        }
        else  if tableView == tblView_UserSocialSites{
            
            let value = array_UserSocialSites[indexPath.row]
            array_UserSocialSites.remove(at: indexPath.row)
            array_ActualSocialSites.insert(value , at: 0)
            tblView_ActualSocialSites.reloadData()
            tblView_UserSocialSites.reloadData()
        }
        
        //Occupation tableViews
        if tableView == tblView_ActualOccupations{
            
            
            let value = array_ActualOccupations[indexPath.row]
            array_ActualOccupations.removeObject(at: indexPath.row)
            array_UserOccupations.insert(value, at: 0)
            self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray //data set for search
            tblView_UserOccupations.reloadData()
            tblView_ActualOccupations.reloadData()
            
        }
        else  if tableView == tblView_UserOccupations{
            
            let value = array_UserOccupations[indexPath.row]
            array_UserOccupations.removeObject(at: indexPath.row)
            array_ActualOccupations.insert(value , at: 0)
            self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray  //data set for search
            tblView_UserOccupations.reloadData()
            tblView_ActualOccupations.reloadData()
        }
        
        //Interests tableViews
        if tableView == tblView_ActualInterests{
            
            let value = array_ActualInterests[indexPath.row]
            array_ActualInterests.removeObject(at: indexPath.row)
            array_UserInterests.insert(value, at: 0)
            self.arrsearchActualOccupation = self.array_ActualInterests.mutableCopy() as! NSMutableArray  //data set for search
            tblView_ActualInterests.reloadData()
            tblView_UserInterests.reloadData()
            
        }
        else  if tableView == tblView_UserInterests{
            
            let value = array_UserInterests[indexPath.row]
            array_UserInterests.removeObject(at: indexPath.row)
            array_ActualInterests.insert(value , at: 0)
            self.arrsearchActualOccupation = self.array_ActualInterests.mutableCopy() as! NSMutableArray  //data set for search
            tblView_ActualInterests.reloadData()
            tblView_UserInterests.reloadData()
            
        }
        
        //school search table
        if tableView == tblView_SchoolSearch{
            
            let str = (self.array_Schools_Company[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            
            txtfield_SchoolSearch.text = str
            txtfield_School.text = txtfield_SchoolSearch.text
            self.view_BlurrView.isHidden = true
            self.view_SchoolSearch.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
            self.view.endEditing(true)
        }
    }
}

extension UserEditProfileViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if Global.DeviceType.IS_IPHONE_5 || Global.DeviceType.IS_IPHONE_4_OR_LESS
        {
            if  textField == txtfield_Company {
                
                self.animateTextField(textField: textField, up:true,movementDistance: 100,scrollView: self.scroll_view)  //scroll up when keyboard appears
            }
            else if textField != txtfield_Company && textField != txtfield_Name  {
                
                self.animateTextField(textField: textField, up:true,movementDistance: 180,scrollView: self.scroll_view)
            }
        }
        else{
            
            if  textField != txtfield_Name && textField != txtfield_Company {
                
                self.animateTextField(textField: textField, up:true,movementDistance: 150,scrollView: self.scroll_view)
            }
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        if textField != txtfield_SchoolSearch && textField != txtfield_Name && textField != txtfield_School && textField != txtfield_Company {
//            
//            if textField.text == ""{
//                
//                self.showAlert(Message: "Please fill url.", vc: self)
//            }
//            else{
//                if self.verifyUrl(urlString: textField.text!){
//                    
//                }else{
//                    self.showAlert(Message: "Please fill valid url.", vc: self)
//                    
//                }
//            }
//        }
//    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtfield_Name{
            txtfield_Name.resignFirstResponder()
        }
        else if textField == txtfield_Company{
            txtfield_Company.resignFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == txtfield_Company {
            
            let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            
            if (string.length <= 30) {
                
                return true
            }
            else{
                return false
            }
        }
        
        if textField == txtfield_SchoolSearch{
            
            str_searchText = (txtfield_SchoolSearch.text! as NSString).replacingCharacters(in: range, with: string as String) as NSString
            print(str_searchText!)
            
            if ((self.str_searchText?.length)! > 2 ) {
                if (self.str_searchText?.hasPrefix(" "))! {
                    return false
                }
                self.array_Schools_Company.removeAllObjects()
                
                self.getallSchools()
                return self.str_searchText!.length <= 30
            }
            else{
                self.array_Schools_Company.removeAllObjects()
                DispatchQueue.main.async {
                    
                    self.tblView_SchoolSearch.reloadData()
                }
                return self.str_searchText!.length <= 30
            }
            
        }
        
        //Social sites urls
        let str: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        let index = textField.tag
        switch index {
        case 0:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = str
            array_UserSocialSites[index] = dic
            print(array_UserSocialSites)
            break
            
        case 1:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = str
            array_UserSocialSites[index] = dic
            print(array_UserSocialSites)
            break
            
        case 2:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = str
            array_UserSocialSites[index] = dic
            print(array_UserSocialSites)
            
            break
            
        default:
            break
        }
        
        return true
    }
}

extension UserEditProfileViewController:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lbl_Description_Placeholder.isHidden = true
        if Global.DeviceType.IS_IPHONE_5 || Global.DeviceType.IS_IPHONE_4_OR_LESS{
            self.animateTextView(textView: textView, up: true, movementDistance: 200, scrollView:self.scroll_view)
        }
        else{
            self.animateTextView(textView: textView, up: true, movementDistance: 210, scrollView:self.scroll_view)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtView_Desrciption.text == ""{
            lbl_Description_Placeholder.isHidden = false
        }
        else {
            
            lbl_Description_Placeholder.isHidden = true
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
}

extension UserEditProfileViewController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        
        //search bar occupation
        if searchBar == serachBar_Occupation{
            var txtAfterUpdate = searchBar.text! as NSString
            txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
            
            if(txtAfterUpdate.length == 0) {
//                temp_arrOccupation = NSMutableArray()
//                temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
//                array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
//                self.tblView_ActualOccupations.reloadData()
                
                self.getallOccupation()
               
            }
            else{
                if txtAfterUpdate.length > 2 {
                    
                let predicate = NSPredicate(format: "(name contains[cd] %@)", txtAfterUpdate)
                temp_arrOccupation.removeAllObjects()
                temp_arrOccupation.addObjects(from: self.arrsearchActualOccupation.filtered(using: predicate))
                array_ActualOccupations.removeAllObjects()
                array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
                self.tblView_ActualOccupations.reloadData()
                }
                else {
                    temp_arrOccupation = NSMutableArray()
                    temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
                    array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
                    self.tblView_ActualOccupations.reloadData()

                }
            }
        }
    //search bar Interests
        else {
            
            var txtAfterUpdate = searchBar.text! as NSString
            txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
            
            if(txtAfterUpdate.length == 0) {
//                self.temp_arrOccupation = NSMutableArray()
//                self.temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
//                self.array_ActualInterests = self.temp_arrOccupation.mutableCopy() as! NSMutableArray
//                self.tblView_ActualInterests.reloadData()
                self.getallInterests()
            }
            else {
                if txtAfterUpdate.length > 2 {
                   
                let predicate = NSPredicate(format: "(name contains[cd] %@)", txtAfterUpdate)
                self.temp_arrOccupation.removeAllObjects()
                self.temp_arrOccupation.addObjects(from: self.arrsearchActualOccupation.filtered(using: predicate))
                array_ActualInterests.removeAllObjects()
                array_ActualInterests = temp_arrOccupation.mutableCopy() as! NSMutableArray
                self.tblView_ActualInterests.reloadData()
                }
                
                else{
                    self.temp_arrOccupation = NSMutableArray()
                    self.temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
                    self.array_ActualInterests = self.temp_arrOccupation.mutableCopy() as! NSMutableArray
                    self.tblView_ActualInterests.reloadData()
                }
            }
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar == tblView_ActualOccupations{
            temp_arrOccupation = NSMutableArray()
            temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
            array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
            self.tblView_ActualOccupations.reloadData()
            
        }
        else{
            
            temp_arrOccupation = NSMutableArray()
            temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
            array_ActualInterests = temp_arrOccupation.mutableCopy() as! NSMutableArray
            self.tblView_ActualInterests.reloadData()
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
     
        searchBar.resignFirstResponder()
        
    }

}


