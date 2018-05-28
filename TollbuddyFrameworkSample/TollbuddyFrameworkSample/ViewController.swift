//
//  ViewController.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 23/04/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit
import HTA_B2B
import MessageUI

class ViewController: UIViewController {
    
    @IBOutlet weak var changeMonitoringButton: UIButton!
    @IBOutlet weak var monitoringStatusLabel: UILabel!
    var isMonitoring: Bool = false {
        didSet {
            if isViewLoaded {
                updateMonitoringState()
            }
        }
    }
    
    @IBOutlet weak var speedCheckLabel: UILabel!
    @IBOutlet weak var speedCheckSwitch: UISwitch!
    @IBOutlet weak var geofenceQueueLabel: UILabel!
    
    let themeBlueColor = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        B2B.setLoggingLevel(.debug, shouldWriteToFile: true)
        B2B.initializeSDK()
        
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let minSpeed = UserDefaultsWrapper.minSpeedForMonitoring ?? 20
        speedCheckLabel.text = "Speed Check (\(minSpeed) miles/hour)"
        view.setNeedsLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initializeView() {
        updateMonitoringState()
        
        let shouldCheckSpeed = true
        speedCheckSwitch.setOn(shouldCheckSpeed, animated: false)
        B2B.setSpeedCheckEnabled(shouldCheckSpeed)
        
        B2B.geofeneQueueChanged = { [weak self] (queue) in
            self?.geofenceQueueLabel.text = queue
        }
        
        B2B.errorTracker = {(error) in
            switch error {
            case .locationServicesDisabled:
                print("Error : LocationServicesDisabled")
            case .locationServicesDenied:
                print("Error : locationServicesDenied")
            case .locationServicesRestricted:
                print("Error : LocationServicesRestricted")
            case .serviceFailure(let errorMessage):
                print("Error : \(errorMessage)")
            }
        }
    }
    
    func updateMonitoringState() {
        if isMonitoring {
            B2B.startMonitoring()
            changeMonitoringButton.setTitle("Stop Monitoring", for: .normal)
            changeMonitoringButton.backgroundColor = UIColor.red
            monitoringStatusLabel.text = "Location Monitoring is Active"
        } else {
            B2B.stopMonitoring()
            changeMonitoringButton.setTitle("Start Monitoring", for: .normal)
            changeMonitoringButton.backgroundColor = themeBlueColor
            monitoringStatusLabel.text = "Not Monitoring Location Changes"
        }
    }
    
    @IBAction func changeMonitoringState(_ sender: UIButton) {
        isMonitoring = !isMonitoring
    }
    
    @IBAction func speedCheckStatusChanged(_ sender: Any) {
        B2B.setSpeedCheckEnabled(speedCheckSwitch.isOn)
    }

    //MARK:- Retrieve Toll Details
    func retrieveTollDetails() {
        let tollDetailsRequestModel = B2BTollDetailsRequestModel()
        tollDetailsRequestModel.fromDate = dateToString(dateString: "2018-05-16T08:15:30-05:00")
        tollDetailsRequestModel.toDate = dateToString(dateString: "2018-05-18T08:15:30-05:00")
        tollDetailsRequestModel.pageNumber = 2
        tollDetailsRequestModel.pageSize = 5
        B2B.retrieveGeoTollDetails(tollDetailsRequestModel) { (data, error) in
            if let data = data {
                let theJSONText = String(data: data,
                                         encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }
        }
    }
    
    private func dateToString(dateString : String)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.date(from: dateString)
        return dateString
    }
}
