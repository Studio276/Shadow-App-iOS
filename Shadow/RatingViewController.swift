//
//  RatingViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 19/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

var ratingview_name : String?
var ratingview_imgurl : String?
var ratingview_ratingNumber : String = ""



class RatingViewController: UIViewController {
    
    
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
      
    var arr_GetRatingData : NSMutableArray = NSMutableArray()
    
    var imageView1 : UIImageView?
    var imageView2 : UIImageView?
    var imageView3 : UIImageView?
    var imageView4 : UIImageView?
    var imageView5 : UIImageView?
  
    @IBOutlet weak var tblView_Rating: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
  }
    
    func SetRatingView (Number:String) {
         DispatchQueue.main.async {
        switch Number {
            
        case "0":
            self.imageView1?.image = UIImage(named: "StarEmpty")
            self.imageView2?.image = UIImage(named: "StarEmpty")
            self.imageView3?.image = UIImage(named: "StarEmpty")
            self.imageView4?.image = UIImage(named: "StarEmpty")
            self.imageView5?.image = UIImage(named: "StarEmpty")
            
        case "1":
            self.imageView1?.image = UIImage(named: "StarFull")
            self.imageView2?.image = UIImage(named: "StarEmpty")
            self.imageView3?.image = UIImage(named: "StarEmpty")
            self.imageView4?.image = UIImage(named: "StarEmpty")
            self.imageView5?.image = UIImage(named: "StarEmpty")
            
        case "2":
            self.imageView1?.image = UIImage(named: "StarFull")
            self.imageView2?.image = UIImage(named: "StarFull")
            self.imageView3?.image = UIImage(named: "StarEmpty")
            self.imageView4?.image = UIImage(named: "StarEmpty")
            self.imageView5?.image = UIImage(named: "StarEmpty")
            
        case "3":
            self.imageView1?.image = UIImage(named: "StarFull")
            self.imageView2?.image = UIImage(named: "StarFull")
            self.imageView3?.image = UIImage(named: "StarFull")
            self.imageView4?.image = UIImage(named: "StarEmpty")
            self.imageView5?.image = UIImage(named: "StarEmpty")
            
        case "4":
            self.imageView1?.image = UIImage(named: "StarFull")
            self.imageView2?.image = UIImage(named: "StarFull")
            self.imageView3?.image = UIImage(named: "StarFull")
            self.imageView4?.image = UIImage(named: "StarFull")
            self.imageView5?.image = UIImage(named: "StarEmpty")
            
        case "5":
            self.imageView1?.image = UIImage(named: "StarFull")
            self.imageView2?.image = UIImage(named: "StarFull")
            self.imageView3?.image = UIImage(named: "StarFull")
            self.imageView4?.image = UIImage(named: "StarFull")
            self.imageView5?.image = UIImage(named: "StarFull")
            
            
            
        default:
            break
        }
        
        }
        
    }
    
   

    
    func ShowRatingData() {
        
        if self.checkInternetConnection()
        {
            //API To login
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()

            
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
            if bool_UserIdComingFromSearch == true  {
                
                dic.setValue(userIdFromSearch , forKey: "otherUserId")

            }
            else{
                dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: "otherUserId")
            }
            
            print(dic)
            
            ProfileAPI.sharedInstance.RatingList(dict: dic, completion: {(response) in
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
                
                switch status
                {
                case 200:
                    print("success")
                    
                    let arr  = (response.value(forKey: "data") as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                    
                    if arr.value(forKey: "avgRating") != nil {
                        self.SetRatingView(Number: "\(arr.value(forKey: "avgRating")!)")
                        ratingview_ratingNumber = "\(arr.value(forKey: "avgRating")!)"
                        
                        }
                    
                    if (arr.value(forKey: "userRatings") as? NSArray) != nil {
                    
                    self.arr_GetRatingData = (arr.value(forKey: "userRatings") as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    else if (arr.value(forKey: "companyRatings") as? NSArray) != nil {
                        
                        self.arr_GetRatingData = (arr.value(forKey: "companyRatings") as? NSArray)?.mutableCopy() as! NSMutableArray

                    }
                    else if (arr.value(forKey: "schoolRatings") as? NSArray) != nil {
                        
                        self.arr_GetRatingData = (arr.value(forKey: "schoolRatings") as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    else if (arr.value(forKey: "occupationRatings") as? NSArray) != nil {
                        
                        self.arr_GetRatingData = (arr.value(forKey: "occupationRatings") as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                    }
                    
                    //((Response as! NSDictionary).value(forKey: "CommentRepliesData") as? NSArray)?.mutableCopy() as! NSMutableArray
                    print(self.arr_GetRatingData)
                    
                    DispatchQueue.main.async {
                        
                        self.tblView_Rating.reloadData()
                        
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    
                    self.arr_GetRatingData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.tblView_Rating.reloadData()
                        
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
        
        
        
        view_stars.addSubview(imageView1!)
        view_stars.addSubview(imageView2!)
        view_stars.addSubview(imageView3!)
        view_stars.addSubview(imageView4!)
        view_stars.addSubview(imageView5!)
        
        self.navigationItem.titleView = view_stars
        
    }

    
    func PushAddRatingScreen() {
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "addrating") as! AddRatingViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      
        
        DispatchQueue.main.async {
            self.imgView_Profile.layer.cornerRadius = 70.0
            self.imgView_Profile.clipsToBounds = true
            self.imgView_Profile.layer.borderColor = UIColor.init(red: 176.0/255.0, green: 93.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
            self.imgView_Profile.layer.borderWidth = 2.0
        }
        
        
        // Do any additional setup after loading the view.
        if bool_UserIdComingFromSearch == true  {
            
            if  userIdFromSearch != SavedPreferences.value(forKey: Global.macros.kUserId)as? NSNumber {
                
                let btn_addRating = UIButton(type: .custom)
                btn_addRating.setImage(UIImage(named: "add"), for: .normal)
                btn_addRating.frame = CGRect(x: self.view.frame.size.width - 50, y: 0, width: 50, height: 50)
                btn_addRating.addTarget(self, action: #selector(PushAddRatingScreen), for: .touchUpInside)
                let item4 = UIBarButtonItem(customView: btn_addRating)
                self.navigationItem.setRightBarButton(item4, animated: true)
                
                
            }

           
            
        }
        
        
        if ratingview_imgurl != nil {
            self.imgView_Profile.sd_setImage(with: URL(string:ratingview_imgurl!), placeholderImage: UIImage(named: "dummy"))//image
        }
        
        tblView_Rating.tableFooterView = UIView()
        
        CreateNavigationBackBarButton() //Create custom ack button
        custom_StarView ()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        ShowRatingData()
        
        lbl_name.text = ratingview_name
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


//MARK: UITableview methods

extension RatingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_GetRatingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! RatingTableViewCell
        cell.txtView_Comment.text = (arr_GetRatingData[indexPath.row] as! NSDictionary)["comment"] as? String
        
        let dict_Temp = (arr_GetRatingData[indexPath.row] as! NSDictionary)["userDTO"] as? NSDictionary
        
        cell.lbl_name.text = dict_Temp?.value(forKey: "userName") as? String
      

        var profileurl =  dict_Temp?.value(forKey: "profileImageUrl") as? String

        profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if profileurl != nil {
            cell.imgview_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "dummy"))//image
        }
        
        let rating_number = "\((arr_GetRatingData[indexPath.row] as! NSDictionary)["rating"]!)"
        switch rating_number {
            
        case "0":
            cell.imgView_Rating1.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating2.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating3.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "1":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating3.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "2":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "3":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarFull")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "4":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarFull")
            cell.imgView_Rating4.image = UIImage(named: "StarFull")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "5":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarFull")
            cell.imgView_Rating4.image = UIImage(named: "StarFull")
            cell.imgView_Rating5.image = UIImage(named: "StarFull")
            
            
            
        default:
            break
        }

        
        return cell
    }
    
    
}


