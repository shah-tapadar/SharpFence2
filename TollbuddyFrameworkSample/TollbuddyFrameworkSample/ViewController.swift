//
//  ViewController.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 23/04/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit
import TollBuddy_SDK

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
    
    @IBOutlet weak var speedCheckSwitch: UISwitch!
    @IBOutlet weak var geofenceQueueLabel: UILabel!
    
    let themeBlueColor = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        B2B.setLoggingLevel(.debug)
        B2B.initializeSDK()
        
        initializeView()
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
            changeMonitoringButton.setTitle("Stop Monitoring", for: .normal)
            changeMonitoringButton.backgroundColor = UIColor.red
            monitoringStatusLabel.text = "Location Monitoring is Active"
        } else {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        B2B.startMonitoring()

        let jsonText = dataResponse
        var array: [Any]?
        if let data = jsonText.data(using: String.Encoding.utf8) {

            do {
                let peoplesArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [Any]

                array = peoplesArray

            } catch let error as NSError {
                print(error)
            }
        }
        if let dict = array as? [NSDictionary] {
            B2B.startMonitoringFromMaster(arrayDic: dict)
        }
    }
}

let dataResponse = """
[{"GeoFenceMapId":50,"GeoFenceId":50,"GeoFenceName":"Palarivattom-Toll-Fence-North","GeoFenceLocation":{"type":"Point","coordinates":[76.30035510,10.00091154]},"Radius":100,"GeoFenceType":{"GFTypeId":1,"GFTypeName":"Guard"},"GFPatterns":[{"PatternMapId":57,"Pattern":"G50G47G46"},{"PatternMapId":60,"Pattern":"G46G47G50"},{"PatternMapId":61,"Pattern":"G49G47G50"},{"PatternMapId":62,"Pattern":"G50G47G49"},{"PatternMapId":65,"Pattern":"G50G47G48"},{"PatternMapId":66,"Pattern":"G48G47G50"}]},
{"GeoFenceMapId":56,"GeoFenceId":56,"GeoFenceName":"Edachira-Toll-Fence-Plaza","GeoFenceLocation":{"type":"Point","coordinates":[76.36938583,10.01701157]},"Radius":100,"GeoFenceType":{"GFTypeId":2,"GFTypeName":"Plaza"},"GFPatterns":[{"PatternMapId":79,"Pattern":"G57G56G59G60"},{"PatternMapId":80,"Pattern":"G57G56G59"},{"PatternMapId":81,"Pattern":"G57G56G58"},{"PatternMapId":82,"Pattern":"G58G56G59G60"},{"PatternMapId":83,"Pattern":"G58G56G59"},{"PatternMapId":84,"Pattern":"G58G56G57"},{"PatternMapId":85,"Pattern":"G59G56G57"},{"PatternMapId":86,"Pattern":"G59G56G58"},{"PatternMapId":87,"Pattern":"G60G59G56G57"},{"PatternMapId":88,"Pattern":"G60G59G56G58"}]},
{"GeoFenceMapId":57,"GeoFenceId":57,"GeoFenceName":"Edachira-Toll-Fence-South","GeoFenceLocation":{"type":"Point","coordinates":[76.36910688,10.00640385]},"Radius":100,"GeoFenceType":{"GFTypeId":1,"GFTypeName":"Guard"},"GFPatterns":[{"PatternMapId":79,"Pattern":"G57G56G59G60"},{"PatternMapId":80,"Pattern":"G57G56G59"},{"PatternMapId":81,"Pattern":"G57G56G58"},{"PatternMapId":84,"Pattern":"G58G56G57"},{"PatternMapId":85,"Pattern":"G59G56G57"},{"PatternMapId":87,"Pattern":"G60G59G56G57"}]},
{"GeoFenceMapId":58,"GeoFenceId":58,"GeoFenceName":"Edachira-Toll-Fence-East","GeoFenceLocation":{"type":"Point","coordinates":[76.35477316,10.01555355]},"Radius":100,"GeoFenceType":{"GFTypeId":1,"GFTypeName":"Guard"},"GFPatterns":[{"PatternMapId":81,"Pattern":"G57G56G58"},{"PatternMapId":82,"Pattern":"G58G56G59G60"},{"PatternMapId":83,"Pattern":"G58G56G59"},{"PatternMapId":84,"Pattern":"G58G56G57"},{"PatternMapId":86,"Pattern":"G59G56G58"},{"PatternMapId":88,"Pattern":"G60G59G56G58"}]},
{"GeoFenceMapId":59,"GeoFenceId":59,"GeoFenceName":"Edachira-Toll-Fence-North-1","GeoFenceLocation":{"type":"Point","coordinates":[76.37054455,10.0302813]},"Radius":100,"GeoFenceType":{"GFTypeId":1,"GFTypeName":"Guard"},"GFPatterns":[{"PatternMapId":81,"Pattern":"G57G56G58"},{"PatternMapId":82,"Pattern":"G58G56G59G60"},{"PatternMapId":83,"Pattern":"G58G56G59"},{"PatternMapId":84,"Pattern":"G58G56G57"},{"PatternMapId":86,"Pattern":"G59G56G58"},{"PatternMapId":88,"Pattern":"G60G59G56G58"}]},
{"GeoFenceMapId":60,"GeoFenceId":60,"GeoFenceName":"Edachira-Toll-Fence-North-2","GeoFenceLocation":{"type":"Point","coordinates":[76.39470588,10.02753442]},"Radius":100,"GeoFenceType":{"GFTypeId":1,"GFTypeName":"Guard"},"GFPatterns":[{"PatternMapId":79,"Pattern":"G57G56G59G60"},{"PatternMapId":82,"Pattern":"G58G56G59G60"},{"PatternMapId":87,"Pattern":"G60G59G56G57"},{"PatternMapId":88,"Pattern":"G60G59G56G58"}]},
{"GeoFenceMapId":61,"GeoFenceId":61,"GeoFenceName":"Geo-Toll-Fence-Plaza","GeoFenceLocation":{"type":"Point","coordinates":[76.36169313,10.00644764]},"Radius":100,"GeoFenceType":{"GFTypeId":2,"GFTypeName":"Plaza"},"GFPatterns":[{"PatternMapId":89,"Pattern":"G64G63G61G62"},{"PatternMapId":90,"Pattern":"G64G61G62"},{"PatternMapId":91,"Pattern":"G63G61G62"},{"PatternMapId":92,"Pattern":"G62G61G63"},{"PatternMapId":93,"Pattern":"G62G61G64"},{"PatternMapId":94,"Pattern":"G62G61G63G64"}]}
]
"""

