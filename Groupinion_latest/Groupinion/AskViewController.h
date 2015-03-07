//
//  AskViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
#import "MySingletonClass.h"
#import "ShareToFacebookViewController.h"
#import "MBProgressHUD.h"

#import <FacebookSDK/FacebookSDK.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <KiipSDK/KiipSDK.h>
@interface AskViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,UIScrollViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>
{
    
    NSMutableArray *subCategoryListArray;
    
    int subCatId;
    NSString *selectedDayOpen;
    
    BOOL imageSelected;
    
    BOOL refresh;
    BOOL multipleChoiceQuestion;
    
    UIButton *categoryButton;
    UIButton *daysOpenBtn;
    
    
    int imageDescriptionCount;
    
    //========================
    
    UIImage *selectedImageFirst;
    UIImage *selectedImageSecond;
    UIImage *selectedImageThird;
    UIImage *selectedImageFourth;
    
    BOOL firstImageSelected;
    BOOL seconfImageSelected;
    BOOL thirdImageSelected;
    BOOL fourthImageSelected;
    
    NSMutableArray *imageArray;
    NSThread *myThread;
    NSCondition *conLock;
    
    int threadCount;
    
    
    NSString *imageNameFirst;
    NSString *imageNameTwo;
    NSString *imageNameThree;
    NSString *imageNameFourth;
    
    NSMutableArray *imageNameArray;
    
    
    
    //-----------------------------
    int markUrgent;
    int quesMode;
    int optionSelected;
    //----------------
    NSString *strCategory;
    NSString *strPoint;
    NSString *strCategoryName;
}

//=============================
@property (nonatomic, strong) UIView *categoryView;
@property (nonatomic, strong) UIView *subCategoryView;
@property (nonatomic, strong) UIView *openDayView;

@property (nonatomic, strong) UIButton *urgentButton;

@property (nonatomic, strong) UITextView *questionTextView;

@property (nonatomic, strong)NSMutableArray *categoryListArray;
@property (nonatomic, strong)NSMutableArray *subCategoryListArray;
@property (nonatomic, strong)NSMutableArray *openDaysArray;

@property (nonatomic, strong)UIButton *uploadPhoto;

@property (nonatomic, strong) UILabel *placeHolderLable;
@property (nonatomic, strong) UILabel *answerPlaceHolderFirst;
@property (nonatomic, strong) UILabel *answerPlaceHolderSecond;
@property (nonatomic, strong) UILabel *answerPlaceHolderThird;
@property (nonatomic, strong) UILabel *answerPlaceHolderFourth;

@property (nonatomic, strong)UIImageView *picImageView;
@property (nonatomic, strong)UIImageView *picImageViewSecond;
@property (nonatomic, strong)UIImageView *picImageViewThird;
@property (nonatomic, strong)UIImageView *picImageViewFourth;

@property (nonatomic, strong) UIButton *uploadButtonSecond;
@property (nonatomic, strong) UIButton *uploadButtonThird;
@property (nonatomic, strong) UIButton *uploadButtonfourth;

@property (nonatomic, strong) UITextView *textViewFirst;
@property (nonatomic, strong) UITextView *textViewSecond;
@property (nonatomic, strong) UITextView *textViewThird;
@property (nonatomic, strong) UITextView *textViewFourth;
@property (nonatomic, strong) UISegmentedControl *segmentcontrol;
//@property UIImagePickerController *imagePickerController;

@property (nonatomic,strong)UIImageView *imageView;

@property UITableView *categoryTable;
@property UITableView *subCategoryTable;
@property UITableView *openDaysTable;
//======================24Oct===========================
@property (nonatomic, strong) UIButton *privacyButton;
@property (nonatomic, strong) UIView *privacyView;
@property (nonatomic, strong) UITableView *privacyTableView;
@property (nonatomic, strong) UIView *optionView;
@property (nonatomic, strong) UITableView *optionTableView;
@property (nonatomic, strong) NSMutableString *frndListString;
@property (nonatomic, strong) UIButton *optionButtn;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@end
