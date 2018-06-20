//
//  B2B+Helper.swift
//  VerraB2BSample
//
//  Created by Seethal on 01/06/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit
import VerraSDK

class B2BHelper {
    static var notifications: [String]?
    private enum NotificationAlertStatus {
        case None
        case Present
        case Dismiss
    }
   static private var alertStatus: NotificationAlertStatus = .None
    
   static func pushNotificationFromB2BSDK(_ userInfo: [AnyHashable : Any]) -> Bool {
        if let alert = B2B.processPushNotification(withUserInfo: userInfo), let message = alert.message {
            if notifications == nil {
                notifications = [String]()
            }
            notifications?.append(message)
            displayPrompt(title: "Push Notification Received",
                          acceptTitle: "OK", cancelTitle: nil,
                          accepted: { (accepted) in
            })
            return true
        } else {
            // Other Push notification
            return false
        }
    }
    
    static fileprivate func multipleAlerts() {
        let count = notifications?.count ?? 0
        if count > 0 {
            displayPrompt(title: "Push Notification Received",
                          acceptTitle: "OK", cancelTitle: nil,
                          accepted: { (accepted) in
            })
        }
    }
    static fileprivate func dismissAction() {
        alertStatus = .Dismiss
        notifications?.remove(at: 0)
        DispatchQueue.main.async {
            self.multipleAlerts()
        }
    }
    
    static fileprivate func displayPrompt(title: String?,
                       acceptTitle: String, cancelTitle: String?,
                       accepted: ((Bool) -> Void)?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let topVC = appDelegate.window?.rootViewController?.topMostViewController()  else {
            return
        }
        if alertStatus == .Present{
            
        } else {
            alertStatus = .Present
            let message = notifications?.first
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: acceptTitle, style: .default, handler: {
                (action) -> Void in
                alertController.dismiss(animated: true, completion: nil)
                accepted?(true)
                self.dismissAction()
            })
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                topVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
