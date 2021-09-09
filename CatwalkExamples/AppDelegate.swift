//
//  AppDelegate.swift
//  CatwalkExamples
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit
import Catwalk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GenieAPI.apiToken = "YOUR_TOKEN"
        Customization.boldFontName = "GreycliffCF-Bold"
        Customization.lightFontName = "GreycliffCF-Light"
        Customization.regularFontName = "GreycliffCF-Regular"
        Customization.italicFontName = "GreycliffCF-RegularOblique"
        Customization.chatScreenBackgroundColor = UIColor.blue
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController()
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
        
        return true
    }

}

