//
//  CustomSearchViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 03/07/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class CustomSearchViewController: UIViewController, UIGestureRecognizerDelegate {
     let array = ["1","2","3","4"]
    
    @IBOutlet weak var view_BehindSearchView: UIView!
    @IBOutlet weak var tblview_AllSearchResult: UITableView!
    @IBOutlet weak var view_CollectionView: UIView!
    @IBOutlet weak var customCollectionView: UICollectionView!
    @IBOutlet weak var kHeightTopView: NSLayoutConstraint!
    
    @IBOutlet weak var btn_HorizontalView: UIButton!
    @IBOutlet weak var btn_VerticalView: UIButton!
    var bool_LastResultSearch : Bool = false
    
    //Making secondary Searchbar
    var searchBar = UISearchBar()
    var btn2:UIButton = UIButton()
    var barBtn_Search: UIBarButtonItem?
    var str_searchText: NSString?
    var arr_SearchData : NSMutableArray = NSMutableArray()
    
    var linkForOpenWebsite : String?
    
    var dicUrl: NSMutableDictionary = NSMutableDictionary()
    let array_URL = ["facebookUrl","linkedInUrl","instagramUrl","googlePlusUrl","gitHubUrl","twitterUrl"]

    //For Location
    
    @IBOutlet weak var btn_FilterLocation: UIButton!
    @IBOutlet weak var img_DropDrown: UIImageView!
    
    
    //For Location filter UI
    
    @IBOutlet weak var view_Black: UIView!
    @IBOutlet weak var view_PopUp: UIView!
    @IBOutlet weak var custom_slider: UISlider!
    var str_radiusInMiles : String?
    
    @IBOutlet weak var btn_Apply: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var lbl_Filter: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          showSearchBar()
        let searchTextField:UITextField = searchBar.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "customsearch")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = imageView
        
       searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                   attributes: [NSForegroundColorAttributeName: Global.macros.themeColor])
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.rightView = nil

        tblview_AllSearchResult.tableFooterView = UIView()
        
        str_radiusInMiles = "10000"
        btn_FilterLocation.setTitle("Select distance", for: .normal)

        
     


    }
    
    override func viewWillAppear(_ animated: Bool) {
        bool_UserIdComingFromSearch = false
        dic_DataOfProfileForOtherUser.removeAllObjects()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.tabBarController?.tabBar.isHidden = true
        
        if bool_LocationFilter == true {
            
            btn_FilterLocation.isHidden = false
            img_DropDrown.isHidden = false
            self.GetSearchDataAccordingToLocation()
            
        }
            
        else if  bool_CompanySchoolTrends == true {
            
            btn_FilterLocation.isHidden = true
            img_DropDrown.isHidden = true
            self.GetOnlyCompanyData()
            
        }
            
        else {
            
            btn_FilterLocation.isHidden = true
            img_DropDrown.isHidden = true
             self.getSearchData()
            
        }
        
        
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(handle_Tap(_:))) // Tap gesture to resign keyboard
        //        tap.delegate = self
        //        self.view.addGestureRecognizer(tap)
        
        
        SetButtonCustomAttributes(btn_Cancel)
        SetButtonCustomAttributes(btn_Apply)
        
        
        custom_slider.addTarget(self, action: #selector(adjustLabelForSlider), for: .valueChanged)
        
        tblview_AllSearchResult.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tblview_AllSearchResult.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        bool_LastResultSearch = false
      //  self.dicUrl.removeAllObjects()

    }
    
    
    func adjustLabelForSlider(_ sender: UISlider) {
        
       
//        CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
//        CGRect thumbRect = [self.slider thumbRectForBounds:self.slider.bounds
//            trackRect:trackRect
//            value:self.slider.value];
//        
//        yourLabel.center = CGPointMake(thumbRect.origin.x + self.slider.frame.origin.x,  self.slider.frame.origin.y - 20);
        
        
        let trackRect : CGRect = sender.trackRect(forBounds: sender.bounds)
        let thumbRect : CGRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
        lbl_Filter.center = CGPoint(x: thumbRect.origin.x + sender.frame.origin.x + 5, y: sender.frame.origin.y - 7)
   
        let currentValue = Int(sender.value)
        lbl_Filter.text = "\(currentValue)"
    }
    
    
    
    // MARK: Tap gesture to hide keyboard
    func handle_Tap(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        view_Black.isHidden = true
        view_PopUp.isHidden = true
 
        
    }

    
    /**
     showSearchBar is called when the user taps on the search icon.
     */
    
    func showSearchBar() {
        
        searchBar.frame = CGRect(x: 40, y: self.view_BehindSearchView.frame.origin.y + 10, width: self.view_BehindSearchView.frame.width - 100, height: 50)
        
        let btn_back = UIButton(type: .custom)
        btn_back.frame = CGRect(x: 0, y: 10, width: 50, height: 50)
        btn_back.setImage(UIImage(named:"back-new"), for: .normal)
        _ = UIBarButtonItem(customView: btn_back)
        btn_back.addTarget(self, action: #selector(self.PopView), for: .touchUpInside)
        

        
       // searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()
        searchBar.alpha = 0
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            glassIconView.tintColor = UIColor.purple

           
            
            textFieldInsideSearchBar.layer.borderColor = UIColor.lightGray.cgColor
            textFieldInsideSearchBar.layer.cornerRadius = 6.0
            textFieldInsideSearchBar.layer.borderWidth = 1.0
            
        }
        
        view_BehindSearchView.addSubview(searchBar)
        view_BehindSearchView.addSubview(btn_back)

        self.searchBar.alpha = 1
        
                
    }
    
  
    func PopView() {
        
        _ = self.navigationController?.popViewController(animated: true)
        bool_AllTypeOfSearches = false
        bool_LocationFilter = false
        bool_CompanySchoolTrends = false

    }
    
    
    func CancelSearch() {
        
        
    }
    
    //MARK: Api to search the data
    
    func getSearchData() {
        
        if self.checkInternetConnection()
        {
            //API To login
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
            dic.setValue(str_searchText, forKey: "searchKeyword")
            print(dic)
            
            ProfileAPI.sharedInstance.AllSearchData(dict: dic, completion: {(response) in
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
 
                switch status
                {
                case 200:
                    print("success")
                    
                    self.arr_SearchData = (response.value(forKey: "data") as? NSArray)?.mutableCopy() as! NSMutableArray
                    self.bool_LastResultSearch = true
                    
                    if self.arr_SearchData.count == 0 {
                        self.bool_LastResultSearch = false
                        
                    }
                    print(self.arr_SearchData)
                    
                    DispatchQueue.main.async {
                        
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()

                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    
                    self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()

                    }
                    
                case 401 :
                    
                    self.AlertSessionExpire()

                    
                case 500:
                    
                    
                    self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                default:
                    break
                }
                
                self.clearAllNotice()
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    self.bool_LastResultSearch = false

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
    
    func GetSearchDataAccordingToLocation() {
        
        
        if self.checkInternetConnection()
        {
            //API To login
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
            dic.setValue(str_searchText, forKey: "searchKeyword")
            dic.setValue(str_radiusInMiles, forKey: "radiusInMiles")
            dic.setValue(myCurrentLat, forKey: "latitude")
            dic.setValue(myCurrentLong, forKey: "longitude")
            dic.setValue(0, forKey: "searchType")
            print(dic)
            
            ProfileAPI.sharedInstance.AllSearchDataAsLocation(dict: dic, completion: {(response) in
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
                
                switch status
                {
                case 200:
                    print("success")
                    
                    self.arr_SearchData = (response.value(forKey: "data") as? NSArray)?.mutableCopy() as! NSMutableArray
                    //((Response as! NSDictionary).value(forKey: "CommentRepliesData") as? NSArray)?.mutableCopy() as! NSMutableArray
                    print(self.arr_SearchData)
                    self.bool_LastResultSearch = true

                    if self.arr_SearchData.count == 0 {
                        self.bool_LastResultSearch = false
                        
                    }

                    DispatchQueue.main.async {
                        
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    
                    self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                case 401 :
                    
                    self.AlertSessionExpire()

                    
                case 500:
                    
                    
                    self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }

                    
                default:
                    break
                }
                
                self.clearAllNotice()
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.bool_LastResultSearch = false

                    self.showAlert(Message:(err?.localizedDescription)!, vc: self)
                    
                    
                }
                
                
                
            })
            
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
            
        }
        
        
        
    }
    
    //Api for getting Only company
    
    func GetOnlyCompanyData() {
        
        
        if self.checkInternetConnection()
        {
            //API To login
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
            dic.setValue(ratingType, forKey: "ratingType")
            dic.setValue(str_searchText, forKey: "searchKeyword")
            dic.setValue(0, forKey: "searchType")
            print(dic)
            
            ProfileAPI.sharedInstance.getAllTypeTopRatingListbyType(dict: dic, completion: {(response) in
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
                
                switch status
                {
                case 200:
                    print("success")
                    
                    self.arr_SearchData = (response.value(forKey: "data") as? NSArray)?.mutableCopy() as! NSMutableArray
                    //((Response as! NSDictionary).value(forKey: "CommentRepliesData") as? NSArray)?.mutableCopy() as! NSMutableArray
                    print(self.arr_SearchData)
                    self.bool_LastResultSearch = true
                    
                    if self.arr_SearchData.count == 0 {
                        self.bool_LastResultSearch = false
                        
                    }


                    DispatchQueue.main.async {
                        
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    
                    self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                case 401 :
                    
                    self.AlertSessionExpire()

                    
                case 500:
                    
                    
                    self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false

                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }

                    
                default:
                    break
                }
                
                self.clearAllNotice()
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.bool_LastResultSearch = false

                    self.showAlert(Message:(err?.localizedDescription)!, vc: self)
                    
                    
                }
                
                
                
            })
            
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
            
        }
        
        
        
    }
    
    

    
    //Actions of buttons
    
    @IBAction func Action_ListView(_ sender: UIButton) {
        
        btn_HorizontalView.setImage(UIImage(named: "three-dot-icon"), for: .normal)
        btn_VerticalView.setImage(UIImage(named: "three-horizontal-lines"), for: .normal)
        
        tblview_AllSearchResult.isHidden = false
        view_CollectionView.isHidden = true
         searchBar.isHidden = false
        kHeightTopView.constant = 80
        
        if bool_LocationFilter == true {
            
            btn_FilterLocation.isHidden = false
            img_DropDrown.isHidden = false
            
        }
        else {
            
            btn_FilterLocation.isHidden = true
            img_DropDrown.isHidden = true
            
            
        }

    }
    
    
    @IBAction func Action_HorizontalView(_ sender: Any) {
        
        
        
        if arr_SearchData.count > 0 {
            
            btn_HorizontalView.setImage(UIImage(named:  "purpleDots"), for: .normal)
            btn_VerticalView.setImage(UIImage(named:  "grayHorizontalLines"), for: .normal)

            
        
        tblview_AllSearchResult.isHidden = true
        view_CollectionView.isHidden = false
        searchBar.resignFirstResponder()
//        searchBar.isHidden = true
//        kHeightTopView.constant = 50
        
            
        }
        else {
            
            
            self.showAlert(Message: "No data found.", vc: self)

        }

    }
    
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    
    @IBAction func Action_Messaging(_ sender: UIButton) {
        
        self.showAlert(Message: "Coming Soon", vc: self)

    }
    
    
    
    @IBAction func Action_RequestNotification(_ sender: UIButton) {
        
        self.showAlert(Message: "Coming Soon", vc: self)

    }
    
    @IBAction func Action_Video(_ sender: UIButton) {
        print("atinder")
        
        if video_url != nil {
        
        bool_PlayFromProfile = true
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        else{
            
            
            self.showAlert(Message: "No video to play yet.", vc: self)
 
        }
        
        
    }
    
    @IBAction func Action_OpenSocialSite1(_ sender: UIButton) {
        linkForOpenWebsite = ""
        SetWebViewUrl (index: 0)

        
    }
    
    @IBAction func Action_OpenSocialSite2(_ sender: UIButton) {
        linkForOpenWebsite = ""

        SetWebViewUrl (index: 1)

        
    }
    
    @IBAction func Action_OpenSocialSite3(_ sender: UIButton) {
        linkForOpenWebsite = ""

        
        SetWebViewUrl (index: 2)

    }
    
    
    
    @IBAction func Action_ViewFullProfile(_ sender: UIButton) {
        
        bool_UserIdComingFromSearch = true
        let dict_Temp = (arr_SearchData[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary

        userIdFromSearch = dict_Temp?.value(forKey: "userId") as? NSNumber
        let str_role = dict_Temp?.value(forKey: "role") as? String
        dic_DataOfProfileForOtherUser = NSMutableDictionary()
        dic_DataOfProfileForOtherUser = (arr_SearchData[sender.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary

        
        if str_role == "USER" {
            
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        else {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
        }

    }
    
    
    
    @IBAction func ActionSelectLocationFilter(_ sender: Any) {
        self.view.endEditing(true)

        view_Black.isHidden = false
        view_PopUp.isHidden = false
        
    }
    
    
    
    @IBAction func Action_Slider(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        str_radiusInMiles = "\(currentValue)"
        
    }
    
    
    
    
    @IBAction func Action_FilterLocationApply(_ sender: Any) {
        btn_FilterLocation.setTitle(str_radiusInMiles! + " " + "m", for: .normal)
        view_Black.isHidden = true
        view_PopUp.isHidden = true
        self.view.endEditing(true)

        GetSearchDataAccordingToLocation()

        
//        if (self.searchBar.text?.characters.count)! > 3 {
//        }
        
        
    }
    

    @IBAction func Action_Cancel(_ sender: Any) {
        self.view.endEditing(true)
        view_Black.isHidden = true
        view_PopUp.isHidden = true

        
    }
    
    
    
    @IBAction func Action_DidSelectRow(_ sender: UIButton) {
        
        bool_UserIdComingFromSearch = true
        userIdFromSearch = (arr_SearchData[sender.tag] as! NSDictionary)["userId"]! as? NSNumber
        
        let dict_Temp = (arr_SearchData[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary
        let str_role = dict_Temp?.value(forKey: "role") as? String
        
        dic_DataOfProfileForOtherUser = (arr_SearchData[sender.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        if str_role == "USER" {

        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
      
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
        else {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
    }
    
    
    func SetWebViewUrl (index:Int) {
        
        let tempArray = self.dicUrl.allKeys as! [String]
        
        if tempArray.count > 0{
        
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
        
        }
        
        if linkForOpenWebsite != nil && linkForOpenWebsite != ""{
        if let checkURL = NSURL(string: linkForOpenWebsite!) {
            if  UIApplication.shared.openURL(checkURL as URL){
                print("URL Successfully Opened")
                linkForOpenWebsite = ""
            }
        }
        else {
            
            self.showAlert(Message: "Invalid URL", vc: self)
            
            print("Invalid URL")
        }
        }
        else {
            self.showAlert(Message: "Invalid URL", vc: self)

            print("Invalid URL")
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

//MARK: SEARCHBAR METHODS

extension CustomSearchViewController:UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchBar.resignFirstResponder()
        
    }
    

    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.searchBar.resignFirstResponder()
            return false
            
        }
        str_searchText = (searchBar.text! as NSString).replacingCharacters(in: range, with: text) as NSString
        //print(str_searchText!)
        
        
        if ((self.str_searchText?.length)! > 2 ) {
            if (self.str_searchText?.hasPrefix(" "))! {
                return false
            }
            
            
            if bool_AllTypeOfSearches == true {
                
                if bool_LastResultSearch == false {
                    self.arr_SearchData.removeAllObjects()

                self.getSearchData()
                }
  
            }
            else if bool_LocationFilter == true {
                
                if bool_LastResultSearch == false {
                    self.arr_SearchData.removeAllObjects()

              self.GetSearchDataAccordingToLocation()
                }
            }
            
            else if bool_CompanySchoolTrends == true{
                
                if bool_LastResultSearch == false {
                    self.arr_SearchData.removeAllObjects()

                self.GetOnlyCompanyData()
                }
            }
            
            
            return self.str_searchText!.length <= 30
        }
            else  if ((self.str_searchText?.length)! == 0 ) {
            
             self.arr_SearchData.removeAllObjects()
            
            if bool_AllTypeOfSearches == true {
                
                    self.getSearchData()
                }
            
          else  if bool_LocationFilter == true {
                
                self.GetSearchDataAccordingToLocation()
            }
                
            else if bool_CompanySchoolTrends == true{
                
                self.GetOnlyCompanyData()
            }
                
            else {
                
                DispatchQueue.main.async {
                    
                    self.tblview_AllSearchResult.reloadData()
                    self.customCollectionView.reloadData()
                    
                    
                }
 
                
                
            }
            
            
        }
            else{
            self.arr_SearchData.removeAllObjects()
            DispatchQueue.main.async {
                
                self.tblview_AllSearchResult.reloadData()
                self.customCollectionView.reloadData()
               

            }
           
        }
           return self.str_searchText!.length <= 30
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
   
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchBar.alpha = 1
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
}

//MARK: - CLASS EXTENSIONS
extension CustomSearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arr_SearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Simple", for: indexPath) as! AllSearchesTableViewCell
        
        cell.btn_DidSelectRow.tag = indexPath.row
        
        if bool_LocationFilter == true {
            
            cell.lbl_Time.isHidden = false
            
             if self.arr_SearchData.count > 0 {
                let str_distance = (arr_SearchData[indexPath.row] as! NSDictionary)["distance"] as? NSString
                
                if str_distance == "" || str_distance == nil {
                    cell.lbl_Time.text = "0m"
                }
                else {
                    cell.lbl_Time.text = String(format: "%.02f", str_distance!.floatValue) + "m"
                }
                
            }
  
        }
            
            
        else {
            
            cell.lbl_Time.isHidden = true

        }
        
        
        if self.arr_SearchData.count > 0 {
        cell.lbl_Name.text = (arr_SearchData[indexPath.row] as! NSDictionary)["name"] as? String
            let rating_number = "\((arr_SearchData[indexPath.row] as! NSDictionary)["avgRating"]!)"
            
           
            //print(rating_number)
            
            switch rating_number {
                
            case "0":
                cell.imgStar_One.image = UIImage(named: "StarEmpty")
                cell.imgStar_Two.image = UIImage(named: "StarEmpty")
                cell.imgStar_Three.image = UIImage(named: "StarEmpty")
                cell.imgStar_Four.image = UIImage(named: "StarEmpty")
                cell.imgStar_Five.image = UIImage(named: "StarEmpty")
                
            case "1":
                    cell.imgStar_One.image = UIImage(named: "StarFull")
                    cell.imgStar_Two.image = UIImage(named: "StarEmpty")
                    cell.imgStar_Three.image = UIImage(named: "StarEmpty")
                    cell.imgStar_Four.image = UIImage(named: "StarEmpty")
                    cell.imgStar_Five.image = UIImage(named: "StarEmpty")
                
            case "2":
                cell.imgStar_One.image = UIImage(named: "StarFull")
                cell.imgStar_Two.image = UIImage(named: "StarFull")
                cell.imgStar_Three.image = UIImage(named: "StarEmpty")
                cell.imgStar_Four.image = UIImage(named: "StarEmpty")
                cell.imgStar_Five.image = UIImage(named: "StarEmpty")
                
            case "3":
                cell.imgStar_One.image = UIImage(named: "StarFull")
                cell.imgStar_Two.image = UIImage(named: "StarFull")
                cell.imgStar_Three.image = UIImage(named: "StarFull")
                cell.imgStar_Four.image = UIImage(named: "StarEmpty")
                cell.imgStar_Five.image = UIImage(named: "StarEmpty")
                
            case "4":
                cell.imgStar_One.image = UIImage(named: "StarFull")
                cell.imgStar_Two.image = UIImage(named: "StarFull")
                cell.imgStar_Three.image = UIImage(named: "StarFull")
                cell.imgStar_Four.image = UIImage(named: "StarFull")
                cell.imgStar_Five.image = UIImage(named: "StarEmpty")
     
            case "5":
                cell.imgStar_One.image = UIImage(named: "StarFull")
                cell.imgStar_Two.image = UIImage(named: "StarFull")
                cell.imgStar_Three.image = UIImage(named: "StarFull")
                cell.imgStar_Four.image = UIImage(named: "StarFull")
                cell.imgStar_Five.image = UIImage(named: "StarFull")
     
                
               
            default:
                break
            }
            
            let dict_Temp = (arr_SearchData[indexPath.row] as! NSDictionary)["userDTO"] as? NSDictionary
            var profileurl = dict_Temp?.value(forKey: "profileImageUrl")as? String
            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if profileurl != nil {
                cell.imgView_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummySearch"))//image
            }
       bool_LastResultSearch = false
        }
        return cell
    }
}

//MARK : - COLLECTIONVIEW StarFull
 extension CustomSearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)as! CustomCollectionViewCell

        cell.btn_ViewFullProfile.tag = indexPath.row
        cell.btn_PlayVideo.tag = indexPath.row
        cell.btn_SocialSite1.tag = indexPath.row
        cell.btn_SocialSite2.tag = indexPath.row
        cell.btn_SocialSite3.tag = indexPath.row

        
        if self.arr_SearchData.count > 0 {
            
            self.dicUrl.removeAllObjects()

            cell.lbl_CompanySchoolUserName.text = (arr_SearchData[indexPath.row] as! NSDictionary)["name"] as? String
            let rating_number = "\((arr_SearchData[indexPath.row] as! NSDictionary)["avgRating"]!)"
            //print(rating_number)
            
            switch rating_number {
                
            case "0":
                cell.imgView_Star1.image = UIImage(named: "StarEmpty")
                cell.imgView_Star2.image = UIImage(named: "StarEmpty")
                cell.imgView_Star3.image = UIImage(named: "StarEmpty")
                cell.imgView_Star4.image = UIImage(named: "StarEmpty")
                cell.imgView_Star5.image = UIImage(named: "StarEmpty")
                
            case "1":
                cell.imgView_Star1.image = UIImage(named: "StarFull")
                cell.imgView_Star2.image = UIImage(named: "StarEmpty")
                cell.imgView_Star3.image = UIImage(named: "StarEmpty")
                cell.imgView_Star4.image = UIImage(named: "StarEmpty")
                cell.imgView_Star5.image = UIImage(named: "StarEmpty")
                
            case "2":
                cell.imgView_Star1.image = UIImage(named: "StarFull")
                cell.imgView_Star2.image = UIImage(named: "StarFull")
                cell.imgView_Star3.image = UIImage(named: "StarEmpty")
                cell.imgView_Star4.image = UIImage(named: "StarEmpty")
                cell.imgView_Star5.image = UIImage(named: "StarEmpty")
                
            case "3":
                cell.imgView_Star1.image = UIImage(named: "StarFull")
                cell.imgView_Star2.image = UIImage(named: "StarFull")
                cell.imgView_Star3.image = UIImage(named: "StarFull")
                cell.imgView_Star4.image = UIImage(named: "StarEmpty")
                cell.imgView_Star5.image = UIImage(named: "StarEmpty")
                
            case "4":
                cell.imgView_Star1.image = UIImage(named: "StarFull")
                cell.imgView_Star2.image = UIImage(named: "StarFull")
                cell.imgView_Star3.image = UIImage(named: "StarFull")
                cell.imgView_Star4.image = UIImage(named: "StarFull")
                cell.imgView_Star5.image = UIImage(named: "StarEmpty")
                
            case "5":
                cell.imgView_Star1.image = UIImage(named: "StarFull")
                cell.imgView_Star2.image = UIImage(named: "StarFull")
                cell.imgView_Star3.image = UIImage(named: "StarFull")
                cell.imgView_Star4.image = UIImage(named: "StarFull")
                cell.imgView_Star5.image = UIImage(named: "StarFull")
                
                
                
            default:
                break
            }
            
            let dict_Temp = (arr_SearchData[indexPath.row] as! NSDictionary)["userDTO"] as? NSDictionary
            let str_role = dict_Temp?.value(forKey: "role") as? String
            
            
            let str_video =  dict_Temp?.value(forKey: "videoUrl") as? String
            if str_video != nil {
                video_url = NSURL(string: str_video!) as URL?
            }
            else{
                
                video_url = nil
            }
            
          //  self.dicUrl = NSMutableDictionary()
            

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
                    
                    cell.btn_SocialSite1.isHidden = false
                    cell.btn_SocialSite2.isHidden = true
                    cell.btn_SocialSite3.isHidden = true
                    cell.btn_SocialSite1.setImage(UIImage(named:tempArray[0]), for: UIControlState.normal)
                    cell.btn_SocialSite2.setImage(UIImage(), for: UIControlState.normal)
                    cell.btn_SocialSite3.setImage(UIImage(), for: UIControlState.normal)

                    
                }
                if tempArray.count >= 2 {
                    
                    cell.btn_SocialSite2.isHidden = false
                    cell.btn_SocialSite3.isHidden = true

                    cell.btn_SocialSite2.setImage(UIImage(named:tempArray[1]), for: UIControlState.normal)
                    cell.btn_SocialSite3.setImage(UIImage(), for: UIControlState.normal)
                    
                }
                if tempArray.count == 3  {
                    
                    cell.btn_SocialSite3.isHidden = false
                    cell.btn_SocialSite3.setImage(UIImage(named:tempArray[2] ), for: UIControlState.normal)
                    
                }
                
                
                
                
            }
            else {
                
                cell.btn_SocialSite1.isHidden = true
                cell.btn_SocialSite2.isHidden = true
                cell.btn_SocialSite3.isHidden = true
                cell.btn_SocialSite1.setImage(UIImage(), for: UIControlState.normal)
                cell.btn_SocialSite2.setImage(UIImage(), for: UIControlState.normal)
                cell.btn_SocialSite3.setImage(UIImage(), for: UIControlState.normal)

                
            }

            
            
            if str_role == "USER" {
              
                 cell.kHeight_BehindDetailView.constant = 132
                let companyName =  dict_Temp?.value(forKey: "companyName") as! String
                let schoolName = dict_Temp?.value(forKey: "schoolName") as! String
                if companyName != ""
                {
                    cell.lbl_Location.text = companyName
                }
                else {
                   cell.lbl_Location.text = "NA"
                }
                
                if schoolName != ""
                {
                    cell.lbl_Url.text = schoolName
                }
                else {
                    cell.lbl_Url.text = "NA"
                }
                
            }
            else{
                
                cell.kHeight_BehindDetailView.constant = 183
                  cell.lbl_Count_CompanySchoolWithOccupations.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseUsers") as! NSDictionary)["count"]!)"
                cell.lbl_Count_NumberOfUsers.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary)["count"]!)"
                if dict_Temp?.value(forKey: "location") != nil {
                cell.lbl_Location.text = dict_Temp?.value(forKey: "location") as? String
                }
                
            }
            
            cell.lbl_Count_ShadowersVerified.text = "\((dict_Temp?.value(forKey: "shadowersVerified") as! NSDictionary)["count"]!)"
            cell.lbl_Count_ShadowedByShadowUser.text = "\((dict_Temp?.value(forKey: "shadowedByShadowUser") as! NSDictionary)["count"]!)"
            
            let str_bio = dict_Temp?.value(forKey: "bio") as? String
            
            if str_bio == "" || str_bio == nil {
                cell.txtView_Description.text = "No biography to show..."
            }
            else {
              cell.txtView_Description.text = str_bio
            }
  
            
            //  profileImageUrl
            var profileurl = dict_Temp?.value(forKey: "profileImageUrl")as? String
            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if profileurl != nil {
                cell.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
            }
            bool_LastResultSearch = false

        }
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: UIScreen.main.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_SearchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
}

}


