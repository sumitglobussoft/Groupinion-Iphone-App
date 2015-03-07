//
//  QuestionsViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 15/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
#import "JSON.h"
#import "AnswerQuestionViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "AnswerQuestionViewController.h"

@interface QuestionsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,AnswerQuestionViewControllerDelegate,UIScrollViewDelegate>
{
    
    UITableView *questionTable;
    NSMutableArray *questionList;
    NSMutableArray *subCategoryArray;
    NSMutableArray *subTitleList;
    
    NSString *lastSelectedsubCategoryID;
    
    NSMutableData *mData;
    BOOL successData;
    UIActivityIndicatorView *activityIndicator;
    
    //======================
    NSMutableArray *allFeedArray;
    NSMutableArray *avatarList;
    NSMutableArray *maxvotedImageArray;
    NSMutableArray *categoryListArray;
    int feedCount;
    
    int currentTap;
    BOOL checkScroll;
    NSString *lastCalledUrl;
}
@property (nonatomic, strong) NSMutableArray *maxvotedImageArray;
@property (nonatomic, strong) NSMutableArray *avatarList;
@property (nonatomic, strong) NSMutableArray *categoryListArray;
@property (nonatomic, strong) NSMutableArray *allFeedArray;
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, strong) NSMutableArray *notificationarray;
@property (nonatomic, strong) UITableView *notificationTable;

@property UIButton *moreButton;
@property(nonatomic, strong)UITableView *questionTable;
@property (nonatomic, strong)UITableView *categoryTable;
@property (nonatomic, strong)UITableView *subCategoryTable;

@property (nonatomic, strong) UIButton *greenChatButton;

@property (nonatomic, strong) UIView *categoryView;
@property (nonatomic, strong) UIView *subCategoryView;
//======================New UI ============================
@property (nonatomic, strong) UIImageView *secondHeaderView;
@property (nonatomic, strong) UILabel *indicatorLabel;
@end
