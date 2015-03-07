//
//  AnswerQuestionViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 17/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "AnswerQuestionViewController.h"
#import "JSON.h"
#import "MySingletonClass.h"
#import "SendHttpRequest.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"


@interface AnswerQuestionViewController ()
{
    SDWebImageManager *sdImageManager;
}
@end

@implementation AnswerQuestionViewController
@synthesize name,dict,HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}
//Back BUtton Action
-(void)backButtonClicked{

    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.commentTextView resignFirstResponder];
    
}
-(void)hideKeyboard{
    [self.commentTextView resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
        voted=NO;
    voteValue=@"";
    startLimit=0;
    endLimit=100;
    //add banner Image Of Groupinion
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"Answer_question.png"];
    [self.view addSubview:bannerImage];
    
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 52, self.view.bounds.size.width, 400)];
    self.scrollView.delegate=self;
    self.scrollView.contentSize=CGSizeMake(self.view.bounds.size.width, 600);
    [self.view addSubview:self.scrollView];
    
    //Adding Gesture Recognizer on Scorll View
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired=1;
    [self.scrollView addGestureRecognizer:tap];
    
    self.nameLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 320, 30)];
    self.nameLable.textAlignment=NSTextAlignmentLeft;
    self.nameLable.font=[UIFont boldSystemFontOfSize:17];
    
    [self.scrollView addSubview:self.nameLable];
    
    
    
    self.tickMarkImageView.hidden=YES;
    //===================================================================
    //Add Setting Button To View
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame= CGRectMake(260, 8, 50, 35);
    settingBtn.enabled=YES;
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    //=========================================================
    //Add Setting Button To View
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame= CGRectMake(10, 8, 60, 35);
    
    backBtn.enabled=YES;
    [backBtn setBackgroundImage:[UIImage imageNamed:@"Back_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //========================================================
    self.reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reportButton.frame = CGRectMake(250, 1, 60, 30);
    [self.reportButton setBackgroundImage:[UIImage imageNamed:@"report_new.png"] forState:UIControlStateNormal];
    [self.reportButton addTarget:self action:@selector(reportButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.reportButton];
    
    self.followImageView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 1, 60, 30)];
    //----------------------------------------------------
    //follow image
    self.followImageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.followImageView];
    UITapGestureRecognizer *tapFollow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFollowTapGesture:)];
    tapFollow.numberOfTapsRequired=1;
    [self.followImageView addGestureRecognizer:tapFollow];
    
    //=======================================================
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    tap.numberOfTapsRequired=1;
    //[self.questionview addGestureRecognizer:tap2];
    
    self.questionLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 300, 30)];
    self.questionLable.backgroundColor = [UIColor clearColor];
    self.questionLable.textColor = [UIColor lightGrayColor];
    self.questionLable.numberOfLines = 0;
    self.questionLable.userInteractionEnabled = YES;
    self.questionLable.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.questionLable];
    [self.questionLable addGestureRecognizer:tap2];
    
    //==================================================
    //Add Comment Text View
    self.commentTextView= [[UITextView alloc]initWithFrame:CGRectMake(10, 140, 300, 60)];
    self.commentTextView.layer.borderColor=[UIColor grayColor].CGColor;
    self.commentTextView.layer.borderWidth=1.0f;
    //self.commentTextView.text=@"Add your comment here";
    self.commentTextView.delegate=self;
    self.commentTextView.layer.cornerRadius=10.0;
    self.commentTextView.clipsToBounds=YES;
    
    [self.scrollView addSubview:self.commentTextView];
    
    
    self.placeHolderLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    self.placeHolderLable.backgroundColor=[UIColor clearColor];
    self.placeHolderLable.adjustsFontSizeToFitWidth=YES;
    self.placeHolderLable.font=[UIFont fontWithName:@"Arial" size:12];
    self.placeHolderLable.alpha=0.4;
    self.placeHolderLable.textColor = [UIColor blackColor];
    self.placeHolderLable.text = @"Ask your question here";
    [self.commentTextView addSubview:self.placeHolderLable];
    
    ////===================================================
    //Add Vote Button
    self.voteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.voteButton.frame=CGRectMake(220, 205, 90, 30);
    [self.voteButton setBackgroundImage:[UIImage imageNamed:@"Vote_btn"] forState:UIControlStateNormal];
    [self.voteButton addTarget:self action:@selector(voteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.voteButton];
    
    ////======================================================
    //Add Table View to display all comments
    
    self.commentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 250, self.view.bounds.size.height, 150) style:UITableViewStylePlain];
    self.commentTable.layer.borderWidth=1.0f;
    self.commentTable.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.commentTable.delegate=self;
    self.commentTable.dataSource=self;
    [self.scrollView addSubview:self.commentTable];
    
    
    ////===================================================
    //Add SKIP Button
    
    if(!self.skipButton){
        self.skipButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.skipButton.frame=CGRectMake(240, 100, 63, 30);
        [self.skipButton setBackgroundImage:[UIImage imageNamed:@"skip.png"] forState:UIControlStateNormal];
        [self.skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.skipButton];
    }
    
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    [self.view addSubview:HUD];
    
    //[self checkQuestionType:dict];
    [self firstMethod];
    
    //Passing delegate for stop activity indicator view
    if (self.ansQuesDelegate != nil && [self.ansQuesDelegate respondsToSelector:@selector(stopActivityIndicator)]) {
        [self.ansQuesDelegate stopActivityIndicator];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
}
//First method for display question details
-(void)firstMethod{
    [self performSelectorOnMainThread:@selector(checkQuestionType:) withObject:dict waitUntilDone:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
//Follow tap Action
-(void) handleFollowTapGesture:(id)sender{
    UIView *v = (UIControl *)sender;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)v;
    UIImageView *img = (UIImageView *)tap.view;

    NSString *uid = [MySingletonClass sharedSingleton].groupinionUserID;
    NSString *q = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unique_que"]];
    NSString *urlString= [NSString stringWithFormat:@"http://beta.groupinion.com/android/follow/?uid=%@&q=%@",uid,q];
    
    NSString *response = [SendHttpRequest sendRequest:urlString];
    NSLog(@"Response == %@", response);
    if ([response isEqualToString:@"error"]) {
        NSLog(@"Error");
    }
    else{
        NSDictionary *respoDict = [response JSONValue];
        NSString *res = [NSString stringWithFormat:@"%@",[respoDict objectForKey:@"Message"]];
        if ([res isEqualToString:@"You are follow this user"]) {
            NSLog(@"Follow");
            img.image = [UIImage imageNamed:@"green_following_btn.png"];
        }
        else if ([res isEqualToString:@"You have unfollow this user"]){
            NSLog(@"unfollow");
            img.image = [UIImage imageNamed:@"follow_btn.png"];
        }
        else{
            NSLog(@"Unknown Response");
        }

        [MySingletonClass sharedSingleton].reported = YES;
    }
    
}
#pragma mark -
//Report Button Action
-(void)reportButtonClicked{
    NSLog(@"Report BUtton Clicked");
    
    //http://beta.groupinion.com/android/report/?unique=HaDfT&id=753
    
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground = YES;
    HUD.delegate = self;
    [HUD show:YES];
    [self.view addSubview:HUD];
    
    NSString *unique_id=[dict objectForKey:@"unique_que"];
    NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
    
    NSString *urlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/report/?unique=%@&id=%@",unique_id,uid];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *response=[SendHttpRequest sendRequest:urlString];
    if([response isEqualToString:@"error"]){
        [HUD hide:YES];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        
        if([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            
            self.tickMarkImageView.hidden=YES;
            // NSArray *ary = [response JSONValue];
            NSDictionary *dict11 = [response JSONValue];
            NSString *msg = [dict11 objectForKey:@"message"];
            [HUD hide:YES];
            [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            
            //Enable Refresh After report
            [MySingletonClass sharedSingleton].reported=YES;
             [MySingletonClass sharedSingleton].sendNotification=NO;
            [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
            [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
            [MySingletonClass sharedSingleton].refreshMyprofile=YES;
            
            NSLog(@"Response==%@",response);
            //Return Format
            //{"Status":"1","message":"Question reported successfully!","nextQid":"kwgko"}
            // NSArray *ary = [response JSONValue];
            NSDictionary *reportDict=[response JSONValue];
            NSString *status=[reportDict objectForKey:@"Status"];
            nextquesUniqueID = [reportDict objectForKey:@"nextQid"];
            [HUD hide:YES];
            if ([status isEqualToString:@"0"]) {
                NSLog(@"error to report ");
            }
            else{
                //get new Question
                startLimit=0;
                endLimit=100;
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Thank you for bringing this to our attention" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alertView.tag=1;
                [alertView show];
            }
        }
        
        
    }
    
    
}
#pragma mark -
//Alert View Delegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        
        [self getNextQuestion:nextquesUniqueID];
    }
}
//Get next Question
-(void)getNextQuestion:(NSString *)uniqueID{
    
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
    
    //    NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/new_nextquestion/index.php?unique=%@&uid=%@",uniqueID,uid];
    //    NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/new_nextquestion/index.php?unique=%@&uid=%@",uniqueID,uid];
   // NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/nextquestion_with_thumbimage_and_newvotebar/index.php?unique=%@&uid=%@",uniqueID,uid];
    
    
    //http://beta.groupinion.com/android/new_directquestionview/?q=rLR4J&read=0
    //// http://beta.groupinion.com/android/ios_new_directquestionview/?q=%@&read=1&uid=1113

    NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_new_directquestionview/?q=%@&read=0&uid=%@",uniqueID,uid];
    
    
    NSString *nextQuesResponse = [SendHttpRequest sendRequest:urlString];
    
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
            [self checkQuestionType:nextQuesDict];
        }
    }
}


#pragma mark -
//Checking Question Type
-(void)checkQuestionType:(NSMutableDictionary *)dataDict{
    //Fetching NickName
   self.nameLable.text=[[NSString stringWithFormat:@"%@ asks:",[dataDict objectForKey:@"NickName"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    
    voted= NO;
    voteValue=@"";
    self.yesnoTickImageView.hidden=YES;
    
    //Checking Follow Value
    NSString *follow = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"follow"]];
    if ([follow isEqualToString:@"1"]) {
        //Followed
        self.followImageView.image = [UIImage imageNamed:@"green_following_btn.png"];
    }
    else{
        //Not Follow
      self.followImageView.image = [UIImage imageNamed:@"follow_btn.png"];
    }
    //Getting question text
   question=[[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"Title"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    NSInteger quesLength=[question length];
    NSLog(@"name length==%d  and question =%@",quesLength,question);
    //set The Question
    self.questionLable.lineBreakMode=NSLineBreakByCharWrapping;
    CGSize lblSize = [question sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(298,1000)];
    self.questionLable.frame = CGRectMake(10, 35, 298, lblSize.height);
    self.questionLable.text = question;
    //self.questionview.text=question;
    
    dict=dataDict;
    
    NSString *totalVote=[dataDict objectForKey:@"TotalVote"];
    [commentArray removeAllObjects];
    //Checking Vote Count
    if([totalVote isEqualToString:@"0"]){
        // if not voted yet reload comment Table
        [self.commentTable reloadData];
        NSLog(@"No Comments");
    }
    else{
        //if voted get All Comments
        NSString *qid=[dataDict objectForKey:@"unique_que"];
        [self getAllComments:qid];
    }
    
    //============================================================
    //Checking Question type
    NSString *quesType=[dataDict objectForKey:@"QuestionType"];
    if([quesType isEqualToString:@"0"]){
        //Single Choice question
        [self singleChoiceQuestion:dataDict];
    }
    else{
        //Multiple Choice Question
        NSLog(@"Multi Choice Question");
        [self newMultiplaeChoiceQuestion:dataDict];
    }
}
//Getting All Comments for Question
-(void) getAllComments:(NSString *)qid{
    
    NSLog(@"qid==%@",qid);
    commentArray = [[NSMutableArray alloc]init];
    NSString *commentUrlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/getcomment_with_avatar_cropimage/index.php?q=%@",qid];
    NSString *response = [self fetchImage:commentUrlString];
    
    
    if([response isEqualToString:@"error"]){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        
        if([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            [self.commentTable reloadData];
      
        }
        else{
            
            //[{"Avatar":"0","cmt_id":"1033","cmt_mood":"1","NickName":"say","cmt_text":"yes","cmt_rate":null,"dbcsFacebookProfile":"0","avatarImage":"0_avatar_75_75.jpg","Default_image_status":"0"}]
            
            NSLog(@"Response== %@",response);
            NSArray *jsonArray=[response JSONValue];
            NSLog(@"jsonArray==%@ and count==%lu",jsonArray,(unsigned long)[jsonArray count]);
    
            for (int i=0; i<[jsonArray count]; i++) {
                
                NSLog(@"%i object index==%@",i,[jsonArray objectAtIndex:i]);
                NSDictionary *d=[jsonArray objectAtIndex:i];
                [commentArray addObject:d];
            }
            
            [self.commentTable reloadData];
        }
    }
}

#pragma mark -
#pragma mark Table View Delegate And Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"Count==%lu",(unsigned long)[commentArray count]);
    return  [commentArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    cell.imageView.frame=CGRectMake(2, 5, 35, 35);
    
    // NSString *questionType=[dict objectForKey:@"QuestionType"];
    
    UIImageView *profileImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 35, 35)];
    profileImage.layer.borderWidth=1.0f;
    profileImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    profileImage.layer.cornerRadius=8.0f;
    profileImage.clipsToBounds=YES;
    [cell.contentView addSubview:profileImage];
    
    UILabel *nameLable=[[UILabel alloc]initWithFrame:CGRectMake(45, 2, 200, 25)];
    nameLable.backgroundColor=[UIColor clearColor];
    nameLable.textAlignment=NSTextAlignmentLeft;
    nameLable.textColor=[UIColor blackColor];
    nameLable.font=[UIFont boldSystemFontOfSize:15];
    [cell.contentView addSubview:nameLable];
    
    UILabel *commentLable=[[UILabel alloc]initWithFrame:CGRectMake(45, 20, 250, 25)];
    commentLable.backgroundColor=[UIColor clearColor];
    commentLable.textAlignment=NSTextAlignmentLeft;
    commentLable.font=[UIFont systemFontOfSize:15];
    commentLable.textColor=[UIColor grayColor];
    [cell.contentView addSubview:commentLable];
    
    NSDictionary *d=[commentArray objectAtIndex:indexPath.row];
    
      nameLable.text=[[NSString stringWithFormat:@"%@", [d objectForKey:@"NickName"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    commentLable.text=[[NSString stringWithFormat:@"%@", [d objectForKey:@"cmt_text"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    
    NSString *defaultImageStatus= [d objectForKey:@"Default_image_status"];
    //UIImage *profilePic=nil;
    NSURL *url=nil;
    if ( [defaultImageStatus isEqualToString:@"1"]) {
        
        NSString *imageName=[d objectForKey:@"avatarImage"];
        
        if ([imageName rangeOfString:@"jpg"].location == NSNotFound) {
            imageName=[NSString stringWithFormat:@"%@.jpg",imageName];
        }
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",imageName]];
//        profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",imageName]]]];
//        profileImage.image = profilePic;
    }//End if block default image set
    else{
        NSString *proImage=[d objectForKey:@"dbcsFacebookProfile"];
        
        if([proImage isEqualToString:@"0"]){
            
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/0_avatar_75_75.jpg"]];
            
//            NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/0_avatar_75_75.jpg"]]];
//            profileImage.image=[UIImage imageWithData:imageData];
        }
        else{
            
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",proImage]];
            
//            NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",proImage]]];
//            profileImage.image=[UIImage imageWithData:imageData];
        }
    }//End Else Block Default image set
    
    [profileImage setImageWithURL:url];
    
       
    UIImageView *votedImage=[[UIImageView alloc]initWithFrame:CGRectMake(255, 5, 60, 16)];
    [cell.contentView addSubview:votedImage];
    
    NSString *voteStatus=[d objectForKey:@"cmt_mood"];
    
    if([voteStatus isEqualToString:@"1"] || [voteStatus isEqualToString:@"yes"]){
        votedImage.image=[UIImage imageNamed:@"voted_blue.png"];
    }
    else if([voteStatus isEqualToString:@"2"] || [voteStatus isEqualToString:@"red"]){
        votedImage.image=[UIImage imageNamed:@"voted_red.png"];
    }
    else if([voteStatus isEqualToString:@"3"] || [voteStatus isEqualToString:@"yellow"]){
        votedImage.image=[UIImage imageNamed:@"voted_yellow.png"];
    }
    else if([voteStatus isEqualToString:@"4"] || [voteStatus isEqualToString:@"blue"]){
        votedImage.image=[UIImage imageNamed:@"voted_blue.png"];
    }
    else if([voteStatus isEqualToString:@"5"] || [voteStatus isEqualToString:@"green"]){
        votedImage.image=[UIImage imageNamed:@"voted_green.png"];
    }
    else if ([voteStatus isEqualToString:@"-1"] || [voteStatus isEqualToString:@"no"]){
        votedImage.image=[UIImage imageNamed:@"voted_gray.png"];
    }
    
    //  }
    
    return cell;
    
}

#pragma  mark -
#pragma mark Single Choice Question

-(void)singleChoiceQuestion:(NSMutableDictionary *)dataDict{
    
     NSLog(@"Single Choice Question");
    //Initialliy Hiding All Subviews
    
    self.scrollView.contentOffset=CGPointMake(0, 0);
    self.productViewFirst.hidden=YES;
    self.productViewSecond.hidden=YES;
    self.productViewThird.hidden=YES;
    self.productViewFourth.hidden=YES;
    
    self.multiProductFirst.hidden=YES;
    self.multiProductSecond.hidden=YES;
    self.multiProductThird.hidden=YES;
    self.multiProductFourth.hidden=YES;
    
//    self.multiProgressFirst.hidden=YES;
//    self.multiProgressSecond.hidden=YES;
//    self.multiProgressThird.hidden=YES;
//    self.multiProgressFourth.hidden=YES;
//    self.emptyProgressBar.hidden=YES;
    
    self.messageLable.hidden=YES;
    self.descriptionLableFirst.hidden=YES;
    self.descriptionLableSecond.hidden=YES;
    self.descriptionLableThird.hidden=YES;
    self.descriptionLableFourth.hidden=YES;
    
    //getting TextView Height
    CGFloat y=self.questionLable.frame.size.height+37;
       //Question image full name
    NSString *imageNameFullScreen=[dataDict objectForKey:@"productThumbImage_310"];
    //Fetching Question image name
    NSString *imageName=[dataDict objectForKey:@"productThumbImage_65"];
    
    //Setting Full Screen Image View
    if (!self.fullSizeImage) {
        self.fullSizeImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 52, 310, 310)];
        self.fullSizeImage.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.fullSizeImage.layer.borderWidth=5.0;
        self.fullSizeImage.layer.cornerRadius=10;
        self.fullSizeImage.clipsToBounds=YES;
        self.fullSizeImage.backgroundColor=[UIColor blackColor];
        self.fullSizeImage.userInteractionEnabled=YES;
        self.fullSizeImage.hidden=YES;
        
        //Adding Tap Gesture
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
        tap.numberOfTapsRequired=1;
        [self.fullSizeImage addGestureRecognizer:tap];
        
        //Addding Close button
        UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        crossBtn.frame = CGRectMake(290, 5, 16, 16);
        crossBtn.tag=1;
        [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [crossBtn addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullSizeImage addSubview:crossBtn];
    }
    
    //Checking Question image
    if ([imageName isEqualToString:@"."]) {
        //question image not found set Groupinion logo as question image
        imageName = @"0_avatar_65_65.jpg";
    }
    //setting question full size image url
    NSURL *fullImageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageNameFullScreen]];
    [self.fullSizeImage setImageWithURL:fullImageUrl];
    
    //setting question thumbnail size image url
    NSURL *proUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageName]];
    //Question iamge display ImageView
    if(!self.productImageView){
        self.productImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, y+5, 65, 65)];
        self.productImageView.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.productImageView.layer.borderWidth=1.0f;
        self.productImageView.layer.cornerRadius=5.0f;
        self.productImageView.clipsToBounds=YES;
        self.productImageView.userInteractionEnabled=YES;
        self.proImagelongGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGestureproductImage)];
        [self.productImageView addGestureRecognizer:self.proImagelongGesture];
        
        [self.scrollView addSubview:self.productImageView];
    }
    self.productImageView.frame = CGRectMake(10, y+5, 65, 65);
    [self.productImageView setImageWithURL:proUrl];
    
    ////=====================================================
    //Add Yes Button
    
    if(!self.yesButton){
        self.yesButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.yesButton.layer.cornerRadius=6.0f;
        self.yesButton.clipsToBounds=YES;
        self.yesButton.layer.backgroundColor = [UIColor colorWithRed:(CGFloat)157/255 green:(CGFloat)201/255 blue:(CGFloat)116/255 alpha:1].CGColor;
        [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.yesButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.yesButton.contentEdgeInsets = UIEdgeInsetsMake(1, 10, 0, 0);
        [self.yesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [self.yesButton addTarget:self action:@selector(yesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.yesButton];
        
        
        self.yesPercentageLable = [[UILabel alloc]initWithFrame:CGRectMake(50, -2, 65, 30)];
        self.yesPercentageLable.backgroundColor = [UIColor clearColor];
        self.yesPercentageLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        self.yesPercentageLable.textColor = [UIColor whiteColor];
        self.yesPercentageLable.textAlignment = NSTextAlignmentRight;
        [self.yesButton addSubview:self.yesPercentageLable];
    }
    self.yesButton.frame = CGRectMake(100, y+10, 120, 25);
    
    ////=======================================================
    //Add NO Button
    
    if(!self.noButton){
        
        self.noButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.noButton.layer.cornerRadius=6.0f;
        self.noButton.clipsToBounds=YES;
        //[self.noButton setBackgroundImage:[UIImage imageNamed:@"Answerquestion_no_btn.png"] forState:UIControlStateNormal];
        self.noButton.layer.backgroundColor = [UIColor colorWithRed:(CGFloat)205/255 green:(CGFloat)102/255 blue:(CGFloat)104/255 alpha:1].CGColor;
        [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        self.noButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.noButton.contentEdgeInsets = UIEdgeInsetsMake(1, 10, 0, 0);
        [self.noButton setTitle:@"No" forState:UIControlStateNormal];
        [self.noButton addTarget:self action:@selector(noButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.noButton];
        
        self.nopercentageLable = [[UILabel alloc]initWithFrame:CGRectMake(50, -2, 65, 30)];
        self.nopercentageLable.backgroundColor = [UIColor clearColor];
        self.nopercentageLable.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        self.nopercentageLable.textColor = [UIColor whiteColor];
        self.nopercentageLable.textAlignment = NSTextAlignmentRight;
        [self.noButton addSubview:self.nopercentageLable];
    }
    self.noButton.frame=CGRectMake(100, y+40, 120, 25);
    y=y+65;
    //==================================================
    //Add Enlarge Button(Below Question image)
       
    if (!self.enlargeButton) {
        self.enlargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.enlargeButton.frame=CGRectMake(20, y+5, 50, 20);
        
        self.enlargeButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self.enlargeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.enlargeButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
        [self.enlargeButton setTitle:@"Enlarge" forState:UIControlStateNormal];
        
        // [self.enlargeButton setBackgroundImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
        [self.enlargeButton addTarget:self action:@selector(handleLongpressGestureproductImage) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:self.enlargeButton];
    }
    self.enlargeButton.frame = CGRectMake(20, y+5, 50, 20);
    y=y+20;
    //Fetching total vote count
    NSString *totalVote = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"TotalVote"]];
    
    if ([totalVote isEqualToString:@"0"]) {
        self.yesPercentageLable.text=[NSString stringWithFormat:@"0%%"];
        self.nopercentageLable.text = [NSString stringWithFormat:@"0%%"];
    }
    else{
        NSString *progress=[dataDict objectForKey:@"progressBar"];
        NSArray *ary=[progress componentsSeparatedByString:@","];
        if (ary.count>1) {
            NSString *yesVoted = [NSString stringWithFormat:@"%@",[ary objectAtIndex:0]];
            self.yesPercentageLable.text=[NSString stringWithFormat:@"%@%%",yesVoted];
            self.nopercentageLable.text = [NSString stringWithFormat:@"%d%%",(100-[yesVoted integerValue])];
        }
        else{
            self.yesPercentageLable.text=[NSString stringWithFormat:@"0%%"];
            self.nopercentageLable.text = [NSString stringWithFormat:@"100%%"];
        }
    }
    self.commentTextView.frame=CGRectMake(10, y+5, 300, 55);
    self.skipButton.frame=CGRectMake(120, y+65, 90, 30);
    self.voteButton.frame=CGRectMake(220, y+65, 90, 30);
    self.commentTable.frame=CGRectMake(0, y+110, self.view.bounds.size.width, 200);
    self.productImageView.hidden=NO;
    self.yesButton.hidden=NO;
    self.noButton.hidden=NO;
    self.skipButton.hidden=NO;
    self.enlargeButton.hidden=NO;
    
    [HUD hide:YES];
}
//Handle Long Press Gesture on Single Choice question image
-(void)handleLongpressGestureproductImage{
    
    [self.view addSubview:self.fullSizeImage];
    self.fullSizeImage.hidden=NO;
}
#pragma mark -
-(void)settingButtonClicked{
    NSLog(@"Setting Button Clicked");
    SettingViewController *setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:setting animated:YES];
    
}

#pragma mark -
//Voted to yes
-(void)yesButtonClicked{
    NSLog(@"Yes Button Action Call");
    voted=YES;
    voteValue=@"yes";
    
    if (!self.yesnoTickImageView) {
        self.yesnoTickImageView = [[UIImageView alloc]init];
        self.yesnoTickImageView.backgroundColor = [UIColor clearColor];
    }
    //Set Tick Mark Button
    self.yesnoTickImageView.image=[UIImage imageNamed:@"yesSelected.png"];
    self.yesnoTickImageView.frame = CGRectMake(225, self.yesButton.frame.origin.y, 30, 25);
    
    self.yesnoTickImageView.hidden=NO;
    [self.scrollView addSubview:self.yesnoTickImageView];
    
    //Fetch vote value
    NSString *progress=[dict objectForKey:@"progressBar"];
    NSArray *ary=[progress componentsSeparatedByString:@","];
    
    //Setting Vote Count
    if([ary count]>0 && [ary count]==3){
        //NSString *currentProgreevalue=[ary objectAtIndex:0];
        NSString *totalVote=[ary objectAtIndex:1];
        NSString *noOfYesVote=[ary objectAtIndex:2];
        
        float newYesPercentage=(([noOfYesVote floatValue]+1)/([totalVote floatValue]+1))*100;
        float newNoPercentage = 100-newYesPercentage;
        self.yesPercentageLable.text = [[NSString stringWithFormat:@"%.2f%%",newYesPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        self.nopercentageLable.text = [[NSString stringWithFormat:@"%.2f%%",newNoPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        
    }
    else{
        NSString *totalVote=[dict objectForKey:@"TotalVote"];
        if ([totalVote isEqualToString:@"0"]) {
            self.yesPercentageLable.text = [NSString stringWithFormat:@"100%%"];
            self.nopercentageLable.text = [NSString stringWithFormat:@"0%%"];
        }
        else{
            float newYesPercentage=(1/([totalVote floatValue]+1))*100;
            float newNoPercentage = 100 - newYesPercentage;
            self.yesPercentageLable.text = [[NSString stringWithFormat:@"%.2f%%",newYesPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.nopercentageLable.text = [[NSString stringWithFormat:@"%.2f%%",newNoPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        
        
    }
    
}
//No vote Button Action
-(void)noButtonClicked{
    NSLog(@"No Button Action Call");

    voted=YES;
    voteValue=@"no";
    //Fetch Voted Value
    NSString *progress=[dict objectForKey:@"progressBar"];
    NSArray *ary=[progress componentsSeparatedByString:@","];
    //Set Tick Mark
    if (!self.yesnoTickImageView) {
        self.yesnoTickImageView = [[UIImageView alloc]init];
        self.yesnoTickImageView.backgroundColor = [UIColor clearColor];
    }
    self.yesnoTickImageView.image=[UIImage imageNamed:@"noSelected.png"];
    self.yesnoTickImageView.frame = CGRectMake(225, self.noButton.frame.origin.y, 30, 25);
    self.yesnoTickImageView.hidden=NO;
    [self.scrollView addSubview:self.yesnoTickImageView];

    //Setting Vote count
    if([ary count]>0 && [ary count]==3){

        NSString *totalVote=[ary objectAtIndex:1];
        NSString *noOfYesVote=[ary objectAtIndex:2];
        
        float newYesPercentage=(([noOfYesVote floatValue])/([totalVote floatValue]+1))*100;
        float newNoPercentage = 100-newYesPercentage;
        self.yesPercentageLable.text = [[NSString stringWithFormat:@"%.2f%%",newYesPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        self.nopercentageLable.text = [[NSString stringWithFormat:@"%.2f%%",newNoPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    else{
                self.yesPercentageLable.text = [NSString stringWithFormat:@"0%%"];
            self.nopercentageLable.text = [NSString stringWithFormat:@"100%%"];
 
    }
}

#pragma mark -
-(void)displayActivityIndicator{
   
        HUD = [[MBProgressHUD alloc]init];
        HUD.dimBackground = YES;
        HUD.delegate = self;
        [self.view addSubview:HUD];
        [HUD show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    //[HUD release];
    HUD = nil;
}
#pragma mark -
//Slip Button Action
-(void)skipButtonClicked{
    NSLog(@"Skip Button Action Call");
    //http://beta.groupinion.com/android/skipQuestion/index.php?unique=B9aQ2&uid=127&SubCategoryID=9&Categories=Entertainment
    
    // http://beta.groupinion.com/android/new_skipQuestion/index.php?unique=B9aQ2&uid=127&SubCategoryID=9&Categories=Entertainment
    
    //http://beta.groupinion.com/android/test_skipquestion_with_thumbimage_and_newvotebar/index.php?unique=ItYzP&uid=127&SubCategoryID=17&Categories=Sports&StartLimit=5&EndLimit=5
    //Checking Limit
    if (startLimit>endLimit) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"You have answered all the questions in this category, visit the Question page to see questions in other categories." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    //Fetch next question after skip
    NSString *uniqueID=[dict objectForKey:@"unique_que"];
    NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
    NSString *subCatID=[dict objectForKey:@"SubCategoryID"];
    NSString *category=[dict objectForKey:@"Categories"];
    
    //    NSString *urlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/new_skipQuestion/index.php?unique=%@&uid=%@&SubCategoryID=%@&Categories=%@",uniqueID,uid,subCatID,category];
    //    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_skipquestion_with_thumbimage_and_newvotebar/index.php?unique=%@&uid=%@&SubCategoryID=%@&Categories=%@&StartLimit=%i&EndLimit=%i",uniqueID,uid,subCatID,category,startLimit,endLimit];
    
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *response=[SendHttpRequest sendRequest:urlString];
    
    if([response isEqualToString:@"error"]){
        NSLog(@"Error");
        [HUD hide:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        
        if([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            
            [HUD hide:YES];
            //NSArray *ary=[response JSONValue];
            NSDictionary *dict11 = [response JSONValue];
            NSString *msg = [dict11 objectForKey:@"Message"];
            
            [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            
           // NSArray *jsonArray=[response JSONValue];
            self.tickMarkImageView.hidden=YES;
//            for (int i=0; i<1; i++) {
                NSMutableDictionary *next_ques_dict = [response JSONValue];
                
                NSString *status =[next_ques_dict objectForKey:@"Status"];
                if([status isEqualToString:@"0"]){
                    
                }
                else{
                    NSString *limit=[NSString stringWithFormat:@"%@",[next_ques_dict objectForKey:@"limit"]];
                   
                   
                    if (startLimit==0) {
                        endLimit = [limit intValue];
                    }
                    
                    startLimit=startLimit+1;
                    //Display Question
                    [self checkQuestionType:next_ques_dict];
                }
                
            //}
        }
        
    }
}




-(UIImage *)createThumbnailImage:(UIImage *)image{
    NSLog(@"ww==%f and hh=%f",image.size.width,image.size.height);
    
    CGSize thumbnailImageSize  = CGSizeMake(65, 65);
    UIImage* thumbnailImage = nil;
    
    UIGraphicsBeginImageContext(thumbnailImageSize);
    [image drawInRect:CGRectMake(3, 3, 59, 59)];
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnailImage;
}


#pragma mark -
#pragma mark Multiple Choice
//Display Multiple Choice Question
-(void)newMultiplaeChoiceQuestion:(NSMutableDictionary *)dataDict{
    //Hiding all SubViews
    self.scrollView.scrollEnabled=YES;
    self.scrollView.contentOffset=CGPointMake(0, 0);
    self.productImageView.hidden=YES;
    //self.myProgressView.hidden=YES;
    self.yesButton.hidden=YES;
    self.noButton.hidden=YES;
    self.enlargeButton.hidden=YES;
    
    self.descriptionLableFirst.hidden=YES;
    self.descriptionLableSecond.hidden=YES;
    self.descriptionLableThird.hidden=YES;
    self.descriptionLableFourth.hidden=YES;
    
    self.productViewFirst.hidden=YES;
    self.productViewSecond.hidden=YES;
    self.productViewThird.hidden=YES;
    self.productViewFourth.hidden=YES;
    
    if(!self.messageLable){
        self.messageLable=[[UILabel alloc]init];
        self.messageLable.backgroundColor=[UIColor clearColor];
        self.messageLable.font=[UIFont systemFontOfSize:12];
        self.messageLable.textColor=[UIColor blackColor];
        self.messageLable.textAlignment=NSTextAlignmentCenter;
        self.messageLable.text=@"Press and hold to enlarge image";
        [self.scrollView addSubview:self.messageLable];
    }
    self.messageLable.hidden=NO;

    
    
    //increase 20;
    //CGFloat descriptionLableHeight = 80;
    CGFloat descriptionLableHeight = self.questionLable.frame.size.height+37;
   
    //CGFloat imageHeight = 110;
    CGFloat imageHeight = descriptionLableHeight + 30;
    
    NSString *imageStringThumb=[dataDict objectForKey:@"productThumbImage_65"];
    
    NSString *imageString=[dataDict objectForKey:@"productThumbImage_310"];
    NSArray *aryImageList=[imageString componentsSeparatedByString:@","];
    NSArray *aryImageListThumb = [imageStringThumb componentsSeparatedByString:@","];
    
    //Fetching All description
    NSString *description=[dataDict objectForKey:@"description"];
    //seprate Discription
    NSArray *descriptionArray=[description componentsSeparatedByString:@","];

     CGFloat xValue=12;
    //Display Discription
    for (int i=0; i<[descriptionArray count]; i++) {
        //Fetching description for image
          NSString *descriptionFirst=[descriptionArray objectAtIndex:i];
        //Checking Description for First option image
        if(![descriptionFirst isEqualToString:@""]){
            //checking i value
            if (i==0) {
                //First description UI
                if(!self.descriptionLableFirst){
                    self.descriptionLableFirst=[[UILabel alloc]init];
                    self.descriptionLableFirst.backgroundColor=[UIColor clearColor];
                    self.descriptionLableFirst.numberOfLines=2;
                    self.descriptionLableFirst.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableFirst.lineBreakMode=NSLineBreakByTruncatingTail;
                    
                    self.descriptionLableFirst.font=[UIFont systemFontOfSize:12.0f];
                    
                    [self.scrollView addSubview:self.descriptionLableFirst];
                }
                //Setting frame
                self.descriptionLableFirst.frame=CGRectMake(xValue, descriptionLableHeight, 70, 30);
                //Checking length of Description
                if (descriptionFirst.length>15) {
                   self.descriptionLableFirst.font=[UIFont systemFontOfSize:10.0f];
                }
                else{
                    self.descriptionLableFirst.font=[UIFont systemFontOfSize:12.0f];
                }
                self.descriptionLableFirst.text=[[NSString stringWithFormat:@"%@",descriptionFirst] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
                
                self.descriptionLableFirst.hidden=NO;
                //First Option image View
                if (!self.multiProductFirst) {
                    
                    self.productViewFirst = [[UIView alloc]init];
                    self.productViewFirst.layer.cornerRadius = 5.0;
                    self.productViewFirst.clipsToBounds = YES;
                    
                    self.productViewFirst.backgroundColor = [UIColor colorWithRed:(float)205/255 green:(float)102/255 blue:(float)104/255 alpha:1.0];
                    [self.scrollView addSubview:self.productViewFirst];
                    
                    self.multiProductFirst=[[UIImageView alloc] init];
                    self.multiProductFirst.layer.cornerRadius=6.0f;
                    self.multiProductFirst.clipsToBounds=YES;
                    self.multiProductFirst.userInteractionEnabled=YES;
                    self.multiProductFirst.backgroundColor = [UIColor clearColor];
                    [self.productViewFirst addSubview:self.multiProductFirst];
                    //Adding Gesture on First option Image View
                    self.firstGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceFirstButtonClicked)];
                    self.firstGesture.numberOfTapsRequired=1;
                    [self.multiProductFirst addGestureRecognizer:self.firstGesture];
                    //Adding Long Press Gesture
                    self.longPressGestureFirst=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureFirst)];
                    
                    [self.multiProductFirst addGestureRecognizer:self.longPressGestureFirst];
                    
                    
                    self.votePercentageLableFirst = [[UILabel alloc]initWithFrame:CGRectMake(2, 70, 66, 20)];
                    self.votePercentageLableFirst.backgroundColor = [UIColor clearColor];
                    self.votePercentageLableFirst.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                    self.votePercentageLableFirst.textColor = [UIColor whiteColor];
                    self.votePercentageLableFirst.textAlignment = NSTextAlignmentCenter;
                    [self.productViewFirst addSubview:self.votePercentageLableFirst];
                    
                }//end multi product first
                self.productViewFirst.frame=CGRectMake(xValue, imageHeight, 70, 90);
                self.productViewFirst.hidden=NO;
                self.multiProductFirst.frame=CGRectMake(2.5, 2.5, 65, 65);
                
                
                NSString *imageFirst=[aryImageList objectAtIndex:0];
                NSString *imageFirstThumb =[aryImageListThumb objectAtIndex:0];
                
                
                NSURL *productImageUrl=nil;
                NSURL *productImageThumbUrl=nil;
                //Fetching option image URL
                if(![imageFirstThumb isEqualToString:@""]){
                    
                    productImageThumbUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                }
                else{
                    
                    productImageThumbUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                }
                
                [self.multiProductFirst setImageWithURL:productImageThumbUrl];
                
                
                //Full Size image
                if(![imageFirst isEqualToString:@""]){
                    
                    productImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                }
                else{
                    
                    productImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    
                }
                //assigning full size image
                [self performSelectorInBackground:@selector(firstImage:) withObject:productImageUrl];
                
                NSLog(@"Downloaded image first");
                
                self.multiProductFirst.hidden=NO;
                
                
                xValue=xValue+77;
                
            }//Condition i=0 block end
            else if (i==1){
                //Second  description UI
                if(!self.descriptionLableSecond){
                    self.descriptionLableSecond=[[UILabel alloc]init];
                    self.descriptionLableSecond.backgroundColor=[UIColor clearColor];
                    self.descriptionLableSecond.numberOfLines=2;
                    self.descriptionLableSecond.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableSecond.lineBreakMode=NSLineBreakByTruncatingTail;
                    self.descriptionLableSecond.font=[UIFont systemFontOfSize:12.0f];
                    
                    [self.scrollView addSubview:self.descriptionLableSecond];
                }
                //Setting frame
                self.descriptionLableSecond.frame=CGRectMake(xValue, descriptionLableHeight, 70, 30);
                //Checking length of Description
                if (descriptionFirst.length>15) {
                    self.descriptionLableSecond.font=[UIFont systemFontOfSize:10.0f];
                }
                else{
                    self.descriptionLableSecond.font=[UIFont systemFontOfSize:12.0f];
                }
                self.descriptionLableSecond.text=[[NSString stringWithFormat:@"%@", descriptionFirst] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
                
                self.descriptionLableSecond.hidden=NO;
                //Second Option image View
                if (!self.multiProductSecond) {
                    
                    
                    self.productViewSecond = [[UIView alloc]init];
                    self.productViewSecond.layer.cornerRadius = 5.0;
                    self.productViewSecond.clipsToBounds = YES;
                    self.productViewSecond.backgroundColor = [UIColor colorWithRed:(float)255/255 green:(float)206/255 blue:(float)17/255 alpha:1.0];
                    [self.scrollView addSubview:self.productViewSecond];
                    
                    self.multiProductSecond=[[UIImageView alloc]init];
                    self.multiProductSecond.layer.cornerRadius=6.0f;
                    self.multiProductSecond.clipsToBounds=YES;
                    
                    self.multiProductSecond.userInteractionEnabled=YES;
                    //Adding Gesture on Second option Image View
                    self.secondGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceSecondButtonClicked)];
                    self.secondGesture.numberOfTapsRequired=1;
                    [self.multiProductSecond addGestureRecognizer:self.secondGesture];
                    [self.productViewSecond addSubview:self.multiProductSecond];
                    
                    //Adding Long Press Gesture
                    self.longPressGestureSecond=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGestureSecond)];
                    
                    [self.multiProductSecond addGestureRecognizer:self.longPressGestureSecond];
                    
                    self.votePercentageLableSecond = [[UILabel alloc]initWithFrame:CGRectMake(2, 70, 66, 20)];
                    self.votePercentageLableSecond.backgroundColor = [UIColor clearColor];
                    self.votePercentageLableSecond.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                    self.votePercentageLableSecond.textColor = [UIColor whiteColor];
                    self.votePercentageLableSecond.textAlignment = NSTextAlignmentCenter;
                    [self.productViewSecond addSubview:self.votePercentageLableSecond];
                    
                }//End if Multiproduct Second
                self.productViewSecond.frame = CGRectMake(xValue, imageHeight, 70, 90);
                self.productViewSecond.hidden=NO;
                self.multiProductSecond.frame=CGRectMake(2.5, 2.5, 65, 65);
                
                NSString *imageFirst=[aryImageList objectAtIndex:1];
                NSString *imageFirstThumb=[aryImageListThumb objectAtIndex:1];
                
                NSURL *productImageTwoUrl=nil;
                NSURL *productImageThumbTwourl=nil;
                
                //Fetching option image URL
                if(![imageFirstThumb isEqualToString:@""]){
                    productImageThumbTwourl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                    
                }
                else{
                    productImageThumbTwourl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                    }
                
                [self.multiProductSecond setImageWithURL:productImageThumbTwourl];
                self.multiProductSecond.hidden=NO;
                //Full Size image
                if(![imageFirst isEqualToString:@""]){
                    
                    productImageTwoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                    }
                else{
                    
                    productImageTwoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    }
                //assigning full size image
                [self performSelectorInBackground:@selector(secondImage:) withObject:productImageTwoUrl];
                xValue=xValue+77;
                
            }//Condition block i=1
            else if(i==2){
                //Third description UI
                if(!self.descriptionLableThird){
                    self.descriptionLableThird=[[UILabel alloc]init];
                    self.descriptionLableThird.backgroundColor=[UIColor clearColor];
                    self.descriptionLableThird.numberOfLines=2;
                    self.descriptionLableThird.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableThird.lineBreakMode=NSLineBreakByTruncatingTail;
                    self.descriptionLableThird.font=[UIFont systemFontOfSize:12.0f];
                    
                    [self.scrollView addSubview:self.descriptionLableThird];
                }
                //Setting frame
                self.descriptionLableThird.frame=CGRectMake(xValue, descriptionLableHeight, 70, 30);
                //Checking length of Description
                if (descriptionFirst.length>15) {
                    self.descriptionLableThird.font=[UIFont systemFontOfSize:10.0f];
                }
                else{
                    self.descriptionLableThird.font=[UIFont systemFontOfSize:12.0f];
                }
                self.descriptionLableThird.text=[[NSString stringWithFormat:@"%@", descriptionFirst] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
                
                self.descriptionLableThird.hidden=NO;
                //Third Option image View
                if (!self.multiProductThird) {
                    self.productViewThird = [[UIView alloc]init];
                    self.productViewThird.layer.cornerRadius = 5.0;
                    self.productViewThird.clipsToBounds = YES;
                    self.productViewThird.backgroundColor = [UIColor colorWithRed:(float)97/255 green:(float)188/255 blue:(float)209/255 alpha:1.0];
                    [self.scrollView addSubview:self.productViewThird];
                    
                    
                    self.multiProductThird=[[UIImageView alloc] init];
                    self.multiProductThird.layer.cornerRadius=6.0f;
                    self.multiProductThird.clipsToBounds=YES;
                    
                    
                    [self.productViewThird addSubview:self.multiProductThird];
                    
                    self.multiProductThird.userInteractionEnabled=YES;
                    //Adding Tap Gesture
                    self.thirdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceThirdButtonClicked)];
                    self.thirdGesture.numberOfTapsRequired=1;
                    [self.multiProductThird addGestureRecognizer:self.thirdGesture];
                    
                    //Adding Long Press Gesture
                    self.longPressGestureThird=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureThird)];
                    
                    [self.multiProductThird addGestureRecognizer:self.longPressGestureThird];
                    
                    self.votePercentageLableThird = [[UILabel alloc]initWithFrame:CGRectMake(2, 70, 66, 20)];
                    self.votePercentageLableThird.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                    self.votePercentageLableThird.backgroundColor = [UIColor clearColor];
                    self.votePercentageLableThird.textColor = [UIColor whiteColor];
                    self.votePercentageLableThird.textAlignment = NSTextAlignmentCenter;
                    [self.productViewThird addSubview:self.votePercentageLableThird];
                    
                }
                self.productViewThird.frame = CGRectMake(xValue, imageHeight, 70, 90);
                self.productViewThird.hidden=NO;
                self.multiProductThird.frame=CGRectMake(2.5, 2.5, 65, 65);
                
                NSString *imageFirst=[aryImageList objectAtIndex:2];
                NSString *imageFirstThumb=[aryImageListThumb objectAtIndex:2];
                NSURL *productImageThirdUrl;
                NSURL *productImageThumbThirdUrl=nil;
                //Third Option image Url
                if(![imageFirstThumb isEqualToString:@""]){
                    productImageThumbThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                    }
                else{
                    productImageThumbThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                    }
                
                [self.multiProductThird setImageWithURL:productImageThumbThirdUrl];
                
                self.multiProductThird.hidden=NO;
                //Third Full Size Image URL
                if(![imageFirstThumb isEqualToString:@""]){
                    productImageThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                    }
                else{
                    productImageThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    }
                
                [self performSelectorInBackground:@selector(thirdImage:) withObject:productImageThirdUrl];
                xValue=xValue+77;
                
            }//Codition Block i=2
            else if (i==3){
                //Forth description UI
                if(!self.descriptionLableFourth){
                    self.descriptionLableFourth=[[UILabel alloc]init];
                    self.descriptionLableFourth.backgroundColor=[UIColor clearColor];
                    self.descriptionLableFourth.numberOfLines=2;
                    self.descriptionLableFourth.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableFourth.lineBreakMode=NSLineBreakByTruncatingTail;
                    self.descriptionLableFourth.font=[UIFont systemFontOfSize:12.0f];
                    
                    [self.scrollView addSubview:self.descriptionLableFourth];
                }
                //Setting frame
                self.descriptionLableFourth.frame=CGRectMake(xValue, descriptionLableHeight, 70, 30);
                //Checking length of Description
                if (descriptionFirst.length>15) {
                    self.descriptionLableFourth.font=[UIFont systemFontOfSize:10.0f];
                }
                else{
                    self.descriptionLableFourth.font=[UIFont systemFontOfSize:12.0f];
                }
                self.descriptionLableFourth.text=[[NSString stringWithFormat:@"%@", descriptionFirst] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
                
                self.descriptionLableFourth.hidden=NO;
                //Forth Option image View
                if (!self.multiProductFourth) {
                    //Forth UIView
                    self.productViewFourth = [[UIView alloc]init];
                    self.productViewFourth.layer.cornerRadius = 5.0;
                    self.productViewFourth.clipsToBounds = YES;
                    self.productViewFourth.backgroundColor = [UIColor colorWithRed:(float)157/255 green:(float)200/255 blue:(float)117/255 alpha:1.0];
                    [self.scrollView addSubview:self.productViewFourth];
                    
                    //Image View
                    self.multiProductFourth=[[UIImageView alloc]init];
                    self.multiProductFourth.layer.cornerRadius=6.0f;
                    self.multiProductFourth.clipsToBounds=YES;
                    
                    self.multiProductFourth.userInteractionEnabled=YES;
                    //Adding Tap Gesture
                    self.thirdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceFourthButtonClicked)];
                    self.thirdGesture.numberOfTapsRequired=1;
                    [self.multiProductFourth addGestureRecognizer:self.thirdGesture];
                    [self.productViewFourth addSubview:self.multiProductFourth];
                    //Adding Long Press Gesture
                    self.longPressGestureFourth=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureForth)];
                    
                    [self.multiProductFourth addGestureRecognizer:self.longPressGestureFourth];
                    //Vote label
                    self.votePercentageLableFourth = [[UILabel alloc]initWithFrame:CGRectMake(2, 70, 66, 20)];
                    self.votePercentageLableFourth.backgroundColor = [UIColor clearColor];
                    self.votePercentageLableFourth.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
                    self.votePercentageLableFourth.textColor = [UIColor whiteColor];
                    self.votePercentageLableFourth.textAlignment = NSTextAlignmentCenter;
                    [self.productViewFourth addSubview:self.votePercentageLableFourth];
                    
                }
                self.productViewFourth.frame = CGRectMake(xValue, imageHeight, 70, 90);
                self.productViewFourth.hidden=NO;
                self.multiProductFourth.frame=CGRectMake(2.5, 2.5, 65, 65);
               
                NSString *imageFirst=[aryImageList objectAtIndex:3];
                
                NSString *imageFirstThumb=[aryImageListThumb objectAtIndex:3];
                
                NSURL *productImageThumbFourUrl=nil;
                NSURL *productImageFoururl=nil;
                //Fetch Forth Image URL
                if(![imageFirstThumb isEqualToString:@""]){
                    productImageThumbFourUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                    
                }
                else{
                    productImageThumbFourUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                    }
                [self.multiProductFourth setImageWithURL:productImageThumbFourUrl];
                
                self.multiProductFourth.hidden=NO;
                
                //Full Size Image URL
                if(![imageFirst isEqualToString:@""]){
                    
                    productImageFoururl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                    }
                else{
                    productImageFoururl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    }
                
                [self performSelectorInBackground:@selector(fourthImage:) withObject:productImageFoururl];
                
                }//Condition Block i==3
        }//End if block of description check
        else{
            NSLog(@"Description Null");
        }

    }//End For loop
    sleep(1.5);
    NSString *totalVote=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"TotalVote"]];
    //check voted count
    if ([totalVote isEqualToString:@"0"]) {
       self.votePercentageLableFirst.text=@"0%";
        self.votePercentageLableSecond.text =@"0%";
        self.votePercentageLableThird.text = @"0%";
        self.votePercentageLableFourth.text = @"0%";
    }
    else{
        
        NSString *votePercentage = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"progressBar"]];
        NSArray *voteAry = [votePercentage componentsSeparatedByString:@","];
        
        self.votePercentageLableFirst.text = [NSString stringWithFormat:@"%@%%",[voteAry objectAtIndex:0]];
        self.votePercentageLableSecond.text = [NSString stringWithFormat:@"%@%%",[voteAry objectAtIndex:2]];
        self.votePercentageLableThird.text = [NSString stringWithFormat:@"%@%%",[voteAry objectAtIndex:4]];
        self.votePercentageLableFourth.text = [NSString stringWithFormat:@"%@%%",[voteAry objectAtIndex:6]];
    }
    //setting Frame
    self.messageLable.frame = CGRectMake(10, imageHeight+95, 300, 20);
    self.commentTextView.frame = CGRectMake(10, imageHeight+115, 300, 55);
    self.voteButton.frame=CGRectMake(220, imageHeight+175, 90, 30);
    self.skipButton.frame=CGRectMake(120, imageHeight+175, 90, 30);
    //self.messageLable.frame=CGRectMake(10, 200, 300, 20);
    self.commentTable.frame=CGRectMake(0, imageHeight+215, self.view.bounds.size.width, 200);
    [HUD hide:YES];
}

/*
-(void)multipleChoiceQuestion:(NSMutableDictionary *)dataDict{
    self.productImageView.hidden=YES;
    self.myProgressView.hidden=YES;
    self.yesButton.hidden=YES;
    self.noButton.hidden=YES;
    self.enlargeButton.hidden=YES;
    
    self.multiProductFirst.hidden=YES;
    self.multiProductSecond.hidden=YES;
    self.multiProductThird.hidden=YES;
    self.multiProductFourth.hidden=YES;
    
    self.multiProgressFirst.hidden=YES;
    self.multiProgressSecond.hidden=YES;
    self.multiProgressThird.hidden=YES;
    self.multiProgressFourth.hidden=YES;
    self.emptyProgressBar.hidden=YES;
    
    self.descriptionLableFirst.hidden=YES;
    self.descriptionLableSecond.hidden=YES;
    self.descriptionLableThird.hidden=YES;
    self.descriptionLableFourth.hidden=YES;
    
    //self.skipButton.hidden=YES;
    
    // NSString *mes=@"";
    if(!self.messageLable){
        self.messageLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 225, 300, 20)];
        self.messageLable.backgroundColor=[UIColor clearColor];
        self.messageLable.font=[UIFont systemFontOfSize:12];
        self.messageLable.textColor=[UIColor blackColor];
        self.messageLable.textAlignment=NSTextAlignmentCenter;
        self.messageLable.text=@"Press and hold to enlarge image";
        [self.view addSubview:self.messageLable];
    }
    self.messageLable.hidden=NO;
    self.commentTextView.frame=CGRectMake(10, 245, 300, 40);
    self.voteButton.frame=CGRectMake(220, 290, 90, 30);
    self.skipButton.frame=CGRectMake(120, 290, 90, 30);
    self.messageLable.frame=CGRectMake(10, 225, 300, 20);
    self.commentTable.frame=CGRectMake(0, 330, self.view.bounds.size.height, 150);
    
    
    //increase 20;
    CGFloat descriptionLableHeight = 130;
    progressHeight = 110;
    CGFloat imageHeight = 160;
    
    if([question length] >40 && [question length ]<=80){
        self.questionview.frame=CGRectMake(5, 75, 300, 55);
        descriptionLableHeight = 150;
        progressHeight = 130;
        imageHeight = 180;
        
        self.messageLable.frame=CGRectMake(10, 245, 300, 20);
        self.commentTextView.frame=CGRectMake(10, 265, 300, 40);
        self.voteButton.frame=CGRectMake(220, 310, 90, 30);
        self.skipButton.frame=CGRectMake(120, 310, 90, 30);
        self.commentTable.frame=CGRectMake(0, 350, self.view.bounds.size.height, 150);
    }
    else if ([question length]>80 && [question length]<=120 ){
        
        self.questionview.frame=CGRectMake(5, 75, 300, 75);
        descriptionLableHeight = 170;
        progressHeight = 150;
        imageHeight = 200;
        
        self.messageLable.frame=CGRectMake(10, 265, 300, 20);
        self.commentTextView.frame=CGRectMake(10, 285, 300, 40);
        self.voteButton.frame=CGRectMake(220, 330, 90, 30);
        self.skipButton.frame=CGRectMake(120, 330, 90, 30);
        self.commentTable.frame=CGRectMake(0, 370, self.view.bounds.size.height, 150);
    }
    else if ([question length]>120 ){
        
        self.questionview.frame=CGRectMake(5, 75, 300, 95);
        descriptionLableHeight = 190;
        progressHeight = 170;
        imageHeight = 220;
        
        self.messageLable.frame=CGRectMake(10, 285, 300, 20);
        
        self.commentTextView.frame=CGRectMake(10, 305, 300, 40);
        self.voteButton.frame=CGRectMake(220, 350, 90, 30);
        self.skipButton.frame=CGRectMake(120, 350, 90, 30);
        self.commentTable.frame=CGRectMake(0, 390, self.view.bounds.size.height, 150);
    }
    
    
    NSString *imageStringThumb=[dataDict objectForKey:@"productThumbImage_65"];
    
    NSString *imageString=[dataDict objectForKey:@"productThumbImage_310"];
    NSArray *aryImageList=[imageString componentsSeparatedByString:@","];
    NSArray *aryImageListThumb = [imageStringThumb componentsSeparatedByString:@","];
    // Created By Rajeev
    
    //    NSString *imageThumbnail = [dataDict objectForKey:@""];
    //    NSArray *arrImagesThumList = [imageThumbnail componentsSeparatedByString:@","];
    
    NSString *description=[dataDict objectForKey:@"description"];
    NSArray *descriptionArray=[description componentsSeparatedByString:@","];
    
    CGFloat xValue=12;
    for (int i=0; i<[descriptionArray count]; i++) {
        
        NSString *descriptionFirst=[descriptionArray objectAtIndex:i];
        
        
        if(![descriptionFirst isEqualToString:@""]){
            
            if (i==0) {
                
                if(!self.descriptionLableFirst){
                    self.descriptionLableFirst=[[UILabel alloc]init];
                    self.descriptionLableFirst.backgroundColor=[UIColor clearColor];
                    self.descriptionLableFirst.numberOfLines=2;
                    self.descriptionLableFirst.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableFirst.lineBreakMode=NSLineBreakByTruncatingTail;
                    self.descriptionLableFirst.font=[UIFont systemFontOfSize:12.0f];
                    
                    [self.view addSubview:self.descriptionLableFirst];
                }
                self.descriptionLableFirst.frame=CGRectMake(xValue, descriptionLableHeight, 65, 30);
                self.descriptionLableFirst.text=descriptionFirst;
                
                self.descriptionLableFirst.hidden=NO;
                
                if (!self.multiProductFirst) {
                    self.multiProductFirst=[[UIImageView alloc] init];
                    self.multiProductFirst.layer.borderWidth=3.0f;
                   
                    self.multiProductFirst.layer.borderColor=[UIColor colorWithRed:(float)218/255 green:(float)119/255 blue:(float)88/255 alpha:1.0].CGColor;
                    
                    self.multiProductFirst.layer.cornerRadius=10.0f;
                    self.multiProductFirst.clipsToBounds=YES;
                    self.multiProductFirst.userInteractionEnabled=YES;
                    [self.view addSubview:self.multiProductFirst];
                    
                    self.firstGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceFirstButtonClicked)];
                    self.firstGesture.numberOfTapsRequired=1;
                    [self.multiProductFirst addGestureRecognizer:self.firstGesture];
                    
                    self.longPressGestureFirst=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureFirst)];
                    
                    [self.multiProductFirst addGestureRecognizer:self.longPressGestureFirst];
                    
                   
                    
                }
                self.multiProductFirst.frame=CGRectMake(xValue, imageHeight, 65, 65);
                
                NSString *imageFirst=[aryImageList objectAtIndex:0];
                NSString *imageFirstThumb =[aryImageListThumb objectAtIndex:0];

                
                NSURL *productImageUrl=nil;
                NSURL *productImageThumbUrl=nil;
                
                if(![imageFirstThumb isEqualToString:@""]){
                    
                    productImageThumbUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                    }
                else{
                    
                   productImageThumbUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                    }
               
                  [self.multiProductFirst setImageWithURL:productImageThumbUrl];
                
                
                
                if(![imageFirst isEqualToString:@""]){
                    
                    productImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                    }
                else{
                    
                    productImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    
                }
                
                [self performSelectorInBackground:@selector(firstImage:) withObject:productImageUrl];
                
                NSLog(@"Downloaded image first");
               
                self.multiProductFirst.hidden=NO;
                
                
                xValue=xValue+77;
                
            }//Condition i=0 block end
            else if (i==1){
                
                if(!self.descriptionLableSecond){
                    self.descriptionLableSecond=[[UILabel alloc]init];
                    self.descriptionLableSecond.backgroundColor=[UIColor clearColor];
                    self.descriptionLableSecond.numberOfLines=2;
                    self.descriptionLableSecond.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableSecond.lineBreakMode=NSLineBreakByTruncatingTail;
                    self.descriptionLableSecond.font=[UIFont systemFontOfSize:12.0f];
                    
                    [self.view addSubview:self.descriptionLableSecond];
                }
                self.descriptionLableSecond.frame=CGRectMake(xValue, descriptionLableHeight, 65, 30);
                self.descriptionLableSecond.text=descriptionFirst;
                
                self.descriptionLableSecond.hidden=NO;
                
                if (!self.multiProductSecond) {
                    
                    self.multiProductSecond=[[UIImageView alloc]init];
                    self.multiProductSecond.layer.borderWidth=3.0f;
                    
                    self.multiProductSecond.layer.borderColor=[UIColor colorWithRed:(float)254/255 green:(float)211/255 blue:0 alpha:1.0].CGColor;
                    self.multiProductSecond.layer.cornerRadius=10.0f;
                    self.multiProductSecond.clipsToBounds=YES;
                   
                    self.multiProductSecond.userInteractionEnabled=YES;
                    self.secondGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceSecondButtonClicked)];
                    self.secondGesture.numberOfTapsRequired=1;
                    [self.multiProductSecond addGestureRecognizer:self.secondGesture];
                    [self.view addSubview:self.multiProductSecond];
                    
                    
                    self.longPressGestureSecond=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGestureSecond)];
                    
                    [self.multiProductSecond addGestureRecognizer:self.longPressGestureSecond];
                    
                   
                    
                }
                self.multiProductSecond.frame=CGRectMake(xValue, imageHeight, 65, 65);
                NSString *imageFirst=[aryImageList objectAtIndex:1];
                NSString *imageFirstThumb=[aryImageListThumb objectAtIndex:1];
                
                NSURL *productImageTwoUrl=nil;
                NSURL *productImageThumbTwourl=nil;
                
                if(![imageFirstThumb isEqualToString:@""]){
                    
                   
                    
                    productImageThumbTwourl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                    
                }
                else{
                    
                
                    productImageThumbTwourl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                    

                }
                
                [self.multiProductSecond setImageWithURL:productImageThumbTwourl];
                self.multiProductSecond.hidden=NO;
                
                if(![imageFirst isEqualToString:@""]){
                    
                    productImageTwoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                    
                }
                else{
                    
                    productImageTwoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    

                }
                
                [self performSelectorInBackground:@selector(secondImage:) withObject:productImageTwoUrl];
                
                NSLog(@"Downloaded image Second");
                
                  
                
                xValue=xValue+77;
                
            }//Condition block i=1
            else if(i==2){
                
                if(!self.descriptionLableThird){
                    self.descriptionLableThird=[[UILabel alloc]init];
                    self.descriptionLableThird.backgroundColor=[UIColor clearColor];
                    self.descriptionLableThird.numberOfLines=2;
                    self.descriptionLableThird.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableThird.lineBreakMode=NSLineBreakByTruncatingTail;
                    self.descriptionLableThird.font=[UIFont systemFontOfSize:12.0f];
                    
                    [self.view addSubview:self.descriptionLableThird];
                }
                self.descriptionLableThird.frame=CGRectMake(xValue, descriptionLableHeight, 65, 30);
                self.descriptionLableThird.text=descriptionFirst;
                
                self.descriptionLableThird.hidden=NO;
                
                if (!self.multiProductThird) {
                    self.multiProductThird=[[UIImageView alloc] init];
                    self.multiProductThird.layer.borderWidth=3.0f;
                   
                    self.multiProductThird.layer.borderColor=[UIColor colorWithRed:(float)90/255 green:(float)189/255 blue:(float)211/255 alpha:1.0].CGColor;
                    self.multiProductThird.layer.cornerRadius=10.0f;
                    self.multiProductThird.clipsToBounds=YES;
                    
                    
                    [self.view addSubview:self.multiProductThird];
                    
                    self.multiProductThird.userInteractionEnabled=YES;
                    self.thirdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceThirdButtonClicked)];
                    self.thirdGesture.numberOfTapsRequired=1;
                    [self.multiProductThird addGestureRecognizer:self.thirdGesture];
                    [self.view addSubview:self.multiProductThird];
                    
                    self.longPressGestureThird=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureThird)];
                    
                    [self.multiProductThird addGestureRecognizer:self.longPressGestureThird];
                    
                    
                }
                self.multiProductThird.frame=CGRectMake(xValue, imageHeight, 65, 65);
                NSString *imageFirst=[aryImageList objectAtIndex:2];
                
              
                NSString *imageFirstThumb=[aryImageListThumb objectAtIndex:2];
                
               
                
                
                NSURL *productImageThirdUrl;
                NSURL *productImageThumbThirdUrl=nil;
                
                if(![imageFirstThumb isEqualToString:@""]){
                    
                   
                   
                   productImageThumbThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                                    
                }
                else{
                                       
                    productImageThumbThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                    
                }
                
                [self.multiProductThird setImageWithURL:productImageThumbThirdUrl];
                
                self.multiProductThird.hidden=NO;
                
                if(![imageFirstThumb isEqualToString:@""]){
                    
                    productImageThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                    

                }
                else{
                    
                    productImageThirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    
                }
                
                [self performSelectorInBackground:@selector(thirdImage:) withObject:productImageThirdUrl];
                
                NSLog(@"Downloaded image third");
                
                                
               
               
                
                
                xValue=xValue+77;
                
            }//Codition Block i=2
            else if (i==3){
                
                if(!self.descriptionLableFourth){
                    self.descriptionLableFourth=[[UILabel alloc]init];
                    self.descriptionLableFourth.backgroundColor=[UIColor clearColor];
                    self.descriptionLableFourth.numberOfLines=2;
                    self.descriptionLableFourth.textAlignment=NSTextAlignmentCenter;
                    self.descriptionLableFourth.lineBreakMode=NSLineBreakByTruncatingTail;
                    self.descriptionLableFourth.font=[UIFont systemFontOfSize:12.0f];
                  
                    [self.view addSubview:self.descriptionLableFourth];
                }
                self.descriptionLableFourth.frame=CGRectMake(xValue, descriptionLableHeight, 65, 30);
                self.descriptionLableFourth.text=descriptionFirst;
                
                self.descriptionLableFourth.hidden=NO;
                
                if (!self.multiProductFourth) {
                    self.multiProductFourth=[[UIImageView alloc]init];
                    self.multiProductFourth.layer.borderWidth=3.0f;
                   
                    
                    self.multiProductFourth.layer.borderColor=[UIColor colorWithRed:(float)176/255 green:(float)245/255 blue:(float)69/255 alpha:1.0].CGColor;
                    self.multiProductFourth.layer.cornerRadius=10.0f;
                    self.multiProductFourth.clipsToBounds=YES;
                    
                    self.multiProductFourth.userInteractionEnabled=YES;
                    self.thirdGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleChoiceFourthButtonClicked)];
                    self.thirdGesture.numberOfTapsRequired=1;
                    [self.multiProductFourth addGestureRecognizer:self.thirdGesture];
                    [self.view addSubview:self.multiProductFourth];
                    
                    self.longPressGestureFourth=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureForth)];
                    
                    [self.multiProductFourth addGestureRecognizer:self.longPressGestureFourth];
                    
                   
                    
                }
                self.multiProductFourth.frame=CGRectMake(xValue, imageHeight, 65, 65);
                NSString *imageFirst=[aryImageList objectAtIndex:3];
                
                NSString *imageFirstThumb=[aryImageListThumb objectAtIndex:3];
                
                NSURL *productImageThumbFourUrl=nil;
                NSURL *productImageFoururl=nil;
                
                if(![imageFirstThumb isEqualToString:@""]){
                    
                    
                    
                    productImageThumbFourUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/%@",imageFirstThumb]];
                    
                }
                else{
                    
                   
                    
                    productImageThumbFourUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_65_65/0_thumb_65_65.png"]];
                    
                   
                }
                [self.multiProductFourth setImageWithURL:productImageThumbFourUrl];
               
                self.multiProductFourth.hidden=NO;

                
                if(![imageFirst isEqualToString:@""]){
                    
                    productImageFoururl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/%@",imageFirst]];
                    

                }
                else{
                    
                    productImageFoururl = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_310_310/0_thumb_310_310.png"]];
                    

                }
                
                [self performSelectorInBackground:@selector(fourthImage:) withObject:productImageFoururl];
                
                 NSLog(@"Downloaded image fourth");
                
                
                
            }//Condition Block i==3
        }
        else{
            NSLog(@"Description Null");
        }
        
       
       
        
         NSString *imageName=[aryImageList objectAtIndex:i];
         
         if (i==0) {
         if( ![descriptionFirst isEqualToString:@""] || descriptionFirst != NULL){
         
         if(!self.descriptionLableFirst){
         self.descriptionLableFirst=[[UILabel alloc]initWithFrame:CGRectMake(xValue, 110, 70, 70)];
         self.descriptionLableFirst.backgroundColor=[UIColor clearColor];
         [self.view addSubview:self.descriptionLableFirst];
         }
         
         if(!self.multiProductFirst){
         self.multiProductFirst=[UIButton buttonWithType:UIButtonTypeRoundedRect];
         self.multiProductFirst.frame=CGRectMake(xValue, 110, 70, 70);
         self.multiProductFirst.layer.borderWidth=2.0f;
         self.multiProductFirst.layer.borderColor=[UIColor redColor].CGColor;
         self.multiProductFirst.layer.cornerRadius=10.0f;
         self.multiProductFirst.clipsToBounds=YES;
         
         [self.view addSubview:self.multiProductFirst];
         }
         NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@",imageName]]];
         
         UIImage *productImage=[UIImage imageWithData:data];
         [self.multiProductFirst setBackgroundImage:productImage forState:UIControlStateNormal];
         self.multiProductFirst.hidden=NO;
         xValue=xValue+80;
         
         }
         
         }
         if (i==1) {
         if(imageName != NULL){
         
         if(!self.multiProductSecond){
         self.multiProductSecond=[UIButton buttonWithType:UIButtonTypeRoundedRect];
         self.multiProductSecond.frame=CGRectMake(xValue, 110, 70, 70);
         self.multiProductSecond.layer.borderWidth=2.0f;
         self.multiProductSecond.layer.borderColor=[UIColor yellowColor].CGColor;
         
         self.multiProductSecond.layer.cornerRadius=10.0f;
         self.multiProductSecond.clipsToBounds=YES;
         [self.view addSubview:self.multiProductSecond];
         }
         
         NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@",imageName]]];
         
         UIImage *productImage=[UIImage imageWithData:data];
         [self.multiProductSecond setBackgroundImage:productImage forState:UIControlStateNormal];
         self.multiProductSecond.hidden=NO;
         xValue=xValue+80;
         
         }
         
         }
         
         if (i==2) {
         if(imageName != NULL){
         
         if(!self.multiProductThird){
         self.multiProductThird=[UIButton buttonWithType:UIButtonTypeRoundedRect];
         self.multiProductThird.frame=CGRectMake(xValue, 110, 70, 70);
         self.multiProductThird.layer.borderWidth=2.0f;
         self.multiProductThird.layer.borderColor=[UIColor greenColor].CGColor;
         self.multiProductThird.layer.cornerRadius=10.0f;
         self.multiProductThird.clipsToBounds=YES;
         [self.view addSubview:self.multiProductThird];
         }
         
         NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@",imageName]]];
         
         UIImage *productImage=[UIImage imageWithData:data];
         [self.multiProductThird setBackgroundImage:productImage forState:UIControlStateNormal];
         self.multiProductThird.hidden=NO;
         xValue=xValue+80;
         
         }
         
         }
         if (i==3) {
         if(imageName != NULL){
         
         if(!self.multiProductFourth){
         self.multiProductFourth=[UIButton buttonWithType:UIButtonTypeRoundedRect];
         self.multiProductFourth.frame=CGRectMake(xValue, 110, 70, 70);
         self.multiProductFourth.layer.borderWidth=2.0f;
         self.multiProductFourth.layer.borderColor=[UIColor cyanColor].CGColor;
         self.multiProductFourth.layer.cornerRadius=10.0f;
         self.multiProductFourth.clipsToBounds=YES;
         [self.view addSubview:self.multiProductFourth];
         }
         
         NSData *data=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/files/%@",imageName]]];
         
         UIImage *productImage=[UIImage imageWithData:data];
         [self.multiProductFourth setBackgroundImage:productImage forState:UIControlStateNormal];
         self.multiProductFourth.hidden=NO;
         xValue=xValue+80;
         
         }
         
         }
         
         
         //==================================================================
        
        
        
        
    }//End For Loop
    
    
    
    NSString *totalVote=[dataDict objectForKey:@"TotalVote"];
    
    if ([totalVote isEqualToString:@"0"]) {
        
        if (!self.emptyProgressBar) {
            self.emptyProgressBar=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            
            
            self.emptyProgressBar.progress=0;
            self.emptyProgressBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            self.emptyProgressBar.trackImage = [[UIImage imageNamed:@"Answerquestion_white_btn_new.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 3.0f, 6.0f, 6.0f)];
            self.emptyProgressBar.progressImage = [[UIImage imageNamed:@"orangebtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];
            [self.view addSubview:self.emptyProgressBar];
            
        }
        self.emptyProgressBar.frame=CGRectMake(10, progressHeight, 300, 20);
        self.emptyProgressBar.hidden=NO;
        
    }
    else{
        NSString *progrsses=[dataDict objectForKey:@"progressBar"];
        NSArray *ary=[progrsses componentsSeparatedByString:@","];
        
        float totalProgress=0;
        xValue=10;
        for (int i=0; i<[ary count]-1; i=i+2) {
            
            if(totalProgress>=100){
                return;
            }
            
            NSString *progrss=[ary objectAtIndex:i];
            
            float progressValue=[progrss  floatValue];
            
            if(progressValue!=0){
                
                
                if (i==0) {
                    
                    if (!self.multiProgressFirst) {
                        self.multiProgressFirst=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                        
                        
                        self.multiProgressFirst.progress=1;
                        self.multiProgressFirst.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                        self.multiProgressFirst.trackImage = [[UIImage imageNamed:@"Answerquestion_white_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 3.0f, 6.0f, 6.0f)];
                        self.multiProgressFirst.progressImage = [[UIImage imageNamed:@"orangebtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];
                        [self.view addSubview:self.multiProgressFirst];
                        
                    }
                    self.multiProgressFirst.frame=CGRectMake(xValue, progressHeight, progressValue*3, 20);
                    self.multiProgressFirst.hidden=NO;
                    NSLog(@"Xvalue first==%f",xValue);
                    xValue=xValue+(progressValue*3);
                    NSLog(@"First Width==%f",self.multiProgressFirst.bounds.size.width);
                }//i==0 block End
                
                if (i==2) {
                    
                    if (!self.multiProgressSecond) {
                        self.multiProgressSecond=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                        
                        
                        self.multiProgressSecond.progress=1;
                        self.multiProgressSecond.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                        self.multiProgressSecond.trackImage = [[UIImage imageNamed:@"Answerquestion_white_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 3.0f, 6.0f, 6.0f)];
                        self.multiProgressSecond.progressImage = [[UIImage imageNamed:@"yellow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];
                        [self.view addSubview:self.multiProgressSecond];
                        
                    }
                    if(xValue==10){
                        self.multiProgressSecond.frame=CGRectMake(xValue, progressHeight, progressValue*3, 20);
                    }
                    else{
                        self.multiProgressSecond.frame=CGRectMake(xValue-10, progressHeight, progressValue*3+10, 20);
                    }
                    NSLog(@"Second Width==%f",self.multiProgressSecond.bounds.size.width);
                    self.multiProgressSecond.hidden=NO;
                    NSLog(@"Xvalue second==%f",xValue);
                    xValue=xValue+progressValue*3;
                    
                }//End Block i==1
                
                if (i==4) {
                    
                    if (!self.multiProgressThird) {
                        self.multiProgressThird=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                        
                        
                        self.multiProgressThird.progress=1;
                        self.multiProgressThird.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                        self.multiProgressThird.trackImage = [[UIImage imageNamed:@"Answerquestion_white_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 3.0f, 6.0f, 6.0f)];
                        self.multiProgressThird.progressImage = [[UIImage imageNamed:@"sky_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];
                        [self.view addSubview:self.multiProgressThird];
                        
                    }
                    
                    if(xValue==10){
                        self.multiProgressThird.frame=CGRectMake(xValue, progressHeight, progressValue*3, 20);
                    }
                    else{
                        self.multiProgressThird.frame=CGRectMake(xValue-10, progressHeight, progressValue*3+10, 20);
                    }
                    NSLog(@"First Width==%f",self.multiProgressThird.bounds.size.width);
                    self.multiProgressThird.hidden=NO;
                    
                    NSLog(@"Xvalue third==%f",xValue);
                    xValue=xValue+progressValue*3;
                }//End Block i==2
                
                if (i==6) {
                    
                    if (!self.multiProgressFourth) {
                        self.multiProgressFourth=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                        
                        
                        self.multiProgressFourth.progress=1;
                        self.multiProgressFourth.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                        self.multiProgressFourth.trackImage = [[UIImage imageNamed:@"Answerquestion_white_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 3.0f, 6.0f, 6.0f)];
                        self.multiProgressFourth.progressImage = [[UIImage imageNamed:@"lightGreen_btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 6.0f, 6.0f, 6.0f)];
                        
                    }
                    
                    if(xValue==10){
                        self.multiProgressFourth.frame=CGRectMake(xValue, progressHeight, progressValue*3, 20);
                        
                    }
                    else{
                        self.multiProgressFourth.frame=CGRectMake(xValue-10, progressHeight, progressValue*3+10, 20);
                        
                    }
                    NSLog(@"First Width==%f",self.multiProgressFourth.bounds.size.width);
                    NSLog(@"Xvalue fourth==%f",xValue);
                    // self.multiProgressFourth.frame=CGRectMake(xValue, 110, progressValue*3, 20);
                    self.multiProgressFourth.hidden=NO;
                    
                }//End of Block i==3
                
            }//End of ProgressValue=0 Block
            
        }//End of For Block
        [self.view addSubview:self.multiProgressFourth];
        [self.view addSubview:self.multiProgressThird];
        [self.view addSubview:self.multiProgressSecond];
        [self.view addSubview:self.multiProgressFirst];
        
    }//end else block
    
    
    [HUD hide:YES];
    
}

*/
#pragma mark -
//Full Size Image View for first option
-(void)firstImage:(NSURL *)url{
    
    if (!self.fullSizeImageFirst) {
        
        self.fullSizeImageFirst = [[UIImageView alloc]initWithFrame:CGRectMake(5, 52, 310, 310)];
        self.fullSizeImageFirst.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.fullSizeImageFirst.layer.borderWidth=5.0;
        self.fullSizeImageFirst.layer.cornerRadius=10;
        self.fullSizeImageFirst.clipsToBounds=YES;
        self.fullSizeImageFirst.backgroundColor=[UIColor blackColor];
        self.fullSizeImageFirst.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
        tap.numberOfTapsRequired=1;
        [self.fullSizeImageFirst addGestureRecognizer:tap];
        UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        crossBtn.frame = CGRectMake(290, 5, 16, 16);
        crossBtn.tag=2;
        [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [crossBtn addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullSizeImageFirst addSubview:crossBtn];
    }
    self.fullSizeImageFirst.hidden=YES;
    
    [self.fullSizeImageFirst setImageWithURL:url];
    

}
//Full Size Image View for Second option
-(void)secondImage:(NSURL *)url{
    
    
    if (!self.fullSizeImageSecond) {
        
        self.fullSizeImageSecond = [[UIImageView alloc]initWithFrame:CGRectMake(5, 52, 310, 310)];
        self.fullSizeImageSecond.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.fullSizeImageSecond.layer.borderWidth=5.0;
        self.fullSizeImageSecond.layer.cornerRadius=10;
        self.fullSizeImageSecond.clipsToBounds=YES;
        self.fullSizeImageSecond.backgroundColor=[UIColor blackColor];
        self.fullSizeImageSecond.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
        tap.numberOfTapsRequired=1;
        [self.fullSizeImageSecond addGestureRecognizer:tap];
        
        UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        crossBtn.frame = CGRectMake(290, 5, 16, 16);
        crossBtn.tag=3;
        [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [crossBtn addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullSizeImageSecond addSubview:crossBtn];
    }
    self.fullSizeImageSecond.hidden=YES;
    
    [self.fullSizeImageSecond setImageWithURL:url];
}
//Full Size Image View for Third option
-(void)thirdImage:(NSURL *)url{
    
    if (!self.fullSizeImageThird) {
        
        self.fullSizeImageThird = [[UIImageView alloc]initWithFrame:CGRectMake(5, 52, 310, 310)];
        self.fullSizeImageThird.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.fullSizeImageThird.layer.borderWidth=5.0;
        self.fullSizeImageThird.layer.cornerRadius=10;
        self.fullSizeImageThird.clipsToBounds=YES;
        self.fullSizeImageThird.backgroundColor=[UIColor blackColor];
        self.fullSizeImageThird.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
        tap.numberOfTapsRequired=1;
        [self.fullSizeImageThird addGestureRecognizer:tap];
        UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        crossBtn.frame = CGRectMake(290, 5, 16, 16);
        crossBtn.tag=4;
        [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [crossBtn addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullSizeImageThird addSubview:crossBtn];
    }
    self.fullSizeImageThird.hidden=YES;
    
    [self.fullSizeImageThird setImageWithURL:url];
}
//Full Size Image View for Forth option
-(void)fourthImage:(NSURL *)url{
    
    if (!self.fullSizeImageFourth) {
        
        self.fullSizeImageFourth = [[UIImageView alloc]initWithFrame:CGRectMake(5, 52, 310, 310)];
        self.fullSizeImageFourth.layer.borderColor=[UIColor darkGrayColor].CGColor;
        self.fullSizeImageFourth.layer.borderWidth=5.0;
        self.fullSizeImageFourth.layer.cornerRadius=10;
        self.fullSizeImageFourth.clipsToBounds=YES;
        self.fullSizeImageFourth.backgroundColor=[UIColor blackColor];
        self.fullSizeImageFourth.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture)];
        tap.numberOfTapsRequired=1;
        [self.fullSizeImageFourth addGestureRecognizer:tap];
        UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        crossBtn.frame = CGRectMake(290, 5, 16, 16);
        [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        crossBtn.tag=5;
        [crossBtn addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.fullSizeImageFourth addSubview:crossBtn];
    }
    self.fullSizeImageFourth.hidden=YES;
    
    [self.fullSizeImageFourth setImageWithURL:url];
}
//Cross Button Action
-(void)crossButtonClicked:(UIButton *)sender{
    
    if (sender.tag==1) {
        self.fullSizeImage.hidden=YES;
    }
    else if(sender.tag==2){
        self.fullSizeImageFirst.hidden=YES;
    }
    else if (sender.tag==3){
        self.fullSizeImageSecond.hidden=YES;
    }
    else if (sender.tag==4){
        self.fullSizeImageThird.hidden=YES;
    }
    else if (sender.tag==5){
        self.fullSizeImageFourth.hidden=YES;
    }
    else{
        self.fullSizeImage.hidden=YES;
        self.fullSizeImageFirst.hidden=YES;
        self.fullSizeImageSecond.hidden=YES;
        self.fullSizeImageThird.hidden=YES;
        self.fullSizeImageFourth.hidden=YES;
    }
}

#pragma mark -
//Multiple choice first Image View tapped Action
-(void)multipleChoiceFirstButtonClicked{
    NSLog(@"Red One Clicked");
    //Checking already initilized or not
    if (!self.tickMarkImageView) {
        self.tickMarkImageView = [[UIImageView alloc]init];
        self.tickMarkImageView.hidden=YES;
        self.tickMarkImageView.frame = CGRectMake(2, 2, 66, 56);
    }
    //Fetch vote value
    NSString *progressString=[dict objectForKey:@"progressBar"];
    //Seprating Vote Value
    NSArray *ary=[progressString componentsSeparatedByString:@","];
    //Checking already voted or not
    if (self.tickMarkImageView.hidden==YES || self.tickMarkImageView.image != [UIImage imageNamed:@"red_tick.png"]) {
        //First option is not voted, vote to First option
        voted=YES;
        voteValue=@"red";
        
        self.tickMarkImageView.hidden=NO;
        self.tickMarkImageView.image = [UIImage imageNamed:@"red_tick.png"];
        [self.multiProductFirst addSubview:self.tickMarkImageView];
        //Fetching Vote Count
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
             float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Fourth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Total  vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote+1)/(tVote+1))*100;
            float yelloPercentage = ((yVote)/(tVote+1))*100;
            float bluePercentage = ((bVote)/(tVote+1))*100;
            float greenPercentage = ((gVote)/(tVote +1))*100;
            //Setting new vote count Value
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableFirst.text = [NSString stringWithFormat:@"100%%"];
            self.votePercentageLableSecond.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableThird.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableFourth.text = [NSString stringWithFormat:@"0%%"];
        }//End else block ary count
        
    }//End else block tick mark image hidden or not
    else{
        //First option already Voted, remove vote count
        voted = NO;
        voteValue=@"not";
        self.tickMarkImageView.hidden=YES;
    
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
            float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Forth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Total vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote)/(tVote))*100;
            float yelloPercentage = ((yVote)/(tVote))*100;
            float bluePercentage = ((bVote)/(tVote))*100;
            float greenPercentage = ((gVote)/(tVote))*100;
            //Setting new vote count Value
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage]stringByReplacingOccurrencesOfString:@".00" withString:@"" ];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableFirst.text = [NSString stringWithFormat:@"0%%"];
        }//End else block ary count
    
    }
   
}

-(void)multipleChoiceSecondButtonClicked{
    NSLog(@"Tap Yellow Image");
    //Checking already initilized or not
    if (!self.tickMarkImageView) {
        self.tickMarkImageView = [[UIImageView alloc]init];
        self.tickMarkImageView.frame = CGRectMake(2, 2, 66, 56);
        self.tickMarkImageView.hidden=YES;
        
    }
    [self.multiProductSecond addSubview:self.tickMarkImageView];
    //Fetch vote value
    NSString *progressString=[dict objectForKey:@"progressBar"];
    //Seprating Vote Value
    NSArray *ary=[progressString componentsSeparatedByString:@","];

    //Checking already voted or not
    if (self.tickMarkImageView.hidden==YES || self.tickMarkImageView.image != [UIImage imageNamed:@"yellow_tick.png"]) {
        //Second option not vote, vote to second and update vote count
        voted=YES;
        voteValue=@"yellow";
        
        self.tickMarkImageView.hidden=NO;
        self.tickMarkImageView.image = [UIImage imageNamed:@"yellow_tick.png"];
        //Fetching Vote Count
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
            float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Fourth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Total vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote)/(tVote+1))*100;
            float yelloPercentage = ((yVote+1)/(tVote+1))*100;
            float bluePercentage = ((bVote)/(tVote+1))*100;
            float greenPercentage = ((gVote)/(tVote +1))*100;
            //Setting new vote count Value
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableSecond.text = [NSString stringWithFormat:@"100%%"];
            self.votePercentageLableFirst.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableThird.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableFourth.text = [NSString stringWithFormat:@"0%%"];
        }//End else block ary count
    }//tickmarkimage hidden if block
    else{
        //Second option already Voted, remove vote count
        voted=NO;
        voteValue=@"not";
        self.tickMarkImageView.hidden=YES;
       
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
            float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Fourth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Total vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote)/(tVote))*100;
            float yelloPercentage = ((yVote)/(tVote))*100;
            float bluePercentage = ((bVote)/(tVote))*100;
            float greenPercentage = ((gVote)/(tVote))*100;
            //Setting new vote count Value
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage]stringByReplacingOccurrencesOfString:@".00" withString:@"" ];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableSecond.text = [NSString stringWithFormat:@"0%%"];
        }//End else block ary count
               
    }//tickmark hidden End else block
    
}


-(void)multipleChoiceThirdButtonClicked{
    NSLog(@"Tap Blue Image");
    //Checking already initilized or not
    if (!self.tickMarkImageView) {
        self.tickMarkImageView = [[UIImageView alloc]init];
        self.tickMarkImageView.frame = CGRectMake(2, 2, 66, 56);
        self.tickMarkImageView.hidden=YES;
        
    }
    [self.multiProductThird addSubview:self.tickMarkImageView];
    //Fetch vote value
    NSString *progressString=[dict objectForKey:@"progressBar"];
    //Seprating Vote Value
    NSArray *ary=[progressString componentsSeparatedByString:@","];
    //Checking already voted or not
    if (self.tickMarkImageView.hidden==YES || self.tickMarkImageView.image != [UIImage imageNamed:@"blue_tick.png"]) {
        //Third option is not voted, vote to First option
        voteValue=@"blue";
        voted=YES;
        
        self.tickMarkImageView.hidden=NO;
        
        self.tickMarkImageView.image = [UIImage imageNamed:@"blue_tick.png"];
        
       //Fetching Vote Count
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
            float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Fourth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Fifth option vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote)/(tVote+1))*100;
            float yelloPercentage = ((yVote)/(tVote+1))*100;
            float bluePercentage = ((bVote+1)/(tVote+1))*100;
            float greenPercentage = ((gVote)/(tVote +1))*100;
            //Setting new vote count Value
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableThird.text = [NSString stringWithFormat:@"100%%"];
            self.votePercentageLableSecond.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableFirst.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableFourth.text = [NSString stringWithFormat:@"0%%"];

            
        }//End else block ary count
        
    }//End if Block tickmark hidden
    else{
        //Third option already Voted, remove vote count
        voted=NO;
        voteValue=@"not";
        self.tickMarkImageView.hidden=YES;
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
            float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Fourth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Total vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote)/(tVote))*100;
            float yelloPercentage = ((yVote)/(tVote))*100;
            float bluePercentage = ((bVote)/(tVote))*100;
            float greenPercentage = ((gVote)/(tVote))*100;
            //Setting new vote count Value
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage]stringByReplacingOccurrencesOfString:@".00" withString:@"" ];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableThird.text = [NSString stringWithFormat:@"0%%"];
        }//End else block ary count

                       
    }//End Else  block tick mark hidden
    
    
    
}
-(void)multipleChoiceFourthButtonClicked{
    NSLog(@"Tap green Image");
    //Checking already initilized or not
    if (!self.tickMarkImageView) {
        self.tickMarkImageView = [[UIImageView alloc]init];
        self.tickMarkImageView.frame = CGRectMake(2, 2, 66, 56);
        self.tickMarkImageView.hidden=YES;
    }
    [self.multiProductFourth addSubview:self.tickMarkImageView];
    //Fetch vote value
    NSString *progressString=[dict objectForKey:@"progressBar"];
    //Seprating Vote Value
    NSArray *ary=[progressString componentsSeparatedByString:@","];
    //Checking already voted or not
    if (self.tickMarkImageView.hidden==YES || self.tickMarkImageView.image != [UIImage imageNamed:@"green_tick.png"]) {
        //Fourth option not vote, vote to second and update vote count
        self.tickMarkImageView.hidden=NO;
        voteValue=@"green";
        voted=YES;
        
        self.tickMarkImageView.image = [UIImage imageNamed:@"green_tick.png"];
        //Fetching Vote Count
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
            float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Fourth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Total vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote)/(tVote+1))*100;
            float yelloPercentage = ((yVote)/(tVote+1))*100;
            float bluePercentage = ((bVote)/(tVote+1))*100;
            float greenPercentage = ((gVote+1)/(tVote +1))*100;
            //Setting new vote count Value
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableFourth.text = [NSString stringWithFormat:@"100%%"];
            self.votePercentageLableSecond.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableFirst.text = [NSString stringWithFormat:@"0%%"];
            self.votePercentageLableThird.text = [NSString stringWithFormat:@"0%%"];
            

        }//End else block ary count
     
        
    }//End if block Chcek tickmarkimage hidden or not
    else{
        //Fourth option already Voted, remove vote count
        self.tickMarkImageView.hidden=YES;
        voted=NO;
        voteValue=@"not";
        //Fetch Vote Count
        if (ary.count>4) {
            //First option vote count
            NSString *redVote=[ary objectAtIndex:1];
            float rVote=[redVote floatValue];
            //Second option vote count
            NSString *yelloVote=[ary objectAtIndex:3];
            float yVote=[yelloVote floatValue];
            //Third option vote count
            NSString *blueVote=[ary objectAtIndex:5];
            float bVote=[blueVote floatValue];
            //Fourth option vote count
            NSString *greenVote=[ary objectAtIndex:7];
            float gVote=[greenVote floatValue];
            //Total vote count
            NSString *totalVote=[ary objectAtIndex:8];
            float tVote=[totalVote floatValue];
            //Finding Percentage
            float redPercentage=((rVote)/(tVote))*100;
            float yelloPercentage = ((yVote)/(tVote))*100;
            float bluePercentage = ((bVote)/(tVote))*100;
            float greenPercentage = ((gVote)/(tVote))*100;
            //Setting new Vote Count
            self.votePercentageLableFirst.text = [[NSString stringWithFormat:@"%.2f%%",redPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableSecond.text = [[NSString stringWithFormat:@"%.2f%%",yelloPercentage]stringByReplacingOccurrencesOfString:@".00" withString:@"" ];
            self.votePercentageLableThird.text = [[NSString stringWithFormat:@"%.2f%%",bluePercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
            self.votePercentageLableFourth.text = [[NSString stringWithFormat:@"%.2f%%",greenPercentage] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }//End if block ary count
        else{
            self.votePercentageLableFourth.text = [NSString stringWithFormat:@"0%%"];
        }//End else block ary count

        
    }//End else block tickmarkimage hidden
    
    
    
}
#pragma mark -
//Display Full Size image for selected option
-(void)handleLongPressGestureFirst{
    NSLog(@"handl Long Press Gesture First");
    
    self.fullSizeImageFirst.hidden=NO;
    [self.view addSubview:self.fullSizeImageFirst];
}

-(void)handleLongGestureSecond{
    NSLog(@"handl Long Press Gesture Second");
    
    self.fullSizeImageSecond.hidden=NO;
    [self.view addSubview:self.fullSizeImageSecond];
    
}

-(void)handleLongPressGestureThird{
    NSLog(@"handl Long Press Gesture third");
    self.fullSizeImageThird.hidden=NO;
    [self.view addSubview:self.fullSizeImageThird];
}

-(void)handleLongPressGestureForth{
    
    NSLog(@"handl Long Press Gesture Fourth");
    
    self.fullSizeImageFourth.hidden=NO;
    [self.view addSubview:self.fullSizeImageFourth];
  
}
#pragma mark -
//Yes no image full size image display
-(void)handleTapGesture{
        self.fullSizeImage.hidden=YES;
    self.fullSizeImageFirst.hidden=YES;
    self.fullSizeImageSecond.hidden=YES;
    self.fullSizeImageThird.hidden=YES;
    self.fullSizeImageFourth.hidden=YES;
}


#pragma mark -

-(NSString*) encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef) string,
                                                              NULL,
                                                              (CFStringRef) @"!*'()@+$,&%=/#[]",
                                                              kCFStringEncodingUTF8));}
#pragma mark -
//Vote button Action
-(void)voteButtonClicked{
    NSLog(@"Vote Button Clicked");
    

    //Checking Voted to any option or not
    if(voted==YES){
        
        [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
        //http://beta.groupinion.com/android/postansweryesno/index.php?vote=yes&q=Fwxta&uid=127&comment=hello&comment=hello
        NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
        NSString *comment=self.commentTextView.text;
       NSString *commentURi = [self encodeToPercentEscapeString:comment];
       
        
        NSString *uniqueID=[dict objectForKey:@"unique_que"];
        //quesUniqueID=uniqueID;
        
        NSString *urlString=[NSString stringWithFormat:@"http://beta.groupinion.com/android/postansweryesno/index.php?vote=%@&q=%@&uid=%@&comment=%@",voteValue,uniqueID,uid,commentURi];
        
        NSLog(@"VotedUrl==%@",urlString);
        //stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding
//        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *response=[SendHttpRequest sendRequest:urlString];
        NSLog(@"response to yes/no=%@",response);
        
        if([response isEqualToString:@"error"]){
            self.displayNextQues=NO;
            voted = NO;
            [HUD hide:YES];
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            
            if([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
                //  NSArray *ary=[response JSONValue];
                self.displayNextQues=NO;
                voted = NO;
                NSDictionary *dictNew=[response JSONValue];
                
                [HUD hide:YES];
                
                NSString *message=[dictNew objectForKey:@"Message"];
                
                [[[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ] show];
                
            }
            else{
                
                self.commentTextView.text=@"";
                self.placeHolderLable.hidden=NO;
                 [self findPointsForSubmittingQuestion:response];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAfterAction" object:nil];
                //Enabling value for view refresh
                [MySingletonClass sharedSingleton].reported=YES;
                [MySingletonClass sharedSingleton].sendNotification=NO;
                [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
                [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
                [MySingletonClass sharedSingleton].refreshMyprofile=YES;
                
                // NSArray *ary=[response JSONValue];
                
                NSDictionary *dictNew=[response JSONValue];
                //Fetch status
                NSString *status=[dictNew objectForKey:@"Status"];
                
                newalertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you for your vote!  Here's another person who needs your help." delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                [newalertView show];
                //Add comment to comment Table
                if([status isEqualToString:@"1"]){
                    
                    //BOOL facebookLogIn=[MySingletonClass sharedSingleton].loginWithFacebook;
                    
                    NSMutableDictionary *newCommentDict=[[NSMutableDictionary alloc]init];
                    NSString *avatar=@"0_avatar_75_75.jpg";
                    NSString *nickName=[MySingletonClass sharedSingleton].nickName;
                    NSString *avatarImage=[MySingletonClass sharedSingleton].avtarImage;
                    
                    [newCommentDict setObject: nickName forKey:@"NickName"];
                    [newCommentDict setObject:@"1" forKey:@"Default_image_status"];
                    [newCommentDict setObject: voteValue forKey:@"cmt_mood"];
                    [newCommentDict setObject: comment forKey:@"cmt_text"];
                    [newCommentDict setObject: avatar forKey:@"Avatar"];
                    [newCommentDict setObject:avatarImage forKey:@"avatarImage"];
                    
                    NSString *totalVote=[dict objectForKey:@"TotalVote"];
                    
                    if([totalVote isEqualToString:@"0"]){
                        commentArray = [[NSMutableArray alloc]init];
                        [commentArray addObject:newCommentDict];
                        [self.commentTable reloadData];
                    }//end block total vote
                    else{
                        [commentArray insertObject:newCommentDict atIndex:0];
                        
                        [self.commentTable beginUpdates];
                        [self.commentTable insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        [self.commentTable endUpdates];
                    }//end
                    
                }
            }
        }
        [HUD hide:YES];
        //Check next question display option
        if (self.displayNextQues==YES) {
            //reset limit value
            startLimit=0;
            endLimit=100;
            //fetch new question
            [self performSelector:@selector(nextQuesAfterVote) withObject:nil afterDelay:1.0];
        }
        else{
            [self performSelector:@selector(dismissAlert:) withObject:newalertView afterDelay:5.0];
        }
        
    }
    else{
        
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please make a vote selection before rating this question" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        NSLog(@"Be the Vote First");
    }
}

-(void)dismissAlert:(UIAlertView *) alertView
{
    [newalertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

//Fetch new Question After Vote
-(void)nextQuesAfterVote{
    
    [NSThread detachNewThreadSelector:@selector(dismissAlert:) toTarget:self withObject:newalertView];
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    NSString *unique_id=[dict objectForKey:@"unique_que"];
    NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
    //    NSString *urlStringNextQues=[NSString stringWithFormat:@"http://beta.groupinion.com/android/nextquestion/index.php?unique=%@&uid=%@",unique_id,uid];
    NSString *urlStringNextQues=[NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_nextquestion_with_thumbimage_and_newvotebar/index.php?unique=%@&uid=%@",unique_id,uid];
    
    NSLog(@"VotedUrl new==%@",urlStringNextQues);
    
    urlStringNextQues = [urlStringNextQues stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *responseNextQues=[SendHttpRequest sendRequest:urlStringNextQues];
    NSLog(@"response to yes/no=%@",responseNextQues);
    
    [HUD hide:YES];
    
    if([responseNextQues rangeOfString:@"error"].location != NSNotFound){
        NSLog(@"Error");
        [HUD hide:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        
        if([responseNextQues rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
         
            self.tickMarkImageView.hidden=YES;
            [HUD hide:YES];
            NSDictionary *dict11 = [responseNextQues JSONValue];
            NSString *msg = [dict11 objectForKey:@"Message"];
            
            [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            self.tickMarkImageView.hidden=YES;
            NSMutableDictionary *next_ques_dict = [responseNextQues JSONValue];
            NSString *status =[next_ques_dict objectForKey:@"Status"];
            //Check status
            if([status isEqualToString:@"0"]){
            }
            else{
                //dispaly next question
                [self checkQuestionType:next_ques_dict];
            }
        }
    }
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
#pragma mark TextView Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    if(textView==self.commentTextView){
        
        if ([self.commentTextView.text length]>=140 && range.length==0) {
            return NO;
        }
    }
    return YES;
}

-(BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    
    self.placeHolderLable.hidden=YES;
    [self.scrollView setContentOffset:CGPointMake(0, self.questionview.frame.origin.y+self.questionview.frame.size.height)];
    return YES;
}

-(BOOL) textViewShouldEndEditing:(UITextView *)textView{
    if ([self.commentTextView.text isEqualToString:@""]) {
        self.placeHolderLable.hidden=NO;
    }
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    return YES;
}

-(NSString *)fetchImage:(NSString *)str{
    
    NSURL *url=[NSURL URLWithString:str];
    
    NSHTTPURLResponse   * response;
    NSError *error;
    
    
    NSLog(@"url==%@",url);
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *respo=nil;
    if(error){
        respo=@"error";
        NSLog(@"url==%@\n error=%@",str,error);
    }
    else{
        respo=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"respo==%@",respo);
    }
    
    
    
    return respo;
}
-(void)findPointsForSubmittingQuestion:(NSString *)response{
    NSArray *arr = [response componentsSeparatedByString:@","];
    NSString *str = [arr objectAtIndex:2];
    
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
    else if (questionPoint>=70 && questionPoint<82){
        NSString *strReward = [NSString stringWithFormat:@"hitting level 4 %@",strCategoryName];
        momentId = strReward;
        momentValue = @"70";
    }
    else if (questionPoint>=110 && questionPoint<120){
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
            // set notification delegate.
            //            KPNotification *notification = poptart.notification;
            //            notification.delegate = self;
            
            [poptart show];
        }];
    }
}
- (void)showError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end
