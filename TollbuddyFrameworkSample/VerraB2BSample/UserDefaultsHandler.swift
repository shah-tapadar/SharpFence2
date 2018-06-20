//
//  UserDefaultsHandler.swift
//  VerraB2BSample
//
//  Created by Dhanesh V on 5/14/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import CoreLocation

internal enum UserDefaultsWrapper {
    
    static var accuracyLevel: CLLocationAccuracy? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.accuracyLevel)
            UserDefaults.standard.synchronize()
        }
        get {
            return (UserDefaults.standard.value(forKey: UserDefaultsKeys.accuracyLevel) as? CLLocationAccuracy)
        }
    }
    
    static var minSpeedForMonitoring: Double? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.minSpeedForMonitoring)
            UserDefaults.standard.synchronize()
        }
        get {
            return (UserDefaults.standard.value(forKey: UserDefaultsKeys.minSpeedForMonitoring) as? Double)
        }
    }
    
    static var distanceFilter: CLLocationDistance? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.distanceFilter)
            UserDefaults.standard.synchronize()
        }
        get {
            return (UserDefaults.standard.value(forKey: UserDefaultsKeys.distanceFilter) as? CLLocationDistance)
        }
    }
    
    static var headingFilter: CLLocationDegrees? {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.headingFilter)
            UserDefaults.standard.synchronize()
        }
        get {
            return (UserDefaults.standard.value(forKey: UserDefaultsKeys.headingFilter) as? CLLocationDegrees)
        }
    }
}

private enum UserDefaultsKeys {
    static let accuracyLevel = "B2BSample-AccuracyLevel"
    static let minSpeedForMonitoring = "B2BSample-MinSpeedForMonitoring"
    static let distanceFilter = "B2BSample-DistanceFilter"
    static let headingFilter = "B2BSample-HeadingFilter"
    static let authToken = "B2BSample-AuthToken"
    static let tokenId = "B2BSample-TokenId"
}
