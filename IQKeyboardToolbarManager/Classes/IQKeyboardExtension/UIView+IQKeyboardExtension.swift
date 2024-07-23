//
//  UIView+IQKeyboardExtension.swift
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

@available(iOSApplicationExtension, unavailable)
@MainActor
private struct AssociatedKeys {
    static var ignoreSwitchingByNextPrevious: Int = 0
}

/**
UIView category for managing textInputView
*/
@available(iOSApplicationExtension, unavailable)
@MainActor
public extension IQKeyboardExtension where Base: UIView {

    /**
     If ignoreSwitchingByNextPrevious is true then library will ignore this textInputView
     while moving to other textInputView using keyboard toolbar next previous buttons.
     Default is false
     */
    var ignoreSwitchingByNextPrevious: Bool {
        get {
            if let base = base {
                return objc_getAssociatedObject(base, &AssociatedKeys.ignoreSwitchingByNextPrevious) as? Bool ?? false
            }
            return false
        }
        set(newValue) {
            if let base = base {
                objc_setAssociatedObject(base, &AssociatedKeys.ignoreSwitchingByNextPrevious,
                                         newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

/**
UIView category for managing textInputView
*/
@available(iOSApplicationExtension, unavailable)
@MainActor
internal extension IQKeyboardExtension where Base: UIView {

    /**
    Returns all siblings of the receiver which canBecomeFirstResponder.
    */
    func responderSiblings() -> [UIView] {

        //    Getting all siblings
        guard let siblings: [UIView] = base?.superview?.subviews else { return [] }

        // Array of textInputView.
        var textInputViews: [UIView] = []
        for view in siblings {
            if view == base || !view.iq.ignoreSwitchingByNextPrevious,
               view.iq.canBecomeFirstResponder() {
                textInputViews.append(view)
            }
        }

        return textInputViews
    }

    /**
    Returns all deep subViews of the receiver which canBecomeFirstResponder.
    */
    func deepResponderViews() -> [UIView] {

        guard let subviews: [UIView] = base?.subviews, !subviews.isEmpty else { return [] }

        // Array of textInputViews.
        var textInputViews: [UIView] = []

        for view in subviews {

            if view == base || !view.iq.ignoreSwitchingByNextPrevious,
               view.iq.canBecomeFirstResponder() {
                textInputViews.append(view)
            }
            // Sometimes there are hidden or disabled views and textInputView inside them still recorded,
            // so we added some more validations here (Bug ID: #458)
            // Uncommented else (Bug ID: #625)
            else if view.subviews.count != 0,
                    base?.isUserInteractionEnabled == true,
                    base?.isHidden == false, base?.alpha != 0.0 {
                for deepView in view.iq.deepResponderViews() {
                    textInputViews.append(deepView)
                }
            }
        }

        // subviews are returning in opposite order. Sorting according the frames 'y'.
        return textInputViews.sorted(by: { (view1: UIView, view2: UIView) -> Bool in

            let frame1: CGRect = view1.convert(view1.bounds, to: base)
            let frame2: CGRect = view2.convert(view2.bounds, to: base)

            if frame1.minY != frame2.minY {
                return frame1.minY < frame2.minY
            } else {
                return frame1.minX < frame2.minX
            }
        })
    }

    private func canBecomeFirstResponder() -> Bool {

        var canBecomeFirstResponder: Bool = false

        if base?.conforms(to: (any UITextInput).self) == true {
            //  Setting toolbar to keyboard.
            if let textInputView: UITextView = base as? UITextView {
                canBecomeFirstResponder = textInputView.isEditable
            } else if let textInputView: UITextField = base as? UITextField {
                canBecomeFirstResponder = textInputView.isEnabled
            }
        }

        if canBecomeFirstResponder {
            canBecomeFirstResponder = base?.isUserInteractionEnabled == true &&
            base?.isHidden == false &&
            base?.alpha != 0.0 &&
            !isAlertViewTextField() &&
            textFieldSearchBar() == nil
        }

        return canBecomeFirstResponder
    }
}

// swiftlint:disable unused_setter_value
@available(iOSApplicationExtension, unavailable)
@objc public extension UIView {
    @available(*, unavailable, renamed: "iq.ignoreSwitchingByNextPrevious")
    var ignoreSwitchingByNextPrevious: Bool {
        get { false }
        set { }
    }
}
// swiftlint:enable unused_setter_value
