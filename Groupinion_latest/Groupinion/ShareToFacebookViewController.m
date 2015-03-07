//
//  ShareToFacebookViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 05/08/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "ShareToFacebookViewController.h"
#import "SettingViewController.h"
#import "GroupViewController.h"
#import "MBProgressHUD.h"
#import "SendHttpRequest.h"
#import "JSON.h"
#import "MySingletonClass.h"
#import "AppDelegate.h"

#define kmaxHeight 105

@interface ShareToFacebookViewController ()
{
    
}
@property(nonatomic, strong)MBProgressHUD *HUD;
@end

@implementation ShareToFacebookViewController
@synthesize HUD;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Prepare UI
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"sharequesheadernew.png"];
    [self.view addSubview:bannerImage];
    
    //================================================
    
    self.nameLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, 320, 30)];
    self.nameLable.textAlignment=NSTextAlignmentLeft;
    self.nameLable.font=[UIFont boldSystemFontOfSize:17];
    self.nameLable.textColor = [UIColor lightGrayColor];
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.text = @"You asked:";
    [self.view addSubview:self.nameLable];
    //======================================================
    
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame= CGRectMake(260, 8, 50, 35);
    
    settingBtn.enabled=YES;
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    //========================================================
    
    self.questionview=[[UITextView alloc]initWithFrame:CGRectMake(5, 75, 300, 105)];
    
    self.questionview.backgroundColor=[UIColor clearColor];
    self.questionview.textColor=[UIColor lightGrayColor];
    self.questionview.editable=NO;
    self.questionview.scrollEnabled=NO;
   
    
    self.questionview.font=[UIFont systemFontOfSize:16.0f];
    self.questionview.text=self.question;
    [self.view addSubview:self.questionview];
    
    
    
    //================================================
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    
    self.dateLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 115, 320, 30)];
    self.dateLable.textAlignment=NSTextAlignmentLeft;
    self.dateLable.backgroundColor = [UIColor clearColor];
    self.dateLable.font=[UIFont boldSystemFontOfSize:17];
    self.dateLable.textColor = [ UIColor lightGrayColor];
    self.dateLable.text = currentDate;
    [self.view addSubview:self.dateLable];
    //========================================================
    
    
    self.descriptionTestView=[[UITextView alloc]initWithFrame:CGRectMake(5, 135, 300, 60)];
    
    self.descriptionTestView.backgroundColor=[UIColor clearColor];
    self.descriptionTestView.textColor=[UIColor lightGrayColor];
    self.descriptionTestView.editable=NO;
    self.descriptionTestView.scrollEnabled=NO;
    self.descriptionTestView.font=[UIFont systemFontOfSize:16.0f];
    self.descriptionTestView.textColor = [UIColor darkGrayColor];
    self.descriptionTestView.text = @"Share this question with your friends and see what they think!";
    [self.view addSubview:self.descriptionTestView];
    
    //=====================================================
    self.facebookLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(130, 210, 60, 60)];
    self.facebookLogoImageView.image=[UIImage imageNamed:@"find_facebook.png"];
    [self.view addSubview:self.facebookLogoImageView];
    
    
    //=============================================
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareButton.frame= CGRectMake(115, 300, 90, 30);
    
    self.shareButton.enabled=YES;
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"sharequessharebtnimg.png"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareButton];
    
    //=======================================================
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.skipButton.frame= CGRectMake(115,340,90,30);
    
    self.skipButton.enabled=YES;
    [self.skipButton setBackgroundImage:[UIImage imageNamed:@"skips.png"] forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipButton];
    
    
    if([self.question length]>40 && [self.question length]<=80){
        self.questionview.frame=CGRectMake(5, 75, 300, 70);
        self.dateLable.frame=CGRectMake(10, 135, 320, 30);
        self.descriptionTestView.frame = CGRectMake(5, 155, 300, 60);
        self.facebookLogoImageView.frame=CGRectMake(130, 230, 60, 60);
        self.shareButton.frame=CGRectMake(115, 320, 90, 30);
        self.skipButton.frame=CGRectMake(115, 360, 90, 30);
    }
    
    else if ([self.question length]>80 && [self.question length]<=120 ){
        self.questionview.frame=CGRectMake(5, 75, 300, 90);
        self.dateLable.frame=CGRectMake(10, 165, 320, 30);
        self.descriptionTestView.frame = CGRectMake(5, 180, 300, 60);
        self.facebookLogoImageView.frame=CGRectMake(130, 240, 60, 60);
        self.shareButton.frame=CGRectMake(115, 320, 90, 30);
        self.skipButton.frame=CGRectMake(115, 360, 90, 30);
        
        
    }
    else if ([self.question length]>120 ){
        self.questionview.frame=CGRectMake(5, 75, 300, 110);
        self.dateLable.frame=CGRectMake(10, 180, 320, 30);
        self.descriptionTestView.frame = CGRectMake(5, 200, 300, 60);
        self.facebookLogoImageView.frame=CGRectMake(130, 260, 60, 60);
        self.shareButton.frame=CGRectMake(115, 330, 90, 30);
        self.skipButton.frame=CGRectMake(115, 370, 90, 30);
        
    }
    
    if (self.imageSelected==YES) {
       [self getMemeImageForFacebookPost]; 
    }
    
    
}

#pragma mark -
//Get meme image
-(void)getMemeImageForFacebookPost{
    
    //[NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    
    NSString *memeResponse = [SendHttpRequest sendRequest:self.memeUrlString];
    NSLog(@"Response Meme= %@",memeResponse);
    
    if ([memeResponse isEqualToString:@"error"]) {
       // [HUD hide:YES];
        NSLog(@"Error to Generate Meme Image http request");
    }
    else{
        
        //{"thumbimg":"http://beta.groupinion.com/wp-content/themes/groupinion/thumbs/J0FO9temp.png","fullimg":"http://beta.groupinion.com/wp-content/themes/groupinion/tempImage/J0FO9temp.png"}
       // [HUD hide:YES];
        
        
        NSDictionary *dict= [memeResponse JSONValue];
        self.fbPostImageUrl = [dict objectForKey:@"fullimg"];
        NSLog(@"meme = %@", self.fbPostImageUrl);
        
    }
}

//Skip Button Action
-(void)skipButtonClicked{
    
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    [MySingletonClass sharedSingleton].reported=YES;
    [MySingletonClass sharedSingleton].sendNotification=NO;
    [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
    [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
    [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
    
    GroupViewController *group = [MySingletonClass sharedSingleton].groupViewController;
    [group.myTabBarController setSelectedIndex:0];
   
}

-(void)displayActivityIndicator{
    
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground  =YES;
    [self.view addSubview:HUD];
   
    [HUD show:YES];
}

//Share button Action
-(void)shareButtonClicked{
    NSLog(@"Share Button Clicked");
    
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    NSString *fbID=[MySingletonClass sharedSingleton].fbUserID;
    //Check facebook session
    if (FBSession.activeSession.isOpen && ![fbID isEqualToString:@""]) {
        
        //session already open
         [self firstCallMethod];
        
    }
    else{
        //open session
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate openSessionWithAllowLoginUI:YES];
    }

    
    
}


-(void) firstCallMethod{
    //Check image selected or not
        if (self.imageSelected==NO) {
            //Post text to user wall
            [self postQustionToUsersWall];
        }
        else{
            [self createGroupinionAlbum]; 
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
//Settign button Action
-(void)settingButtonClicked{
    NSLog(@"Setting Button Clicked");
    
    SettingViewController *setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    [self.navigationController pushViewController:setting animated:YES];
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
#pragma mark Facebook
//Post on User wall
-(void)postQustionToUsersWall{
    [FBRequestConnection startForPostStatusUpdate:self.fbPostString completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    
            if (error) {
                NSLog(@"Error in Posted=%@",error);
                [HUD hide:YES];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            } else {
                NSLog(@"Posted successfully");
                myAlert=  [[UIAlertView alloc] initWithTitle:@"" message:@"Message has been posted" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [myAlert show];
                                        
                [self performSelector:@selector(dismissAlert:) withObject:myAlert afterDelay:2];
            }
                                    
        }];
}

//Create Groupinion Album
-(void)createGroupinionAlbum{
    
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicator) toTarget:self withObject:nil];
    
    
    NSMutableDictionary *createAlbumDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Groupinion Questions",@"name", nil];
    //Fetch user Album details
    [FBRequestConnection startWithGraphPath:@"me/albums" parameters:createAlbumDict HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection,id result, NSError *error){
        
        if (error) {
            [HUD hide:YES];
            NSLog(@"Error==%@",error);
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
            NSLog(@"Result Album check==%@",result);
            //Fetch all Albums
                NSArray *resultArray = (NSArray *) result[@"data"];
                NSString *albumID = nil;
                BOOL albumExist = NO;
            //Check Groupinion Album exist or not
                for (int i=0; i<[resultArray count]; i++) {
                    
                    NSString *albumName = resultArray[i][@"name"];
                    if([albumName isEqualToString:@"Groupinion Questions"]){
                        NSLog(@"Album name = %@",resultArray[i][@"name"]);
                        NSLog(@"Album id = %@",resultArray[i][@"id"]);
                        albumID = resultArray[i][@"id"];
                        albumExist = YES;
                        [self uploadImageToFacebook:albumID];
                        break;
                    }
                    else{
                        NSLog(@"Album name = %@",resultArray[i][@"name"]);
                        NSLog(@"Album id = %@",resultArray[i][@"id"]);
                    }
                    
                }
                
                if (albumExist == YES) {
                    //alnum already created
                    NSLog(@"Upload to Album and id=%@",albumID);
                }
                else{
                    NSLog(@"Create Album First");
                    //create Groupinion Album
                    [FBRequestConnection startWithGraphPath:@"me/albums" parameters:createAlbumDict HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection,id result, NSError *error){
                        
                        if (error) {
                            [HUD hide:YES];
                            NSLog(@"Error to create Album on Facebook=%@",error);
                            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                        }
                        else{
                            NSLog(@"Album Created");
                            NSLog(@"Crated Album Result = %@",result);
                            //Fetch Groupinion Album ID
                            NSString *albumID = [result objectForKey:@"id"];
                            //Post image to Groupinion Album
                            [self uploadImageToFacebook:albumID];
                        }
                        
                    }];
                }
            }
        
    }];
}


-(void)dismissAlert:(UIAlertView *) alertView
{
    [myAlert dismissWithClickedButtonIndex:0 animated:YES];
    [HUD hide:YES];
    [self skipButtonClicked];
}

//Upload Image to Facebook
-(void)uploadImageToFacebook:(NSString *)albumid{
    
    NSLog(@"fb post url =%@",self.fbPostImageUrl);
    UIImage *selectedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.fbPostImageUrl]]];
    NSData *imageData = UIImageJPEGRepresentation(selectedImage, 0);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath = [documentsDirectory
                           stringByAppendingPathComponent:[NSString stringWithFormat:@"newimage.jpg"]];
    NSLog(@"imagePath==%@",imagePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Save image to FileManager
    [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
    
    //Prepare Dict
    NSMutableDictionary *params= [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  selectedImage,@"picture",self.fbPostString,@"caption",
                                  nil];
    
    NSString *graphPath=[NSString stringWithFormat:@"%@/Photos",albumid];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    // First request uploads the photo.
    //Prepare request
    FBRequest *requestttt = [FBRequest requestWithGraphPath:graphPath parameters:params HTTPMethod:@"POST"];
    

    
    [connection addRequest:requestttt
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             //[HUD hide:YES];
             myAlert=  [[UIAlertView alloc] initWithTitle:@"" message:@"Image has been posted" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
             [myAlert show];
             
             [self performSelector:@selector(dismissAlert:) withObject:myAlert afterDelay:2];
            // [self skipButtonClicked];
         }
         else{
             [HUD hide:YES];
             [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
             NSLog(@"Error==%@",error.userInfo);
         }
     }
            batchEntryName:@"Groupinionphotopost"
     ];
    
    [connection start];
    
}


@end
