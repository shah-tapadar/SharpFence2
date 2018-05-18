//
//  ViewController.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 23/04/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit
import TollBuddy_SDK
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
    
    @IBAction func emailLogs(_ sender: Any) {
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([])
        let date = Date()
        mailVC.setSubject("B2B SDK Logs - \(date)")
        if let attachmentData = NSData(contentsOf: B2B.logFileURL()) {
            mailVC.setMessageBody("Please find the B2B SDK logs generated on \(date) attached herewith.", isHTML: false)
            mailVC.addAttachmentData(attachmentData as Data, mimeType: "txt", fileName: "B2B-SDK-Logs - \(date).txt")
        } else {
            mailVC.setMessageBody("No log file could be found. Please verify that logToFile was set to 'true' in B2B setup configuration.", isHTML: false)
        }
        
        present(mailVC, animated: true, completion: nil)
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
