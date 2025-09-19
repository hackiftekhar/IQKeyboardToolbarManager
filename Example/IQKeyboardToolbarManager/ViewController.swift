//
//  ViewController.swift
//  IQKeyboardToolbarManager
//
//  Created by hackiftekhar on 07/23/2024.
//  Copyright (c) 2024 hackiftekhar. All rights reserved.
//

import UIKit
import IQKeyboardToolbarManager

class ViewController: UIViewController {
    
    @IBOutlet weak var textField1: UITextField?
    @IBOutlet weak var textField2: UITextField?
    @IBOutlet weak var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable IQKeyboardToolbarManager
        IQKeyboardToolbarManager.shared.isEnabled = true
        
        // Configure to show placeholder text (this helps demonstrate the iOS 26 fix)
        IQKeyboardToolbarManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = true
        
        #if DEBUG
        // Test the iOS 26 fix in debug builds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print(IQKeyboardToolbarManager.iOS26FixDocumentation)
            print("\nCurrent device needs iOS 26 fix: \(IQKeyboardToolbarManager.needsiOS26Fix)")
        }
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if DEBUG
        // When a text field becomes active, test the toolbar layout
        NotificationCenter.default.addObserver(
            forName: UITextField.textDidBeginEditingNotification,
            object: nil,
            queue: .main
        ) { _ in
            IQKeyboardToolbarManager.shared.testIOS26Fix()
        }
        #endif
    }
}
