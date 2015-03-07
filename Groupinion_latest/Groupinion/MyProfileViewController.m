//
//  MyProfileViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "MyProfileViewController.h"
#import "JSON.h"
#import "MySingletonClass.h"
#import "CustomRatingCell.h"
#import "SendHttpRequest.h"
#import "MBProgressHUD.h"

@interface MyProfileViewController ()
{
    int arrayCountInt;
    UIImageView *profileImage;
    
}
@property(nonatomic, strong)MBProgressHUD *HUD;
@property (nonatomic, strong)UIImageView *profileImage;
@end

@implementation MyProfileViewController
@synthesize profileImage,HUD;
@synthesize rateAry,ratingArray;

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)displayActivityIndicator{
    HUD = [[MBProgressHUD alloc]init];
    HUD.delegate=self;
    HUD.dimBackground=YES;
    [self.view addSubview:HUD];
    [HUD show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    //[HUD release];
    HUD = nil;
}
/* Notifiaction  handler method for refreshView and refreshAfterAction
 */
-(void)refreshMyProfileAfterAction{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // send your notification here instead of in updateFunction
        //[[NSNotificationCenter defaultCenter] post...];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyProfileAfterAction) name:@"refreshAfterAction" object:nil];
   
    //=============================================
    //Add Setting Button To View
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame=CGRectMake(260, 8, 50, 35);
    
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    //Profile Label....
    UILabel *profileName=[[UILabel alloc]initWithFrame:CGRectMake(4, 170, 50, 40)];
    profileName.text=@"Profile:";
    profileName.adjustsFontSizeToFitWidth=NO;
    profileName.font=[UIFont fontWithName:@"Arial-BoldMT" size:13];
    
    profileName.backgroundColor=[UIColor clearColor];
    [self.view addSubview:profileName];
    
    //line------
    self.lineBelowRating=[[UIView alloc]initWithFrame:CGRectMake(4, 218, 320, 1)];
    self.lineBelowRating.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.lineBelowRating];
    
    //Ratings Label..
    self.ratingLabel=[[UILabel alloc]initWithFrame:CGRectMake(4, 220, 100, 15)];
    self.ratingLabel.text=@"Ratings:";
    self.ratingLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:13];
    [self.view addSubview:self.ratingLabel];
    
    //Rating Table Creation..
    ratingTable=[[UITableView alloc]initWithFrame:CGRectMake(4, 235, 320, 150)];
    ratingTable.hidden=YES;
    ratingTable.delegate=self;
    ratingTable.dataSource=self;
    ratingTable.backgroundColor=[UIColor clearColor];
    [self.view addSubview:ratingTable];
    
    //Activity indicator....
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 5, 40, 40)];
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:activityIndicator];
    
    //FBLogin....
    fBLogin= [[MySingletonClass sharedSingleton]loginWithFacebook];
    NSLog(@"fb login-%c",fBLogin);
    //NickName of FB...
    nickNameOfFB=[[MySingletonClass sharedSingleton]nickName];
    NSLog(@"Nick Name-%@",nickNameOfFB);
    
    //Rating Array Allocation..
    ratingArray=[[NSMutableArray alloc]init];
    
    rateAry=[[NSMutableArray alloc]init];
    
    //Profile Buttton....
    UIButton *profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(4, 150, 100, 25);
    [profileButton addTarget:self action:@selector(profileButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [profileButton setTitle:@"Change image" forState:UIControlStateNormal];
    profileButton.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [profileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:profileButton];
    
    //Profile Image...
    profileImage=[[UIImageView alloc]initWithFrame:CGRectMake(4, 55, 100, 100)];
    //profileImage.image=[UIImage imageNamed:[resultDict objectForKey:@"PROFILE_PIC"]];
    [self.view addSubview:profileImage];
    
    self.descriptionTextView = [[UITextView alloc]init];
    self.descriptionTextView.frame = CGRectMake(5, 200, 320, 30);
    self.descriptionTextView.editable=NO;
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.descriptionTextView];
    
    
    //EditButton....
    UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:[UIImage imageNamed:@"edit.png"] forState:UIControlStateNormal];
    editButton.backgroundColor=[UIColor clearColor];
    editButton.frame=CGRectMake(70, 182, 30, 15);
    [editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    
    //Name Lable
    self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 200, 40)];
    self.nameLable.adjustsFontSizeToFitWidth=NO;
    self.nameLable.font = [UIFont boldSystemFontOfSize:17];
    self.nameLable.textColor = [UIColor darkGrayColor];
    self.nameLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.nameLable];
    
    
    //Total Comment label..
    self.totalCommentLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 97, 200, 40)];
    self.totalCommentLabel.adjustsFontSizeToFitWidth=NO;
    self.totalCommentLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:13];
    self.totalCommentLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.totalCommentLabel];
    
    self.questionAskedLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 125, 200, 40)];
    
    self.questionAskedLabel.adjustsFontSizeToFitWidth=NO;
    self.questionAskedLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:13];
    self.questionAskedLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.questionAskedLabel];
    
    
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground = YES;
    [self.view addSubview:HUD];
    
    
    [self callWebServiceToFetchAllFeed];
    
}
#pragma mark-
#pragma mark Rating table delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    arrayCountInt=[ratingArray count];
    
    return [ratingArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier=@"cellIdentifier";
    CustomRatingCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[CustomRatingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dictStuff=[ratingArray objectAtIndex:indexPath.row];
    
    cell.categoryName.text=[dictStuff objectForKey:@"Categories"];
    NSString *starCount = [dictStuff objectForKey:@"star"];
    NSLog(@"Indexpath.row = %ld",(long)indexPath.row);
    NSLog(@"Star count string = =%@",starCount);
    NSString *starImageName = [NSString stringWithFormat:@"starimage%@.png",starCount];
    int starCountIntValue = [starCount intValue];
    cell.ratingImage.frame = CGRectMake(60,35 , 16*starCountIntValue, 15);
    cell.ratingImage.image=[UIImage imageNamed:starImageName];
    
    
    if ([cell.categoryName.text isEqualToString:@"Shopping & Fashion"]) {
        
        cell.imageView.image=[UIImage imageNamed:@"shopping_icon.png"];
    }
    else if ([cell.categoryName.text isEqualToString:@"Entertainment"]) {
        
        cell.imageView.image=[UIImage imageNamed:@"entertainment.png"];
    }
    else if ([cell.categoryName.text isEqualToString:@"Sports"]) {
        cell.imageView.image=[UIImage imageNamed:@"sports.png"];
    }
    else if ([cell.categoryName.text isEqualToString:@"Food & Lifestyle"]) {
        cell.imageView.image=[UIImage imageNamed:@"food.png"];
    }
    else if ([cell.categoryName.text isEqualToString:@"News & Politics"]) {
        cell.imageView.image=[UIImage imageNamed:@"news.png"];
    }
    return cell;
}
#pragma mark -
//Prepare Service  for Fetch Profile Info for logged in User
-(void)callWebServiceToFetchAllFeed{

    [activityIndicator startAnimating];
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    NSString *groupinionId=[MySingletonClass sharedSingleton].groupinionUserID;
    
    NSString *allFeedUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/profile/index.php/?uid=%@",groupinionId];
    
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
    
 	NSMutableURLRequest *l_pRequest = [[NSMutableURLRequest alloc]initWithURL:l_pURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:50.0];
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
    
    //	[alert release];
    //	[mData release];
	
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
    NSLog(@"json_String==%@",json_string);
    
    //Check Response
    if([json_string isEqualToString:@"error"]){
        NSLog(@"Error");
        [HUD hide:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    
    else{
        //Check Staus
        if([json_string rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            
            
            //{"Status":"0","Message":"all fields are mandatory"}
            [HUD hide:YES];
            NSDictionary *dict11 = [json_string JSONValue];
            NSString *msg = [dict11 objectForKey:@"Message"];
            
            [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
        else{
            //{"Status":"1","PROFILE_PIC":"0.jpg","TOTAL_CMT":"6","TOTAL_CMT_RATE":0,"AVG_CMT_RATE":0,"TOTAL_QUESTION":"16","AVG_QUESTION_RATE":0,"DescriptionMe":"hai","Default_image_status":"0"}
            
            
            NSDictionary *resultDict=[json_string JSONValue];
            
            NSLog(@"all Profile-----%@",resultDict);
            //Set Nick Name
             self.nameLable.text=[[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"NickName"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
            
            
            NSString *imageUrl;
            //Check image uploaded or not
            if ([[resultDict objectForKey:@"Default_image_status"]isEqualToString:@"0"]) {
                
                NSString *imageName=[resultDict objectForKey:@"PROFILE_PIC"];
                //Check Login type
                if ([MySingletonClass sharedSingleton].loginWithFacebook==YES) {
                    imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large",imageName];
                    
                }
                else
                {
                    imageUrl = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",imageName];
                }
            }
            
            else
            {
                NSString *imageName=[resultDict objectForKey:@"PROFILE_PIC"];
                imageUrl = [NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",imageName];
            }
            
            NSLog(@"image URL-------%@",imageUrl);
            NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            //profileImage.image = [UIImage imageWithData:data];
            //Create Thumbnail Image
            CGSize thumbnailImageSize  = CGSizeMake(100, 100);
            UIImage* thumbnailImage = nil;
            
            UIGraphicsBeginImageContext(thumbnailImageSize);
            [[UIImage imageWithData:data] drawInRect:profileImage.bounds];
            thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            profileImage.image = thumbnailImage;
            //Total Vote
            NSString *totalVote=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"TOTAL_CMT"]];
            if ([totalVote isEqualToString:@"1"] || [totalVote isEqualToString:@"0"]) {
                self.totalCommentLabel.text=[NSString stringWithFormat:@"%@ Total Vote",[resultDict objectForKey:@"TOTAL_CMT"]];
            }
            else{
                self.totalCommentLabel.text=[NSString stringWithFormat:@"%@ Total Votes",[resultDict objectForKey:@"TOTAL_CMT"]];
            }
            //Question Asked label..
                        
            //Total asked questions
            NSString *totalQuestion=[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"TOTAL_QUESTION"]];
            
            if ([totalQuestion isEqualToString:@"1"] || [totalQuestion isEqualToString:@"1"]) {
                self.questionAskedLabel.text=[NSString stringWithFormat:@"%@ Question Asked",[resultDict objectForKey:@"TOTAL_QUESTION"]];
            }
            else{
                self.questionAskedLabel.text=[NSString stringWithFormat:@"%@ Questions Asked",[resultDict objectForKey:@"TOTAL_QUESTION"]];
            }
            
            //Profile added Description
             NSString *des=[[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"DescriptionMe"]] stringByReplacingOccurrencesOfString:@"&#34;" withString:@"\""];
            
            if ([des isEqualToString:@""] || des==nil) {
                
                if (fBLogin == YES) {
                    self.descriptionTextView.text=[MySingletonClass sharedSingleton].about_me;
                }
                else{
                    self.descriptionTextView.text=@"";
                }
                
            }
            else{
                
                self.descriptionTextView.text=des;
            }
            
            //Set Frame
            if ([des length]<40) {
                self.descriptionTextView.frame = CGRectMake(5, 200, 320, 30);
            }
            else if ([des length]>40 && [des length]<=80){
                self.descriptionTextView.frame = CGRectMake(5, 200, 320, 50);
                self.lineBelowRating.frame=CGRectMake(4, 250, 320, 1);
                self.ratingLabel.frame=CGRectMake(4, 252, 100, 15);
                ratingTable.frame=CGRectMake(4, 267, 320, 150);
            }
            else if ([des length]>80 && [des length]<=120){
                self.descriptionTextView.frame = CGRectMake(5, 200, 320, 70);
                self.lineBelowRating.frame=CGRectMake(4, 258, 320, 1);
                self.ratingLabel.frame=CGRectMake(4, 260, 100, 15);
                ratingTable.frame=CGRectMake(4, 270, 320, 150);
            }
            else if ([des length]>120){
                self.descriptionTextView.frame = CGRectMake(5, 200, 320, 76);
                self.lineBelowRating.frame=CGRectMake(4, 278, 320, 1);
                self.ratingLabel.frame=CGRectMake(4, 280, 100, 15);
                ratingTable.frame=CGRectMake(4, 295, 320, 150);
            }
            
            [self getLevelForCategory];
            
            
        }//End Check Status Block
        
    }//End Check Error Block
    
    [activityIndicator stopAnimating];
    
}

#pragma mark -
//Get Category Level info
-(void)getLevelForCategory{
    
    NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
    //Prepare Web Service for fetching Category Level Info
    NSString *stringUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/level/index.php?uid=%@",uid ];
    
    NSString *response = [SendHttpRequest sendRequest:stringUrl];
    
    if([response isEqualToString:@"error"]){
        [HUD hide:YES];
    }
    else{
        //Check response status
        if([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
            //{"Status":"0","Message":"User Id field should not be empty"}
            [HUD hide:YES];
        }
        else{
            //[{"Categories":"Sports","star":"3"},{"Categories":"Shopping & Fashion","star":"4"},{"Categories":"Entertainment","star":"3"},{"Categories":"News & Politics","star":"1"},{"Categories":"Food & Lifestyle","star":"2"}]
            
            if (!ratingArray) {
                ratingArray = [[NSMutableArray alloc]init];
            }
            else{
                [ratingArray removeAllObjects];
            }
            
            NSArray *ary = [response JSONValue];
            
            for (int i=0; i <[ary count]; i++) {
                
                NSDictionary *starDict = [ary  objectAtIndex:i];
                
                NSString *str=[starDict objectForKey:@"star"];
                
                if (![str isEqualToString:@"0"]) {
                    [ratingArray addObject:starDict];
                }
            }
            if ([ratingArray count]>0) {
                ratingTable.hidden=NO;
                [ratingTable reloadData];
            }
            
            
            [HUD hide:YES];
        }
    }
    
}

//Edit button Action
-(void)editButtonClicked
{
    self.textViewEdit = [[UITextView alloc]initWithFrame:CGRectMake(12, 50, 260, 50)];
    self.textViewEdit.delegate=self;
    [self.textViewEdit becomeFirstResponder];
    
    editAlertView = [[UIAlertView alloc]initWithTitle:@"Enter Description" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    editAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    editAlertView.tag=2;
    [self.textViewEdit becomeFirstResponder];
    [editAlertView addSubview:self.textViewEdit];
    
    [editAlertView show];
    //[self profileButtonClicked];
}

-(NSString*) encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef) string,
                                                              NULL,
                                                              (CFStringRef) @"!*'()@+$,&%=/#[]",
                                                              kCFStringEncodingUTF8));}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==2) {
        
        if (buttonIndex==1) {

            if ([self.textViewEdit.text isEqualToString:@""]) {
                NSLog(@"Enter description First");
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter description" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                //Update Profile Description
                [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
                
                NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
                NSString *des=self.textViewEdit.text;
                
                NSString *desURI = [self encodeToPercentEscapeString:des];
                
                //Service for update description
                NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/profileupdate/index.php?uid=%@&dis=%@",uid,desURI];

                NSLog(@"Edit Profile url = %@",urlString);
                
                NSString *response = [SendHttpRequest sendRequest:urlString];
                
                if ([response isEqualToString:@"error"]) {
                    
                    [HUD hide:YES];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                }
                
                else{
                    //{"Status":"0","Message":"All fields are mandatory"}
                    NSDictionary *dict=[response JSONValue];
                    if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
                        NSLog(@"Error");
                        [HUD hide:YES];
                        [[[UIAlertView alloc] initWithTitle:@"" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    }
                    else{
                        //                        /{"status":"1","message":"User Profile Update Successfully"}
                        self.descriptionTextView.text=des;
                        //set Frame
                        if ([des length]<40) {
                            self.descriptionTextView.frame = CGRectMake(5, 200, 320, 30);
                            self.lineBelowRating.frame=CGRectMake(4, 228, 320, 1);
                            self.ratingLabel.frame=CGRectMake(4, 230, 100, 15);
                            ratingTable.frame=CGRectMake(4, 240, 320, 150);
                        }
                        else if ([des length]>40 && [des length]<=80){
                            self.descriptionTextView.frame = CGRectMake(5, 200, 320, 50);
                            self.lineBelowRating.frame=CGRectMake(4, 250, 320, 1);
                            self.ratingLabel.frame=CGRectMake(4, 252, 100, 15);
                            ratingTable.frame=CGRectMake(4, 267, 320, 150);
                        }
                        else if ([des length]>80 && [des length]<=120){
                            self.descriptionTextView.frame = CGRectMake(5, 200, 320, 70);
                            self.lineBelowRating.frame=CGRectMake(4, 258, 320, 1);
                            self.ratingLabel.frame=CGRectMake(4, 260, 100, 15);
                            ratingTable.frame=CGRectMake(4, 270, 320, 150);
                        }
                        else if ([des length]>120){
                            self.descriptionTextView.frame = CGRectMake(5, 200, 320, 90);
                            self.lineBelowRating.frame=CGRectMake(4, 278, 320, 1);
                            self.ratingLabel.frame=CGRectMake(4, 280, 100, 15);
                            ratingTable.frame=CGRectMake(4, 290, 320, 150);
                        }
                        
                        [HUD hide:YES];
                        
                        
                        [[[UIAlertView alloc] initWithTitle:@"" message:[dict objectForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    }
                }
                
            }
            
        }//end if block buttonIndex==1
    }//End if block tag condition
}

#pragma mark -
//Profile Button Action
-(void)profileButtonClicked
{
    //display Photo Album
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        imagePicker.delegate = self;
        
        imagePicker.view.frame = CGRectMake(0, 0, 320, 400);
        
        
        [self.view addSubview:imagePicker.view];
    }
}
#pragma mark ImagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    imagePicker.view.hidden=YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Get Selected image
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSLog(@"Before---%f,%f",image.size.width,image.size.height);
    imagePicker.view.hidden=YES;
    //Set Image Orientation
    UIImage *orientedImage = [SendHttpRequest orientedFixedImage:image];
   //Get Image data
    NSData *imageData = UIImageJPEGRepresentation(orientedImage, 0);//It should convert to JPG.....
    //get size of Image
    int sizeOfImage=imageData.length/1024;
    
    NSLog(@"Size of Image--%i kb",sizeOfImage);
    //Check image size
    if (sizeOfImage<3024) {
        
        [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
       
        BOOL uploaded=[self uploadImageToServer:imageData];
        
        if (uploaded==YES) {
            //Create Thumbnail image
            CGSize thumbnailImageSize  = CGSizeMake(100, 100);
            UIImage* thumbnailImage = nil;
            
            UIGraphicsBeginImageContext(thumbnailImageSize);
            [image drawInRect:profileImage.bounds];
            thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            profileImage.image=thumbnailImage;
            [MySingletonClass sharedSingleton].profileImage=thumbnailImage;
            [MySingletonClass sharedSingleton].reported=YES;
            [MySingletonClass sharedSingleton].sendNotification=NO;
        }
        
        NSLog(@"Uploaded---%c",uploaded);
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please limit photo uploads to under 3.4MB" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];     //alert show.
        
    }
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


#pragma mark -
//Upload Image to server..
-(BOOL)uploadImageToServer:(NSData *)data{
    //create image name on the basis of Date nad Time
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm:ssdd/MM/yy"];
    NSDate *cDate=[NSDate date];
    
    NSString *fileName=[formatter stringFromDate:cDate];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSLog(@"FileName==%@",fileName);
    
    //set file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory
                           stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",fileName]];
    NSLog(@"imagePath==%@",imagePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //save image to file path
    [fileManager createFileAtPath:imagePath contents:data attributes:nil];
   
    NSURL *url = [NSURL URLWithString:@"http://beta.groupinion.com/android/avataruploadimage/UploadToServer.php"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //Set boby for request
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@\"\r\n", imagePath] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Image Return String: %@",returnString);
    
    BOOL retuneStatus;
    // Image Uploaded or not if return success than Yes otherwise No.
    if([returnString isEqualToString:@"success"]){
        retuneStatus = YES;
        NSString *groupinionId=[MySingletonClass sharedSingleton].groupinionUserID;
        NSString *imageFile=fileName;
        //set new profile image
        NSString *stringUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/profilepic/index.php/?uid=%@&image=%@&ext=jpg",groupinionId,imageFile];
        
        NSLog(@"String Url--%@",stringUrl);
        
        NSString *responseString=[self fetchAllCategories:stringUrl];
        
        NSDictionary *dictResult=[responseString JSONValue];
        
        NSLog(@"dict Result--%@",dictResult);
        
        if ([[dictResult objectForKey:@"Status"] isEqualToString:@"1"] )
        {
            //{"Status":"1","Path":"http://beta.groupinion.com/app3/modules/boonex/avatar/data/images/103155120813.jpg"}
            NSString *path=[dictResult objectForKey:@"Path"];
            
            NSURL *url=[NSURL URLWithString:path];
            
            NSData *dataImage=[NSData dataWithContentsOfURL:url];
            
            profileImage.image=[UIImage imageWithData:dataImage];
            [HUD hide:YES];
        }
        else
        {//{"Status":"0","Message":"All fields are mandatory"}
            [HUD hide:YES];
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error in Uploading" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }
    else{
        
        retuneStatus = NO;
        [HUD hide:YES];
    }
    return  retuneStatus;
}

-(NSString *)fetchAllCategories:(NSString *)urlString{
    
    //  NSLog(@"URL String----%@",urlString);
    NSHTTPURLResponse   * response;
    NSURL *url=[NSURL URLWithString:urlString];
    
    NSError *error;
    NSLog(@"url==%@",url);
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *respo=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"respo==%@",respo);
    
    return respo;
    
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
//Setting button Action
-(void)settingButtonClicked{
    NSLog(@"Setting Button Clicked");
    SettingViewController *setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView == self.textViewEdit) {
        
        if ([self.textViewEdit.text length]>=140 && range.length==0) {
            return NO;
        }
    }
    return YES;
}

@end



