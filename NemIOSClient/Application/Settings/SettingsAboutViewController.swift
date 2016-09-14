//
//  SettingsAboutViewController.swift
//
//  This file is covered by the LICENSE file in the root of this project.
//  Copyright (c) 2016 NEM
//

import UIKit

class SettingsAboutViewController: UIViewController {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    
    //MARK: - Load Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        
        infoLabel.text = "VERSION".localized() + " " + versionNumber + " " + "BUILD".localized() + " " + buildNumber + "BETA"
        actionButton.setTitle("OK".localized(), for: UIControlState())
        
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - @IBAction
    
    @IBAction func closePopUp(_ sender: AnyObject) {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func okAction(_ sender: AnyObject) {
        closePopUp(self)
    }
}
