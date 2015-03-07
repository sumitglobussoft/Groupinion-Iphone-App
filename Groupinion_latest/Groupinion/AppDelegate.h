//
//  AppDelegate.h
//  Groupinion
//
//  Created by Sumit Ghosh on 15/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <KiipSDK/KiipSDK.h>
#import "ViewController.h"
#import "GroupViewController.h"
#import "FBIntermediateViewController.h"
#import "QuestionsViewController.h"

@class ViewController;
@class GroupViewController;
@class FBIntermediateViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate, KiipDelegate>
{
    
}

@property (strong, nonatomic) NSUserDefaults *userDefault;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) GroupViewController *groupViewcontroller;
@property (strong, nonatomic) FBIntermediateViewController *fbInter;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
-(void)logoutFlow;
-(void)makeRootViewController;
@end
