//
//  SignInAndUpViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 18/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "SignInAndUpViewController.h"
#import "MySingletonClass.h"
#import "ResendVerificationMailViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "SendHttpRequest.h"


#define PushNotificationDeviceToken @"GroupinionPushNotificationDeviceToken"
#define CheckFirstRun @"CheckGroupinionFirstRun"

@interface SignInAndUpViewController ()
{
}
@property(nonatomic, strong)MBProgressHUD *HUD;
@end

@implementation SignInAndUpViewController
@synthesize action,HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    self.passwordTextField.text=@"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //add banner Image Of Groupinion
    bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    bannerImage.image=[UIImage imageNamed:@"group.png"];
    [self.view addSubview:bannerImage];
    
    secondBanner=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 35)];
    [self.view addSubview:secondBanner];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame= CGRectMake(10, 8, 60, 35);
    
    backBtn.enabled=YES;
    [backBtn setBackgroundImage:[UIImage imageNamed:@"Back_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //================================================
    //Add Password Text Field
    self.passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 150, self.view.bounds.size.width-20, 30)];
    self.passwordTextField.textAlignment=NSTextAlignmentCenter;
    self.passwordTextField.delegate=self;
    self.passwordTextField.borderStyle=UITextBorderStyleBezel;
    self.passwordTextField.secureTextEntry=YES;
    [self.view addSubview:self.passwordTextField];
    
    //================================================
    //Add Password Text Field
    self.emailTextField=[[UITextField alloc]init];
    self.emailTextField.textAlignment=NSTextAlignmentCenter;
    self.emailTextField.borderStyle=UITextBorderStyleBezel;
    self.emailTextField.delegate=self;
    [self.view addSubview:self.emailTextField];
    
    
    //=========================================
    //Create Account Button
    
    self.createAccountButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.createAccountButton.layer.cornerRadius=5.0;
    // self.createAccountButton.layer.borderWidth=1.0f;
    //self.createAccountButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.createAccountButton.clipsToBounds=YES;
    
    [self.createAccountButton setBackgroundImage:[UIImage imageNamed:@"create_account_btn.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.createAccountButton];
    
    
    //Check Action type
    if([action isEqualToString:@"signin"]){
        
        secondBanner.image=[UIImage imageNamed:@"please_login"];
        
        self.emailTextField.frame=CGRectMake(10, 100, self.view.bounds.size.width-20, 30);
        self.passwordTextField.placeholder=@"Enter your password";
        self.emailTextField.placeholder=@"Enter your e-mail";
        self.emailTextField.keyboardType=UIKeyboardTypeEmailAddress;
        
        //=========================================
        //Create Account Button
        
        self.loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.loginButton.layer.cornerRadius=5.0;
        //self.loginButton.layer.borderWidth=1.0f;
        // self.loginButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
        self.loginButton.clipsToBounds=YES;
        self.loginButton.frame=CGRectMake(10, 200, self.view.bounds.size.width-20, 35);
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(performUserLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginButton];
        
        //Set Position Of Create Account button
        self.createAccountButton.frame=CGRectMake(10, 250, self.view.bounds.size.width-20, 30);
        
        [self.createAccountButton addTarget:self action:@selector(signUpView) forControlEvents:UIControlEventTouchUpInside];
        
        self.emailTextField.text = @"avinashkashyap@globussoft.com";
        self.passwordTextField.text = @"INas_1820";
        
    }
    else{
        
        [self signUpView];
        
    }
    
    //===============================================
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 265, 30, 30)];
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground  =YES;
    [self.view addSubview:HUD];
}

-(void)backButtonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)signUpView{
    
    secondBanner.image=[UIImage imageNamed:@"create_acc_banner.png"];
    
    self.emailTextField.frame=CGRectMake(10, 200, self.view.bounds.size.width-20, 30);
    self.passwordTextField.placeholder=@"Enter your password";
    self.emailTextField.placeholder=@"Add your e-mail";
    
    //Add User Name Text Field in the time of Registration
    self.user_nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 30)];
    self.user_nameTextField.placeholder=@"Username you'd like to have";
    self.user_nameTextField.borderStyle=UITextBorderStyleBezel;
    self.user_nameTextField.delegate=self;
    self.user_nameTextField.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:self.user_nameTextField];
    
    self.loginButton.hidden=YES;
    
    self.createAccountButton.frame=CGRectMake(10, 250, self.view.bounds.size.width-20, 35);
    [self.createAccountButton removeTarget:self action:@selector(signUpView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.createAccountButton addTarget:self action:@selector(performRegistration) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.user_nameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark -
#pragma mark Registration
-(void)performRegistration{
    
    NSLog(@"User Name==%@",self.user_nameTextField.text);
    NSLog(@"Password==%@",self.passwordTextField.text);
    NSLog(@"Email==%@",self.emailTextField.text);
    
    if(self.user_nameTextField.text==NULL){
        NSLog(@"Null");
    }
    if(self.user_nameTextField.text==nil){
        NSLog(@"nil");
    }
    
    if ([self.user_nameTextField.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || self.user_nameTextField.text==NULL ||self.emailTextField.text==NULL || self.passwordTextField.text==NULL || self.user_nameTextField.text==nil ||self.emailTextField.text==nil || self.passwordTextField.text==nil) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please Enter All Details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        
        [activityIndicator startAnimating];
        
        NSString *email=self.emailTextField.text;
        NSLog(@"Entered Email=%@",email);
        //Email Validation
        BOOL corrct=[self checkEmailValidation:email];
        
        if(corrct==YES){
            
            //http://beta.groupinion.com/android/newaccount/index.php?uname=&email=&password
            [HUD show:YES];
            NSString *user_name=self.user_nameTextField.text;
            NSString *password = self.passwordTextField.text;
            
            NSString *signUpUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/account_new/index.php?uname=%@&email=%@&password=%@",user_name,email,password];
            NSDictionary *dict = [[NSDictionary alloc]init];
            NSString *jsonstring1  = [dict JSONRepresentation];
            NSLog(@"ssss  ===%@",jsonstring1);
            NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
            //[dict release];
            NSLog(@"56566=====%@",post1);
            opration = @"signUp";
            [self sendHTTPPost:jsonstring1 :signUpUrl] ;
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Email!" message:@"Please Enter Valid Email id" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [activityIndicator stopAnimating];
            [alert show];
        }
    }
}

-(NSString*) encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef) string,
                                                              NULL,
                                                              (CFStringRef) @"!*'()@+$,&%=/#[]",
                                                              kCFStringEncodingUTF8));}

#pragma mark -
#pragma mark Login

-(void)performUserLogin{
    
//Validation
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]  ||self.emailTextField.text==NULL || self.passwordTextField.text==NULL || self.emailTextField.text==nil || self.passwordTextField.text==nil) {
        
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please Enter All Details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    
    else{
        
        NSString *email=self.emailTextField.text;
        NSLog(@"Entered Email=%@",email);
        //Email Validation
        BOOL corrct=[self checkEmailValidation:email];
        
        if(corrct==YES){
            [activityIndicator startAnimating];
            [HUD show:YES];
            //http://beta.groupinion.com/android/login/index.php?email=&password=
            
            NSString *logInUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/login/index.php?email=%@&password=%@",email,self.passwordTextField.text];
            logInUrl = [logInUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            //[dict setObject:@"50cb8685a6904" forKey:@"code"];
            
            NSString *jsonstring1  = [dict JSONRepresentation];
            
            NSLog(@"ssss  ===%@",jsonstring1);
            NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
            //[dict release];
            NSLog(@"56566=====%@",post1);
            
            opration = @"login";
            [self sendHTTPPost:jsonstring1 :logInUrl ] ;
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Email!" message:@"Please Enter Valid Email id" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}


#pragma mark -
#pragma mark Send Request

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
    [activityIndicator stopAnimating];
    [HUD hide:YES];
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
    
    NSString *smallString = [json_string lowercaseString];
    
    if ([smallString rangeOfString:@"error"].location != NSNotFound) {
        [[[UIAlertView alloc] initWithTitle:@"ERROR:" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    
    // NSArray *jsonArray = [json_string JSONValue];
    
    NSDictionary *resultDict=[json_string JSONValue];
    NSLog(@"Json Dict==%@",resultDict);
    
    NSString *status=[resultDict objectForKey:@"Status"];
    NSLog(@"Status==%@",status);
    
    [activityIndicator stopAnimating];
    //Check Status
    if([status isEqualToString:@"0"]){
        
        NSString *msg=[resultDict objectForKey:@"Message"];
        
        [HUD hide:YES];
        //Check Email Confirmation
        if ([msg rangeOfString:@"verify your account"].location !=NSNotFound) {
            
            ResendVerificationMailViewController *resend = [[ResendVerificationMailViewController alloc]initWithNibName:@"ResendVerificationMailViewController" bundle:nil];
            resend.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            resend.email=self.emailTextField.text;
            [self presentViewController:resend animated:YES completion:nil];
        }
        else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:[resultDict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show ];
        }
        
        
    }
    else{
        
        [self.emailTextField resignFirstResponder];
        [self.user_nameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        [MySingletonClass sharedSingleton].loginWithFacebook=NO;
        [MySingletonClass sharedSingleton].reported=YES;
        [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
        [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
        [MySingletonClass sharedSingleton].refreshMyprofile=YES;
        
        //Check Action
        if([opration isEqualToString:@"login"]){
            
            [MySingletonClass sharedSingleton].groupinionUserID = [resultDict objectForKey:@"ID"];
            [MySingletonClass sharedSingleton].nickName = [resultDict objectForKey:@"nickname"];
            [MySingletonClass sharedSingleton].totalNotification = [NSString stringWithFormat:@"%@",[resultDict objectForKey:@"Total Notifications"]];
            //Rajeev (KIIP)
            NSString *strPoints = [resultDict objectForKey:@"points"];
            if (strPoints != (id)[NSNull null]) {
                NSArray *arrPoints = [strPoints componentsSeparatedByString:@","];
                
                NSString *strSports = @"";
                NSString *strShoppAndFas = @"";
                NSString *strEnter = @"";
                NSString *strNewsAndPol = @"";
                NSString *strFoodAndLifeS = @"";
                
                for (int i=0; i<[arrPoints count]; i++) {
                    NSString *str = [arrPoints objectAtIndex:i];
                    
                    if ([str rangeOfString:@"Entertainment"].location !=NSNotFound) {
                        strEnter = [str substringWithRange:NSMakeRange(14, [str length]-14)];
                    }
                    else if ([str rangeOfString:@"Shopping & Fashion"].location !=NSNotFound){
                        strShoppAndFas = [str substringWithRange:NSMakeRange(19, [str length]-19)];
                    }
                    else if ([str rangeOfString:@"Sports"].location !=NSNotFound){
                        strSports = [str substringWithRange:NSMakeRange(7, [str length]-7)];
                    }
                    else if ([str rangeOfString:@"News & Politics"].location !=NSNotFound){
                        strNewsAndPol = [str substringWithRange:NSMakeRange(16, [str length]-16)];
                    }
                    else if ([str rangeOfString:@"Food & Lifestyle"].location !=NSNotFound){
                        strFoodAndLifeS = [str substringWithRange:NSMakeRange(17, [str length]-17)];
                    }
                }
                
                
                [MySingletonClass sharedSingleton].totalPointsSports=strSports;
                [MySingletonClass sharedSingleton].totalPointsShoppindAndFashion=strShoppAndFas;
                [MySingletonClass sharedSingleton].totalPointsNewsAndPolitics=strNewsAndPol;
                [MySingletonClass sharedSingleton].totalPointsFoodAndLifeS=strFoodAndLifeS;
                [MySingletonClass sharedSingleton].totalPointsEntertainment=strEnter;
            }
            
            //========================================
            //Check Profile Image Uploaded or not
            NSString *picSetStatus=[resultDict objectForKey:@"Default_image_status"];
            UIImage *profilePic=nil;
            if ([picSetStatus isEqualToString:@"1"]) {
                //Profile image uploaded
                //Fetch url of Profile Pic
                NSString *profileImageString=[resultDict objectForKey:@"avatarImage"];
                if ([profileImageString rangeOfString:@"jpg"].location == NSNotFound) {
                    //                    profileImageString=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/avatar/data/images/%@.jpg",profileImageString];
                    profileImageString=[NSString stringWithFormat:@"%@.jpg",profileImageString];
                }
                
                [MySingletonClass sharedSingleton].avtarImage=profileImageString;
                profileImageString=[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",profileImageString];
                
                profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageString]]];
                
            }
            else{
                
                
                [MySingletonClass sharedSingleton].avtarImage=@"0_avatar_75_75.jpg";
                
                profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/0_avatar_75_75.jpg"]]];
            }//End Else block picSetStatus
            
            [MySingletonClass sharedSingleton].profileImage=profilePic;
            
            
            [HUD hide:YES];
            
            GroupViewController *group=[[GroupViewController alloc]initWithNibName:@"GroupViewController" bundle:nil];
            group.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
            [self presentViewController:group animated:YES completion:nil];

           
        }//End if block login
        else{
            
            NSLog(@"Registration Succeeded");
            [MySingletonClass sharedSingleton].groupinionUserID = [resultDict objectForKey:@"ID"];
            [MySingletonClass sharedSingleton].nickName = self.user_nameTextField.text;
            [MySingletonClass sharedSingleton].avtarImage=@"0_avatar_75_75.jpg";
            UIImage *profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/0_avatar_75_75.jpg"]]];
            [MySingletonClass sharedSingleton].totalNotification=@"0";
            [MySingletonClass sharedSingleton].profileImage=profilePic;
            //-----------
            [MySingletonClass sharedSingleton].totalPointsSports=@"0";
            [MySingletonClass sharedSingleton].totalPointsShoppindAndFashion=@"0";
            [MySingletonClass sharedSingleton].totalPointsNewsAndPolitics=@"0";
            [MySingletonClass sharedSingleton].totalPointsFoodAndLifeS=@"0";
            [MySingletonClass sharedSingleton].totalPointsEntertainment=@"0";
            [HUD hide:YES];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:[resultDict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=2;
            [alert show];
        }
        
        
        
    }
    
}

#pragma mark -
-(void)saveDeviceTokenToDB:(NSString *)uid deviceToken : (NSData *)tokenData{
    
    // http://beta.groupinion.com/android/iphone_device/register.php?userid=&regId=
    
    
    
    NSString *urlString  = [NSString stringWithFormat:@"http://beta.groupinion.com/android/iphone_device/register.php?userid=%@&regId=%@",uid,tokenData];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *response = [SendHttpRequest sendRequest:urlString];
    
    NSLog(@"response to save device token= %@", response);
    
    if ([response isEqualToString:@"error"]) {
        
    }
    else{
        
        if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
            NSLog(@"Error to save device token");
        }
        else{
            NSLog(@"token Saved ");
        }
    }
    
    
}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==2) {
        
        
                GroupViewController *groupVC=[[GroupViewController alloc]initWithNibName:@"GroupViewController" bundle:nil];
                groupVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:groupVC animated:YES completion:nil];
        
    }
}
- (BOOL) checkEmailValidation:(NSString *)email{
    
    BOOL stricterFilter = YES;
    BOOL correct;
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:email] == YES){
        
        correct=YES;
    }
    else{
        
        correct=NO;
        
    }
    return correct;
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




-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
