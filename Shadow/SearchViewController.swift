//
//  SearchViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 26/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

public var bool_AllTypeOfSearches = false
public var bool_CompanySchoolTrends = false
public var bool_LocationFilter = false
 public var ratingType : String?



class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var kleadingCompany: NSLayoutConstraint! //38
    @IBOutlet weak var ktrailingTrends: NSLayoutConstraint!
    
    
    @IBOutlet weak var ktop_Company: NSLayoutConstraint! //252
    @IBOutlet weak var ktop_Location: NSLayoutConstraint!  //253
    @IBOutlet weak var ktop_School: NSLayoutConstraint! //236
    @IBOutlet weak var ktop_Trendy: NSLayoutConstraint!  //247
    
    
    @IBOutlet weak var tbl_ViewAllSearches: UITableView!
    
    //Making secondary Searchbar
    var searchBar = UISearchBar()
    var btn2:UIButton = UIButton()
    var barBtn_Search: UIBarButtonItem?
    var lbl_Search = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSearchBar()
        
        let searchTextField:UITextField = searchBar.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "customsearch")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = imageView
        searchTextField.placeholder = "Search"
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",
                                                               attributes: [NSForegroundColorAttributeName: Global.macros.themeColor])
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.rightView = nil
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //Setting footer view
        self.navigationItem.setHidesBackButton(false, animated:true)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)

       
        
    }
    
    //MARK: Search Bar Appear & Disappear
    
    /**
     showSearchBar is called when the user taps on the search icon.
     */
    
    func showSearchBar() {
        
        searchBar.alpha = 0
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        
        
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.frame = CGRect(x: 40, y: glassIconView.frame.origin.y , width: 16, height: 16)
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            glassIconView.tintColor = UIColor.purple
            
//            lbl_Search.frame = CGRect(x:glassIconView.frame.origin.x + 118, y: textFieldInsideSearchBar.frame.origin.y + 7 , width: 45, height: 30)
//            lbl_Search.text = "Search"
//            lbl_Search.font = lbl_Search.font.withSize(13)
//            lbl_Search.textColor = UIColor.purple
//            searchBar.addSubview(lbl_Search)
            

            
            textFieldInsideSearchBar.layer.borderColor = UIColor.lightGray.cgColor
            textFieldInsideSearchBar.layer.cornerRadius = 6.0
            textFieldInsideSearchBar.layer.borderWidth = 1.0
            
        }
        
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.setImage(UIImage(named:"cross_icon"), for: .normal)
        let item = UIBarButtonItem(customView: btn1)
        btn1.addTarget(self, action: #selector(self.CancelSearch), for: .touchUpInside)
        
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButtonItems(nil, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
        
        self.searchBar.alpha = 1
        
//        UIView.animate(withDuration: 0.5, animations: {
//            self.searchBar.alpha = 1
//
//        }, completion: { finished in
//            self.searchBar.becomeFirstResponder()
//        })
        
    }
    

    func CancelSearch() {

   
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    
        
    }
   
    
    func makeTopNavigationSearchbar()
    {
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.returnKeyType = .done
        
    }
    
    //Adding secondary uibar butttons to navigation bar
    /**
     hideSearchBarAndMakeUIChanges is used to create the top navigation normal after the search work is finished or user cancel the search bar.
     */
    
  /*  func hideSearchBarAndMakeUIChanges ()
    {
        
        //Adding secondary uibarbuttons to the nav bar and revoke its methods
        navigationItem.setRightBarButton(barBtn_Search!, animated: true)
        searchBar.text = ""
        
        barBtn_Search?.image = UIImage.init(named: "search_icon")
        barBtn_Search?.target = self
        barBtn_Search?.action = #selector(self.showSearchBar)
        
        //Creating custom back button
        self.CreateNavigationBackBarButton()
        
        
        //self.array_Global = NSMutableArray.init(array: self.array_temp_VendorList as [AnyObject], copyItems: true)
        //tableView_ServiceProvider.reloadData()
        btn2.setImage(UIImage(named:"search_icon"), for: .normal)
        
        //Adding Title Label
        let navigationTitlelabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 21))
        navigationTitlelabel.center = CGPoint(x: 160, y: 284)
        //navigationTitlelabel.font = UIFont(name: "Muli-Light", size: 16.0)
        navigationTitlelabel.textAlignment = NSTextAlignment.center
        navigationTitlelabel.textColor  = UIColor.white
        //navigationTitlelabel.text = selectedCategory!
        self.navigationController!.navigationBar.topItem!.titleView = navigationTitlelabel
        
    } */

    
    //Action of 4 search buttons
    
    
    @IBAction func Action_SelectCompany(_ sender: Any) {
        
        ratingType = "Company"
        bool_CompanySchoolTrends = true
        self.PushToCustomSearchVC()

    }
    
    
    @IBAction func Action_Location(_ sender: Any) {
        
        bool_LocationFilter = true
        self.PushToCustomSearchVC()

    }
    
    
    @IBAction func Action_School(_ sender: Any) {
        
        ratingType = "School"
        bool_CompanySchoolTrends = true

        self.PushToCustomSearchVC()

    }
    
    
    @IBAction func Action_Trends(_ sender: Any) {
        ratingType = "Trend"
        bool_CompanySchoolTrends = true

        self.PushToCustomSearchVC()

    }
    
     // MARK: - Navigation to Custom search VC
    
    func PushToCustomSearchVC() {
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "customSearch") as! CustomSearchViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension SearchViewController:UISearchBarDelegate{
    
    /**
     searchBarSearchButtonClicked is called when the user taps on the searchbar icon.
     
     :Param: searchBar is the searchbar which is clicked.
     */
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
     
        searchBar.resignFirstResponder()
        
    }
    
    /**
     searchBarTextDidBeginEditing is called when the user taps on the searchbar icon and start typing in the bar.
     :Param: searchBar is the searchbar which is clicked.
     */
    
    
    /**
     searchBarTextDidBeginEditing is called when the user taps on the searchbar icon and start typing in the bar.
     :Param: searchBar is the searchbar which is clicked.
     :range: is the current range of the text.
     :text : is the current letter typed by the user.
     */
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
     
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
//        if self.checkInternetConnection()
//        {
//            offset = NSNumber()
//            //  searchBar.resignFirstResponder()
//            checkSearchOrSimple = true
//            string_Search = searchText
//            self.array_Global.removeAllObjects()
//        }
//        ListOfSavedDrafts()  //To get all top host
        
    }
    /**
     searchBarCancelButtonClicked is called when the user taps on the cancel icon.
     :Param: searchBar is the searchbar which is clicked.
     
     */
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        bool_AllTypeOfSearches = true
       self.PushToCustomSearchVC()
        

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
}
