//
//  MyQuestionViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
#import "AnswerQuestionViewController.h"
#import "MBProgressHUD.h"

@interface MyQuestionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnswerQuestionViewControllerDelegate,MBProgressHUDDelegate>
{
    NSMutableData *mData;
    BOOL successData;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *allQuestionsArray;
    UIImageView *imageVote;
    UITableView *questionTable;
    BOOL displayAlert;
    BOOL stopIndicator;
    
}
@property (nonatomic, strong) NSMutableArray *allQuestionsArray;
@end
