//
//  AppDelegate.swift
//  Spotify-Clone
//
//  Created by Ayush Bhatt on 23/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        setUpRootVC()
        
        print(AuthManager.shared.signInURL?.absoluteString)
        
        return true
    }
    
    //MARK:  UI Functions
    
    public func setUpRootVC(){
        if AuthManager.shared.isSignedIn{
            let tabBarVC = TabBarViewController()
            window?.rootViewController = tabBarVC
        }
        else{
            let welcomeVC = WelcomeViewController()
            let welcomeNC = UINavigationController(rootViewController: welcomeVC)
            welcomeNC.navigationBar.prefersLargeTitles = true
            welcomeNC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window?.rootViewController = welcomeNC
        }
    }
}
