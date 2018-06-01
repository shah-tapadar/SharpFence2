//
//  LogsViewController.swift
//  TollbuddyFrameworkSample
//
//  Created by Dhanesh V on 5/18/18.
//  Copyright © 2018 HTA. All rights reserved.
//

import UIKit
import B2B_SDK
import MessageUI

class LogsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let logs = try? String(contentsOf: B2B.logFileURL()) {
            textView.text = logs
        } else {
            textView.text = "No logs found!"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bottom = NSMakeRange(textView.text.count - 1, 1)
        textView.scrollRangeToVisible(bottom)
    }
    
    @IBAction func email(_ sender: Any) {
        
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

extension LogsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
