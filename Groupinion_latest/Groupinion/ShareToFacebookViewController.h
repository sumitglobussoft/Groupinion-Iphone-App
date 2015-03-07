//
//  ShareToFacebookViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 05/08/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ShareToFacebookViewController : UIViewController
{
    UIAlertView *myAlert;
}


-(void) firstCallMethod;

@property (nonatomic,strong) UIImage *postImage;
@property (nonatomic, strong) NSString *memeUrlString;
@property (nonatomic, assign) BOOL imageSelected;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *fbPostString;



@property (nonatomic, strong) NSString *fbPostImageUrl;

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UITextView *questionview;
@property (nonatomic, strong) UILabel *dateLable;
@property (nonatomic, strong) UITextView *descriptionTestView;
@property (nonatomic, strong) UIImageView *facebookLogoImageView;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *skipButton;
@end
