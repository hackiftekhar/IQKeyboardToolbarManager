//
//  IQKeyboardToolbarManager.swift
//  https://github.com/hackiftekhar/IQKeyboardToolbarManager
//  Copyright (c) 2013-24 Iftekhar Qurashi.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import IQTextInputViewNotification
import IQKeyboardCore
import IQKeyboardToolbar

@available(iOSApplicationExtension, unavailable)
@MainActor
@objc public final class IQKeyboardToolbarManager: NSObject {

    private let textInputViewObserver: IQTextInputViewNotification = IQTextInputViewNotification()

    internal var textInputView: UIView? {
        textInputViewObserver.textInputView
    }
    /**
     Returns the default singleton instance.
     */
    @MainActor
    @objc public static let shared: IQKeyboardToolbarManager = .init()

    /**
     Automatic add the IQKeyboardToolbar functionality. Default is YES.
     */
    @objc public var enable: Bool = true {
        didSet {
            reloadInputViews()
            showLog("enable: \(enable ? "Yes" : "NO")")
        }
    }

    @objc public var enableDebugging: Bool = false

    /**
     Configurations related to the toolbar display over the keyboard.
     */
    @objc public let toolbarConfiguration: IQKeyboardToolbarConfiguration = .init()

    // MARK: UISound handling

    /**
     If YES, then it plays inputClick sound on next/previous/done click.
     */
    @objc public var playInputClicks: Bool = true

    /**
     Disable automatic toolbar creation within the scope of disabled toolbar viewControllers classes.
     Within this scope, 'enableAutoToolbar' property is ignored. Class should be kind of UIViewController.
     */
    @objc public var disabledToolbarClasses: [UIViewController.Type] = []

    /**
     Enable automatic toolbar creation within the scope of enabled toolbar viewControllers classes.
     Within this scope, 'enableAutoToolbar' property is ignored. Class should be kind of UIViewController.
     If same Class is added in disabledToolbarClasses list, then enabledToolbarClasses will be ignore.
     */
    @objc public var enabledToolbarClasses: [UIViewController.Type] = []

    /**
     Allowed subclasses of UIView to add all inner textInputView,
     this will allow to navigate between textInputView contains in different superview.
     Class should be kind of UIView.
     */
    @objc public var deepResponderAllowedContainerClasses: [UIView.Type] = []

    internal var logIndentation = 0

    override init() {

        super.init()

        addTextInputViewObserver()

        disabledToolbarClasses.append(UIAlertController.self)
        disabledToolbarClasses.append(UIInputViewController.self)

        deepResponderAllowedContainerClasses.append(UITableView.self)
        deepResponderAllowedContainerClasses.append(UICollectionView.self)
        deepResponderAllowedContainerClasses.append(IQDeepResponderContainerView.self)

        // (Bug ID: #550)
        // Loading IQKeyboardToolbar, IQTitleBarButtonItem, IQBarButtonItem to fix first time keyboard appearance delay
        // If you experience exception breakpoint issue at below line then try these solutions
        // https://stackoverflow.com/questions/27375640/all-exception-break-point-is-stopping-for-no-reason-on-simulator
        DispatchQueue.main.async {
            let textInputView: UIView = UITextField()
            textInputView.iq.addDone(target: nil, action: #selector(self.doneAction(_:)))
            textInputView.iq.addPreviousNextDone(target: nil, previousAction: #selector(self.previousAction(_:)),
                                             nextAction: #selector(self.nextAction(_:)),
                                             doneAction: #selector(self.doneAction(_:)))
        }
    }

    /**    reloadInputViews to reload toolbar buttons enable/disable state on the fly Enhancement ID #434. */
    @objc func reloadInputViews() {

        guard let textInputView = textInputViewObserver.textInputView else { return }
        // If enabled then adding toolbar.
        if privateIsEnableAutoToolbar(of: textInputView) {
            self.addToolbarIfRequired(of: textInputView)
        } else {
            self.removeToolbarIfRequired(of: textInputView)
        }
    }

    private func addTextInputViewObserver() {
        textInputViewObserver.subscribe(identifier: "IQActiveConfiguration",
                                        changeHandler: { [self] info in

            guard info.textInputView.iq.isAlertViewTextField() == false else {
                return
            }

            switch info.event {
            case .beginEditing:
                reloadInputViews()
            case .endEditing:
                removeToolbarIfRequired(of: info.textInputView)
            }
        })
    }
}