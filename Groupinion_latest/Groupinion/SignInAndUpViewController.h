//
//  SignInAndUpViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 18/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "GroupViewController.h"

#import "ResendVerificationMailViewController.h"


@interface SignInAndUpViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    NSMutableData *mData;
    BOOL successData;
    UIActivityIndicatorView *activityIndicator;
    UIImageView *bannerImage;
    UIImageView *secondBanner;
    
    NSString *opration;
}
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *user_nameTextField;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *createAccountButton;

@end
