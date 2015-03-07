//
//  QuestionsViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 15/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "QuestionsViewController.h"
#import "AnswerQuestionViewController.h"
#import "MySingletonClass.h"
#import "UIImageView+WebCache.h"

#define  lastRefreshTime @"GRO_Main_Feed_lastrefreshtime"
@interface QuestionsViewController ()

@end

@implementation QuestionsViewController
@synthesize moreButton;
@synthesize questionTable;
@synthesize HUD;
@synthesize allFeedArray, avatarList,maxvotedImageArray, categoryListArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Hiding SubViews on Touch on View
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.notificationView.hidden=YES;
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
}

#pragma mark - 
#pragma mark Answer View Delegate
//Answer view delegate method
-(void)stopActivityIndicator{
    [HUD hide:YES];
}


#pragma mark -
//Notification Observer method for hiding Subviews
-(void)hideAllOtherView{
    self.notificationView.hidden=YES;
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
}

//Hiding other table when user start scrolling Question tabel
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView==self.questionTable) {
        self.notificationView.hidden=YES;
        self.categoryView.hidden=YES;
        self.subCategoryView.hidden=YES;
        
    }
}

#pragma mark -
//Refreshing Notification Count(Notification Observer Method)
-(void) refreshNotificationCount{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // send your notification here instead of in updateFunction
        //[[NSNotificationCenter defaultCenter] post...];
        [self getNumberOfNotification];
    });
}
//Fetching Notification Count
-(void)getNumberOfNotification{
    NSString *userID = [MySingletonClass sharedSingleton].groupinionUserID;
    NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/notification/index.php?uid=%@",userID];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *response = [self fetchAllCategories:urlString];
    
    if ([response isEqualToString:@"error"]) {
        NSLog(@"Error to Fetch Notification count");
    }
    else{
        if ([response rangeOfString:@"\"Status\":\"0\""].location !=NSNotFound || (NSNull *)response == [NSNull null] || [response rangeOfString:@"null"].location != NSNotFound) {
            NSLog(@"status 0 to Fetch Notification count");
        }
        else{
            NSDictionary *dddd=[response JSONValue];
            NSString *newNotiNumber = [NSString stringWithFormat:@"%@",[dddd objectForKey:@"Total Notifications"]];
            NSLog(@"Number of Notification ==%@",newNotiNumber);
            if ([newNotiNumber isEqualToString:@"0"]) {
                [MySingletonClass sharedSingleton].totalNotification=0;
                self.greenChatButton.hidden=YES;
            }
            else{
                
                NSLog(@"Do Nothing");
                
                // }//old notification is equals to new notification
                //  else{
                
                [self.greenChatButton setTitle:newNotiNumber forState:UIControlStateNormal];
                
                [MySingletonClass sharedSingleton].totalNotification=newNotiNumber;
                [self displayNotificationBubble];
                NSLog(@"Call web service for getting new questions");
                
                //   }//End else block number of new amd old notification check
                
            }//End block new notification == 0
            
            
        }//End Else block status check
        
    }//End else block error check
}
//Displaying Notification Count on button
-(void)displayNotificationBubble{
    
    NSString *totalNotification = [MySingletonClass sharedSingleton].totalNotification;
    
    NSLog(@"Total notificatioino==%@",totalNotification);
    if ([totalNotification isEqualToString:@"0"] || (NSNull *)totalNotification == [NSNull null] || totalNotification==nil || totalNotification == NULL) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        self.greenChatButton.hidden=YES;
    }
    else{
        
        if (!self.greenChatButton) {
            NSLog(@"first notification =%@",totalNotification);
            
            //dimension=53*48;
            self.greenChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.greenChatButton.frame = CGRectMake(232, 8, 38,37);
            [self.greenChatButton setBackgroundImage:[UIImage imageNamed:@"greenChatImg.png"] forState:UIControlStateNormal];
            
            [self.view addSubview:self.greenChatButton];
        }
        self.greenChatButton.hidden=NO;
        [self.greenChatButton setTitle:totalNotification forState:UIControlStateNormal];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:[totalNotification integerValue]];
        [self getAllNotificationQuestion];
    }//End Else Block Notification
}


//UI for display Notification Table
-(void)addViewToDisplayNotification{
    
    if (!self.notificationView) {
        
        self.notificationView = [[UIView alloc]initWithFrame:CGRectMake(115, 40, 200, 300)];
        [self.view addSubview:self.notificationView];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
        imgView.image=[UIImage imageNamed:@"notificationImage.png"];
        [self.notificationView addSubview:imgView];
        
        UIButton *clearNotificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearNotificationButton.frame = CGRectMake(140, 20, 40, 15) ;
        [clearNotificationButton setBackgroundImage:[UIImage imageNamed:@"clear_all.png"] forState:UIControlStateNormal];
        [clearNotificationButton addTarget:self action:@selector(clearAllNotificationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.notificationTable=[[UITableView alloc]initWithFrame:CGRectMake(30, 40, 158, 220) style:UITableViewStylePlain];
        self.notificationTable.delegate=self;
        self.notificationTable.dataSource=self;

        self.notificationTable.layer.cornerRadius=5.0;
        self.notificationTable.clipsToBounds=YES;
        [self.notificationView addSubview:self.notificationTable];
        
        
        [self.notificationView addSubview:clearNotificationButton];
        self.notificationView.hidden=YES;
    }
    else{
        [self.notificationTable reloadData];
    }
}
//Get All New Notification data(questions)
-(void)getAllNotificationQuestion{
    
    
    if (self.notificationarray.count>0) {
        [self.notificationarray removeAllObjects];
    }
    
    [self performSelectorOnMainThread:@selector(addViewToDisplayNotification) withObject:nil waitUntilDone:NO];
    
    //http://beta.groupinion.com/android/viewnotification/index.php?uid=1101
    NSString *userID = [MySingletonClass sharedSingleton].groupinionUserID;
    NSString *urlSting = [NSString stringWithFormat:@"http://beta.groupinion.com/android/viewnotification/index.php?uid=%@",userID];
    urlSting = [urlSting stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *response = [self fetchAllCategories:urlSting];
    
    if ([response isEqualToString:@"error"]) {
        
        
    }//End if Block response error check
    else{
        
        if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound || [response rangeOfString:@"null"].location != NSNotFound) {
            
            
        }//End if block response status check
        else{
            
            NSArray *notifyArray = [response JSONValue];
            
            if (!self.notificationarray) {
                self.notificationarray = [[NSMutableArray alloc]init];
            }
            
            for (int i =0 ; i<[notifyArray count]; i++) {
                NSDictionary *notiDict=[notifyArray objectAtIndex:i];
                [self.notificationarray addObject:notiDict];
            }
            
            if (self.notificationarray.count>0) {
                [self.notificationTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            
            //[self.notificationTable reloadData];
            
        }//Enld Else block response status check
    }//End else response error check
}
//Clear all notification
-(void)clearAllNotificationButtonClicked{
    [self.notificationarray removeAllObjects];
    [self.notificationTable reloadData];
    self.greenChatButton.hidden=YES;
    self.notificationView.hidden=YES;
    
    
    //[MySingletonClass sharedSingleton].totalNotification=@"0";
    NSString *userid=[MySingletonClass sharedSingleton].groupinionUserID;
    NSString *clearNotiUrlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/clearnotification/index.php?uid=%@",userid];
    clearNotiUrlString = [clearNotiUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *response = [self fetchAllCategories:clearNotiUrlString];
    
    if ([response isEqualToString:@"error"]) {
        
    }
    else{
        
        [MySingletonClass sharedSingleton].totalNotification=@"0";
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        NSLog(@"response to clear notification=%@",response);
    }
    
}

//Notification Button Clicked Action
-(void)greenChtButtonClicked{
    
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    if (self.notificationView.hidden==YES) {
        [self.view addSubview:self.notificationView];
        self.notificationView.hidden=NO;
    }
    else{
        self.notificationView.hidden=YES;
    }
}

//Refershing after Filter(Notification Observer Method)
//Displaying default View all question view
-(void)refreshAfterFilter{
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    self.notificationView.hidden=YES;
    
    [HUD hide:YES];
    
    BOOL reported = [MySingletonClass sharedSingleton].sendNotification;
    
    if(reported==YES){
        feedCount = 0;
        [MySingletonClass sharedSingleton].sendNotification=NO;
        [allFeedArray removeAllObjects];
        [avatarList removeAllObjects];
        [maxvotedImageArray removeAllObjects];
        [moreButton addTarget:self action:@selector(moreQuestion) forControlEvents:UIControlEventTouchUpInside];
        
        [self performSelectorOnMainThread:@selector(callWebServiceToFetchAllFeed) withObject:nil waitUntilDone:YES];
        // [self callWebServiceToFetchAllFeed];
        
    }
}
#pragma mark -

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [HUD hide:YES];
    checkScroll = YES;
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    self.notificationView.hidden=YES;
    
    BOOL reported = [MySingletonClass sharedSingleton].reported;
    
    if (reported==NO) {
        //Check last refresh time
        [self checkRefreshTime];
    }
    reported = [MySingletonClass sharedSingleton].reported;
    if(reported==YES){
        feedCount = 0;
        NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
        
        NSDate *cuDate =[NSDate date];
        NSLog(@"cu Date =%@",cuDate);
        NSDateFormatter *fo = [[NSDateFormatter alloc] init];
        [fo setDateFormat:@"mm"];
        NSString *ccc=[fo stringFromDate:cuDate];
        NSLog(@"cccc=%@",ccc);
        [user setObject:ccc forKey:lastRefreshTime];
        
        [MySingletonClass sharedSingleton].reported=NO;
        [allFeedArray removeAllObjects];
        [avatarList removeAllObjects];
        [maxvotedImageArray removeAllObjects];
        [moreButton addTarget:self action:@selector(moreQuestion) forControlEvents:UIControlEventTouchUpInside];
        [self callWebServiceToFetchAllFeed];
    }
    
    [activityIndicator stopAnimating];
    
}
//Checking Refresh Time
-(void)checkRefreshTime{
    
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    NSString *lastTime = [user objectForKey:lastRefreshTime];
    
    
    NSDate *cuDate =[NSDate date];
    NSLog(@"cu Date =%@",cuDate);
    
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"mm"];
    
    NSString *ccc=[fo stringFromDate:cuDate];
    NSLog(@"cccc=%@",ccc);
    
    
    if ([ccc integerValue]<[lastTime integerValue]) {
        [MySingletonClass sharedSingleton].reported=YES;
    }
    else{
        
        NSInteger a=[ccc integerValue] - [lastTime integerValue];
        //refresh after 5 min
        if (a>=5) {
            [MySingletonClass sharedSingleton].reported=YES;
        }
        
    }
}
//NOtification observer method for Refresh Questions
//Refresh All Questions
-(void)refreshMainFeed{
    
    
    NSLog(@"All Feed Array Count =%lu",(unsigned long)allFeedArray.count);
    
    
    if (!allFeedArray) {
        allFeedArray = [[NSMutableArray alloc]init];
        avatarList = [[NSMutableArray alloc]init];
        maxvotedImageArray = [[NSMutableArray alloc]init];
    }
    else{
        [allFeedArray removeAllObjects];
        [avatarList removeAllObjects];
        [maxvotedImageArray removeAllObjects];
    }
    
    feedCount=0;
    
    
    [moreButton addTarget:self action:@selector(moreQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self callWebServiceToFetchAllFeed];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    feedCount=0;
    checkScroll = YES;
    //add banner Image Of Groupinion
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"headFeed1Img.png"];
    [self.view addSubview:bannerImage];
    
    //Adding Green(Notification display) Button
    self.greenChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.greenChatButton.frame = CGRectMake(232, 8, 38,37);
    [self.greenChatButton setBackgroundImage:[UIImage imageNamed:@"greenChatImg.png"] forState:UIControlStateNormal];
    [self.greenChatButton addTarget:self action:@selector(greenChtButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.greenChatButton];
    
    //Add Observer Method for Refreshing Question
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainFeed) name:@"refreshView" object:nil];
    
    //Add Observer Method for Refreshing Question after filter
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterFilter) name:@"refreshAfterFilter" object:nil];
    
    //Add Observer Method for Refreshing Notification Count
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotificationCount) name:@"refreshBubble" object:nil];
    
    //Add Observer Method for Hiding SubViews
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllOtherView) name:@"hideView" object:nil];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self displayNotificationBubble];
        
    });
    
    //================================================
    //Add Search Button To View
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    menuButton.frame=CGRectMake(10, 12, 60, 26);
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"categoryButton.png"] forState:UIControlStateNormal];
    [self.view addSubview:menuButton];
    //===================================================
    //Add Setting Button To View
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(270, 8, 45, 35);
    settingBtn.clipsToBounds=NO;
    settingBtn.layer.cornerRadius=10.0f;
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    //================================================
    
    allFeedArray=[[NSMutableArray alloc]init];
    avatarList=  [[NSMutableArray alloc]init];
    maxvotedImageArray = [[NSMutableArray alloc]init];

    self.questionTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 110, 320, 300) style:UITableViewStylePlain];
    
    self.questionTable.dataSource=self;
    self.questionTable.delegate=self;
    
    [self.view addSubview:self.questionTable];
    //========================================
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 350, 40, 40)];
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    //[activityIndicator startAnimating];
    //-------------------------------------------------
    //New UI Code
    self.secondHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    self.secondHeaderView.image = [UIImage imageNamed:@"all_select.png"];
    [self.view addSubview:self.secondHeaderView];
    self.secondHeaderView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self.secondHeaderView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
//Setting Button Action
//Display Setting ViewController
-(void)settingButtonClicked{
    NSLog(@"Setting Button Clicked");
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    self.notificationView.hidden=YES;
    SettingViewController *setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:setting animated:YES];
}
//Getting more question
-(void)moreQuestion{
    self.categoryView.hidden=YES;
    self.subCategoryView.hidden=YES;
    self.notificationView.hidden=YES;
    feedCount=allFeedArray.count;
    [self callWebServiceToFetchAllFeed];
}

#pragma mark -
#pragma mark TableView Data Sourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.categoryTable) {
        return [categoryListArray count];
    }
    else if (tableView==self.questionTable){
        NSLog(@"Feed count = %d",allFeedArray.count);
        return [allFeedArray count];
    }
    else if (tableView==self.subCategoryTable)
    {
        return [subCategoryArray count];
    }
    else if (tableView==self.notificationTable){
        return self.notificationarray.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    for (UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    
    if (tableView==self.questionTable) {
        
        NSDictionary *elements=[allFeedArray objectAtIndex:indexPath.row];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(55, 0, 170, 50)];
        lbl.numberOfLines=2;
        lbl.lineBreakMode=NSLineBreakByTruncatingTail;
        lbl.font=[UIFont boldSystemFontOfSize:15.0f];
        lbl.textColor=[UIColor darkGrayColor];
        lbl.text=[[NSString stringWithFormat:@"%@",[elements objectForKey:@"Title"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
        
        [cell.contentView addSubview:lbl];
        //-----------------------------------------------
        NSString *urgent = [NSString stringWithFormat:@"%@",[elements objectForKey:@"urgent"]];
        if ([urgent isEqualToString:@"1"]) {
            UIImageView *urgentImage = [[UIImageView alloc] initWithFrame:CGRectMake(55, 10, 12, 25)];
            urgentImage.image = [UIImage imageNamed:@"exclanation_mark.png"];
            [cell.contentView addSubview:urgentImage];
            lbl.frame = CGRectMake(67, 0, 160, 50);
        }
        //------------------------------------------------
        UIImageView *profileImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 45, 50)];
        
        NSURL *url = [elements objectForKey:@"avatarImageUrl"];
        [profileImage setImageWithURL:url];
        [cell.contentView addSubview:profileImage];
        
        UILabel *nameLbl=[[UILabel alloc]initWithFrame:CGRectMake(55, 40, 165, 20)];
        nameLbl.font=[UIFont systemFontOfSize:15.0f];
        nameLbl.textColor=[UIColor grayColor];
        nameLbl.backgroundColor=[UIColor clearColor];
        nameLbl.text=[[NSString stringWithFormat:@"%@",[elements objectForKey:@"NickName"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
        [cell.contentView addSubview:nameLbl];
        
        
        NSString *vote=[NSString stringWithFormat:@"%@",[elements objectForKey:@"TotalVote"]];
        
        if([vote integerValue]==0){
            // Be The First Vote
            
            UIImageView *beFirst=[[UIImageView alloc]initWithFrame:CGRectMake(260, 23, 50, 20)];
            beFirst.image=[maxvotedImageArray objectAtIndex:indexPath.row];
            [cell.contentView addSubview:beFirst];
        }//End if Block check TotalVote
        else{
            
            // voteBar = "100, No"; questiontype=0
            //"100, 520dc743a6550.jpg";  if questiontype=1
            NSString *newvotebar = [elements objectForKey:@"voteBar"];
            NSArray *ary=[newvotebar componentsSeparatedByString:@","];
            // NSLog(@"ary = =%@",ary);
            NSString *percentageString=[ary objectAtIndex:0];
            
            //            NSString *ques_type = [elements objectForKey:@"QuestionType"];
            
            UILabel *percentageLable=[[UILabel alloc]initWithFrame:CGRectMake(225, 10, 40, 40)];
            percentageLable.backgroundColor=[UIColor clearColor];
            percentageLable.textColor=[UIColor darkGrayColor];
            percentageLable.textAlignment=NSTextAlignmentRight;
            percentageLable.numberOfLines=2;
            //percentageLable.font=[UIFont fontWithName:@"Arial" size:10];
            percentageLable.font=[UIFont systemFontOfSize:11];
            percentageLable.lineBreakMode=NSLineBreakByTruncatingTail;
            percentageLable.text=[NSString stringWithFormat:@"%@%% voted:",percentageString];
            [cell.contentView addSubview:percentageLable];
            
            //=========================================
            UILabel *vvv=[[UILabel alloc]initWithFrame:CGRectMake(260, 47, 60, 20)];
            vvv.backgroundColor=[UIColor clearColor];
            vvv.textColor=[UIColor darkGrayColor];
            vvv.textAlignment=NSTextAlignmentCenter;
            
            vvv.font=[UIFont fontWithName:@"Arial" size:11];
            
            vvv.text=@"Vote Now!";
            [cell.contentView addSubview:vvv];
            //===================================
            UIImageView *maxVotedImage=[[UIImageView alloc]initWithFrame:CGRectMake(270, 4, 45, 45)];
            maxVotedImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
            maxVotedImage.layer.borderWidth=1.0;
            maxVotedImage.image=[maxvotedImageArray objectAtIndex:indexPath.row];
            [cell.contentView addSubview:maxVotedImage];
            
            
        }//End else block total vote
        
    }//Table Check Question Table End
    else if (tableView==self.categoryTable) {
        
        cell.textLabel.text=[[categoryListArray objectAtIndex:indexPath.row]objectForKey:@"Category"];
        
        
    }
    else if(tableView==self.subCategoryTable) {
        
        NSString *removeUnWantedChars=[[subCategoryArray objectAtIndex:indexPath.row]objectForKey:@"SubCategory"];
        cell.textLabel.text=[removeUnWantedChars stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    }
    else if (tableView == self.notificationTable){
        
        NSMutableDictionary *notiDict=[self.notificationarray objectAtIndex:indexPath.row];
        NSString *mes = [NSString stringWithFormat:@"%@",[notiDict objectForKey:@"Description"]];
        cell.textLabel.numberOfLines=2;
        cell.textLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.text=mes;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.categoryTable) {
        return 57;
    }
    else if (tableView==self.notificationTable){
        return 40;
    }
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.questionTable) {
        
        self.categoryView.hidden=YES;
        self.subCategoryView.hidden=YES;
        self.notificationView.hidden=YES;
        
        [activityIndicator startAnimating];
        
        NSDictionary *dict=[allFeedArray objectAtIndex:indexPath.row];
       
        [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
        
        AnswerQuestionViewController *ansQues=[[AnswerQuestionViewController alloc]initWithNibName:@"AnswerQuestionViewController" bundle:nil];
        ansQues.displayNextQues=YES;
        ansQues.dict=(NSMutableDictionary *)dict;
        
        
        ansQues.ansQuesDelegate=self;
        [self.navigationController pushViewController:ansQues animated:YES];
        
    }
    else if(tableView==self.categoryTable)
    {
        NSLog(@"catergory table selected");
        NSDictionary *dict=[categoryListArray objectAtIndex:indexPath.row];
        
        // Added By Rajeev
        NSString *catID=[dict objectForKey:@"CategoryID"];
        self.categoryView.hidden=YES;
        self.notificationView.hidden=YES;
        if ([catID isEqualToString:@"All"]) {
            NSLog(@"Category all is selected...");
            
            feedCount=0;
            checkScroll = YES;

            [allFeedArray removeAllObjects];
            [avatarList removeAllObjects];
            [maxvotedImageArray removeAllObjects];
            if (currentTap == 0) {
                NSLog(@"All Question Tab ");
                [self callWebServiceToFetchAllFeed];
            }
            else if (currentTap == 1){
                NSLog(@"Friend Question Tab ");
                [self friendTapedAction];
            }
            else if (currentTap == 2){
                NSLog(@"Following Question Tab ");
                [self followingTapedAction];
            }

            else{
                NSLog(@"Unknown Tap");
            }
        }
        //==================================================
        else{
            [self showAllSubCategoryList:catID];
            
        }
    }
    else if(tableView==self.subCategoryTable)
    {
        feedCount=0;
        checkScroll = YES;
        [MySingletonClass sharedSingleton].reported=YES;
        [MySingletonClass sharedSingleton].sendNotification=YES;

        [allFeedArray removeAllObjects];
        [avatarList removeAllObjects];
        [maxvotedImageArray removeAllObjects];
        NSDictionary *dict=[subCategoryArray objectAtIndex:indexPath.row];
        NSString *subCatID=[dict objectForKey:@"CategoryID"];
        if (currentTap == 0) {
            [self fetchFeedBySelectedSubCategory:subCatID];
            NSLog(@"All Question Tab filter");
        }
        else if (currentTap == 1){
            NSLog(@"Friend Question Tab Filter");
            [self showFriendsFilterFeeds:subCatID];
        }
        else if (currentTap == 2){
            NSLog(@"Following Question Tab Filter");
            [self showFollowingFilterFeeds:subCatID];
        }

        else{
            NSLog(@"Unknown Tap");
        }
        
        
    }
    else if (tableView == self.notificationTable){
        NSLog(@"Row clicked =%d",indexPath.row);
        NSDictionary *notiDict = [self.notificationarray objectAtIndex:indexPath.row];
        NSString *uniQue = [NSString stringWithFormat:@"%@",[notiDict objectForKey:@"Unique_que"]];
        
        [self.notificationarray removeObjectAtIndex:indexPath.row] ;
        [NSThread detachNewThreadSelector:@selector(hideNotificationView) toTarget:self withObject:nil];
        
        [self getNextQuestion:uniQue];
    }
}

#pragma mark - 
#pragma mark ScrollView Delegate
//Checking Scrolling
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    if (checkScroll==YES && allFeedArray.count>4) {
        
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 80;
        if(y > h + reload_distance) {
            self.questionTable.frame = CGRectMake(0, 52, 320, 260);
            checkScroll = NO;
            if (self.indicatorLabel) {
                self.indicatorLabel.hidden=NO;
            }
            else{
                self.indicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 370, 320, 30)];
                self.indicatorLabel.backgroundColor = [UIColor clearColor];
                self.indicatorLabel.textAlignment = NSTextAlignmentCenter;
                self.indicatorLabel.textColor = [UIColor lightGrayColor];
                self.indicatorLabel.text=@"Loading";
                [self.view addSubview:self.indicatorLabel];
            }
            [activityIndicator startAnimating];
            //[self loadMoreQuestions];
            [self performSelector:@selector(loadMoreQuestions) withObject:nil afterDelay:3];
            NSLog(@"pos: %f of %f", y, h);
            NSLog(@"load more rows");
        }
    }
    
}
//Loading more Questions
-(void) loadMoreQuestions{
     NSString *urlString = nil;
    NSString *userid = [MySingletonClass sharedSingleton].groupinionUserID;
    feedCount = allFeedArray.count;
    if ([lastCalledUrl isEqualToString:@"allQuestions"]) {
        NSLog(@"All Question More");
        urlString =[NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_getallquestion_with_thumbimage_and_newvotebar/index.php?to=%d&userid=%@",feedCount,userid];
    }
    else if ([lastCalledUrl isEqualToString:@"allQuestionsFilter"]){
        NSLog(@"All filter Question More");
        urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_filterquestionfeed_with_thumbimage_and_newvotebar/index.php?subcatid=%@&limit=%d&userid=%@",lastSelectedsubCategoryID,feedCount,userid];
    }
    else if ([lastCalledUrl isEqualToString:@"FriendsQuestions"]){
        NSLog(@"All Friends Question More");
        urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/getfbfriends/?uid=%@&limit=%d",userid,feedCount];
    }
    else if ([lastCalledUrl isEqualToString:@"FriendsQuestionsFilter"]){
        // http://beta.groupinion.com/android/getfriends_filterquestionfeed/index.php?subcatid=All&limit=0&userid=477
        urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/getfriends_filterquestionfeed/index.php?subcatid=%@&limit=%d&userid=%@",lastSelectedsubCategoryID,feedCount,userid];
        NSLog(@"All Friend Filter Question More");
    }
    else if ([lastCalledUrl isEqualToString:@"FollowingQuestions"]){
        NSLog(@"All Following Question More");
        urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/getfollowers/?uid=%@&limit=%d",userid,feedCount];
    }
    else if ([lastCalledUrl isEqualToString:@"FollowingQuestionsFilter"]){
        NSLog(@"All Following Filter Question More");
        urlString =[NSString stringWithFormat:@"http://beta.groupinion.com/android/getfollowers_filterquestionfeed/index.php?subcatid=%@&limit=%d&userid=%@",lastSelectedsubCategoryID,feedCount,userid];
    }
    [self loadAllTabMoreQuestions:urlString];
    self.questionTable.frame = CGRectMake(0, 110, 320, 300);
    
    [activityIndicator stopAnimating];
    self.indicatorLabel.hidden=YES;
}
//Getting more questions
-(void)loadAllTabMoreQuestions:(NSString *) urlString{
    
    NSString *response = [self fetchAllCategories:urlString];
    if ([response isEqualToString:@"error"]) {
        NSLog(@"Error");
    }
    else{
        if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
            NSLog(@"No more Questions");
            checkScroll = NO;
        }
        else{
            NSArray *jsonArray = [response JSONValue];
            NSMutableDictionary *dict=nil;
            
            for (int i =0; i<[jsonArray count]; i++) {
                dict=[jsonArray objectAtIndex:i];
                [self newCreateTableCallElements:dict];
            }
            
            checkScroll = YES;
        }
    }
}
//Fetching require Data from Json Response
-(void)newCreateTableCallElements:(NSMutableDictionary *)feed{
    
    NSString *imageUploaded = [NSString stringWithFormat:@"%@", [feed objectForKey:@"Default_image_status"]];
    NSURL *url=nil;
    
    //Checking Image set by User or Not
    if ([imageUploaded isEqualToString:@"0"]) {
        //if image not set
        NSString *fbID=[NSString stringWithFormat:@"%@",[feed objectForKey:@"dbcsFacebookProfile"]];
        //Checking question owner connected with Facebook or not
        if([fbID isEqualToString:@"0"]){
            //if not than set Groupinion logo as Profile Pic
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/0_avatar_75_75.jpg"]];
        }
        else{
            
            //fecth image from faceboook
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",fbID]];
        }
        
    }//End imageUploaded if block
    else{
        //if image set
        //get profile image
        NSString *avatarImage=[NSString stringWithFormat:@"%@",[feed objectForKey:@"avatarImage"]];
        
        //        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/avatar/data/images/%@",avatarImage]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",avatarImage]];
        
    }//End imageUploded Else block
    
    //==================================================
    //Check vote count
    NSString *vote=[feed objectForKey:@"TotalVote"];
    UIImage *proImage=nil;
    if ([vote isEqualToString:@"0"]) {
        
        proImage = [UIImage imageNamed:@"beFirst.png"];
    }
    else{
        
        NSString *newvotebar = [feed objectForKey:@"voteBar"];
        NSArray *ary=[newvotebar componentsSeparatedByString:@","];
        NSString *ques_type = [feed objectForKey:@"QuestionType"];
        
        //Checking Multiple Choice question or Single Choice Question
        if ([ques_type isEqualToString:@"1"]) {
            //MUltiple choice question
            //fetch maximum voted image
            NSString *imageName=[ary objectAtIndex:2];
            imageName=[imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString *str=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_75_75/%@",imageName];
            proImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
            
            
        }//check if block End
        else{
            //Yes no Question
            NSString *votedTo=[ary objectAtIndex:1];
            if ([votedTo rangeOfString:@"Yes"].location != NSNotFound) {
                
                proImage=[UIImage imageNamed:@"yesimg.png"];
            }
            else{
                proImage=[UIImage imageNamed:@"noimg.png"];
                
            }
            
        }//End else block ques_type
    }
    
    if (url != nil && proImage != nil) {
        [feed setObject:url forKey:@"avatarImageUrl"];
        // [feed setObject:image forKey:@"avatardownloadedimage"];
        [allFeedArray addObject:feed];
        [maxvotedImageArray addObject:proImage];
        
        [self.questionTable beginUpdates];
        [self.questionTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:allFeedArray.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.questionTable endUpdates];
    }
    
    //===================================================
    
}
#pragma mark -
//Hiding NOtifiaction view
-(void)hideNotificationView{
    self.notificationView.hidden=YES;
    NSString *notiTotal=[MySingletonClass sharedSingleton].totalNotification;
    notiTotal = [NSString stringWithFormat:@"%d",[notiTotal integerValue] - 1];
    
    if ([notiTotal isEqualToString:@"0"]) {
        self.greenChatButton.hidden=YES;
    }
    [MySingletonClass sharedSingleton].totalNotification=notiTotal;
    [self.greenChatButton setTitle:notiTotal forState:UIControlStateNormal];
    
    
    [self.notificationTable reloadData];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:[notiTotal integerValue]];
}
#pragma mark -
//Getting notifiaction question details
-(void)getNextQuestion:(NSString *)uniqueID{
    
    [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
    //NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
    
    
    //http://beta.groupinion.com/android/new_directquestionview/?q=VOsmh&read=0
   // http://beta.groupinion.com/android/ios_new_directquestionview/?q=%@&read=1&uid=1113
    NSString *uid = [MySingletonClass sharedSingleton].groupinionUserID;
    NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_new_directquestionview/?q=%@&read=1&uid=%@",uniqueID,uid];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *nextQuesResponse = [self fetchAllCategories:urlString];
    
    NSLog(@"Next Question Response = %@",nextQuesResponse);
    
    if([nextQuesResponse isEqualToString:@"error"]){
        [HUD hide:YES];
    }
    else{
        if([nextQuesResponse rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            
            [HUD hide:YES];
            //NSArray *ary = [nextQuesResponse JSONValue];
            NSDictionary *dict11 = [nextQuesResponse JSONValue];
            NSString *msg = [dict11 objectForKey:@"Message"];
            
            [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
        else{
            
            // NSArray *ary = [nextQuesResponse JSONValue];
            NSMutableDictionary *nextQuesDict = [nextQuesResponse JSONValue];
            NSLog(@"nextDict= %@", nextQuesDict);
            
            //Switch to AnswerViewController
            AnswerQuestionViewController *ansQues=[[AnswerQuestionViewController alloc]initWithNibName:@"AnswerQuestionViewController" bundle:nil];
            ansQues.displayNextQues=YES;
            ansQues.dict=nextQuesDict;
            ansQues.ansQuesDelegate=self;
            [self.navigationController pushViewController:ansQues animated:YES];
        }
    }
}
#pragma mark -
-(void) showActivityIndicator{
    
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground=YES;
    [self.view addSubview:HUD];
    
    
    [HUD show:YES];
}

#pragma mark All Filter Feed
//Prepare service for filter questions
-(void)fetchFeedBySelectedSubCategory:(NSString *)urlString
{
    [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
    checkScroll = YES;
    self.subCategoryView.hidden=YES;
    [activityIndicator startAnimating];
    lastSelectedsubCategoryID=urlString;
    NSString *userID = [MySingletonClass sharedSingleton].groupinionUserID;
    
    
    //http://beta.groupinion.com/android/ios_filterquestionfeed_with_thumbimage_and_newvotebar/index.php?subcatid=4&limit=0&userid=1113
    
    NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_filterquestionfeed_with_thumbimage_and_newvotebar/index.php?subcatid=%@&limit=%d&userid=%@",lastSelectedsubCategoryID,feedCount,userID];
    lastCalledUrl = @"allQuestionsFilter";
    allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //[dict setObject:@"50cb8685a6904" forKey:@"code"];
    
    NSString *jsonstring1  = [dict JSONRepresentation];
    
    NSLog(@"ssss  ===%@",jsonstring1);
    NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
    //[dict release];
    NSLog(@"56566=====%@",post1);
    //make request
    [self sendHTTPPost:jsonstring1 :allFeedUrl] ;
    
}
#pragma mark Friends Filter Feed
//Fetching Only Friends question on the basis on selected filter type
-(void) showFriendsFilterFeeds:(NSString *)catID{
    [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
    checkScroll = YES;
    self.subCategoryView.hidden=YES;
    [activityIndicator startAnimating];
    lastSelectedsubCategoryID=catID;
    NSString *userID = [MySingletonClass sharedSingleton].groupinionUserID;
    
    
    //http://beta.groupinion.com/android/ios_filterquestionfeed_with_thumbimage_and_newvotebar/index.php?subcatid=4&limit=0&userid=1113
    
    NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/getfriends_filterquestionfeed/index.php?subcatid=%@&limit=%d&userid=%@",lastSelectedsubCategoryID,feedCount,userID];
    lastCalledUrl = @"FriendsQuestionsFilter";
    allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //[dict setObject:@"50cb8685a6904" forKey:@"code"];
    
    NSString *jsonstring1  = [dict JSONRepresentation];
    
    NSLog(@"ssss  ===%@",jsonstring1);
    NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
    //[dict release];
    NSLog(@"56566=====%@",post1);
    
    [self sendHTTPPost:jsonstring1 :allFeedUrl] ;
}
#pragma mark Following Filter Feed
//Fetching Only Following question on the basis on selected filter type
-(void) showFollowingFilterFeeds:(NSString *)catID{
    [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
    checkScroll = YES;
    self.subCategoryView.hidden=YES;
    [activityIndicator startAnimating];
    lastSelectedsubCategoryID=catID;
    NSString *userID = [MySingletonClass sharedSingleton].groupinionUserID;
    
    // http://beta.groupinion.com/android/getfollowers_filterquestionfeed/index.php?subcatid=2&limit=0&userid=1113
    
    NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/getfollowers_filterquestionfeed/index.php?subcatid=%@&limit=%d&userid=%@",lastSelectedsubCategoryID,feedCount,userID];
    lastCalledUrl = @"FollowingQuestionsFilter";
    allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //[dict setObject:@"50cb8685a6904" forKey:@"code"];
    
    NSString *jsonstring1  = [dict JSONRepresentation];
    
    NSLog(@"ssss  ===%@",jsonstring1);
    NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
    //[dict release];
    NSLog(@"56566=====%@",post1);
    
    [self sendHTTPPost:jsonstring1 :allFeedUrl] ;
}
#pragma mark -
#pragma mark Filter urgent Question
/*
- (void) filterUrgentQuestions : (NSString *)catID{
    NSLog(@"Filter Urgent Questions");
}*/
#pragma mark -
//Display all subcategory List
-(void)showAllSubCategoryList:(NSString *)catId{
    self.categoryView.hidden=YES;
    
    if (!self.subCategoryView) {
        
        self.subCategoryView = [[UIView alloc]initWithFrame:CGRectMake(10, 40, 280, 320)];
        [self.view addSubview:self.subCategoryView];
        
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 60)];
        
        imgView.image=[UIImage imageNamed:@"choose_subcategory_Header.png"];
        
        
        self.subCategoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, 280, 270) style:UITableViewStylePlain];
        self.subCategoryTable.delegate=self;
        self.subCategoryTable.dataSource=self;
        self.subCategoryTable.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorImages.png"]].CGColor;
        self.subCategoryTable.layer.borderWidth=5.0;
        self.subCategoryTable.layer.cornerRadius=5.0;
        self.subCategoryTable.clipsToBounds=YES;
        subCategoryArray=[[NSMutableArray alloc]init];
        [self.subCategoryView addSubview:self.subCategoryTable];
        
        [self.subCategoryView addSubview:imgView];
    }
    else{
        self.subCategoryTable.contentOffset=CGPointMake(0, 0);
        self.subCategoryView.hidden=NO;
    }
    [subCategoryArray removeAllObjects];
    
    NSString *urlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/subcategories/index.php?catid=%@",catId];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonResponse=[self fetchAllCategories:urlString];
    
    if([jsonResponse rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
        
        //NSArray *ary=[jsonResponse JSONValue];
        NSDictionary *dict11 = [jsonResponse JSONValue];
        NSString *msg = [dict11 objectForKey:@"Message"];
        
        [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        NSArray *jsonArray=[jsonResponse JSONValue];
        
        if([jsonArray count]>0){
            
            for (int i=0; i<jsonArray.count; i++) {
                NSDictionary *dict=[jsonArray objectAtIndex:i];
                [subCategoryArray addObject:dict];
            }
            //NSLog(@"SubCategory Array-%@",subCategoryArray);
            
            [self.subCategoryTable reloadData];
        }
        
    }
}

#pragma mark -
#pragma mark Json Parsing
//Prepare service for geting all questios
-(void)callWebServiceToFetchAllFeed{
    
    NSString *userid = [MySingletonClass sharedSingleton].groupinionUserID;
    [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
    currentTap = 0;
    self.secondHeaderView.image = [UIImage imageNamed:@"all_select.png"];
    
    //http://beta.groupinion.com/android/ios_getallquestion_with_thumbimage_and_newvotebar/index.php?to=0&userid=959
    [activityIndicator startAnimating];
    NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_getallquestion_with_thumbimage_and_newvotebar/index.php?to=%d&userid=%@",feedCount,userid];
    
    lastCalledUrl = @"allQuestions";
    
    allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //[dict setObject:@"50cb8685a6904" forKey:@"code"];
    
    NSString *jsonstring1  = [dict JSONRepresentation];
    
    NSLog(@"ssss  ===%@",jsonstring1);
    NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
    //[dict release];
    NSLog(@"56566=====%@",post1);
    
    [self sendHTTPPost:jsonstring1 :allFeedUrl] ;
}

-(void)sendHTTPPost:(NSString* )json_string :(NSString *)m_pURLAddr{
    
	NSURL *l_pURL = [NSURL URLWithString:m_pURLAddr];
    NSLog(@"Url===%@",l_pURL);
    
 	NSMutableURLRequest *l_pRequest = [[NSMutableURLRequest alloc]initWithURL:l_pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100.0];
	NSLog(@"request===\%@",l_pRequest);
	if(json_string != nil){
		[l_pRequest setHTTPBody:[json_string dataUsingEncoding:NSUTF8StringEncoding]];
		
        [l_pRequest setHTTPMethod:@"POST"];
        NSURLConnection *l_pConn = [[NSURLConnection alloc]initWithRequest:l_pRequest delegate:self startImmediately:NO];
        [l_pConn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [l_pConn start];
        
        
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //[mData release];
	mData = [[NSMutableData alloc]init];
	
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[mData appendData:data];
    
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"No connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    NSLog(@"Error==%@",error);
    [HUD hide:YES];
    [activityIndicator stopAnimating];
	[alert show];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    successData = YES;
	[self webServiceRequestCompleted];
    
}

-(void)webServiceRequestCompleted{
    
    if(!successData){
        return;
    }
    NSString *json_string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
    // NSLog(@"json_String==%@",json_string);
    
    if([json_string rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
        
        // NSArray *ary=[json_string JSONValue];
         [self.questionTable reloadData];
        [HUD hide:YES];
        NSDictionary *dict11 = [json_string JSONValue];
        NSString *msg = [dict11 objectForKey:@"Message"];
        
        [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        
        NSArray *resultArray=[json_string JSONValue];
        if([resultArray count]==0)
        {
            [self.questionTable reloadData];
            [HUD hide:YES];
            [[[UIAlertView alloc] initWithTitle:@"" message:@"No More Questions" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            NSMutableDictionary *dict=nil;
            // NSString *userID = [MySingletonClass sharedSingleton].groupinionUserID;
            for (int i =0; i<[resultArray count]; i++) {
                dict=[resultArray objectAtIndex:i];
                
                [self CreateTableCallElements:dict];
                
            }
             [self.questionTable reloadData];
            
        }
        
    }
    
   [activityIndicator stopAnimating];
    [HUD hide:YES];
}

-(void)CreateTableCallElements:(NSMutableDictionary *)feed{
    
    NSString *imageUploaded = [NSString stringWithFormat:@"%@", [feed objectForKey:@"Default_image_status"]];
    NSURL *url=nil;
    
    
    if ([imageUploaded isEqualToString:@"0"]) {
        
        NSString *fbID=[NSString stringWithFormat:@"%@",[feed objectForKey:@"dbcsFacebookProfile"]];
        
        if([fbID isEqualToString:@"0"]){
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/0_avatar_75_75.jpg"]];
        }
        else{
            
            
            url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",fbID]];
        }
        
    }//End imageUploaded if block
    else{
        
        NSString *avatarImage=[NSString stringWithFormat:@"%@",[feed objectForKey:@"avatarImage"]];
        
        //        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/avatar/data/images/%@",avatarImage]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",avatarImage]];
        
    }//End imageUploded Else block
    
    //===============================================
    
    NSString *vote=[feed objectForKey:@"TotalVote"];
    UIImage *proImage=nil;
    if ([vote isEqualToString:@"0"]) {
        //be the first vote
        proImage = [UIImage imageNamed:@"beFirst.png"];
    }
    else{
        
        NSString *newvotebar = [feed objectForKey:@"voteBar"];
        NSArray *ary=[newvotebar componentsSeparatedByString:@","];
        //NSLog(@"ary = =%@",ary);
        // NSString *percentageString=[ary objectAtIndex:0];
        NSString *ques_type = [feed objectForKey:@"QuestionType"];
        if ([ques_type isEqualToString:@"1"]) {
            //Multile Choice question
            NSString *imageName=[ary objectAtIndex:2];
            imageName=[imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            //            NSString *str=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@",imageName];
            NSString *str=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_75_75/%@",imageName];
            proImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
            
            
        }//check if block End
        else{
            
            NSString *votedTo=[ary objectAtIndex:1];
            if ([votedTo rangeOfString:@"Yes"].location != NSNotFound) {
                
                proImage=[UIImage imageNamed:@"yesimg.png"];
            }
            else{
                proImage=[UIImage imageNamed:@"noimg.png"];
                
            }
            
        }//End else block ques_type
    }
    
    if (url != nil && proImage != nil) {
        [feed setObject:url forKey:@"avatarImageUrl"];
        // [feed setObject:image forKey:@"avatardownloadedimage"];
        [allFeedArray addObject:feed];
        [maxvotedImageArray addObject:proImage];
    }
    
    //===========================================================
    
}
#pragma mark -
//Display Filter Menu option
-(void)showMenu{
    
    if (self.categoryView && self.categoryView.hidden==NO) {
        self.categoryView.hidden=YES;
        return;
    }
    self.subCategoryView.hidden=YES;
    self.notificationView.hidden=YES;
    //Checking if Category list allready fetched
    if(![categoryListArray count]>0){
        categoryListArray = [[NSMutableArray alloc]init];
        
        NSString *urlString=@"http://beta.groupinion.com/android/all_categories/";
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *response=[self fetchAllCategories:urlString];
        
        if([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            
            //NSArray *ary=[response JSONValue];
            NSDictionary *dict11 = [response JSONValue];
            NSString *msg = [dict11 objectForKey:@"Message"];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            NSArray *jsonArray=[response JSONValue];
            
            for (int i=0; i<[jsonArray count]; i++) {
                NSDictionary *dict=[jsonArray objectAtIndex:i];
                [categoryListArray addObject:dict];
                NSLog(@"category==%@",[dict objectForKey:@"Category"]);
                [MySingletonClass sharedSingleton].categoryListArray = categoryListArray;
            }
            
            // NSLog(@"category list==%@",categoryListArray);
            NSLog(@"catrgory cout==%lu",(unsigned long)[categoryListArray count]);
            
            [self tableviewDisplayCatagories];
        }
    }
    else{
        [self.categoryTable setContentOffset:CGPointMake(0, 0)];
        self.categoryView.hidden=NO;
        
    }
}
//UI for display category Table
-(void)tableviewDisplayCatagories
{
    
    self.categoryView=[[UIView alloc]initWithFrame:CGRectMake(10, 40, 280, 320)];
    [self.view addSubview:self.categoryView];
    
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 60)];
    imgView.image=[UIImage imageNamed:@"choose_category_Header.png"];
    
    self.categoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 55, 280, 270) style:UITableViewStylePlain];
    self.categoryTable.delegate=self;
    self.categoryTable.dataSource=self;
    //self.categoryTable.layer.borderColor = [UIColor cyanColor].CGColor;
    UIColor *co= [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorImages.png"]];
    self.categoryTable.layer.borderColor = co.CGColor;
    self.categoryTable.layer.borderWidth=5.0;
    
    self.categoryTable.layer.cornerRadius=5.0;
    self.categoryTable.clipsToBounds=YES;
    [self.categoryView addSubview:self.categoryTable];
    
    [self.categoryView addSubview:imgView];
}

//send request to server
-(NSString *)fetchAllCategories:(NSString *)urlString{
    
    //http://beta.groupinion.com/android/categories/
    NSURL *url=[NSURL URLWithString:urlString];
    
    NSHTTPURLResponse   * response;
    NSError *error;
    NSLog(@"url==%@",url);
    // NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100.0];
    
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *respo=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    // NSLog(@"respo==%@",respo);
    
    return respo;
    
}


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
#pragma mark New-
//Handle Tap Gesture on All,Friend,Following Banner(second Banner)
-(void) handleTapGesture:(id)sender{
    
    UIView *v = (UIControl *)sender;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)v;
    [self.questionTable setContentOffset:CGPointZero];
    
    CGPoint touchPoint =[tap locationInView:self.secondHeaderView];
    NSLog(@"x=%f  and  y=%f",touchPoint.x,touchPoint.y);
    
    CGFloat x = touchPoint.x;
    //Checking Touch Point
    if (x>40 && x<70 && currentTap !=0) {
        //All tap seleccted
        if (currentTap != 0) {
            currentTap=0;
            //feedCount=0;
            self.secondHeaderView.image = [UIImage imageNamed:@"all_select.png"];
            [self allTapedAction];
        }
        
    }
    else if (x>120 && x<185 && currentTap !=1){
        //Friend Tap Selected
        if (currentTap != 1) {
            currentTap=1;
            self.secondHeaderView.image = [UIImage imageNamed:@"friends_select.png"];
            [self friendTapedAction];
        }
        
    }
    else if (x>230 && x<310 && currentTap !=2){
        //Following Tap Selected
        if (currentTap !=2) {
            currentTap=2;
            self.secondHeaderView.image = [UIImage imageNamed:@"following_select.png"];
            [self followingTapedAction];
        }
        
    }
}
//Action after selecting All Tab
-(void) allTapedAction{
    feedCount = 0;
    checkScroll=YES;
    [MySingletonClass sharedSingleton].sendNotification=NO;
    self.questionTable.hidden=NO;
    [allFeedArray removeAllObjects];
    [maxvotedImageArray removeAllObjects];
    [avatarList removeAllObjects];
    [self callWebServiceToFetchAllFeed];
    NSLog(@"All Tap ");
}
//Action after selecting Friends Tab
-(void) friendTapedAction{
    NSLog(@"Friends Tap");
    //self.questionTable.hidden = YES;
    [activityIndicator startAnimating];
    [allFeedArray removeAllObjects];
    [maxvotedImageArray removeAllObjects];
    [avatarList removeAllObjects];
   feedCount = 0;
    checkScroll=YES;
    [MySingletonClass sharedSingleton].sendNotification=YES;
      NSString *userid = [MySingletonClass sharedSingleton].groupinionUserID;
     [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
     
     
    
     NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/getfbfriends/?uid=%@&limit=%d",userid,feedCount];
                           
     lastCalledUrl = @"FriendsQuestions";
     allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
     
     NSString *jsonstring1  = [dict JSONRepresentation];
     
     NSLog(@"ssss  ===%@",jsonstring1);
     NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
     
     NSLog(@"56566=====%@",post1);
     
     [self sendHTTPPost:jsonstring1 :allFeedUrl] ;
    
}
//Action after selecting Following Tab
-(void) followingTapedAction{
    NSLog(@"Following Tap");
    //self.questionTable.hidden=YES;
      NSString *userid = [MySingletonClass sharedSingleton].groupinionUserID;
    [MySingletonClass sharedSingleton].sendNotification=YES;
     [NSThread detachNewThreadSelector:@selector(showActivityIndicator) toTarget:self withObject:nil];
     
     feedCount = 0;
    checkScroll=YES;
     [activityIndicator startAnimating];
    [allFeedArray removeAllObjects];
    [maxvotedImageArray removeAllObjects];
    [avatarList removeAllObjects];
     NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/getfollowers/?uid=%@&limit=%d",userid,feedCount];
     lastCalledUrl = @"FollowingQuestions";
     allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
     NSString *jsonstring1  = [dict JSONRepresentation];
     NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
     NSLog(@"56566=====%@",post1);
     
     [self sendHTTPPost:jsonstring1 :allFeedUrl] ;
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    //[HUD release];
    HUD = nil;
}
@end
