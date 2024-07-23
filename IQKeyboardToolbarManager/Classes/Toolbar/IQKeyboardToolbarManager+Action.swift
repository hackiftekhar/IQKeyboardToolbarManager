//
//  IQKeyboardToolbarManager+Action.swift
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
import IQKeyboardCore
import IQKeyboardToolbar

// MARK: Previous next button actions
@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardToolbarManager {

    /**
    Returns YES if can navigate to previous responder textInputView, otherwise NO.
    */
    @objc var canGoPrevious: Bool {
        // If it is not first textInputView. then it's previous object canBecomeFirstResponder.
        guard let textInputViews: [UIView] = responderViews(),
              let view: UIView = textInputViewObserver.textInputView,
              let index: Int = textInputViews.firstIndex(of: view),
              index > 0 else {
            return false
        }
        return true
    }

    /**
    Returns YES if can navigate to next responder textInputViews, otherwise NO.
    */
    @objc var canGoNext: Bool {
        // If it is not first textInputView. then it's previous object canBecomeFirstResponder.
        guard let textInputViews: [UIView] = responderViews(),
              let view: UIView = textInputViewObserver.textInputView,
              let index: Int = textInputViews.firstIndex(of: view),
              index < textInputViews.count-1 else {
            return false
        }
        return true
    }

    /**
    Navigate to previous responder textInputViews
    */
    @discardableResult
    @objc func goPrevious() -> Bool {

        // If it is not first textInputView. then it's previous object becomeFirstResponder.
        guard let textInputViews: [UIView] = responderViews(),
              let view: UIView = textInputViewObserver.textInputView,
              let index: Int = textInputViews.firstIndex(of: view),
              index > 0 else {
            return false
        }

        let nextTextInputView: UIView = textInputViews[index-1]

        let isAcceptAsFirstResponder: Bool = nextTextInputView.becomeFirstResponder()

        //  If it refuses then becoming previous textInputView as first responder again.    (Bug ID: #96)
        if !isAcceptAsFirstResponder {
            showLog("Refuses to become first responder: \(nextTextInputView)")
        }

        return isAcceptAsFirstResponder
    }

    /**
    Navigate to next responder textInputView.
    */
    @discardableResult
    @objc func goNext() -> Bool {

        // If it is not first textInputView. then it's previous object becomeFirstResponder.
        guard let textInputViews: [UIView] = responderViews(),
              let view: UIView = textInputViewObserver.textInputView,
              let index: Int = textInputViews.firstIndex(of: view),
              index < textInputViews.count-1 else {
            return false
        }

        let nextTextInputView: UIView = textInputViews[index+1]

        let isAcceptAsFirstResponder: Bool = nextTextInputView.becomeFirstResponder()

        //  If it refuses then becoming previous textInputView as first responder again.    (Bug ID: #96)
        if !isAcceptAsFirstResponder {
            showLog("Refuses to become first responder: \(nextTextInputView)")
        }

        return isAcceptAsFirstResponder
    }
}

internal extension IQKeyboardToolbarManager {

    /**    previousAction. */
    @objc func previousAction(_ barButton: IQBarButtonItem) {

        // If user wants to play input Click sound.
        if playInputClicks {
            // Play Input Click Sound.
            UIDevice.current.playInputClick()
        }

        guard canGoPrevious,
              let textInputView: UIView = textInputViewObserver.textInputView else {
            return
        }

        let isAcceptedAsFirstResponder: Bool = goPrevious()

        if isAcceptedAsFirstResponder {
            Self.sendInvokeAction(of: barButton, sender: textInputView)
        }
    }

    /**    nextAction. */
    @objc func nextAction(_ barButton: IQBarButtonItem) {

        // If user wants to play input Click sound.
        if playInputClicks {
            // Play Input Click Sound.
            UIDevice.current.playInputClick()
        }

        guard canGoNext,
              let textInputView: UIView = textInputViewObserver.textInputView else {
            return
        }

        let isAcceptedAsFirstResponder: Bool = goNext()

        if isAcceptedAsFirstResponder {
            Self.sendInvokeAction(of: barButton, sender: textInputView)
        }
    }

    /**    doneAction. Resigning current textInputView. */
    @objc func doneAction(_ barButton: IQBarButtonItem) {

        // If user wants to play input Click sound.
        if playInputClicks {
            // Play Input Click Sound.
            UIDevice.current.playInputClick()
        }

        guard let textInputView: UIView = textInputViewObserver.textInputView else {
            return
        }

        // Resign textInputView.
        let isResignedFirstResponder: Bool = textInputView.resignFirstResponder()

        if isResignedFirstResponder {
            Self.sendInvokeAction(of: barButton, sender: textInputView)
        }
    }
}

private extension IQKeyboardToolbarManager {
    private static func sendInvokeAction(of barButton: IQBarButtonItem, sender: UIView) {
        var invocation: IQInvocation? = barButton.invocation

        var sender: UIView = sender
        // Handling search bar special case
        if let searchBar: UIView = sender.iq.textFieldSearchBar() {
            invocation = searchBar.iq.toolbar.nextBarButton.invocation
            sender = searchBar
        }

        invocation?.invoke(from: sender)
    }
}
