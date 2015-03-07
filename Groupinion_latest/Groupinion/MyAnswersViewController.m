//
//  MyAnswersViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "MyAnswersViewController.h"
#import "JSON.h"
#import "CustomCell.h"
#import "MySingletonClass.h"
#import "MBProgressHUD.h"
#import "AnswerQuestionViewController.h"
#import "UIImageView+WebCache.h"
@interface MyAnswersViewController ()
{
    
}
@property(nonatomic, strong)MBProgressHUD *HUD;
@end

@implementation MyAnswersViewController
@synthesize HUD;
@synthesize allAnswersArray;

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //[HUD hide:YES];
    
    BOOL reported = [MySingletonClass sharedSingleton].refreshMyAnswer;
    
    if(reported==YES){
        
        reported=NO;
        // allFeedArray=[[NSMutableArray alloc]init];
        // avatarList=  [[NSMutableArray alloc]init];
        [MySingletonClass sharedSingleton].refreshMyAnswer=NO;
        
        [self callWebServiceToFetchAllFeed];
        
    }
    else{
        [HUD hide:YES];
        [activityIndicator stopAnimating];
    }
    
    
    
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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    /*
    BOOL reported = [MySingletonClass sharedSingleton].refreshMyAnswer;
    
    if(reported==YES){
        
        
        displayAlert=YES;
        [MySingletonClass sharedSingleton].refreshMyAnswer=NO;
        //[allAnswersArray removeAllObjects];
        [self callWebServiceToFetchAllFeed];
        
    }
    else{
        [HUD hide:YES];
        [activityIndicator stopAnimating];
    }
     */
   
    if (stopindicator==YES) {
        stopindicator=NO;
        [HUD hide:YES];
    }
    
    
    if (!allAnswersArray ) {
        
        displayAlert = YES;
        [self callWebServiceToFetchAllFeed];
    }

}


-(void)stopActivityIndicator{
    [HUD hide:YES];
}

/* Notifiaction  handler method for refreshView and refreshAfterAction
 */
-(void)refreshMyAnswerPage{
    
    NSLog(@"All allAnswersArray Array Count =%lu",(unsigned long)allAnswersArray.count);
    
    
        //allAnswersArray = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // send your notification here instead of in updateFunction
        //[[NSNotificationCenter defaultCenter] post...];
        displayAlert=NO;
        [self callWebServiceToFetchAllFeed];
    });
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // NSLog(@"class name==%@",self.class);
    
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"headFeed1Img.png"];
    [self.view addSubview:bannerImage];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyAnswerPage) name:@"refreshView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyAnswerPage) name:@"refreshAfterAction" object:nil];
    
    //=============================================
    //Add Setting Button To View
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(260, 8, 50, 35);
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    

    //Creation of Question table
    answerTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 330) style:UITableViewStylePlain];
    answerTable.delegate=self;
    answerTable.dataSource=self;
    answerTable.hidden=YES;
    [self.view addSubview:answerTable];
    
    
    //Activity indicator....
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 5, 40, 40)];
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [answerTable addSubview:activityIndicator];
    
    
       
    [activityIndicator startAnimating];
    
    displayAlert=YES;
    //[self callWebServiceToFetchAllFeed];
}

#pragma mark-tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allAnswersArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    for (UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict=[allAnswersArray objectAtIndex:indexPath.row];
    NSString *commentText=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"cmt_text"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    NSString *title=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    NSString *nickName=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"NickName"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    //NSLog(@"comment text--%@   title---%@  nickName--%@",commentText,title,nickName);
    // cell.commentTextLabel.text=commentText;
    // cell.titleLabel.text=title;
    // cell.nickNameLabel.text=nickName;
    
    //Add Comment Text Lable
    UILabel *commentTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 0, 200, 16)];
    commentTextLabel.backgroundColor=[UIColor clearColor];
    commentTextLabel.textColor=[UIColor darkGrayColor];
    commentTextLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:15];
    commentTextLabel.text=commentText;
    [cell.contentView addSubview:commentTextLabel];
    
    //=======================================
    //Add Title Text Lable
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 19, 200, 16)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont fontWithName:@"Arial" size:12];
    
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.text = title;
    [cell.contentView addSubview:titleLabel];
    NSString *urgent = [NSString stringWithFormat:@"%@",[dict objectForKey:@"urgent"]];
    if ([urgent isEqualToString:@"1"]) {
        UIImageView *urgentImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 15, 12, 25)];
        urgentImage.image = [UIImage imageNamed:@"exclanation_mark.png"];
        [cell.contentView addSubview:urgentImage];
        titleLabel.frame = CGRectMake(18, 0, 160, 50);
    }
    NSString *totalVote=[dict objectForKey:@"TotalVote"];
    titleLabel.text = title;
    //===============================
    //Add Nick Name Text Lable
    
    UILabel *nickNameLable = [[UILabel alloc]initWithFrame:CGRectMake(7, 38, 130, 16)];
    nickNameLable.backgroundColor=[UIColor clearColor];
    nickNameLable.textColor=[UIColor grayColor];
    nickNameLable.font=[UIFont fontWithName:@"Arial" size:12];
    nickNameLable.text=[NSString stringWithFormat:@"%@",nickName];
    [cell.contentView addSubview:nickNameLable];
    //============================================
    
    UIImageView *votedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(218, 2, 45, 45)];
    votedImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    votedImageView.layer.borderWidth=1.0f;
    [cell.contentView addSubview:votedImageView];

    UIImageView *maxVoteedImage = [[UIImageView alloc] initWithFrame:CGRectMake(268, 2, 45, 45)];
    maxVoteedImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    maxVoteedImage.layer.borderWidth=1.0f;
    [cell.contentView addSubview:maxVoteedImage];
    
    
     NSString *ques_type = [dict objectForKey:@"QuestionType"];
    
    if([ques_type isEqualToString:@"1"]){
        
        [votedImageView setImageWithURL:[dict objectForKey:@"productImageUrl"]];
        [maxVoteedImage setImageWithURL:[dict objectForKey:@"MaxVotedProductImageUrl"]];
    }
    else{
        UIImage *image=[dict objectForKey:@"votedImage"];
        
        votedImageView.image=image;
        maxVoteedImage.image=[dict objectForKey:@"proImage"];
    }
    
    
    
    UILabel *totalVoteLable = [[UILabel alloc]initWithFrame:CGRectMake(140, 38, 190, 16)];
    totalVoteLable.backgroundColor=[UIColor clearColor];
    totalVoteLable.textColor=[UIColor grayColor];
    totalVoteLable.font=[UIFont fontWithName:@"Arial" size:10];
    totalVoteLable.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:totalVoteLable];
    
    if ([totalVote isEqualToString:@"1"]) {
        totalVoteLable.text=[NSString stringWithFormat:@"%@ vote",totalVote];
    }
    
    else{
        totalVoteLable.text=[NSString stringWithFormat:@"%@ votes",totalVote];
    }
    
    UILabel *youVoted = [[UILabel alloc]initWithFrame:CGRectMake(220, 45, 100, 16)];
    youVoted.backgroundColor=[UIColor clearColor];
    youVoted.textColor=[UIColor blackColor];
    youVoted.font=[UIFont fontWithName:@"Arial" size:9];
    youVoted.textAlignment = NSTextAlignmentLeft;
    youVoted.text = @"You Voted     Leader";
    [cell.contentView addSubview:youVoted];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [allAnswersArray objectAtIndex:indexPath.row];
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    stopindicator=YES;
    AnswerQuestionViewController *ansQues=[[AnswerQuestionViewController alloc]initWithNibName:@"AnswerQuestionViewController" bundle:nil];
    ansQues.dict=(NSMutableDictionary *)dict;
    ansQues.displayNextQues=NO;
    ansQues.ansQuesDelegate=self;
    //[self presentViewController:ansQues animated:YES completion:nil];
    [self.navigationController pushViewController:ansQues animated:YES];
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingButtonClicked{
    NSLog(@"Setting Button Clicked");
    SettingViewController *setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];
}

#pragma mark -
//Call service for fetch all Answered Question
-(void)callWebServiceToFetchAllFeed{
    
    
    //http://beta.groupinion.com/android/getallquestion/index.php?to=0
    
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    [activityIndicator startAnimating];
    
    NSString *groupinionId=[MySingletonClass sharedSingleton].groupinionUserID;
    
    NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_myanswer_with_thumbimage_and_newvotebar/?id=%@",groupinionId];
    
    allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *jsonstring1  = [dict JSONRepresentation];
    NSLog(@"ssss  ===%@",jsonstring1);
    NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
    NSLog(@"56566=====%@",post1);
    [self sendHTTPPost:jsonstring1 :allFeedUrl] ;
}

-(void)sendHTTPPost:(NSString* )json_string :(NSString *)m_pURLAddr{
    
	NSURL *l_pURL = [NSURL URLWithString:m_pURLAddr];
    NSLog(@"Url===%@",l_pURL);
    
 	NSMutableURLRequest *l_pRequest = [[NSMutableURLRequest alloc]initWithURL:l_pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:200.0];
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
    [HUD hide:YES];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"No connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    NSLog(@"Error==%@",error);
    [activityIndicator stopAnimating];
	[alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    successData = YES;
	[self webServiceRequestCompleted];
    
}

-(void)dismissAlertView:(UIAlertView *)alert{
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)webServiceRequestCompleted{
    
    if(!successData){
        return;
    }
    NSString *json_string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
    NSLog(@"json_String==%@",json_string);
    
//Check Response status
    if ([json_string rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
        [HUD hide:YES];
        [activityIndicator stopAnimating];
        if (displayAlert==YES) {
            displayAlert = NO;
            UIAlertView *myAlert =  [[UIAlertView alloc] initWithTitle:@"" message:@"You have not answered any Questions" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil] ;
            [myAlert show];
            [self performSelector:@selector(dismissAlertView:) withObject:myAlert afterDelay:3];
        }
      
    }
    else{
        NSArray *resultArray=[json_string JSONValue];
        
        if (!allAnswersArray) {
            allAnswersArray = [[NSMutableArray alloc]init];
        }
        else{
            [allAnswersArray removeAllObjects];
        }
        //Fetch TableCell Data
        for (int i =0; i<[resultArray count]; i++) {
            NSMutableDictionary *dict=[resultArray objectAtIndex:i];
            // [allAnswersArray addObject:dict];
            [self createTableCell:dict];
        }
        
        if (resultArray.count>0) {
            answerTable.hidden=NO;
            [answerTable reloadData];
        }
        
       // NSLog(@"all Answers-----%@",allAnswersArray);
    }
    
    
    [HUD hide:YES];
    
    [activityIndicator stopAnimating];
}

//Fecth Table Cell Data
-(void)createTableCell:(NSMutableDictionary *)feed{
    
    NSString *newvotebar = [feed objectForKey:@"voteBar"];
    NSArray *ary=[newvotebar componentsSeparatedByString:@","];
  //  NSLog(@"ary = =%@",ary);
    
    UIImage *proImage=nil;
    // NSString *percentageString=[ary objectAtIndex:0];
    NSString *ques_type = [feed objectForKey:@"QuestionType"];
    NSString *cmt_mood = [feed objectForKey:@"cmt_mood"];
    UIImage *votedProImage=nil;
    //Check question type
    if ([ques_type isEqualToString:@"1"]) {
        
        NSString *imageName=[ary objectAtIndex:2];
        imageName=[imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *str=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_75_75/%@",imageName];
        
        [feed setObject:[NSURL URLWithString:str] forKey:@"productImageUrl"];
        NSString *proImages=[feed objectForKey:@"productThumbImage"];
        NSArray *aryProImg=[proImages componentsSeparatedByString:@","];
        //Highest voted option Image
        if ([aryProImg count]>0) {
            NSString *str2=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_75_75/%@",[aryProImg objectAtIndex:[cmt_mood integerValue]-2]];
            [feed setObject:[NSURL URLWithString:str2] forKey:@"MaxVotedProductImageUrl"];
        }
        
    }//check if block End
    else{
        
        NSString *votedTo=[ary objectAtIndex:1];
        if ([votedTo rangeOfString:@"Yes"].location != NSNotFound) {
            //yes highest voted
            proImage=[UIImage imageNamed:@"yesimg.png"];
        }
        else{
            //Not Highest voted
            proImage=[UIImage imageNamed:@"noimg.png"];
            
        }
        //Voted option
        if ([cmt_mood isEqualToString:@"1"]) {
            votedProImage = [UIImage imageNamed:@"yesimg.png"];
        }
        else{
            votedProImage = [UIImage imageNamed:@"noimg.png"];
        }
        //Create Thumbnail Image
        CGSize thumbnailImageSize  = CGSizeMake(44, 44);
        UIImage* thumbnailImage = nil;
        
        UIGraphicsBeginImageContext(thumbnailImageSize);
        [proImage drawInRect:CGRectMake(0, 0, 44, 44)];
        thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        UIImage *thumbnailImage2 = nil;
        UIGraphicsBeginImageContext(thumbnailImageSize);
        [votedProImage drawInRect:CGRectMake(0, 0, 44, 44)];
        thumbnailImage2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [feed setObject:thumbnailImage forKey:@"proImage" ];
        [feed setObject:thumbnailImage2 forKey:@"votedImage"];
        
    }//End else block ques_type
    
    [allAnswersArray addObject:feed];
    
}

@end
