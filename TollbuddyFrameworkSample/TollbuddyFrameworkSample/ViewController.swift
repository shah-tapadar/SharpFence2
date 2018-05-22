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
}
