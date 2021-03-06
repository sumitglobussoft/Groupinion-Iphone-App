//
//  AnswerQuestionViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 17/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import <KiipSDK/KiipSDK.h>
@protocol AnswerQuestionViewControllerDelegate <NSObject>

-(void)stopActivityIndicator;

@end

@interface AnswerQuestionViewController : UIViewController<UITextViewDelegate,UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,MBProgressHUDDelegate>
{
    BOOL voted;
    NSString *nextquesUniqueID;
    NSString *voteValue;
    NSString *question;
    //UIImage *fullImageFirst, *secondImage,*thirdImage,*fourthImage;
    //UIImage *fullImageFirstThumb, *secondImageThumb,*thirdImageThumb,*fourthImageThumb;
    NSMutableArray *commentArray;
    
    
    //CGFloat progressHeight;
    
    UIAlertView *newalertView;
    
    //UIImage *productFullScreenImage;
    
    int startLimit, endLimit;
    
    //int point;
    NSString *strCategory;
    NSString *strPoint;
    NSString *strCategoryName;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong)MBProgressHUD *HUD;

@property (nonatomic, weak) id <AnswerQuestionViewControllerDelegate> ansQuesDelegate;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) UITextView *questionview;
@property (nonatomic, strong) UILabel *questionLable;
@property (nonatomic, strong) UILabel *placeHolderLable;

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UIButton *voteButton;

@property (nonatomic, strong) UITableView *commentTable;
@property (nonatomic, strong) UIButton *reportButton;

@property (nonatomic, assign) BOOL displayNextQues;

@property (nonatomic, strong) UIImageView *followImageView;
//Single Choice Question
//@property (nonatomic, strong) UIProgressView *myProgressView;
@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILongPressGestureRecognizer *proImagelongGesture;

@property (nonatomic, strong) UIButton *yesButton;

@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *enlargeButton;

@property (nonatomic, strong) UILabel *yesPercentageLable;
@property (nonatomic, strong) UILabel *nopercentageLable;
@property (nonatomic, strong) UIImageView *yesnoTickImageView;

//====================================================
//Multiple Choice Question

@property (nonatomic, strong) UIImageView *tickMarkImageView;

@property (nonatomic, strong) UIImageView *multiProductFirst;
@property (nonatomic, strong) UIImageView *multiProductSecond;
@property (nonatomic, strong) UIImageView *multiProductThird;
@property (nonatomic, strong) UIImageView *multiProductFourth;

@property (nonatomic, strong) UILabel *descriptionLableFirst;
@property (nonatomic, strong) UILabel *descriptionLableSecond;
@property (nonatomic, strong) UILabel *descriptionLableThird;
@property (nonatomic, strong) UILabel *descriptionLableFourth;

@property (nonatomic, strong) UILabel *messageLable;

//@property (nonatomic, strong) UIProgressView *multiProgressFirst;
//@property (nonatomic, strong) UIProgressView *multiProgressSecond;
//@property (nonatomic, strong) UIProgressView *multiProgressThird;
//@property (nonatomic, strong) UIProgressView *multiProgressFourth;
//@property (nonatomic, strong) UIProgressView *emptyProgressBar;

@property (nonatomic, strong) UITapGestureRecognizer *firstGesture;
@property (nonatomic, strong) UITapGestureRecognizer *secondGesture;
@property (nonatomic, strong) UITapGestureRecognizer *thirdGesture;
@property (nonatomic, strong) UITapGestureRecognizer *fourthGesture;

@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureFirst;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureSecond;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureThird;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureFourth;


@property (nonatomic,strong) UIImageView *fullSizeImage;

@property (nonatomic, strong) UIImageView *fullSizeImageFirst;
@property (nonatomic, strong) UIImageView *fullSizeImageSecond;
@property (nonatomic, strong) UIImageView *fullSizeImageThird;
@property (nonatomic, strong) UIImageView *fullSizeImageFourth;


@property (nonatomic, strong) UIView *productViewFirst;
@property (nonatomic, strong) UIView *productViewSecond;
@property (nonatomic, strong) UIView *productViewThird;
@property (nonatomic, strong) UIView *productViewFourth;

@property (nonatomic, strong) UILabel *votePercentageLableFirst;
@property (nonatomic, strong) UILabel *votePercentageLableSecond;
@property (nonatomic, strong) UILabel *votePercentageLableThird;
@property (nonatomic, strong) UILabel *votePercentageLableFourth;




@end
