//
//  ViewController.m
//  IQKeyboardToolbarManager_ObjcExample
//
//  Created by Iftekhar on 8/8/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

#import "ViewController.h"
#import <IQKeyboardToolbarManager/IQKeyboardToolbarManager-Swift.h>
#import <IQKeyboardToolbar/IQKeyboardToolbar-Swift.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextField *textField = [[UITextField alloc] init];
    textField.iq_ignoreSwitchingByNextPrevious = false;

    IQDeepResponderContainerView *containerView = [[IQDeepResponderContainerView alloc] init];

    IQKeyboardToolbarManager.shared.enable = true;
    IQKeyboardToolbarManager.shared.enableDebugging = true;
    IQKeyboardToolbarManager.shared.toolbarConfiguration.tintColor = UIColor.systemPinkColor;
    IQKeyboardToolbarManager.shared.playInputClicks = true;
    [IQKeyboardToolbarManager.shared reloadInputViews];

    if (IQKeyboardToolbarManager.shared.canGoPrevious) {
        [IQKeyboardToolbarManager.shared goPrevious];
    }

    if (IQKeyboardToolbarManager.shared.canGoNext) {
        [IQKeyboardToolbarManager.shared goNext];
    }

    [IQKeyboardToolbarManager.shared resignFirstResponder];


    NSMutableArray<Class> *disabledToolbarClasses = [IQKeyboardToolbarManager.shared.disabledToolbarClasses mutableCopy];
    [disabledToolbarClasses addObject:ViewController.class];
    IQKeyboardToolbarManager.shared.disabledToolbarClasses = disabledToolbarClasses;

    NSMutableArray<Class> *enabledToolbarClasses = [IQKeyboardToolbarManager.shared.enabledToolbarClasses mutableCopy];
    [enabledToolbarClasses addObject:ViewController.class];
    IQKeyboardToolbarManager.shared.enabledToolbarClasses = enabledToolbarClasses;

    NSMutableArray<Class> *deepResponderAllowedContainerClasses = [IQKeyboardToolbarManager.shared.deepResponderAllowedContainerClasses mutableCopy];
    [deepResponderAllowedContainerClasses addObject:UIStackView.class];
    IQKeyboardToolbarManager.shared.deepResponderAllowedContainerClasses = deepResponderAllowedContainerClasses;
}


@end
