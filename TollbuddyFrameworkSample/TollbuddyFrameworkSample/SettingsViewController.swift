//
//  SettingsViewController.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 5/14/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit
import TollBuddy_SDK
import CoreLocation

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var accuracyLevelButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var minSpeedField: UITextField!
    @IBOutlet weak var distanceFilterField: UITextField!
    @IBOutlet weak var headingFilterField: UITextField!
    
    let accuracyLevels = [LocationAccuracyLevel.level1: "Level 1",
                          LocationAccuracyLevel.level2: "Level 2",
                          LocationAccuracyLevel.level3: "Level 3"]
    
    var selectedAccuracyLevel: CLLocationAccuracy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    func initializeView() {
        pickerContainerView.isHidden = true
        if let accuracyLevel = UserDefaultsWrapper.accuracyLevel,
            let levelName = accuracyLevels[accuracyLevel] {
            selectedAccuracyLevel = accuracyLevel
            accuracyLevelButton.setTitle("Accuracy Level: \(levelName)", for: .normal)
        } else {
            accuracyLevelButton.setTitle("Accuracy Level: Default", for: .normal)
        }
        
        if let minSpeed = UserDefaultsWrapper.minSpeedForMonitoring {
            minSpeedField.text = "\(minSpeed)"
        } else {
            minSpeedField.text = ""
        }
        if let distanceFilter = UserDefaultsWrapper.distanceFilter {
            distanceFilterField.text = "\(distanceFilter)"
        } else {
            distanceFilterField.text = ""
        }
        if let headingFilter = UserDefaultsWrapper.headingFilter {
            headingFilterField.text = "\(headingFilter)"
        } else {
            headingFilterField.text = ""
        }
    }
    
    @IBAction func tappedBackground(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func accuracyLevelButtonTapped(_ sender: Any) {
        pickerContainerView.isHidden = false
        contentView.isUserInteractionEnabled = false
    }
    
    @IBAction func save(_ sender: Any) {
        UserDefaultsWrapper.accuracyLevel = selectedAccuracyLevel
        
        if let minSpeedString = minSpeedField.text,
            let minSpeed = Double(minSpeedString) {
            UserDefaultsWrapper.minSpeedForMonitoring = minSpeed
        } else {
            UserDefaultsWrapper.minSpeedForMonitoring = nil
        }
        if let distanceFilterString = distanceFilterField.text,
        let distanceFilter = Double(distanceFilterString) {
            UserDefaultsWrapper.distanceFilter = distanceFilter
        } else {
            UserDefaultsWrapper.distanceFilter = nil
        }
        if let headingFilterString = headingFilterField.text,
        let headingFilter = Double(headingFilterString) {
            UserDefaultsWrapper.headingFilter = headingFilter
        } else {
            UserDefaultsWrapper.headingFilter = nil
        }
        
        B2B.setLocationProperties(distanceFilter: UserDefaultsWrapper.distanceFilter,
                                  headingFilter: UserDefaultsWrapper.headingFilter)
        B2B.setGeofenceLimits(maxDistance: nil, maxCount: nil,
                              minSpeedForMonitoring: UserDefaultsWrapper.minSpeedForMonitoring,
                              bufferRegionBoundary: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickerDoneTapped(_ sender: Any) {
        contentView.isUserInteractionEnabled = true
        pickerContainerView.isHidden = true
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        let levelName = (selectedRow == 0) ? "Default" : "Level \(selectedRow)"
        if let level = accuracyLevels.first(where: { $0.value == levelName }) {
            selectedAccuracyLevel = level.key
        } else {
            selectedAccuracyLevel = nil
        }
        accuracyLevelButton.setTitle("Accuracy Level: \(levelName)", for: .normal)
    }
    
    @IBAction func clearLogs(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "Warning!", message: "Are you sure you want to clear the logs?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            B2B.clearLogs()
            alertVC.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true)
    }
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Default"
        }
        return "Level \(row)"
    }
}
