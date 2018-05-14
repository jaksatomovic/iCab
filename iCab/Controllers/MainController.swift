//
//  MainController.swift
//  iCab
//
//  Created by Jaksa Tomovic on 10/05/2018.
//  Copyright © 2018 Jakša Tomović. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainController: UITabBarController {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let mapController = HomeController()
        mapController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "user").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "user").withRenderingMode(.alwaysOriginal))
        mapController.tabBarItem.title = "Home"
        
        
        let historyController = PreviousController()
        let navHistoryController = SwipeNavigationController(rootViewController: historyController)
        navHistoryController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "refresh-ccw").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "refresh-ccw").withRenderingMode(.alwaysOriginal))
        navHistoryController.tabBarItem.title = "History"
        
        
        let settingsController = SettingsController()
        let navSettingsController = SwipeNavigationController(rootViewController: settingsController)
        navSettingsController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "bell").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "bell").withRenderingMode(.alwaysOriginal))
        navSettingsController.tabBarItem.title = "Settings"
        
        
        viewControllers = [mapController, navHistoryController, navSettingsController]
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        tabBar.tintColor = Pallete.palette_main
                
    }
    
    
}
