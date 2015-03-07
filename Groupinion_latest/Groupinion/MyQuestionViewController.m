//
//  MyQuestionViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "JSON.h"
#import "MySingletonClass.h"
#import "MBProgressHUD.h"

#import "AnswerQuestionViewController.h"
#import "UIImageView+WebCache.h"


@interface MyQuestionViewController ()
{
   
}
@property(nonatomic, strong)MBProgressHUD *HUD;
@end

@implementation MyQuestionViewController
@synthesize HUD;
@synthesize allQuestionsArray;

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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    BOOL reported = [MySingletonClass sharedSingleton].refreshMyQuestion;
    
    if(reported==YES){
        
        
        
        [MySingletonClass sharedSingleton].refreshMyQuestion=NO;
        //[allQuestionsArray removeAllObjects];
        [self callWebServiceToFetchAllFeed];
    }
    else{
        [HUD hide:YES];
        [activityIndicator stopAnimating];
    }
}
*/
/* Notifiaction  handler method for refreshView and refreshAfterAction
 */
-(void)refreshMyQuestionAfterAction{
    NSLog(@"All Question Array Count =%lu",(unsigned long)allQuestionsArray.count);
       // allQuestionsArray=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
        // send your notification here instead of in updateFunction
        //[[NSNotificationCenter defaultCenter] post...];
        displayAlert=NO;
        [self callWebServiceToFetchAllFeed];
    });
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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //[HUD hide:YES];
    
    if (stopIndicator==YES) {
        stopIndicator=NO;
        [HUD hide:YES];
    }
    
    if (!allQuestionsArray) {
        displayAlert=YES;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // NSLog(@"class name==%@",self.class);
    
    stopIndicator = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyQuestionAfterAction) name:@"refreshView" object:nil];
    //refreshAfterAction
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyQuestionAfterAction) name:@"refreshAfterAction" object:nil];
    
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"headFeed1Img.png"];
    [self.view addSubview:bannerImage];
    
    //================================================
    //Add Setting Button To View
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(260, 8, 50, 35);
    
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    ///QuestionArray...
    //allQuestionsArray=[[NSMutableArray alloc]init];
    
    //Creation of Question table
    questionTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 330) style:UITableViewStylePlain];
    questionTable.delegate=self;
    questionTable.dataSource=self;
    questionTable.hidden=YES;
    [self.view addSubview:questionTable];
    
    
    //Activity indicator....
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 5, 40, 40)];
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [questionTable addSubview:activityIndicator];
    
    
    
    [activityIndicator startAnimating];
    
    displayAlert =YES;
    [self callWebServiceToFetchAllFeed];
    
}


#pragma mark-tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allQuestionsArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier=@"cellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    for (UIView *view in [cell.contentView subviews])
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict=[allQuestionsArray objectAtIndex:indexPath.row];
    NSString *title=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"Title"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
    NSString *date=[dict objectForKey:@"Date"];
    NSString *vote=[dict objectForKey:@"TotalVote"];
    //NSLog(@"title--%@   date---%@  vote--%@",title,date,vote);
    NSString *dateString=[date substringToIndex:[date length]-9];
    // 2013/08/16
    NSArray *ary = [dateString componentsSeparatedByString:@"-"];
    if ([ary count]>0 && [ary count]==3) {
        
        dateString = [NSString stringWithFormat:@"%@/%@/%@",[ary objectAtIndex:1],[ary objectAtIndex:2],[ary objectAtIndex:0]];
    }
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(3, 0, 200, 30)];
    titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:15];
    titleLabel.text=title;
    titleLabel.textColor=[UIColor darkGrayColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:titleLabel];
    
    NSString *urgent = [NSString stringWithFormat:@"%@",[dict objectForKey:@"urgent"]];
    if ([urgent isEqualToString:@"1"]) {
        UIImageView *urgentImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 12, 25)];
        urgentImage.image = [UIImage imageNamed:@"exclanation_mark.png"];
        [cell.contentView addSubview:urgentImage];
        titleLabel.frame = CGRectMake(18, 0, 160, 50);
    }
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(3, 35, 200, 22)];
    dateLabel.font=[UIFont fontWithName:@"Arial" size:13];
    
    dateLabel.textColor=[UIColor lightGrayColor];
    dateLabel.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:dateLabel];
    //==============================================================
    // NSString *voteTotal=[dict objectForKey:@"TotalVote"];
    
    
    
    if([vote integerValue]==0){
        // Be The First Vote
        UIImage *proImage=[dict objectForKey:@"proImage"];
        UIImageView *beFirst=[[UIImageView alloc]initWithFrame:CGRectMake(260, 23, 50, 20)];
        beFirst.image=proImage;
        [cell.contentView addSubview:beFirst];
        dateLabel.text=dateString;
    }//End if Block check TotalVote
    else{
        
        // voteBar = "100, No"; questiontype=0
        //"100, 520dc743a6550.jpg";  if questiontype=1
        NSString *newvotebar = [dict objectForKey:@"voteBar"];
        NSArray *ary=[newvotebar componentsSeparatedByString:@","];
        NSLog(@"ary = =%@",ary);
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
        
        if([vote isEqualToString:@"1"]){
            dateLabel.text=[NSString stringWithFormat:@"%@    %@ vote",dateString,vote];
        }
        else{
            dateLabel.text=[NSString stringWithFormat:@"%@    %@ votes",dateString,vote];
        }
        
        
        
        //==========================================================================
        
        //==========================================================================
        UIImageView *maxVotedImage=[[UIImageView alloc]initWithFrame:CGRectMake(270, 4, 45, 50)];
        maxVotedImage.layer.borderColor=[UIColor grayColor].CGColor;
        maxVotedImage.layer.borderWidth=1.0;
       
        [cell.contentView addSubview:maxVotedImage];
        
        
        NSString *ques_type = [dict objectForKey:@"QuestionType"];
        
        if ([ques_type isEqualToString:@"1"]) {
            
            [maxVotedImage setImageWithURL:[dict objectForKey:@"ProductImageUrl"]];
        }
        else{
            UIImage *proImage=[dict objectForKey:@"proImage"];
             maxVotedImage.image=proImage;
        }
    }
    
    
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [allQuestionsArray objectAtIndex:indexPath.row];
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    stopIndicator=YES;
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

#pragma mark -
#pragma mark Answer View Delegate
-(void)stopActivityIndicator{
    [HUD hide:YES];
}
-(void)resetFollowValue:(NSMutableDictionary *)dataDict{
    NSString *followValue = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"follow"]];
    if ([allQuestionsArray containsObject:dataDict]) {
        NSLog(@"Contain Object");
    }
    if ([followValue isEqualToString:@"1"]) {
        [dataDict setObject:@"0" forKey:@"follow"];
    }
    else{
        [dataDict setObject:@"1" forKey:@"follow"];
    }
}
#pragma mark -
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
//Web Service call for fetching all questions
-(void)callWebServiceToFetchAllFeed{
    
    
    //http://beta.groupinion.com/android/new_myquestion/?id=
    
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    
    [activityIndicator startAnimating];
    
    NSString *groupinionId=[MySingletonClass sharedSingleton].groupinionUserID;
    NSLog(@"Groupinion ID-%@",groupinionId );
    
    NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/ios_myquestion_with_thumbimage_and_newvotebar/index.php?id=%@",groupinionId];
    allFeedUrl = [allFeedUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"all feed url------%@",allFeedUrl);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
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
    
    //	[alert release];
    //	[mData release];
	
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
    //Check Response
    //{"Status":"0","Message":"Sorry No Data Found"}
    if ([json_string rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
        [HUD hide:YES];
        [activityIndicator stopAnimating];
        
        if (displayAlert==YES) {
            displayAlert=NO;
            UIAlertView *myAlert=  [[UIAlertView alloc] initWithTitle:@"" message:@"You have not asked any questions yet" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [myAlert show];
            [self performSelector:@selector(dismissAlertView:) withObject:myAlert afterDelay:3];
        }
      
    }
    else{
        displayAlert=NO;
        NSArray *resultArray=[json_string JSONValue];
        
        if (!allQuestionsArray) {
            allQuestionsArray = [[NSMutableArray alloc]init];
            
        }
        else{
            [allQuestionsArray removeAllObjects];
        }
        
        for (int i =0; i<[resultArray count]; i++) {
            NSMutableDictionary *dict=[resultArray objectAtIndex:i];
            [self createTableCell:dict];
            
        }
        if (resultArray.count>0) {
            questionTable.hidden=NO;
            [questionTable reloadData];
        }
        [HUD hide:YES];
        
        [activityIndicator stopAnimating];
    }
}
//Fetch TabeViewCell Data
-(void)createTableCell:(NSMutableDictionary *)feed{
    
    NSString *vote=[feed objectForKey:@"TotalVote"];
    UIImage *proImage=nil;
    //Check question voted or not
    if ([vote isEqualToString:@"0"]) {
        
        proImage = [UIImage imageNamed:@"beFirst.png"];
        
        [feed setObject:proImage forKey:@"proImage" ];
    }
    else{
        
        NSString *newvotebar = [feed objectForKey:@"voteBar"];
        NSArray *ary=[newvotebar componentsSeparatedByString:@","];
        NSString *ques_type = [feed objectForKey:@"QuestionType"];
        //Check Question type
        if ([ques_type isEqualToString:@"1"]) {
            
            NSString *imageName=[ary objectAtIndex:2];
            imageName=[imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *str=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/thumb_75_75/%@",imageName];
            [feed setObject:[NSURL URLWithString:str] forKey:@"ProductImageUrl"];
        }//check if block End
        else{
            //Check highest voted count
            NSString *votedTo=[ary objectAtIndex:1];
            if ([votedTo rangeOfString:@"Yes"].location != NSNotFound) {
                //yes highest voted
                proImage=[UIImage imageNamed:@"yesimg.png"];
            }
            else{
                //Not Highest voted
                proImage=[UIImage imageNamed:@"noimg.png"];
                
            }
            [feed setObject:proImage forKey:@"proImage" ];
            
        }//End else block ques_type
    }
    [allQuestionsArray addObject:feed];
   // NSLog(@"Pro Image Lists -=- %@",proImage);
}//check if block End
@end