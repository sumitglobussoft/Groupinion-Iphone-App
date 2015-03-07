//
//  AskViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "AskViewController.h"
#import "MySingletonClass.h"
#import "JSON.h"
#import "SendHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "FriendsPickerViewController.h"
#import "WebImageSearchViewController.h"


@interface AskViewController () <FriendPickerDelegate, WebImageSearchViewControllerDelegate>{
    
    
    UIImagePickerController *imagePicker;
}
@property(nonatomic, strong)MBProgressHUD *HUD;
//Defining ScroolView..
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *subCategoryLabel;
@property (nonatomic, strong) UILabel *openDaysLabel;
@property (nonatomic, strong) UIButton *makeMultiChoiceButton;
//Creation of toogleBackButton
@property (nonatomic, strong) UIButton *toogleBackButton;

//Creation of SubmitQuestion Button..
@property (nonatomic, strong) UIButton *submitQuesButton;

@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) FriendsPickerViewController *friendPicker;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation AskViewController
@synthesize subCategoryListArray,HUD,imagePicker;

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    
    self.privacyView.hidden=YES;
    self.openDayView.hidden=YES;
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    [self.questionTextView resignFirstResponder];
    [self.textViewFirst resignFirstResponder];
    [self.textViewSecond resignFirstResponder];
    [self.textViewThird resignFirstResponder];
    [self.textViewFourth resignFirstResponder];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == [self view] || touch.view == self.scrollView) {
        return YES;
    }
    return NO;
}
//Hide Sub Views
-(void)hideView{
    
    self.privacyView.hidden=YES;
    self.openDayView.hidden=YES;
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    [self.questionTextView resignFirstResponder];
    [self.textViewFirst resignFirstResponder];
    [self.textViewSecond resignFirstResponder];
    [self.textViewThird resignFirstResponder];
    [self.textViewFourth resignFirstResponder];
}
/*
//Refresh Page
 "makeyesnoQuestion" notification handler 
  refresh AskView and display "Yes No Question view"
*/
-(void)makeYesNoQuestionOnTab{
    
    [HUD hide:YES];
    markUrgent = 0;
    [self.urgentButton setBackgroundImage:[UIImage imageNamed:@"mark_urgent_new.png"] forState:UIControlStateNormal];
    quesMode=1;
    self.optionButtn.hidden=YES;
    self.optionView.hidden=YES;
    optionSelected=0;
    [self.segmentcontrol setImage:[UIImage imageNamed:@"yn_green_new.png"] forSegmentAtIndex:0];
    [self.segmentcontrol setImage:[UIImage imageNamed:@"mc_gray_new.png"] forSegmentAtIndex:1];
    [self.segmentcontrol setSelectedSegmentIndex:0];
    multipleChoiceQuestion=NO;
    
    self.scrollView.contentSize=CGSizeMake(320, 550);
    self.scrollView.frame=CGRectMake(0, 52, self.view.bounds.size.width, 400) ;
    self.scrollView.scrollsToTop=YES;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //self.scrollView.scrollEnabled=NO;
    
    multipleChoiceQuestion=NO;
    
    self.toogleBackButton.hidden=YES;
    self.makeMultiChoiceButton.frame=CGRectMake(165, 140, 145, 70);
    self.uploadPhoto.frame=CGRectMake(10, 175, 145, 70);
    self.makeMultiChoiceButton.hidden=NO;
    self.uploadPhoto.hidden=NO;
    self.uploadButtonSecond.hidden=YES;
    self.uploadButtonThird.hidden=YES;
    self.uploadButtonfourth.hidden=YES;
    self.textViewFirst.hidden=YES;
    self.textViewSecond.hidden=YES;
    self.textViewThird.hidden=YES;
    self.textViewFourth.hidden=YES;
    self.submitQuesButton.hidden=NO;
    self.submitQuesButton.frame=CGRectMake(10, 260, 300, 40);
    
    firstImageSelected=NO;
    seconfImageSelected=NO;
    thirdImageSelected=NO;
    fourthImageSelected=NO;
    imageDescriptionCount=0;
    
    selectedImageFirst=nil;
    selectedImageSecond=nil;
    selectedImageThird=nil;
    selectedImageFourth=nil;
    
    self.subCategoryView.hidden=YES;
    self.categoryView.hidden=YES;
    self.openDayView.hidden=YES;
    self.privacyView.hidden=YES;
    
    self.openDaysLabel.text=@"";
    self.subCategoryLabel.text=@"";
    self.questionTextView.text=@"";
    quesMode = 1;
    self.frndListString = (NSMutableString *)@"";
    
    self.placeHolderLable.hidden=NO;
    self.picImageView.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    self.picImageViewSecond.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    self.picImageViewThird.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    self.picImageViewFourth.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    self.subCategoryLabel.hidden=YES;
    self.openDaysLabel.hidden = YES;
    
    self.textViewFirst.text=@"";
    self.textViewSecond.text=@"";
    self.textViewThird.text=@"";
    self.textViewFourth.text=@"";
    
    self.answerPlaceHolderFirst.hidden=NO;
    self.answerPlaceHolderSecond.hidden=NO;
    self.answerPlaceHolderThird.hidden=NO;
    self.answerPlaceHolderFourth.hidden=NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    quesMode=1;
    self.frndListString = (NSMutableString *)@"";
    refresh=YES;
    imageSelected = NO;
    multipleChoiceQuestion=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeYesNoQuestionOnTab) name:@"makeyesnoQuestion" object:nil];
    //============================================
    //Implementing UIScrollView....
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 52, self.view.bounds.size.width, 400)];
    self.scrollView.delegate=self;
    self.scrollView.contentSize=CGSizeMake(320, 550);
    
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
    tap.delegate=self;
    tap.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tap];
    //===========================================
    //Add Banner Image(Ask Question)
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"Ask-question_hedder_btn.png"];
    [self.view addSubview:bannerImage];
    //==========================================
    // Add Stting Button
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(260, 8, 50, 35);
    
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingBtn];
    //===============================================
    
    //Add Category Button
    
    categoryButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    categoryButton.frame=CGRectMake(10, 10, 145, 30);
    categoryButton.layer.borderWidth=1.0f;
    categoryButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryButton.clipsToBounds=YES;
    categoryButton.layer.cornerRadius=5.0f;
    [categoryButton setBackgroundImage:[UIImage imageNamed:@"Choose_Category.png"] forState:UIControlStateNormal];
    [categoryButton addTarget:self action:@selector(categoryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:categoryButton];
    //================================================
    //After Clicking on subCategory....
    
    self.subCategoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 3, 115, 25)];
    self.subCategoryLabel.backgroundColor=[UIColor whiteColor];
    //self.subCategoryLabel.text=@"Choose Category";
    self.subCategoryLabel.textColor = [UIColor lightGrayColor];
    self.subCategoryLabel.adjustsFontSizeToFitWidth=YES;
    self.subCategoryLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [categoryButton addSubview:self.subCategoryLabel];
    self.subCategoryLabel.hidden=YES;
    
    
    //========================================================
    //Add Days Open Button
    
    daysOpenBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    daysOpenBtn.frame=CGRectMake(165, 10, 145, 30);
    daysOpenBtn.layer.borderWidth=1.0f;
    daysOpenBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    daysOpenBtn.clipsToBounds=YES;
    daysOpenBtn.layer.cornerRadius=5.0f;
    [daysOpenBtn setBackgroundImage:[UIImage imageNamed:@"days_open.png"] forState:UIControlStateNormal];
    [daysOpenBtn addTarget:self action:@selector(daysOpenButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:daysOpenBtn];
    
    
    self.openDaysLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 3, 110, 25)];
    self.openDaysLabel.backgroundColor=[UIColor whiteColor];
    self.openDaysLabel.adjustsFontSizeToFitWidth=YES;
    self.openDaysLabel.textColor = [UIColor lightGrayColor];
    self.openDaysLabel.font=[UIFont fontWithName:@"Arial" size:12];
    [daysOpenBtn addSubview:self.openDaysLabel];
    self.openDaysLabel.hidden=YES;
    
    
    //==================================================
    self.questionTextView=[[UITextView alloc]initWithFrame:CGRectMake(10, 50, 300, 70)];
    //questionTextView.text=@"Ask your question here";
    self.questionTextView.layer.borderWidth=1.0;
    self.questionTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.questionTextView.layer.cornerRadius=5.0;
    self.questionTextView.clipsToBounds=YES;
    self.questionTextView.delegate=self;
    self.questionTextView.textColor = [UIColor blackColor];
    self.questionTextView.editable=YES;
    
    self.questionTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.questionTextView.keyboardType = UIKeyboardTypeDefault;
    [self.scrollView addSubview:self.questionTextView];
    
    self.placeHolderLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    self.placeHolderLable.backgroundColor=[UIColor clearColor];
    self.placeHolderLable.adjustsFontSizeToFitWidth=YES;
    self.placeHolderLable.font=[UIFont fontWithName:@"Arial" size:12];
    self.placeHolderLable.alpha=0.4;
    self.placeHolderLable.textColor = [UIColor blackColor];
    self.placeHolderLable.text = @"Ask your question here";
    [self.questionTextView addSubview:self.placeHolderLable];
    
    //=============================================
    // Add Upload Photo Button
    
    self.uploadPhoto=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.uploadPhoto.frame=CGRectMake(10, 175, 145, 70);
    self.uploadPhoto.layer.borderWidth=1.0f;
    self.uploadPhoto.tag=1;
    self.uploadPhoto.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.uploadPhoto.clipsToBounds=YES;
    self.uploadPhoto.layer.cornerRadius=5.0f;
    [self.uploadPhoto setBackgroundImage:[UIImage imageNamed:@"upload_photos.png"] forState:UIControlStateNormal];
    [self.uploadPhoto addTarget:self action:@selector(uploadPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.uploadPhoto];
    
    //=========================================
    
    self.picImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 65, 68)];
    self.picImageView.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    [self.uploadPhoto addSubview:self.picImageView];
    //================================================
    self.segmentcontrol = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:[UIImage imageNamed:@"yn_green_new.png"],[UIImage imageNamed:@"mc_gray_new.png"], nil] ];
    self.segmentcontrol.backgroundColor = [UIColor clearColor];
    self.segmentcontrol.segmentedControlStyle=UISegmentedControlStyleBar;
    self.segmentcontrol.frame = CGRectMake(10, 130, 145, 34);
    [self.segmentcontrol setWidth:70 forSegmentAtIndex:0];
    [self.segmentcontrol setWidth:73 forSegmentAtIndex:1];
    self.segmentcontrol.tintColor=[UIColor clearColor];
    [self.segmentcontrol addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.segmentcontrol.selectedSegmentIndex=0;
    [self.scrollView addSubview:self.segmentcontrol];
    
    //=========================================
    // Add Upload Photo Button
    
    self.submitQuesButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.submitQuesButton.frame=CGRectMake(10, 260, 300, 40);
    self.submitQuesButton.layer.borderWidth=1.0f;
    self.submitQuesButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.submitQuesButton.clipsToBounds=YES;
    self.submitQuesButton.layer.cornerRadius=5.0f;
    [self.submitQuesButton setBackgroundImage:[UIImage imageNamed:@"Submit_question_btn.png"] forState:UIControlStateNormal];
    [self.submitQuesButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.submitQuesButton];
    
    //====================24Oct ===============================
    self.privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.privacyButton.frame = CGRectMake(165, 130, 145, 34);
    [self.privacyButton setBackgroundImage:[UIImage imageNamed:@"choose_privacy_new.png"] forState:UIControlStateNormal];
    [self.privacyButton addTarget:self action:@selector(privacyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.privacyButton];
    
    //--------------------------------------------------
    markUrgent = 0;
    self.urgentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.urgentButton.frame = CGRectMake(165, 175, 145, 34);
    [self.urgentButton setBackgroundImage:[UIImage imageNamed:@"mark_urgent_new.png"] forState:UIControlStateNormal];
    [self.urgentButton addTarget:self action:@selector(markUrgentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.urgentButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
//Yes/No and Multiple Choice toggle action
-(IBAction)segmentedControlIndexChanged:(id)sender{
    
    switch (self.segmentcontrol.selectedSegmentIndex) {
        case 0:
            //Display Yes/No Question
            [self.segmentcontrol setImage:[UIImage imageNamed:@"yn_green_new.png"] forSegmentAtIndex:0];
            [self.segmentcontrol setImage:[UIImage imageNamed:@"mc_gray_new.png"] forSegmentAtIndex:1];
            [self toogleBackButtonClicked];
            NSLog(@"Button index 0 Clicked");
            break;
        case 1:
            //Display mutliple Choice question
            [self.segmentcontrol setImage:[UIImage imageNamed:@"yn_new.png"] forSegmentAtIndex:0];
            [self.segmentcontrol setImage:[UIImage imageNamed:@"mc_new.png"] forSegmentAtIndex:1];
            [self newMakeMultipleChoiceButtonClicked:nil];
            NSLog(@"Button index 1 Clicked");
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark Mark Urgent Button Clicked
//Urgent Button Action
-(void) markUrgentButtonAction: (id)sender{
    /*
     markUrgent = 0 menans not urgent
                =1 means urgent question
     */
    if (markUrgent == 0) {
        markUrgent = 1;
        [self.urgentButton setBackgroundImage:[UIImage imageNamed:@"mark_urgent_select_new.png"] forState:UIControlStateNormal];
    }
    else{
        markUrgent = 0;
        [self.urgentButton setBackgroundImage:[UIImage imageNamed:@"mark_urgent_new.png"] forState:UIControlStateNormal];
    }
    //NSLog(@"Class Name == %@",[self class]);
}
#pragma mark -
#pragma mark Button Action methods
//Setting Button Actiion
//Display Settting View Controller
-(void)settingButtonClicked{
    NSLog(@"Setting Button Clicked");
    
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    self.openDayView.hidden=YES;
    self.privacyView.hidden=YES;
    [self.questionTextView resignFirstResponder];
    [self.textViewFirst resignFirstResponder];
    [self.textViewSecond resignFirstResponder];
    [self.textViewThird resignFirstResponder];
    [self.textViewFourth resignFirstResponder];
    
    SettingViewController *setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:setting animated:YES];
}

//Category Button Action
-(void)categoryButtonAction{
    NSLog(@"Category Button Clicked");
    
    self.subCategoryView.hidden=YES;
    self.openDayView.hidden=YES;
    self.privacyView.hidden=YES;
    
    //Check Categories already fetched or not
    if([self.categoryListArray count]<=0){
        //category not fetched
        //Fetch list of category from server
        self.categoryListArray=[[NSMutableArray alloc]init];
        NSString *urlString=@"http://beta.groupinion.com/android/categories/";
        
        NSString *response=[self fetchAllCategories:urlString];
        //Check response status
        if([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            
            // NSArray *ary=[response JSONValue];
            NSDictionary *dict11 = [response JSONValue];
            NSString *msg = [dict11 objectForKey:@"Message"];
            
            [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            
            NSArray *jsonArray=[response JSONValue];
            
            for (int i=0; i<[jsonArray count]; i++) {
                NSDictionary *dict=[jsonArray objectAtIndex:i];
                [self.categoryListArray addObject:dict];
                NSLog(@"category==%@",[dict objectForKey:@"Category"]);
                //[MySingletonClass sharedSingleton].categoryListArray = categoryListArray;
            }
            
            NSLog(@"category list==%@",self.categoryListArray);
            NSLog(@"catrgory cout==%lu",(unsigned long)[self.categoryListArray count]);
            //Display Category table
            [self tableviewDisplayCatagories];
        }
        
        
    }
    else{
        [self tableviewDisplayCatagories];
    }
    
}
//Display Category option in form of table view
-(void)tableviewDisplayCatagories
{
    //Prepare UI for display Category option
    if(!self.categoryView){
        //initilize Category View
        self.categoryView=[[UIView alloc]initWithFrame:CGRectMake(10, 37, 300, 320)];
        [self.scrollView addSubview:self.categoryView];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
        imgView.image=[UIImage imageNamed:@"choose_category_Header.png"];
        //initilize category table
        self.categoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, 300, 265) style:UITableViewStylePlain];
        self.categoryTable.delegate=self;
        self.categoryTable.dataSource=self;
        self.categoryTable.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorImages.png"]].CGColor;
        self.categoryTable.layer.borderWidth=5.0;
        self.categoryTable.layer.cornerRadius=5.0;
        self.categoryTable.clipsToBounds=YES;
        [self.categoryView addSubview:self.categoryTable];
        
        
        [self.categoryView addSubview:imgView];
        
    }
    else{
        [self.scrollView addSubview:self.categoryView];
        self.categoryView.hidden=NO;
    }
    
}

#pragma mark -
#pragma mark Privacy Button Action
//Privacy button action
-(void)privacyButtonAction:(id)sender{
    
    if (self.privacyView && self.privacyView.hidden==NO) {
        self.privacyView.hidden=YES;
        return;
    }
    if (!self.privacyView) {
        //initilize privacy view
        self.privacyView = [[UIView alloc] initWithFrame:CGRectMake(165, 160, 145, 155)];
        self.privacyView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.privacyView];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 145, 35)];
        img.image = [UIImage imageNamed:@"choose_privacy_Header_new.png"];
        //initilize Priviacy Table
        self.privacyTableView = [[UITableView alloc]init];
        self.privacyTableView.frame = CGRectMake(0, 30, 145, 125);
        self.privacyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.privacyTableView.layer.borderWidth=5.0f;
        self.privacyTableView.layer.borderColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"colorImages.png"]].CGColor;
        self.privacyTableView.delegate=self;
        self.privacyTableView.dataSource=self;
        [self.privacyView addSubview:self.privacyTableView];
        [self.privacyView addSubview:img];
    }
    else{
        self.privacyView.hidden=NO;
        [self.privacyTableView reloadData];
        [self.scrollView addSubview:self.privacyView];
    }
}
#pragma mark FriendPickerViewDelegae
-(void)friendpickerControllerDidCancel:(FriendsPickerViewController *)friendPicker{
    
    if (self.frndListString.length>0) {
        quesMode=3;
        NSLog(@"Seleted friend after cancel =%@",self.frndListString);
    }
    else{
        quesMode=1;
        self.frndListString = (NSMutableString *)@"";
    }
    
    NSLog(@"Friend Picker Cancel Button Clicked");
}
-(void)friendPickerController:(FriendsPickerViewController *)friendPicker didFinishPickingFriends:(NSMutableArray *)friendListArray{
    NSLog(@"Selected Friends = %@",friendListArray);
    quesMode=3;
    
    self.frndListString = [[NSMutableString alloc] init];
    for (int i =0; i<friendListArray.count; i++) {
        NSDictionary *dict =[friendListArray objectAtIndex:i];
        NSString *frndID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ID"]];
        
        [self.frndListString appendString:[NSString stringWithFormat:@"%@,",frndID]];
    }
    
    [self.frndListString appendString:[MySingletonClass sharedSingleton].groupinionUserID];
    NSLog(@"Frnds ID String =%@",self.frndListString);
}

///TableView Delegates
#pragma mark -
#pragma mark Table View Delegate And DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.categoryTable) {
        return [self.categoryListArray count];
    }
    else if (tableView==self.subCategoryTable) {
        return [self.subCategoryListArray count]-1;
    }
    else if (tableView==self.openDaysTable) {
        return [self.openDaysArray count];
    }
    else if (tableView==self.privacyTableView || tableView == self.optionTableView) {
        return 3;
    }
    
    
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Check Table type
    if (tableView==self.categoryTable) {
        
        cell.textLabel.text=[[self.categoryListArray objectAtIndex:indexPath.row]objectForKey:@"Category"];
        
    }
    else if (tableView==self.subCategoryTable) {
        NSString *removeUnWantedChars=[[self.subCategoryListArray objectAtIndex:indexPath.row+1]objectForKey:@"SubCategory"];
        cell.textLabel.text=[removeUnWantedChars stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    }
    else if (tableView==self.openDaysTable) {
        cell.textLabel.text=[NSString stringWithFormat:@" %@",[self.openDaysArray objectAtIndex:indexPath.row]];
    }
    else if (tableView==self.privacyTableView){
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines=2;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        if (indexPath.row==0) {
            cell.textLabel.text = @"Everyone";
        }
        else if (indexPath.row==1){
            cell.textLabel.text = @"Friends Only";
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = @"Specific Friends";
        }
        
        if (indexPath.row==quesMode-1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (tableView == self.optionTableView){
        if (indexPath.row==0) {
            cell.textLabel.text = @"2";
        }
        else if (indexPath.row==1){
            cell.textLabel.text = @"3";
        }
        else if (indexPath.row == 2){
            cell.textLabel.text = @"4";
        }
        
        if (indexPath.row==optionSelected-2) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.categoryTable  || tableView==self.openDaysTable) {
        return 52;
    }
    
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Category table Cell Selected
    if (tableView==self.categoryTable) {
        NSLog(@"catergory table selected");
        NSDictionary *dict=[self.categoryListArray objectAtIndex:indexPath.row];
        NSString *catID=[dict objectForKey:@"CategoryID"];
        [self showAllSubCategoryList:catID];
        [self.subCategoryTable reloadData];
    }
    //Sub Category table Cell Selected
    if (tableView==self.subCategoryTable) {
        NSDictionary *dictValue=[self.subCategoryListArray objectAtIndex:indexPath.row+1];
        NSLog(@"dictValue-%@",dictValue);
        NSMutableString *categoryValue=[dictValue objectForKey:@"SubCategory"];
        NSString  *subCategoryId = [dictValue objectForKey:@"CategoryID"];
        subCatId = [subCategoryId integerValue];
        if ([categoryValue length]>0) {
            self.categoryView.hidden=YES;
            self.subCategoryView.hidden=YES;
            self.subCategoryLabel.hidden=NO;
            categoryValue=[[categoryValue stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"]mutableCopy];
            self.subCategoryLabel.text=categoryValue;
        }
        
    }
    //Open days table Cell Selected
    if (tableView==self.openDaysTable) {
        NSMutableString *openDaysString=[self.openDaysArray objectAtIndex:indexPath.row];
        if ([openDaysString length]>0) {
            self.openDayView.hidden=YES;
            self.openDaysLabel.hidden=NO;
            self.openDaysLabel.text=openDaysString;
            selectedDayOpen = openDaysString;
        }
    }
    //Privacy table Cell Selected
    if (tableView==self.privacyTableView) {
        self.privacyView.hidden=YES;
        if (indexPath.row==0) {
            quesMode=1;
            self.frndListString = (NSMutableString *)@"";
            NSLog(@"Public Post");
        }
        else if (indexPath.row==1){
            quesMode=2;
            self.frndListString = (NSMutableString *)@"";
            NSLog(@"Friends POst");
        }
        else{
            quesMode=3;
            NSLog(@"Display Friends List");
            self.friendPicker = [[FriendsPickerViewController alloc] initWithNibName:@"FriendsPickerViewController" bundle:nil];
            self.friendPicker.delegate=self;
            self.friendPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:self.friendPicker animated:YES completion:nil];
        }
    }
    ////Option table Cell Selected
    else if (tableView == self.optionTableView){
        self.optionView.hidden=YES;
        imageDescriptionCount=0;
        if (indexPath.row == optionSelected-2) {
            return;
        }
        if (indexPath.row==0) {
            optionSelected=2;
            
        }
        else if (indexPath.row==1){
            optionSelected=3;
        }
        else{
            optionSelected=4;
        }
        [self.optionTableView reloadData];
        
        [self displayOptionForQuestion:nil];
    }
    
    
}

#pragma mark -
//Display Sub Category options for selected Category
-(void)showAllSubCategoryList:(NSString *)catId{
    self.categoryView.hidden=YES;
    
    if (!self.subCategoryView) {
        
        self.subCategoryView =[[UIView alloc]initWithFrame:CGRectMake(10, 37, 300, 320)];
        [self.scrollView addSubview:self.subCategoryView];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
        
        imgView.image=[UIImage imageNamed:@"choose_subcategory_Header.png"];
        
        self.subCategoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, 300, 265) style:UITableViewStylePlain];
        self.subCategoryTable.delegate=self;
        self.subCategoryTable.dataSource=self;
        self.subCategoryTable.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorImages.png"]].CGColor;
        self.subCategoryTable.layer.borderWidth=5.0;
        self.subCategoryTable.layer.cornerRadius=5.0;
        self.subCategoryTable.clipsToBounds=YES;
        subCategoryListArray=[[NSMutableArray alloc]init];
        [self.subCategoryView addSubview:self.subCategoryTable];
        
        [self.subCategoryView addSubview:imgView];
    }
    else{
        self.subCategoryTable.contentOffset=CGPointMake(0, 0);
        [self.scrollView addSubview:self.subCategoryView];
        self.subCategoryView.hidden=NO;
    }
    [subCategoryListArray removeAllObjects];
    
    //Call service for retrieve sub categroy for selected category
    NSString *urlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/subcategories/index.php?catid=%@",catId];
    
    NSString *jsonResponse=[self fetchAllCategories:urlString];
    //Check Response Status
    if([jsonResponse rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
        
        //NSArray *ary=[jsonResponse JSONValue];
        NSDictionary *dict11 = [jsonResponse JSONValue];
        NSString *msg = [dict11 objectForKey:@"Message"];
        
        [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        NSArray *jsonArray=[jsonResponse JSONValue];
        if([jsonArray count]>0){
            //Fetch All Sub Category
            for (int i=0; i<jsonArray.count; i++) {
                NSDictionary *dict=[jsonArray objectAtIndex:i];
                [subCategoryListArray addObject:dict];
            }
            NSLog(@"SubCategory Array-%@",subCategoryListArray);
        }
    }
}
//make a request for fetching data
-(NSString *)fetchAllCategories:(NSString *)urlString{
    
    //http://beta.groupinion.com/android/categories/
    NSURL *url=[NSURL URLWithString:urlString];
    
    NSHTTPURLResponse   * response;
    NSError *error;
    NSLog(@"url==%@",url);
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *respo=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"respo==%@",respo);
    
    return respo;
    
}
#pragma mark -
//Days Open Button Clicked

-(void)daysOpenButtonAction{
    
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    //Initilizing UI
    if (!self.openDaysTable) {
        
        self.openDayView = [[UIView alloc]initWithFrame:CGRectMake(10, 37, 300, 320)];
        [self.scrollView addSubview:self.openDayView];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
        imgView.image=[UIImage imageNamed:@"daysopen.png"];
        
        self.openDaysTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, 300, 265) style:UITableViewStylePlain];
        self.openDaysTable.delegate=self;
        self.openDaysTable.dataSource=self;
        self.openDaysTable.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorImages.png"]].CGColor;
        self.openDaysTable.layer.borderWidth=5.0;
        self.openDaysTable.layer.cornerRadius=5.0;
        self.openDaysTable.clipsToBounds=YES;
        [self.openDayView addSubview:self.openDaysTable];
        [self.openDayView addSubview:imgView];
        
        if (!self.openDaysArray) {
            //Open days array.....1,2,3,4,7,14,30 days
            self.openDaysArray=[[NSMutableArray alloc]init];
            self.openDaysArray=[NSMutableArray arrayWithObjects:@"1 day",@"2 days",@"3 days",@"4 days",@"7 days",@"14 days",@"30 days", nil];
        }
    }
    else{
        [self.scrollView addSubview:self.openDayView];
        self.openDayView.hidden=NO;
    }
    
    
    NSLog(@"Days Open Button Clicked");
}

#pragma mark -
//Upload Photo Button Clicked
-(void)uploadPhotoButtonAction:(UIButton*)sender{
    //Check Button Tag
    switch (sender.tag) {
        case 1:
            self.imageView=self.picImageView;
            break;
        case 2:
            self.imageView=self.picImageViewSecond;
            break;
        case 3:
            self.imageView=self.picImageViewThird;
            break;
        case 4:
            self.imageView=self.picImageViewFourth;
            break;
            
        default:
            break;
    }
    
    //Display Action Sheet
    if (self.actionSheet) {
        [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    else{
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Upload from camera roll",@"Take a picture",@"Search the web", nil];
        self.actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        //self.actionSheet.layer.backgroundColor = [UIColor redColor].CGColor;
        [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"button index = %d",buttonIndex);
    //check selected button index of Action Sheet
    if (buttonIndex == 0) {
        NSLog(@"Open Photo Library");
        //Display Photo Album
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.view.frame = CGRectMake(0, 0, 320, 420);
        [self.view addSubview:imagePicker.view];
    }
    else if (buttonIndex == 1){
        NSLog(@"Capture Photo");
        // Open Camera
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.view.frame = CGRectMake(0, 0, 320, 420);
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        [self.view addSubview:imagePicker.view];
    }
    else if (buttonIndex == 2){
        NSLog(@"Search From Web");
        //Search on Web
        WebImageSearchViewController *websearch = [[WebImageSearchViewController alloc] initWithNibName:@"WebImageSearchViewController" bundle:nil];
        websearch.delegate = self;
        websearch.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:websearch animated:YES completion:nil];
    }
    else{
        NSLog(@"Cancel Button Clicked");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    imagePicker.view.hidden=YES;
    // [self dismissModalViewControllerAnimated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    refresh = NO;
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *orientedImage = [SendHttpRequest orientedFixedImage:image];
    if (multipleChoiceQuestion==YES) {
        //Check number of selected options
        if (optionSelected != 4) {
            CGSize selectedImageSize = orientedImage.size;
            CGFloat imageWidth = selectedImageSize.width;
            CGFloat imageHeigth = selectedImageSize.height;
            NSLog(@"Selected image width = %f and heigth =%f",imageWidth,imageHeigth);
            //Check selected image Dimension
            if (imageWidth<800/optionSelected || imageHeigth<800) {
                NSString *mes = [NSString stringWithFormat:@"Upload image with dimension greater than %d X 800",800/optionSelected];
                [[[UIAlertView alloc] initWithTitle:@"" message:mes delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                return;
            }
        }
        
    }
    //Check selected image number
    if(self.imageView == self.picImageView){
        
        firstImageSelected=YES;
        selectedImageFirst = orientedImage;
        self.picImageView.image=image;
        self.imageView.hidden=NO;
        NSLog(@"first button selected");
    }
    else if(self.imageView == self.picImageViewSecond){
        seconfImageSelected =YES;
        selectedImageSecond = orientedImage;
        self.picImageViewSecond.image=image;
        NSLog(@"second Button Clicked");
    }
    else if(self.imageView == self.picImageViewThird){
        thirdImageSelected = YES;
        selectedImageThird = orientedImage;
        self.picImageViewThird.image=image;
        NSLog(@"Third button Clicked");
    }
    else{
        fourthImageSelected =YES;
        selectedImageFourth = orientedImage;
        self.picImageViewFourth.image=image;
        NSLog(@"Fourth button");
    }
    ///Create Thumbnail Image for selected image
    CGSize thumbnailImageSize  = CGSizeMake(63, 68);
    UIImage* thumbnailImage = nil;
    
    UIGraphicsBeginImageContext(thumbnailImageSize);
    [image drawInRect:self.picImageView.bounds];
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image=thumbnailImage;
    
    imagePicker.view.hidden=YES;
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    //NSLog(@"Image:%@", image);
    if (error) {
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil]show];
        
    }
    
}
#pragma mark -
//WebImageSearchViewControllerDelegate
-(void) webImageSearch:(WebImageSearchViewController *)webSearch finishSelectingImage:(UIImage *)selectedImage{
    //Check selected option
    if(self.imageView == self.picImageView){
        
        firstImageSelected=YES;
        selectedImageFirst = selectedImage;
        self.picImageView.image=selectedImage;
        self.imageView.hidden=NO;
        NSLog(@"first button selected");
    }
    else if(self.imageView == self.picImageViewSecond){
        seconfImageSelected =YES;
        selectedImageSecond = selectedImage;
        self.picImageViewSecond.image=selectedImage;
        NSLog(@"second Button Clicked");
    }
    else if(self.imageView == self.picImageViewThird){
        thirdImageSelected = YES;
        selectedImageThird = selectedImage;
        self.picImageViewThird.image=selectedImage;
        NSLog(@"Third button Clicked");
    }
    else{
        fourthImageSelected =YES;
        selectedImageFourth = selectedImage;
        self.picImageViewFourth.image=selectedImage;
        NSLog(@"Fourth button");
    }
    //Create Thumbnail image
    CGSize thumbnailImageSize  = CGSizeMake(63, 68);
    UIImage* thumbnailImage = nil;
    
    UIGraphicsBeginImageContext(thumbnailImageSize);
    [selectedImage drawInRect:self.picImageView.bounds];
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image=thumbnailImage;
}

#pragma mark -
#pragma mark Multiple Choice

//Make Multiple Choice Button action
//Display multiple Choice View
-(void) newMakeMultipleChoiceButtonClicked:(id)sender{
    self.privacyView.hidden=YES;
    imageDescriptionCount=0;
    multipleChoiceQuestion = YES;
    firstImageSelected=NO;
    selectedImageFirst = nil;
    self.picImageView.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    
    self.uploadPhoto.hidden=YES;
    self.submitQuesButton.hidden=YES;
    
    //Displaying Option button
    if (self.optionButtn) {
        self.optionButtn.hidden=NO;
    }
    else{
        self.optionButtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.optionButtn.frame = CGRectMake(10, 175, 145, 34);
        [self.optionButtn setBackgroundImage:[UIImage imageNamed:@"chooseoptions.png"] forState:UIControlStateNormal];
        [self.optionButtn addTarget:self action:@selector(displayMultipleChoiceOptions:) forControlEvents:UIControlEventTouchUpInside];
        //[self.optionButtn setTitle:@"Choose no. of options" forState:UIControlStateNormal];
        [self.scrollView addSubview:self.optionButtn];
    }
}

//Display Option TableView
-(void)displayMultipleChoiceOptions:(id)sender{
    if (self.optionView && self.optionView.hidden==NO) {
        self.optionView.hidden=YES;
        return;
    }
    NSLog(@"Display Option");
    if (self.optionView) {
        [self.optionTableView reloadData];
        self.optionView.hidden=NO;
    }
    else{
        self.optionView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, 145, 155)];
        self.optionView.backgroundColor = [UIColor clearColor];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 145, 35)];
        img.image = [UIImage imageNamed:@"choose_options_Header_new.png"];
        
        self.optionTableView = [[UITableView alloc]init];
        self.optionTableView.frame = CGRectMake(0, 30, 145, 125);
        self.optionTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.optionTableView.layer.borderWidth=5.0f;
        self.optionTableView.layer.borderColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"colorImages.png"]].CGColor;
        self.optionTableView.delegate=self;
        self.optionTableView.dataSource=self;
        [self.optionView addSubview:self.optionTableView];
        [self.optionView addSubview:img];
    }
    [self.scrollView addSubview:self.optionView];
}

//Display selected number of options for Multi Choice
-(void) displayOptionForQuestion:(id)sender{
    
    //Initialy hide all sub views
    self.uploadPhoto.hidden = NO;
    self.uploadPhoto.frame = CGRectMake(10, 220, 145, 70);
    self.scrollView.contentSize=CGSizeMake(320, 550);
    firstImageSelected = NO;
    seconfImageSelected = NO;
    thirdImageSelected = NO;
    fourthImageSelected = NO;
    self.textViewFirst.text=@"";
    self.textViewSecond.text = @"";
    self.textViewThird.text = @"";
    self.textViewFourth.text = @"";
    self.answerPlaceHolderFirst.hidden=NO;
    self.answerPlaceHolderSecond.hidden=NO;
    self.answerPlaceHolderThird.hidden=NO;
    self.answerPlaceHolderFourth.hidden=NO;
    self.uploadButtonThird.hidden=YES;
    self.textViewThird.hidden=YES;
    self.uploadButtonfourth.hidden=YES;
    self.textViewFourth.hidden=YES;
    CGFloat yy=380;
    //Check selected option
    if (optionSelected>=2) {
        //Prepare UI
        if (self.textViewFirst) {
            self.picImageViewSecond.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
            self.picImageView.image = [UIImage imageNamed:@"Multiple-Choice_photos.png"];
            self.uploadButtonSecond.hidden = NO;
            self.textViewFirst.hidden = NO;
            self.textViewSecond.hidden = NO;
        }
        else{
            //Initilizing First option text view
            self.textViewFirst=[[UITextView alloc]initWithFrame:CGRectMake(162, 220, 150, 70)];
            self.textViewFirst.layer.borderWidth=1.0f;
            self.textViewFirst.delegate=self;
            self.textViewFirst.layer.cornerRadius=5.0f;
            self.textViewFirst.alpha=0.8;
            
            self.textViewFirst.layer.borderColor=[UIColor grayColor].CGColor;
            [self.scrollView addSubview:self.textViewFirst];
            
            //Placeholder for First TextView
            self.answerPlaceHolderFirst = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
            self.answerPlaceHolderFirst.backgroundColor = [UIColor clearColor];
            self.answerPlaceHolderFirst.numberOfLines=2;
            self.answerPlaceHolderFirst.lineBreakMode = NSLineBreakByTruncatingTail;
            self.answerPlaceHolderFirst.font = [UIFont fontWithName:@"Arial" size:13];
            self.answerPlaceHolderFirst.text = @"Insert text for answer A here";
            self.answerPlaceHolderFirst.alpha = 0.6;
            [self.textViewFirst addSubview:self.answerPlaceHolderFirst];
            
            //Initilizing second option Button
            self.uploadButtonSecond=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.uploadButtonSecond.frame=CGRectMake(10, 300, 145, 70);
            self.uploadButtonSecond.layer.borderWidth=1.0f;
            self.uploadButtonSecond.tag=2;
            self.uploadButtonSecond.layer.borderColor=[UIColor lightGrayColor].CGColor;
            self.uploadButtonSecond.clipsToBounds=YES;
            self.uploadButtonSecond.layer.cornerRadius=5.0f;
            [self.uploadButtonSecond setBackgroundImage:[UIImage imageNamed:@"upload_photos.png"] forState:UIControlStateNormal];
            [self.uploadButtonSecond addTarget:self action:@selector(uploadPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:self.uploadButtonSecond];
            //Initilizing second option ImageView view
            self.picImageViewSecond=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 65, 68)];
            self.picImageViewSecond.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
            [self.uploadButtonSecond addSubview:self.picImageViewSecond];
            
            //Initilizing second option text view
            self.textViewSecond=[[UITextView alloc]initWithFrame:CGRectMake(162, 300, 150, 70)];
            self.textViewSecond.layer.borderWidth=1.0f;
            self.textViewSecond.delegate=self;
            //self.textViewSecond.text=@"Insert text for answer B here";
            self.textViewSecond.layer.cornerRadius=5.0f;
            self.textViewSecond.alpha=0.6;
            self.textViewSecond.layer.borderColor=[UIColor grayColor].CGColor;
            [self.scrollView addSubview:self.textViewSecond];
            //Placeholder for second TextView
            self.answerPlaceHolderSecond = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
            self.answerPlaceHolderSecond.backgroundColor = [UIColor clearColor];
            self.answerPlaceHolderSecond.numberOfLines=2;
            self.answerPlaceHolderSecond.lineBreakMode = NSLineBreakByTruncatingTail;
            self.answerPlaceHolderSecond.font = [UIFont fontWithName:@"Arial" size:13];
            self.answerPlaceHolderSecond.text = @"Insert text for answer B here";
            self.answerPlaceHolderSecond.alpha = 0.8;
            [self.textViewSecond addSubview:self.answerPlaceHolderSecond];
        }
        
    }//End option selected == 2
    
    
    if (optionSelected==3 || optionSelected == 4) {
        self.scrollView.contentSize=CGSizeMake(320, 650);
        self.uploadButtonThird.hidden=NO;
        self.textViewThird.hidden=NO;
        yy=460;
        if (self.uploadButtonThird) {
            self.picImageViewThird.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
            self.picImageViewFourth.image = [UIImage imageNamed:@"Multiple-Choice_photos.png"];
        }
        else{
            //Initilizing third option button
            self.uploadButtonThird=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.uploadButtonThird.frame=CGRectMake(10, 380, 145, 70);
            self.uploadButtonThird.layer.borderWidth=1.0f;
            self.uploadButtonThird.tag=3;
            self.uploadButtonThird.layer.borderColor=[UIColor lightGrayColor].CGColor;
            self.uploadButtonThird.clipsToBounds=YES;
            self.uploadButtonThird.layer.cornerRadius=5.0f;
            [self.uploadButtonThird setBackgroundImage:[UIImage imageNamed:@"upload_photos.png"] forState:UIControlStateNormal];
            [self.uploadButtonThird addTarget:self action:@selector(uploadPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:self.uploadButtonThird];
            //Initilizing third option ImageView
            self.picImageViewThird=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 65, 68)];
            self.picImageViewThird.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
            
            [self.uploadButtonThird addSubview:self.picImageViewThird];
            
            //Initilizing third option text view
            self.textViewThird=[[UITextView alloc]initWithFrame:CGRectMake(162, 380, 150, 70)];
            self.textViewThird.layer.borderWidth=1.0f;
            self.textViewThird.layer.cornerRadius=5.0f;
            //self.textViewThird.text=@"Insert text for answer C here";
            self.textViewThird.delegate=self;
            self.textViewThird.alpha=0.8;
            self.textViewThird.layer.borderColor=[UIColor grayColor].CGColor;
            [self.scrollView addSubview:self.textViewThird];
            
            //Initilizing placeholder third option text view
            self.answerPlaceHolderThird = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
            self.answerPlaceHolderThird.backgroundColor = [UIColor clearColor];
            self.answerPlaceHolderThird.numberOfLines=2;
            self.answerPlaceHolderThird.lineBreakMode = NSLineBreakByTruncatingTail;
            self.answerPlaceHolderThird.font = [UIFont fontWithName:@"Arial" size:13];
            self.answerPlaceHolderThird.text = @"Insert text for answer C here";
            self.answerPlaceHolderThird.alpha = 0.6;
            [self.textViewThird addSubview:self.answerPlaceHolderThird];
        }
    }//optionselected ==3 && 4
    
    if (optionSelected == 4) {
        yy=540;
        self.scrollView.contentSize=CGSizeMake(320, 750);
        self.uploadButtonfourth.hidden=NO;
        self.textViewFourth.hidden=NO;
        if (self.uploadButtonfourth) {
            self.picImageViewFourth.image = [UIImage imageNamed:@"Multiple-Choice_photos.png"];
            
        }
        else{
            //Initilizing Fourth option Button
            self.uploadButtonfourth=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.uploadButtonfourth.frame=CGRectMake(10, 460, 145, 70);
            self.uploadButtonfourth.layer.borderWidth=1.0f;
            self.uploadButtonfourth.tag=4;
            self.uploadButtonfourth.layer.borderColor=[UIColor lightGrayColor].CGColor;
            self.uploadButtonfourth.clipsToBounds=YES;
            self.uploadButtonfourth.layer.cornerRadius=5.0f;
            [self.uploadButtonfourth setBackgroundImage:[UIImage imageNamed:@"upload_photos.png"] forState:UIControlStateNormal];
            [self.uploadButtonfourth addTarget:self action:@selector(uploadPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:self.uploadButtonfourth];
            //Initilizing Fourth option Image view
            self.picImageViewFourth=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 65, 68)];
            self.picImageViewFourth.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
            
            [self.uploadButtonfourth addSubview:self.picImageViewFourth];
            //Initilizing Fourth option text view
            self.textViewFourth=[[UITextView alloc]initWithFrame:CGRectMake(162, 460, 150, 70)];
            self.textViewFourth.layer.borderWidth=1.0f;
            self.textViewFourth.layer.cornerRadius=5.0f;
            self.textViewFourth.delegate=self;
            //self.textViewFourth.text=@"Insert text for answer D here";
            self.textViewFourth.alpha=0.8;
            self.textViewFourth.layer.borderColor=[UIColor grayColor].CGColor;
            [self.scrollView addSubview:self.textViewFourth];
            
            //Placeholder for Fourth TextView
            self.answerPlaceHolderFourth = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
            self.answerPlaceHolderFourth.backgroundColor = [UIColor clearColor];
            self.answerPlaceHolderFourth.numberOfLines=2;
            self.answerPlaceHolderFourth.lineBreakMode = NSLineBreakByTruncatingTail;
            self.answerPlaceHolderFourth.font = [UIFont fontWithName:@"Arial" size:13];
            self.answerPlaceHolderFourth.text = @"Insert text for answer D here";
            self.answerPlaceHolderFourth.alpha = 0.6;
            [self.textViewFourth addSubview:self.answerPlaceHolderFourth];
        }
    }
    self.submitQuesButton.hidden=NO;
    self.submitQuesButton.frame=CGRectMake(10, yy, 300, 40);
    NSLog(@"Option selected = %d",optionSelected);
    NSLog(@"image description count = %d",imageDescriptionCount);
}

/*
-(void)makeMultipleChoiceButtonClicked{
    
    imageDescriptionCount=0;
    multipleChoiceQuestion = YES;
    firstImageSelected=NO;
    selectedImageFirst = nil;
    self.picImageView.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    
    //self.makeMultiChoiceButton.hidden=YES;
    self.uploadPhoto.frame=CGRectMake(10, 180, 145, 70);
    self.submitQuesButton.frame=CGRectMake(10, 510, 300, 40);
    
    self.scrollView.scrollEnabled=YES;
    self.scrollView.contentSize=CGSizeMake(320, 750);
    if(!self.toogleBackButton)
    {
        self.toogleBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.toogleBackButton.layer.cornerRadius = 6;
        self.toogleBackButton.clipsToBounds = YES;
        //    self.toogleBackButton.layer.masksToBounds = YES;
        // Edited By Rajeev===========================
        
        //[self.toogleBackButton setTitle:@"Make Yes/No" forState:UIControlStateNormal];
        //    self.toogleBackButton.backgroundColor = [UIColor clearColor];
        // self.toogleBackButton.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        //    self.toogleBackButton.layer.borderColor=[UIColor grayColor].CGColor;
        //    self.toogleBackButton.layer.borderWidth = 2.0f;
        [self.toogleBackButton setBackgroundImage:[UIImage imageNamed:@"make_yesno_new.png"] forState:UIControlStateNormal];
        self.toogleBackButton.alpha = 1.0;
        //======================================================================
        self.toogleBackButton.titleLabel.numberOfLines=2;
        [self.toogleBackButton addTarget:self action:@selector(toogleBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.toogleBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.toogleBackButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:11];
        self.toogleBackButton.frame=CGRectMake(10, 144, 90, 46);
        // [self.scrollView addSubview:self.toogleBackButton];
        
        
        
        self.textViewFirst=[[UITextView alloc]initWithFrame:CGRectMake(162, 180, 150, 70)];
        self.textViewFirst.layer.borderWidth=1.0f;
        self.textViewFirst.delegate=self;
        self.textViewFirst.layer.cornerRadius=5.0f;
        self.textViewFirst.alpha=0.8;
        // self.textViewFirst.text=@"Insert text for answer A here";
        self.textViewFirst.layer.borderColor=[UIColor grayColor].CGColor;
        [self.scrollView addSubview:self.textViewFirst];
        
        self.answerPlaceHolderFirst = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
        self.answerPlaceHolderFirst.backgroundColor = [UIColor clearColor];
        self.answerPlaceHolderFirst.numberOfLines=2;
        self.answerPlaceHolderFirst.lineBreakMode = NSLineBreakByTruncatingTail;
        self.answerPlaceHolderFirst.font = [UIFont fontWithName:@"Arial" size:13];
        self.answerPlaceHolderFirst.text = @"Insert text for answer A here";
        self.answerPlaceHolderFirst.alpha = 0.6;
        [self.textViewFirst addSubview:self.answerPlaceHolderFirst];
        
        self.uploadButtonSecond=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.uploadButtonSecond.frame=CGRectMake(10, 260, 145, 70);
        self.uploadButtonSecond.layer.borderWidth=1.0f;
        self.uploadButtonSecond.tag=2;
        self.uploadButtonSecond.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.uploadButtonSecond.clipsToBounds=YES;
        self.uploadButtonSecond.layer.cornerRadius=5.0f;
        [self.uploadButtonSecond setBackgroundImage:[UIImage imageNamed:@"upload_photos.png"] forState:UIControlStateNormal];
        [self.uploadButtonSecond addTarget:self action:@selector(uploadPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.uploadButtonSecond];
        
        self.picImageViewSecond=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 65, 68)];
        self.picImageViewSecond.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
        [self.uploadButtonSecond addSubview:self.picImageViewSecond];
        
        
        self.textViewSecond=[[UITextView alloc]initWithFrame:CGRectMake(162, 260, 150, 70)];
        self.textViewSecond.layer.borderWidth=1.0f;
        self.textViewSecond.delegate=self;
        //self.textViewSecond.text=@"Insert text for answer B here";
        self.textViewSecond.layer.cornerRadius=5.0f;
        self.textViewSecond.alpha=0.6;
        self.textViewSecond.layer.borderColor=[UIColor grayColor].CGColor;
        [self.scrollView addSubview:self.textViewSecond];
        
        self.answerPlaceHolderSecond = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
        self.answerPlaceHolderSecond.backgroundColor = [UIColor clearColor];
        self.answerPlaceHolderSecond.numberOfLines=2;
        self.answerPlaceHolderSecond.lineBreakMode = NSLineBreakByTruncatingTail;
        self.answerPlaceHolderSecond.font = [UIFont fontWithName:@"Arial" size:13];
        self.answerPlaceHolderSecond.text = @"Insert text for answer B here";
        self.answerPlaceHolderSecond.alpha = 0.8;
        [self.textViewSecond addSubview:self.answerPlaceHolderSecond];
        
        
        self.uploadButtonThird=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.uploadButtonThird.frame=CGRectMake(10, 340, 145, 70);
        self.uploadButtonThird.layer.borderWidth=1.0f;
        self.uploadButtonThird.tag=3;
        self.uploadButtonThird.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.uploadButtonThird.clipsToBounds=YES;
        self.uploadButtonThird.layer.cornerRadius=5.0f;
        [self.uploadButtonThird setBackgroundImage:[UIImage imageNamed:@"upload_photos.png"] forState:UIControlStateNormal];
        [self.uploadButtonThird addTarget:self action:@selector(uploadPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.uploadButtonThird];
        
        self.picImageViewThird=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 65, 68)];
        self.picImageViewThird.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
        
        [self.uploadButtonThird addSubview:self.picImageViewThird];
        
        self.textViewThird=[[UITextView alloc]initWithFrame:CGRectMake(162, 340, 150, 70)];
        self.textViewThird.layer.borderWidth=1.0f;
        self.textViewThird.layer.cornerRadius=5.0f;
        //self.textViewThird.text=@"Insert text for answer C here";
        self.textViewThird.delegate=self;
        self.textViewThird.alpha=0.8;
        self.textViewThird.layer.borderColor=[UIColor grayColor].CGColor;
        [self.scrollView addSubview:self.textViewThird];
        
        self.answerPlaceHolderThird = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
        self.answerPlaceHolderThird.backgroundColor = [UIColor clearColor];
        self.answerPlaceHolderThird.numberOfLines=2;
        self.answerPlaceHolderThird.lineBreakMode = NSLineBreakByTruncatingTail;
        self.answerPlaceHolderThird.font = [UIFont fontWithName:@"Arial" size:13];
        self.answerPlaceHolderThird.text = @"Insert text for answer C here";
        self.answerPlaceHolderThird.alpha = 0.6;
        [self.textViewThird addSubview:self.answerPlaceHolderThird];
        
        
        self.uploadButtonfourth=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.uploadButtonfourth.frame=CGRectMake(10, 420, 145, 70);
        self.uploadButtonfourth.layer.borderWidth=1.0f;
        self.uploadButtonfourth.tag=4;
        self.uploadButtonfourth.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.uploadButtonfourth.clipsToBounds=YES;
        self.uploadButtonfourth.layer.cornerRadius=5.0f;
        [self.uploadButtonfourth setBackgroundImage:[UIImage imageNamed:@"upload_photos.png"] forState:UIControlStateNormal];
        [self.uploadButtonfourth addTarget:self action:@selector(uploadPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.uploadButtonfourth];
        
        self.picImageViewFourth=[[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 65, 68)];
        self.picImageViewFourth.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
        
        [self.uploadButtonfourth addSubview:self.picImageViewFourth];
        
        self.textViewFourth=[[UITextView alloc]initWithFrame:CGRectMake(162, 420, 150, 70)];
        self.textViewFourth.layer.borderWidth=1.0f;
        self.textViewFourth.layer.cornerRadius=5.0f;
        self.textViewFourth.delegate=self;
        //self.textViewFourth.text=@"Insert text for answer D here";
        self.textViewFourth.alpha=0.8;
        self.textViewFourth.layer.borderColor=[UIColor grayColor].CGColor;
        [self.scrollView addSubview:self.textViewFourth];
        
        
        self.answerPlaceHolderFourth = [[UILabel alloc]initWithFrame:CGRectMake(3, -18, 140, 70)];
        self.answerPlaceHolderFourth.backgroundColor = [UIColor clearColor];
        self.answerPlaceHolderFourth.numberOfLines=2;
        self.answerPlaceHolderFourth.lineBreakMode = NSLineBreakByTruncatingTail;
        self.answerPlaceHolderFourth.font = [UIFont fontWithName:@"Arial" size:13];
        self.answerPlaceHolderFourth.text = @"Insert text for answer D here";
        self.answerPlaceHolderFourth.alpha = 0.6;
        [self.textViewFourth addSubview:self.answerPlaceHolderFourth];
        
        
        //self.submitQuesButton.hidden=NO;
        
        
        NSLog(@"Multiple Choice Button Clicked");
    }
    else{
        firstImageSelected=NO;
        seconfImageSelected=NO;
        thirdImageSelected=NO;
        fourthImageSelected=NO;
        self.picImageView.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
        self.picImageViewSecond.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
        self.picImageViewThird.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
        self.picImageViewFourth.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
        
        self.textViewFirst.text=@"";
        self.textViewSecond.text=@"";
        self.textViewThird.text=@"";
        self.textViewFourth.text=@"";
        
        self.answerPlaceHolderFirst.hidden=NO;
        self.answerPlaceHolderSecond.hidden=NO;
        self.answerPlaceHolderThird.hidden=NO;
        self.answerPlaceHolderFourth.hidden=NO;
        
        
        self.toogleBackButton.hidden=NO;
        self.textViewFirst.hidden=NO;
        self.textViewSecond.hidden=NO;
        self.textViewThird.hidden=NO;
        self.textViewFourth.hidden=NO;
        self.uploadButtonSecond.hidden=NO;
        self.uploadButtonThird.hidden=NO;
        self.uploadButtonfourth.hidden=NO;
        self.submitQuesButton.frame=CGRectMake(10, 510, 300, 40);
        self.submitQuesButton.hidden=NO;
    }
}
*/
#pragma mark -
#pragma mark Single Choice
//Make Yes/No Question View
-(void)toogleBackButtonClicked
{
    self.optionButtn.hidden=YES;
    self.optionView.hidden=YES;
    self.privacyView.hidden=YES;
    optionSelected=0;
    self.scrollView.contentSize=CGSizeMake(320, 550);
    self.scrollView.frame=CGRectMake(0, 52, 320, 400);
    self.scrollView.scrollsToTop=YES;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    //self.scrollView.scrollEnabled=NO;
    
    firstImageSelected=NO;
    seconfImageSelected=NO;
    thirdImageSelected=NO;
    fourthImageSelected=NO;
    imageDescriptionCount=0;
    multipleChoiceQuestion=NO;
    
    self.picImageView.image=[UIImage imageNamed:@"Multiple-Choice_photos.png"];
    
    selectedImageFirst=nil;
    selectedImageSecond=nil;
    selectedImageThird=nil;
    selectedImageFourth=nil;
    
    
    // self.scrollView.scrollEnabled=NO;
    
    self.makeMultiChoiceButton.frame=CGRectMake(165, 140, 145, 70);
    self.uploadPhoto.frame=CGRectMake(10, 180, 145, 70);
    self.makeMultiChoiceButton.hidden=NO;
    self.uploadPhoto.hidden=NO;
    self.uploadButtonSecond.hidden=YES;
    self.uploadButtonThird.hidden=YES;
    self.uploadButtonfourth.hidden=YES;
    self.textViewFirst.hidden=YES;
    self.textViewSecond.hidden=YES;
    self.textViewThird.hidden=YES;
    self.textViewFourth.hidden=YES;
    self.submitQuesButton.hidden=NO;
    self.submitQuesButton.frame=CGRectMake(10, 260, 300, 40);
    
}

#pragma resizing image..
//Resizing the image
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

#pragma mark
#pragma mark Submit Button Action
//Submit Question Button action
-(void)submitButtonAction{
    [self.questionTextView resignFirstResponder];
    [self.textViewFirst resignFirstResponder];
    [self.textViewSecond resignFirstResponder];
    [self.textViewThird resignFirstResponder];
    [self.textViewFourth resignFirstResponder];
    
    NSLog(@"count==%d",imageDescriptionCount);
    NSLog(@"Submit Question Clicked");
    
    NSString *selectedSubCategory =  self.subCategoryLabel.text;
    NSString *dayOpen =  self.openDaysLabel.text;
    NSString *question = self.questionTextView.text;
    
    NSLog(@"selected Sub Category= %@",selectedSubCategory);
    NSLog(@"selected day open = %@",dayOpen);
    NSLog(@"question = %@",question);
    
    //Check Validation
    if([selectedSubCategory isEqualToString:@""] || selectedSubCategory == nil){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please select category" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else if ([dayOpen isEqualToString:@""] || dayOpen == nil){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please select day" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else if ([question isEqualToString:@""] || question == nil){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter your question" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        if (quesMode==3 && self.frndListString.length<=1) {
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Please select friend" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        
        [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
        NSLog(@"Ok Submit to server");
        //Check Question Type
        if (multipleChoiceQuestion==YES) {
            NSLog(@"Multiple Choice Question");
            
            
            [self submitToServerMultiChoiceQuestion];
            
        }
        else{
            
            NSLog(@"Single Choice Question");
            [self submitToServerSingleChoiceQuestion];
        }
        
        
    }
    
    
    
}
#pragma mark -

-(void)displayActivityIndicator{
    
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground=YES;
    HUD.delegate=self;
    [self.view addSubview:HUD];
    
    
    [HUD show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    //[HUD release];
    HUD = nil;
}

-(NSString*) encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef) string,
                                                              NULL,
                                                              (CFStringRef) @"!*'()@+$,&%=/#[]",
                                                              kCFStringEncodingUTF8));}
#pragma mark -

-(void)submitToServerSingleChoiceQuestion{
    
    BOOL imageUploaded;
    
    NSString *imageUrl=@"";
    //Check Image Selected or not
    if(firstImageSelected==YES){
        //create image name on the basis of Date nad Time
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyhh:mm:ss"];
        NSDate *cDate=[NSDate date];
        
        NSString *fileName=[formatter stringFromDate:cDate];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        NSLog(@"FileName==%@",fileName);
        
        //UIImage *firstImage = self.picImageView.image;
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:selectedImageFirst,@"image",fileName,@"filename", nil];
        imageUploaded = [self uploadImageToServer:dict];
        
        imageUrl = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",fileName];
        //          imageUrl = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_75_75/%@",fileName];
    }
    else{
        
        imageUploaded = YES;
        imageUrl = @"";
    }
    
    if(imageUploaded == YES){
        
        //if image successfully uploded
        
        //HUD.labelText = @"Posting Question";
        NSLog(@"Image Uploaded Successfully, now save question to server");
        
        NSString *uid = [MySingletonClass sharedSingleton].groupinionUserID;
        
        NSString *ques = self.questionTextView.text;
        ques = [self encodeToPercentEscapeString:ques];
        selectedDayOpen =[selectedDayOpen stringByReplacingOccurrencesOfString:@" " withString:@""];
        selectedDayOpen =[selectedDayOpen stringByReplacingOccurrencesOfString:@"days" withString:@""];
        selectedDayOpen =[selectedDayOpen stringByReplacingOccurrencesOfString:@"day" withString:@""];
        //Prepare URL for saving Yes/No question to Server
        NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/postquestionnew/?id=%@&url=%@&question=%@&type=0&subcatid=%i&dopen=%@&selectedfriends=%@&quemode=%d&urgent=%d",uid,imageUrl,ques,subCatId,selectedDayOpen,self.frndListString,quesMode,markUrgent];
        //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"url string = %@",urlString);
        //Post Question to server
        NSString *response =[SendHttpRequest sendRequest:urlString];
        NSLog(@"Response to save Question = %@",response);
        [HUD hide:YES];
        
        NSLog(@"Response to save Question = %@",response);
        
        //Check Response
        if([response isEqualToString:@"error"]){
            
            NSLog(@"Error to save Question");
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        }
        else{
            
            if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
                
                NSDictionary *responseDict = [response JSONValue];
                NSString *msg = [responseDict objectForKey:@"Message"];
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                // Return Format
                //{"Status":"1","Message":"Data Insert successfully","ID":"1494","unique_que":"F77NC"}
                quesMode=1;
                self.frndListString = (NSMutableString *)@"";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAfterAction" object:nil];
                
                [MySingletonClass sharedSingleton].reported=YES;
                [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
                [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
                NSDictionary *responseDict = [response JSONValue];
                //NSString *msg = [respomseDict objectForKey:@"Status"];
                NSLog(@"Save to Server =%@",responseDict);
                
                NSString *unique_que = [responseDict objectForKey:@"unique_que"];
                
                //https://beta.groupinion.com/get_yesno_meme/?unique=J0FO9&txtcolor=black&img=http://www.beta.groupinion.com/app3/modules/boonex/photos/data/files/20130806041749.png
                
                //Check image selected or not
                if (firstImageSelected==NO) {
                    //image url will Groupinion Logo
                    imageUrl = @"https://www.beta.groupinion.com/app3/modules/boonex/photos/data/files/20130626114301.png";
                }
                //Prepare URl for getting meme image url
                NSString *memeUrlString = [NSString stringWithFormat:@"http://beta.groupinion.com/get_yesno_meme/?unique=%@&txtcolor=black&img=%@",unique_que,imageUrl];
                memeUrlString= [memeUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //Swith to share to facebook view Controller
                ShareToFacebookViewController *share = [[ShareToFacebookViewController alloc]initWithNibName:@"ShareToFacebookViewController" bundle:nil];
                share.memeUrlString = memeUrlString;
                share.imageSelected = firstImageSelected;
                //Prepare text for post on facebook
                NSString *postString = [NSString stringWithFormat:@"I need your help. I asked a question on Groupinion: \"%@\". Please help me decide by voting now at http://www.beta.groupinion.com/question/?q=%@",self.questionTextView.text,unique_que];
                
                share.question = self.questionTextView.text;
                share.fbPostString=postString;
                //share.postImage = selectedImageFirst;
                [MySingletonClass sharedSingleton].shareFB=share;
                [self.navigationController pushViewController:share animated:YES];
            }
        }
        
    }
    else{
        ////if image not uploded
        
        [HUD hide:YES];
        NSLog(@"Image not Uploaded to server");
    }
    
}

-(void)hideActivityIndicator{
    [HUD hide:YES];
}
//Submitting Multiple Choice Question
-(void)submitToServerMultiChoiceQuestion{
    
    //Check all Choice added or not
    if (imageDescriptionCount<optionSelected) {
        //Please submit 2 or more choices for multiple choice question, or toggle to a yes/no question for a single choice
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please submit all choices, or toggle to a yes/no question for a single choice" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
        //        }
        
    }
    
    else{
        
        imageNameArray=[[NSMutableArray alloc]init];
        imageArray = [[NSMutableArray alloc]init];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyhh:mm:ss"];
        NSDate *cDate=[NSDate date];
        
        NSString *fileName=[formatter stringFromDate:cDate];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        NSLog(@"FileName==%@",fileName);
        
        imageNameFirst=@"";
        imageNameTwo=@"";
        imageNameThree=@"";
        imageNameFourth=@"";
        
        //==============================
        
        //Check Number of Selected Image
        
        if (firstImageSelected==YES) {
            NSLog(@"First Image Selected");
            
            NSLog(@"Ok upload image");
            imageNameFirst = [NSString stringWithFormat:@"%@1",fileName];
            [imageNameArray addObject:imageNameFirst];
            [imageArray addObject:selectedImageFirst];
        }
        
        //============================================
        if (seconfImageSelected==YES) {
            NSLog(@"Second Image Selected");
            
            NSLog(@"Ok upload image");
            imageNameTwo = [NSString stringWithFormat:@"%@2",fileName];
            [imageNameArray addObject:imageNameTwo];
            [imageArray addObject:selectedImageSecond];
            
        }
        //============================================
        if (thirdImageSelected==YES) {
            NSLog(@"third Image Selected");
            NSLog(@"Ok upload image");
            imageNameThree = [NSString stringWithFormat:@"%@3",fileName];
            [imageNameArray addObject:imageNameThree];
            [imageArray addObject:selectedImageThird];
            
        }
        //============================================
        if (fourthImageSelected==YES) {
            
            NSLog(@"Ok upload image");
            imageNameFourth= [NSString stringWithFormat:@"%@4",fileName];
            [imageNameArray addObject:imageNameFourth];
            [imageArray addObject:selectedImageFourth];
        }
        //============================================
        
        NSLog(@"Image Array count =%lu",(unsigned long)imageArray.count);
        NSLog(@"\n\nImage Name Array count =%lu==\n%@",(unsigned long)imageNameArray.count,imageNameArray);
        
        //Check image description added for selected numbers of options or not
        if ([imageArray count]>imageDescriptionCount) {
            //Display alert
            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have submitted an image without a title.  Ask anyway?" delegate:self cancelButtonTitle:@"Add title" otherButtonTitles:@"Ask without title", nil];
            myAlert.tag=2;
            [myAlert show];
        }
        else{
            //Prepare image name and url and Upload image to server
            for (int i=0; i<[imageNameArray count]; i++) {
                if ([imageNameArray containsObject:imageNameFirst]) {
                    imageNameFirst = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameFirst];
                    NSLog(@"first = %@",imageNameFirst);
                }
                else if([imageNameArray containsObject:imageNameTwo]){
                    imageNameTwo = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameTwo];
                    NSLog(@"first = %@",imageNameTwo);
                }
                else if ([imageNameArray containsObject:imageNameThree]){
                    imageNameThree = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameThree];
                    NSLog(@"first = %@",imageNameThree);
                }
                else if ([imageNameArray containsObject:imageNameFourth]){
                    imageNameFourth =[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameFourth];
                    NSLog(@"first = %@",imageNameFourth);
                }
            }
            
            [self continueToUploadQuestion];
        }
        
        
        //======================================
        
    }//End else first block
    //===============================================================
}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==2) {
        
        if (buttonIndex==0) {
            
        }
        else{
            
            [NSThread detachNewThreadSelector:@selector(dismissAlertView:) toTarget:self withObject:alertView];
            //Check description for image
            if ([self.textViewFirst.text isEqualToString:@""]) {
                
                if ([imageArray containsObject:selectedImageFirst]) {
                    [imageArray removeObject:selectedImageFirst];
                    [imageNameArray removeObject:imageNameFirst];
                    imageNameFirst = @"";
                    
                }
            }
            else{
                imageNameFirst = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameFirst];
                NSLog(@"first = %@",imageNameFirst);
            }
            
            if ([self.textViewSecond.text isEqualToString:@""]) {
                
                if ([imageArray containsObject:selectedImageSecond]) {
                    [imageArray removeObject:selectedImageSecond];
                    [imageNameArray removeObject:imageNameTwo];
                    imageNameTwo = @"";
                }
                
            }
            else{
                imageNameTwo = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameTwo];
                NSLog(@"first = %@",imageNameTwo);
            }
            
            
            if ([self.textViewThird.text isEqualToString:@""]) {
                
                if ([imageArray containsObject:selectedImageThird]){
                    [imageArray removeObject:selectedImageThird];
                    [imageNameArray removeObject:imageNameThree];
                    imageNameThree = @"";
                }
                
            }
            else{
                imageNameThree = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameThree];
                NSLog(@"first = %@",imageNameThree);
            }
            
            if ([self.textViewFourth.text isEqualToString:@""]) {
                
                if ([imageArray containsObject:selectedImageFourth]) {
                    [imageArray removeObject:selectedImageFourth];
                    [imageNameArray removeObject:imageNameFourth];
                    imageNameFourth = @"";
                }
                
            }
            else{
                imageNameFourth = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@.jpg",imageNameFourth];
                NSLog(@"first = %@",imageNameFourth);
            }
            NSLog(@"Image Array count =%lu",(unsigned long)imageArray.count);
            NSLog(@"\n\nImage Name Array count =%lu==\n%@",(unsigned long)imageNameArray.count,imageNameArray);
            [self continueToUploadQuestion];
            [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
        }
        
    }//End if block tag==2
}

-(void)dismissAlertView:(UIAlertView *)alert{
    
    [alert dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)continueToUploadQuestion{
    
    
    NSString *desFirst = @"";
    NSString *desSecond = @"";
    NSString *desThird = @"";
    NSString *desFourth = @"";
    
    if (optionSelected>=2) {
        desFirst = self.textViewFirst.text;
        desSecond = self.textViewSecond.text;
    }
    
    if (optionSelected>=3) {
       desThird = self.textViewThird.text;
    }
    if (optionSelected==4) {
      desFourth = self.textViewFourth.text;
    }
    conLock = [[NSCondition alloc]init];
    
    
    NSLog(@"Image Array Count =%lu",(unsigned long)[imageArray count]);
    //Upload image to sever
    for (int i =0; i<[imageArray count]; i++) {
        NSMutableDictionary *dict =[[NSMutableDictionary alloc]init];
        [dict setObject:[imageArray objectAtIndex:i] forKey:@"image"];
        [dict setObject:[imageNameArray objectAtIndex:i] forKey:@"filename"];
        //initilize new thread for upload image
        myThread = [[NSThread alloc] initWithTarget:self selector:@selector(createThreadToUploadImageToServer:) object:dict];
        [myThread start];
        //          BOOL check =  [self uploadImageToServer:dict];
        //            if (check==YES) {
        //                uploadedcount = uploadedcount +1;
        //            }
        //            else{
        //                NSLog(@"Not uploaded");
        //                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Image not Uploded" delegate:selectedImageFourth cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        //                return;
        //            }
    }
    //Stop thread for further execution
    if ([imageArray count]>0) {
        [conLock lock];
        [conLock wait];
    }
    
    //Check thread count
    if (threadCount == [imageArray count]) {
        
        NSString *uid = [MySingletonClass sharedSingleton].groupinionUserID;
        
        NSString *ques = self.questionTextView.text;
        ques = [self encodeToPercentEscapeString:ques];
        
        selectedDayOpen =[selectedDayOpen stringByReplacingOccurrencesOfString:@" " withString:@""];
        selectedDayOpen =[selectedDayOpen stringByReplacingOccurrencesOfString:@"days" withString:@""];
        selectedDayOpen =[selectedDayOpen stringByReplacingOccurrencesOfString:@"day" withString:@""];
        
        //http://beta.groupinion.com/android/postquestion/?id=&url1=&url2=&url3=&url4=&question=&type=&subcatid=&dopen&=des1=&des2=&des3=&des4=
        
        desFirst = [self encodeToPercentEscapeString:desFirst];
        desSecond = [self encodeToPercentEscapeString:desSecond];
        desThird = [self encodeToPercentEscapeString:desThird];
        desFourth = [self encodeToPercentEscapeString:desFourth];
        
        //Prepare URL for submit multi choice question to server
        NSString *urlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/postquestionnew/?id=%@&url1=%@&url2=%@&url3=%@&url4=%@&question=%@&type=1&subcatid=%i&dopen=%@&des1=%@&des2=%@&des3=%@&des4=%@&selectedfriends=%@&quemode=%d&urgent=%d",uid,imageNameFirst,imageNameTwo,imageNameThree,imageNameFourth,ques,subCatId,selectedDayOpen,desFirst,desSecond,desThird,desFourth,self.frndListString,quesMode,markUrgent];
        //        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //urlString = [self encodeToPercentEscapeString:urlString];
        NSLog(@"Description = %@",urlString);
        
        
        NSString *response =[SendHttpRequest sendRequest:urlString];
        NSLog(@"Response to save Question = %@",response);
        [HUD hide:YES];
        //Check Response
        if ([response isEqualToString:@"error"]) {
            NSLog(@"Error");
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            
            if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
                NSLog(@"Error===");
                NSDictionary *responseDict = [response JSONValue];
                NSString *msg = [responseDict objectForKey:@"Message"];
                
                [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                quesMode=1;
                self.frndListString = (NSMutableString *)@"";
                [MySingletonClass sharedSingleton].reported=YES;
                [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
                [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
                [MySingletonClass sharedSingleton].refreshMyprofile=YES;
                
                NSDictionary *responseDict = [response JSONValue];
                //NSString *msg = [respomseDict objectForKey:@"Status"];
                NSLog(@"Save to Server =%@",responseDict);
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAfterAction" object:nil];
                
                NSString *unique_que = [responseDict objectForKey:@"unique_que"];
                
                //https://beta.groupinion.com/get_multi_meme/?member_id=5h07q&Image1=http://beta.groupinion.com/app3/modules/boonex/photos/data/files/52000671b8463.jpg&Image2=http://beta.groupinion.com/app3/modules/boonex/photos/data/files/52000671c1dc2.jpg&Image3=http://beta.groupinion.com/app3/modules/boonex/photos/data/files/52000671c3d4d.jpg&Image4=http://beta.groupinion.com/app3/modules/boonex/photos/data/files/52000671c5f28.jpg&des1=sanjay&des2=ab&des3=w&des4=ds&txtcolor=black
                //Preparing url for generate meme image for multi choice question
                NSString *memeUrlString = [NSString stringWithFormat:@"https://beta.groupinion.com/get_multi_meme/?member_id=%@&Image1=%@&Image2=%@&Image3=%@&Image4=%@&des1=%@&des2=%@&des3=%@&des4=%@&txtcolor=black",unique_que,imageNameFirst,imageNameTwo,imageNameThree,imageNameFourth,desFirst,desSecond,desThird,desFourth];
                memeUrlString = [memeUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                //switch to ShareonfacebookViewController
                ShareToFacebookViewController *share = [[ShareToFacebookViewController alloc]initWithNibName:@"ShareToFacebookViewController" bundle:nil];
                share.memeUrlString = memeUrlString;
                if ([imageArray count]>0) {
                    share.imageSelected = YES;
                }
                else{
                    share.imageSelected = NO;
                }
                
                //I need your help. I asked a question on Groupinion: "test question stephen - arohi". Please help me decide by voting now at http://www.beta.groupinion.com/question/?q=6V09a
                //Text for post on facebook
                NSString *postString = [NSString stringWithFormat:@"I need your help. I asked a question on Groupinion: \"%@\". Please help me decide by voting now at http://www.beta.groupinion.com/question/?q=%@",self.questionTextView.text,unique_que];
                
                share.question = self.questionTextView.text;
                share.fbPostString = postString;
                //share.postImage = selectedImageFirst;
                [MySingletonClass sharedSingleton].shareFB=share;
                [self.navigationController pushViewController:share animated:YES];
                
            }//End else Block Status Check
        }//End else block Response check
        
    }//End if block threadcount check
    else{
        [HUD hide:YES];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Image not Uploaded, Please try Again" delegate:selectedDayOpen cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }//End else Block thread count
    
}
//Generating new thread
-(void) createThreadToUploadImageToServer:(NSMutableDictionary *)dict{
    NSLog(@"ThreadCreated ");
    BOOL check=  [self uploadImageToServer:dict];
    
    if (check==YES) {
        threadCount = threadCount + 1;
    }
    else{
        
        NSLog(@"Image not uploaded");
        
        [conLock signal];
    }
    
    NSLog(@"%i thread end",threadCount);
    //wake up thread
    if (threadCount==[imageArray count]) {
        [conLock signal];
    }
}



-(BOOL)saveQuestionToServer:(NSString *)urlString{
    
    // NSURL *url = [NSURL URLWithString:urlString];
    BOOL returnStatus;
    NSString *response =[SendHttpRequest sendRequest:urlString];
    NSLog(@"Response to save Question = %@",response);
    
    if([response isEqualToString:@"error"]){
        
        NSLog(@"Error to save Question");
        returnStatus = NO;
        
    }
    else{
        
        if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
            returnStatus = NO;
            NSDictionary *responseDict = [response JSONValue];
            NSString *msg = [responseDict objectForKey:@"Message"];
            
            [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            // Return Format
            //{"Status":"1","Message":"Data Insert successfully","ID":"1494","unique_que":"F77NC"}
            returnStatus = YES;
            
            [MySingletonClass sharedSingleton].reported=YES;
            [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
            [MySingletonClass sharedSingleton].refreshMyprofile=YES;
            NSDictionary *responseDict = [response JSONValue];
            //NSString *msg = [respomseDict objectForKey:@"Status"];
            NSLog(@"Save to Server =%@",responseDict);
        }
    }
    
    return returnStatus;
}

#pragma mark -
#pragma mark Upload Image To Server

-(BOOL)uploadImageToServer:(NSMutableDictionary *)dict{
    
    
    UIImage *image = [dict objectForKey:@"image"];
    NSString *fileName = [dict objectForKey:@"filename"];
    
    // HUD.labelText = @"Uploading image";
    
    //Check image width and height
    // UIImage *compressedImage = [self compressImage:image];
    
    //======================
    //Get image data for selected image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.3f);
    //save image on path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",fileName]];
    NSLog(@"imagePath==%@",imagePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
    // NSURL *url=[NSURL URLWithString:@"http://beta.groupinion.com/fb/UploadToServer.php"];
    NSURL *url = [NSURL URLWithString:@"http://beta.groupinion.com/android/uploadimage/UploadToServer.php"];
    //prepare request for upload image
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    //get boundary
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //set body
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@\"\r\n", imagePath] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"Image Return String: %@",returnString);
    
    BOOL retuneStatus;
    // Image Uploaded or not if return success than Yes otherwise No.
    if([returnString isEqualToString:@"success"]){
        retuneStatus = YES;
        
    }
    else{
        retuneStatus = NO;
    }
    return  retuneStatus;
    
}
/*
//Compress Image
-(UIImage *)compressImage:(UIImage *)selectedImage{
    
    CGSize selectedImageSize = selectedImage.size;
    
    CGFloat imagewidth = selectedImageSize.width;
    CGFloat imageheight = selectedImageSize.height;
    
    CGFloat targetwidth = 800;
    CGFloat targetheight = 800;
    
    NSLog(@"Selected image width = %f  and\n height = %f",imagewidth,imageheight);
    
    
    //check if selected image width and height Greater than aspected width and height
    if(imagewidth > targetwidth || imageheight >targetheight){
        
        UIImage *newImage = nil;
        
        CGFloat resultantWidth;
        CGFloat resultantheight;
        
        
        if (imagewidth > imageheight) {
            
            resultantWidth = targetwidth;
            
            resultantheight = (resultantWidth * imageheight)/imagewidth;
        }
        else{
            
            resultantheight = targetheight;
            
            resultantWidth = (resultantheight * imagewidth)/imageheight;
        }
        
        NSLog(@"Resultant Width == %f and height == %f",resultantWidth, resultantheight);
        
        CGSize resultantSize = CGSizeMake(targetwidth , targetheight);
        
        UIGraphicsBeginImageContext(resultantSize);
        CGRect drawableRect = CGRectZero;
        
        drawableRect.size.width = resultantWidth;
        drawableRect.size.height = resultantheight;
        
        [selectedImage drawInRect:drawableRect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
        
        
    }//Check with 800
    return selectedImage;
}
*/

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    
    
}

#pragma mark -
#pragma mark TextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return YES;
    }
    
    if(textView==self.questionTextView){
        
        if ([self.questionTextView.text length]>=140 && range.length==0) {
            return NO;
        }
    }
    
    if (textView==self.textViewFirst) {
        if ([self.textViewFirst.text length]>=20 && range.length==0) {
            return NO;
        }
    }
    else if (textView==self.textViewSecond) {
        if ([self.textViewSecond.text length]>=20 && range.length==0) {
            return NO;
        }
    }
    else if (textView==self.textViewThird) {
        if ([self.textViewThird.text length]>=20 && range.length==0) {
            return NO;
        }
    }
    else if (textView==self.textViewFourth) {
        if ([self.textViewFourth.text length]>=20 && range.length==0) {
            return NO;
        }
    }
    
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    //[textView becomeFirstResponder];
    if(textView == self.questionTextView){
        self.placeHolderLable.hidden=YES;
        
    }
    else if(textView == self.textViewFirst){
        // [self.scrollView setContentOffset:CGPointMake(0, 130)];
        if ([self.textViewFirst.text isEqualToString:@""]) {
            self.answerPlaceHolderFirst.hidden=YES;
            
        }
        else{
            imageDescriptionCount = imageDescriptionCount-1;
        }
    }
    else if(textView == self.textViewSecond){
        // [self.scrollView setContentOffset:CGPointMake(0, 200)];
        if ([self.textViewSecond.text isEqualToString:@""]) {
            self.answerPlaceHolderSecond.hidden=YES;
            
        }
        else{
            imageDescriptionCount = imageDescriptionCount-1;
        }
    }
    else if(textView == self.textViewThird){
        //[self.scrollView setContentOffset:CGPointMake(0, 270)];
        if ([self.textViewThird.text isEqualToString:@""]) {
            self.answerPlaceHolderThird.hidden=YES;
        }
        else{
            imageDescriptionCount = imageDescriptionCount-1;
        }
    }
    else if(textView == self.textViewFourth){
        // [self.scrollView setContentOffset:CGPointMake(0, 340)];
        if ([self.textViewFourth.text isEqualToString:@""]) {
            self.answerPlaceHolderFourth.hidden=YES;
        }
        else{
            imageDescriptionCount = imageDescriptionCount-1;
        }
    }
    
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if(textView == self.questionTextView){
        if([textView.text isEqualToString:@""]){
            self.placeHolderLable.hidden=NO;
        }
    }
    else if(textView == self.textViewFirst){
        //[self.scrollView setContentOffset:CGPointMake(0, 170)];
        if([textView.text isEqualToString:@""]){
            self.answerPlaceHolderFirst.hidden=NO;
            
        }
        else{
            imageDescriptionCount=imageDescriptionCount+1;
        }
    }
    else if(textView == self.textViewSecond){
        //[self.scrollView setContentOffset:CGPointMake(0, 170)];
        if([textView.text isEqualToString:@""]){
            self.answerPlaceHolderSecond.hidden=NO;
            
        }
        else{
            imageDescriptionCount=imageDescriptionCount+1;
        }
    }
    else if(textView == self.textViewThird){
        //[self.scrollView setContentOffset:CGPointMake(0, 170)];
        if([textView.text isEqualToString:@""]){
            self.answerPlaceHolderThird.hidden=NO;
            
        }
        else{
            imageDescriptionCount=imageDescriptionCount+1;
        }
    }
    else if(textView == self.textViewFourth){
        // [self.scrollView setContentOffset:CGPointMake(0, 170)];
        if([textView.text isEqualToString:@""]){
            self.answerPlaceHolderFourth.hidden=NO;
            
        }
        else{
            imageDescriptionCount=imageDescriptionCount+1;
        }
    }
    
    return YES;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [searchBar becomeFirstResponder];
    //    if (!self.view.isKeyWindow) {
    //        [self.view makeKeyAndVisible];
    //    }
}
//--------------
#pragma mark
#pragma mark kiip

-(void)findPointsForSubmittingQuestion:(NSString *)response{
    NSArray *arr = [response componentsSeparatedByString:@","];
    NSString *str = [arr objectAtIndex:4];
    
    if ([str rangeOfString:@"Entertainment"].location !=NSNotFound) {
        strPoint = [str substringWithRange:NSMakeRange(24, [str length]-24)];
    }
    else if ([str rangeOfString:@"Shopping & Fashion"].location !=NSNotFound){
        strPoint = [str substringWithRange:NSMakeRange(29, [str length]-29)];
    }
    else if ([str rangeOfString:@"Sports"].location !=NSNotFound){
        strPoint = [str substringWithRange:NSMakeRange(17, [str length]-17)];
    }
    else if ([str rangeOfString:@"News & Politics"].location !=NSNotFound){
        strPoint = [str substringWithRange:NSMakeRange(26, [str length]-26)];
    }
    else if ([str rangeOfString:@"Food & Lifestyle"].location !=NSNotFound){
        strPoint = [str substringWithRange:NSMakeRange(27, [str length]-27)];
    }
    strPoint = [strPoint stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"STrpoint =-=- %@",strPoint);
    strPoint = [strPoint substringToIndex:[strPoint length]-2];
    NSLog(@"STrpoint =-=- %@",strPoint);
    [self showKiip];
}
-(void)showKiip{
    // Rajeev (KIIP)
    
    NSString * momentId = @"";
    NSString *momentValue = @"";
    if ([strCategory isEqualToString:@"Entertainment"]) {
        strCategoryName = @"Entertainment";
    }
    else if([strCategory isEqualToString:@"Shopping & Fashion"]){
        strCategoryName = @"Shopping & Fashion";
    }
    else if ([strCategory isEqualToString:@"Sports"]){
        strCategoryName = @"Sports";
    }
    else if ([strCategory isEqualToString:@"News & Politics"]){
        strCategoryName = @"News & Politics";
    }
    else if ([strCategory isEqualToString:@"Food & Lifestyle"]){
        strCategoryName = @"Food & Lifestyle";
    }
    
    int questionPoint = [strPoint integerValue];
    
    if (questionPoint>=10 && questionPoint<12) {
        NSString *strReward = [NSString stringWithFormat:@"hitting level 1 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"10";
    }
    else if (questionPoint>=20 && questionPoint<22){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 2 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"20";
    }
    else if (questionPoint>=40 && questionPoint<42){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 3 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"40";
    }
    else if (questionPoint>=70 && questionPoint<72){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 4 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"70";
    }
    else if (questionPoint>=110 && questionPoint<112){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 5 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"110";
    }
    else if (questionPoint>=170 && questionPoint<172){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 6 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"170";
    }
    else if (questionPoint>=250 && questionPoint<252){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 7 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"250";
    }
    else if (questionPoint>=330 && questionPoint<332){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 8 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"330";
    }
    else if (questionPoint>=410 && questionPoint<412){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 9 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"410";
    }
    else if (questionPoint>=500 && questionPoint<502){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 10 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"500";
    }
    else if (questionPoint>=600 && questionPoint<602){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 11 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"600";
    }
    else if (questionPoint>=700 && questionPoint<702){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 12 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"700";
    }
    else if (questionPoint>=800 && questionPoint<802){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 13 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"800";
    }
    else if(questionPoint>=900 && questionPoint<902)
    {
        NSString *strReward = [NSString stringWithFormat:@"hitting level 14 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"900";
    }
    
    if (momentId.length>0 && momentValue.length>0) {
        [[Kiip sharedInstance] saveMoment:momentId value:[momentValue doubleValue] withCompletionHandler:^(KPPoptart *poptart, NSError *error) {
            if (error) {
                [self showError:error];
            }
            
            // Since we've implemented this block, Kiip will no longer show the poptart automatically
            // WARNING: poptart may be nil if no reward was given
            //            poptart.delegate = self;
            [poptart show];
        }];
    }
}
- (void)showError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
