//
//  AppDelegate.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 23/04/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit
import UserNotifications
import HTA_B2B

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        registerForPushNotifications()
        
        if let notificationUserInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            processPushedUserInfo(notificationUserInfo, fromAppLaunch: true)
        }

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

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        
        let application = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { (granted, error) in
                    print("Permission granted: \(granted)")
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint("Device Token: \(tokenString)")
        
        B2B.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        //        displayPrompt(title: "Device Token", message: tokenString, acceptTitle: "OK", cancelTitle: nil, accepted: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        debugPrint("Device token registration failed.")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        processPushedUserInfo(userInfo, fromAppLaunch: false)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        processPushedUserInfo(userInfo, fromAppLaunch: false)
    }
    
    func processPushedUserInfo(_ userInfo: [AnyHashable: Any], fromAppLaunch: Bool) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        var message: String = "\(userInfo)"
        if let alert = (userInfo["aps"] as? [AnyHashable: Any])?["alert"] as? String {
            message = alert
        }

        displayPrompt(title: "Push Notification Received", message: message,
            acceptTitle: "OK", cancelTitle: nil,
            accepted: { (accepted) in
        })
    }
    
    func displayPrompt(title: String?, message: String?,
                       acceptTitle: String, cancelTitle: String?,
                       accepted: ((Bool) -> Void)?) {
        
        guard let topVC = window?.rootViewController?.topMostViewController() else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: acceptTitle, style: .default, handler: {
            (action) -> Void in
            alert.dismiss(animated: true, completion: nil)
            accepted?(true)
        })
        alert.addAction(okAction)
        
        if let cancelString = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelString, style: .cancel, handler: {
                (action) -> Void in
                alert.dismiss(animated: true, completion: nil)
                accepted?(false)
            })
            alert.addAction(cancelAction)
        }
        
        DispatchQueue.main.async {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}


