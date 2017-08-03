//
//  CompanyNameAndLocationVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker


class CompanyNameAndLocationVC: UIViewController,GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet var textfield_Location: UITextField!
    @IBOutlet var textfield_Name: UITextField!
    @IBOutlet var btn_Next: UIButton!
    
    var geocoder:CLGeocoder?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationItem.hidesBackButton = true //Hide default back button
        CreateNavigationBackBarButton() //Create custom ack button
        
        self.SetButtonCustomAttributes(btn_Next)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       

        add_padding(textfield: textfield_Name)
        add_padding(textfield: textfield_Location)
        
        Validation()
        
        textfield_Name.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        textfield_Location.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    func textFieldDidChange(textField:UITextField)
    {
        
        
        if textfield_Name.text != "" && (textfield_Name.text?.characters.count)! >= 6 && textfield_Location.text != "" && (textfield_Location.text?.characters.count)! >= 4
        {
            SetButtonCustomAttributesPurple(btn_Next)
            
        }
        else {
            
            SetButtonCustomAttributes(btn_Next)
            
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func Validation()
    {
        if textfield_Name.text != "" && textfield_Location.text != ""{
            
            btn_Next.isUserInteractionEnabled = true
        }
        else{
            btn_Next.isUserInteractionEnabled = false
        }
    }
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        textfield_Location.text = "\(place.name)"
        latlong(string: textfield_Location.text!)
        dismiss(animated: true, completion: nil)
        
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
    
    func CheckCompanyNameExist() {
        
        
        let dict = NSMutableDictionary()
        dict.setValue(textfield_Name.text, forKey: Global.macros.kcompanyName)
        
        //Loader
        DispatchQueue.main.async {
            self.pleaseWait()
        }
        
        AuthenticationAPI.sharedInstance.CheckAvailabilityOfCampanyname(dict: dict, completion: {(response) in
            
            
            switch response {
                
            case 226:
                self.showAlert(Message: "Company name already exist.", vc: self)
                
            case 404:
                DispatchQueue.main.async
                    {
                      //  username = self.textfield_Name.text!
                        self.CreateAlert()

                }
                
            default:
                break
            }
            DispatchQueue.main.async {
                self.clearAllNotice()
            }
            
        }, errorBlock: {(err) in
            
            self.clearAllNotice()
            self.showAlert(Message: Global.macros.kError, vc: self)
            
            
        })

        
        
    }

    
    
    @IBAction func Action_Next(_ sender: UIButton) {
        
        super.viewWillAppear(true)
        if self.checkInternetConnection()
        {
            if textfield_Name.text != ""  {
                
                  if (textfield_Name.text?.characters.count)! >= 6 {
                
                           if textfield_Location.text != "" {
                                
                        if (textfield_Location.text?.characters.count)! >= 4 {
                            
                            //Check address is valid or not
                            companyName = textfield_Name.text!
                            Location = textfield_Location.text!
                            var string_address:String = String()
                            string_address =  "\(textfield_Location.text!)"
                            if string_address  == ""
                            {
                                self.showAlert(Message: "Please enter your location.", vc: self)
                            }
                            else{
                                
                                DispatchQueue.main.async {
                                    self.clearAllNotice()
                                }
                                CheckCompanyNameExist()
                            //    self.CreateAlert()

                         /*       //To find lat long through address
                                let geocoder = CLGeocoder()
                                geocoder.geocodeAddressString(string_address, completionHandler: {
                                    (placemark,error) -> Void in
                                    
                                    DispatchQueue.main.async {
                                        self.clearAllNotice()
                                    }
                                    if (error != nil ) {
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
                                        //To validate address
                                 
                                    }
                                        
                                    else{
                                        self.showAlert(Message: "Can't find your location.Try again later.", vc: self)
                                    }
                                })  */
                            }

 
                            
                            
                        }
                        else {
                            self.showAlert(Message: "Please enter valid location.", vc: self)
                            
                        }
                    }
                        
                    else {
                        self.showAlert(Message: "Please enter your location.", vc: self)
                        
                    }
                }
                else {
                    self.showAlert(Message: "Please enter valid company name.", vc: self)
                    
                }
            }
            else {
                self.showAlert(Message: "Please enter company name.", vc: self)
            }
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
    }
}



extension CompanyNameAndLocationVC:UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfield_Name
        {
            textfield_Location.becomeFirstResponder()
        }
        else
        {
            textfield_Location.resignFirstResponder()
        }
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
        
       // textField.text?.capitalizeFirstLetter()
        
        if textField == textfield_Name{
            
            let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            
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
            let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            
            if (string.length > 0) {
                if string.hasPrefix(" ") {
                    return false
                }
                
                btn_Next.isUserInteractionEnabled = true
                return string.length <= 60
            }
            else{
                btn_Next.isUserInteractionEnabled = false
                return string.length <= 60
                
            }
            
        }
    }
      
}
