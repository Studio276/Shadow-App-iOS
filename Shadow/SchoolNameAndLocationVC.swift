//
//  SchoolNameAndLocationVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker



class SchoolNameAndLocationVC: UIViewController,GMSAutocompleteViewControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet var textfield_Location: UITextField!
    @IBOutlet var textfield_Name: UITextField!
    @IBOutlet var btn_Next: UIButton!
    @IBOutlet weak var view_Black: UIView!
    @IBOutlet weak var view_PopUp: UIView!
    @IBOutlet weak var txtfield_Search: UITextField!
    @IBOutlet weak var tbl_NameOfSchools: UITableView!
    var arr_SearchData : NSMutableArray = NSMutableArray()
    var geocoder:CLGeocoder?
    var str_searchText: NSString?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //    self.navigationItem.hidesBackButton = true //Hide default back button
        CreateNavigationBackBarButton() //Create custom ack button
        self.SetButtonCustomAttributes(btn_Next)
        
        textfield_Name.addTarget(self, action: #selector(self.textFieldDidEndEditing), for: UIControlEvents.editingChanged)
        
     //   textfield_Location.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        //Setting footer view
        tbl_NameOfSchools.tableFooterView = UIView()
        tbl_NameOfSchools.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tbl_NameOfSchools.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handle_Tap(_:))) // Tap gesture to resign keyboard
        tap.delegate = self
        self.view_Black.addGestureRecognizer(tap)

        
    }
    
    
    
    // MARK: Tap gesture to hide keyboard
    func handle_Tap(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        view_Black.isHidden = true
        view_PopUp.isHidden = true
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
     
        if textfield_Name.text != "" && (textfield_Name.text?.characters.count)! >= 6
        {
            SetButtonCustomAttributesPurple(btn_Next)
        }
        else {
            SetButtonCustomAttributes(btn_Next)
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tbl_NameOfSchools.isHidden = true
        GMSServices.provideAPIKey("AIzaSyCywl2nqZ6x_NOMRNSGufIF7RKVe-pgj2w")
        GMSPlacesClient.provideAPIKey("AIzaSyCywl2nqZ6x_NOMRNSGufIF7RKVe-pgj2w")
        add_padding(textfield: textfield_Name)
        add_padding(textfield: textfield_Location)
        Validation()
        
          }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    //MARK: - Functions
    fileprivate func Validation()
    {
        if textfield_Name.text != "" {
            btn_Next.isUserInteractionEnabled = true
        }
        else{
            btn_Next.isUserInteractionEnabled = false
        }
        
    }
    
    
    func getListOfAllSchools() {
        
        if self.checkInternetConnection()
        {
            //API To login
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(str_searchText, forKey: "searchKeyword")
            print(dic)
            
            
            AuthenticationAPI.sharedInstance.AvailableSchools(dict: dic, completion: {(response) in
                
                switch response.0
                {
                case 200:
                 print("success")

                    self.arr_SearchData = ((response.1).value(forKey: "schoolList") as? NSArray)?.mutableCopy() as! NSMutableArray
                  //((Response as! NSDictionary).value(forKey: "CommentRepliesData") as? NSArray)?.mutableCopy() as! NSMutableArray
                    print(self.arr_SearchData)
                    DispatchQueue.main.async {
                    self.tbl_NameOfSchools.isHidden = false
                    self.tbl_NameOfSchools.reloadData()
                        
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                    self.tbl_NameOfSchools.isHidden = true
                    self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    

                    self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.tbl_NameOfSchools.isHidden = true
                        self.tbl_NameOfSchools.reloadData()
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

    /**
     latlong function is used to get list of countries.
     :params: string-string that has the required text.
     :params: dispatchGroup- dispatch group that works until the user write .leave.
     */
    
    func latlong(string:String) {
        
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
                latitude = numLat.stringValue
                let numLong = NSNumber(value: (pl.location?.coordinate.longitude)! as Double)
                longitude = numLong.stringValue
                print("latitude:\(latitude) longitude:\(longitude)")
            }
                
            else{
                self.showAlert(Message: "Can't find your location.Try again later.", vc: self)
            }
        })
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        textfield_Location.text = "\(place.name)"
        latlong(string: textfield_Location.text!)
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
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
    
    //MARK: - Button Actions
    @IBAction func Action_Next(_ sender: UIButton) {
        
        self.view.endEditing(true)
        DispatchQueue.main.async {
            self.pleaseWait()
        }
        
        if textfield_Name.text != "" {
            
            if (textfield_Name.text?.characters.count)! >= 6 {
                
                
                if self.checkInternetConnection()
                {
                    schoolName = textfield_Name.text!
                    Location = textfield_Location.text!
                    
                    
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                    }
                    
                    //To find lat long through address
                    self.CreateAlert()
                }
                else
                {
                    self.clearAllNotice()

                    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                }
 
            }
                
            else {
                self.clearAllNotice()

                self.showAlert(Message: "Please enter valid school name.", vc: self)
                
            }
        }
            
        else {
            
            self.clearAllNotice()

            self.showAlert(Message: "Please enter school name.", vc: self)
            
        }
    }
    
    
    
    @IBAction func Action_DropDown(_ sender: Any) {
        
        self.tbl_NameOfSchools.isHidden = true
        view_Black.isHidden = false
        view_PopUp.isHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension SchoolNameAndLocationVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfield_Name
        {
            textfield_Location.resignFirstResponder()
        }
        else
        {
            textfield_Location.resignFirstResponder()
            
        }
       //Validation()
        return true
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == textfield_Location {
            
            textfield_Location.resignFirstResponder()
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
            
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
     //   textField.text?.capitalizeFirstLetter()
        
        if textField == textfield_Name {
 
        let string: NSString = (textfield_Name.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        if (string.length > 0) {
            if string.hasPrefix(" ") {
                return false
            }
            
            btn_Next.isUserInteractionEnabled = true
            return string.length <= 30
        }
        else{
            btn_Next.isUserInteractionEnabled = false
            return string.length <= 30
            
        }
            }
            
        else {
            
            str_searchText = (txtfield_Search.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            print(str_searchText!)
            
            if ((self.str_searchText?.length)! > 2 ) {
                if (self.str_searchText?.hasPrefix(" "))! {
                    return false
                }
                self.arr_SearchData.removeAllObjects()

                  self.getListOfAllSchools()
                 return self.str_searchText!.length <= 30
            }
            else{
                  self.arr_SearchData.removeAllObjects()
                DispatchQueue.main.async {
                    
                    self.tbl_NameOfSchools.reloadData()
                }
                 return self.str_searchText!.length <= 30
            }
        }
    }
}

extension SchoolNameAndLocationVC : UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return self.arr_SearchData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolcell", for: indexPath)
        cell.textLabel?.text = (self.arr_SearchData[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
             return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let str = (self.arr_SearchData[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
        textfield_Name.text = str
        self.view_Black.isHidden = true
        self.view_PopUp.isHidden = true
        self.view.endEditing(true)
        self.btn_Next.isUserInteractionEnabled = true
      
    }
    
    
    
}

