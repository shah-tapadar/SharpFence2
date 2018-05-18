//
//  UIViewController+Custom.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 5/18/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? self
        }
        return self
    }
}
