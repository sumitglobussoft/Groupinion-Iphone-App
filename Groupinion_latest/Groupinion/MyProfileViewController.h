//
//  MyProfileViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
#import "MBProgressHUD.h"

@interface MyProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    
    NSMutableData *mData;
    BOOL successData;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSMutableArray *wholeProfileArray;
    
    UITableView *ratingTable;
    
    BOOL fBLogin;
    
    NSString *nickNameOfFB;
    
    NSMutableArray *ratingArray;
    
    //Star Rating Image..
    UIImageView *rateImage;
    
    UIImageView *ratingImageInCell;
    
    NSMutableArray *rateAry;
    
    UIImagePickerController *imagePicker;
    
    UIAlertView *editAlertView;
    
}
@property (nonatomic, strong) NSMutableArray *rateAry;
@property (nonatomic, strong) NSMutableArray *ratingArray;

@property (nonatomic, strong) UITextView *textViewEdit;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UIView *lineBelowRating;
@property (nonatomic, strong) UILabel *ratingLabel;
@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UILabel  *totalCommentLabel;
@property (nonatomic, strong)UILabel *questionAskedLabel;
@end
