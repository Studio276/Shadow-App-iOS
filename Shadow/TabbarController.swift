//
//  TabbarController.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
            
            // Create Tab one
            let SearchScreen = Global.macros.Storyboard.instantiateViewController(withIdentifier:"nav_search") as! UINavigationController
            let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "search-icon"), selectedImage: UIImage(named: ""))
            SearchScreen.tabBarItem = tabOneBarItem
            
            
            // Create Tab two
            let HomeScreen = Global.macros.Storyboard.instantiateViewController(withIdentifier:"nav_user") as! UINavigationController
            let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "profile-icon"), selectedImage: UIImage(named: ""))
            HomeScreen.tabBarItem = tabTwoBarItem2
            self.viewControllers = [SearchScreen, HomeScreen]
            
        }
            
        else {
            
            // Create Tab one
            let SearchScreen = Global.macros.Storyboard.instantiateViewController(withIdentifier:"nav_search") as! UINavigationController
            let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "search-icon"), selectedImage: UIImage(named: ""))
            SearchScreen.tabBarItem = tabOneBarItem
            
            
            // Create Tab two
            let HomeScreen = Global.macros.Storyboard.instantiateViewController(withIdentifier:"nav_company") as! UINavigationController
            let tabTwoBarItem2 = UITabBarItem(title: "", image: UIImage(named: "profile-icon"), selectedImage: UIImage(named: ""))
            HomeScreen.tabBarItem = tabTwoBarItem2
            self.viewControllers = [SearchScreen, HomeScreen]
            
            
        }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     
        
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("Selected \(viewController.title!)")
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
