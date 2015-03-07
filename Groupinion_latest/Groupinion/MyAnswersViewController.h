//
//  MyAnswersViewController.h
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

@interface MyAnswersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnswerQuestionViewControllerDelegate,MBProgressHUDDelegate>
{
    NSMutableData *mData;
    BOOL successData;
    
    BOOL displayAlert;
    
    UIActivityIndicatorView *activityIndicator;
    
    //AnswerTable..
    UITableView *answerTable;
    
    //UImageView..
    UIImageView *imageVote;
    
    //Answer Array
    NSMutableArray *allAnswersArray;
    
    //TableView Cell Labels..
    
    BOOL stopindicator;
    
    
}
@property (nonatomic, strong) NSMutableArray *allAnswersArray;
@end
