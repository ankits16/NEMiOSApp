//
//  NavigationController.swift
//
//  This file is covered by the LICENSE file in the root of this project.
//  Copyright (c) 2016 NEM
//

import UIKit

/**
    Creates a navigation controller with the NEM specific
    appearance.
 */
class NavigationController: UINavigationController {

    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateControllerAppearance()
    }
    
    // MARK: - Controller Helper Methods
    
    /// Updates the appearance (coloring, titles) of the controller.
    private func updateControllerAppearance() {
        
        navigationBar.translucent = false
        navigationBar.barTintColor = UIColor(red: 90.0/255.0, green: 179.0/255.0, blue: 232.0/255.0, alpha: 1)
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
    }
}
