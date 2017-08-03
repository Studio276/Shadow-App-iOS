//
//  AppDelegate.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 29/05/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//



import UIKit
import GooglePlaces
import GooglePlacePicker


public var DeviceType:String = "0"
public var DeviceToken:String = "123456"
public var bool_Backntn : Bool = false
public var str_Confirmation:String = ""

public var myCurrentLat : Double?
public var myCurrentLong : Double?



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var locManager = CLLocationManager()
    var currentLocation = CLLocation()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Sleep for splash
        TestFairy.begin("2813e5e8d4b5b274cbdebb5dfc2f013909665937")
        Thread.sleep(forTimeInterval: 3.0)
        
        GMSServices.provideAPIKey("AIzaSyCywl2nqZ6x_NOMRNSGufIF7RKVe-pgj2w")
        GMSPlacesClient.provideAPIKey("AIzaSyCywl2nqZ6x_NOMRNSGufIF7RKVe-pgj2w")
        
        //My current Location
        
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
        }
        
        if SavedPreferences.value(forKey: "userId")as? NSNumber != nil
        {
            DispatchQueue.main.async {
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "TabBar")as! TabbarController
                Global.macros.kAppDelegate.window?.rootViewController = vc
                 vc.selectedIndex = 1
            }
        }
        else
        {
            DispatchQueue.main.async {
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                Global.macros.kAppDelegate.window?.rootViewController = vc
            }
        }
        
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
       // print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        myCurrentLat = locValue.latitude
        myCurrentLong = locValue.longitude
        
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        
//        if LinkedinSwiftHelper.shouldHandle(url) {
//            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

