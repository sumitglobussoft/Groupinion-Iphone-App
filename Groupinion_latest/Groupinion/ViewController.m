
//
//  ViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 15/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "MySingletonClass.h"
#import "ViewController.h"
#import "SignInAndUpViewController.h"
#import "FBIntermediateViewController.h"
#import "MBProgressHUD.h"
#import "QuestionsViewController.h"
//NSString *const FBSessionStateChangedNotification =
//@"com.groupinion.app:FBSessionStateChangedNotification";
@interface ViewController ()
{
    MBProgressHUD *HUD;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [MySingletonClass sharedSingleton].refresh=YES;
    
    self.view.frame=self.view.bounds;
    
    self.backGroundImage.frame=self.view.bounds;
    
    
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    NSDate *cuDate =[NSDate date];
    NSLog(@"cu Date =%@",cuDate);
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"mm"];
    NSString *ccc=[fo stringFromDate:cuDate];
    NSLog(@"cccc=%@",ccc);
    [user setObject:ccc forKey:@"GRO_Main_Feed_lastrefreshtime"];
    
    UILabel *signIN=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 25)];
    signIN.textColor=[UIColor whiteColor];
    signIN.textAlignment=NSTextAlignmentCenter;
    signIN.font=[UIFont systemFontOfSize:14.0f];
    signIN.backgroundColor=[UIColor clearColor];
    signIN.text=@"Login to an existing account";
    signIN=[self setLabelUnderline:signIN];
    [self.btnSignIn addSubview:signIN];
    
    
    UILabel *signUP=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    signUP.textColor=[UIColor whiteColor];
    signUP.textAlignment=NSTextAlignmentLeft;
    signUP.font=[UIFont systemFontOfSize:14.0f];
    signUP.backgroundColor=[UIColor clearColor];
    signUP.text=@"click here";
    signUP=[self setLabelUnderline:signUP];
    [self.btnSingUp addSubview:signUP];
    
    [MySingletonClass sharedSingleton].fbUserID=@"0";
    
    
    HUD = HUD = [[MBProgressHUD alloc]initWithView:self.view];;
    HUD.dimBackground=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



//=======================================================
//Adding UnderLine in Label Text
#pragma mark -
-(UILabel *)setLabelUnderline:(UILabel *)label{
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size lineBreakMode:label.lineBreakMode];
    UIView *viewUnderline=[[UIView alloc] init];
    CGFloat xOrigin=0;
    switch (label.textAlignment) {
        case NSTextAlignmentCenter:
            xOrigin=(label.frame.size.width - expectedLabelSize.width)/2;
            break;
        case NSTextAlignmentLeft:
            xOrigin=0;
            break;
        case NSTextAlignmentRight:
            xOrigin=label.frame.size.width - expectedLabelSize.width;
            break;
        default:
            break;
    }
    viewUnderline.frame=CGRectMake(xOrigin,
                                   expectedLabelSize.height+3,
                                   expectedLabelSize.width,
                                   1);
    viewUnderline.backgroundColor=label.textColor;
    [label addSubview:viewUnderline];
    
    return label;
}

#pragma mark -
//Display Sign in View
- (IBAction)signInButtonAction:(id)sender {
    
    NSLog(@"Sign in Button Clicked");
    SignInAndUpViewController *signIn=[[SignInAndUpViewController alloc]initWithNibName:@"SignInAndUpViewController" bundle:nil];
    signIn.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    signIn.action=@"signin";
    [self presentViewController:signIn animated:YES completion:nil];
}

-(void) displayActivityIndicatore{
    [self.view addSubview:HUD];
    [HUD show:YES];
}

-(void)stopActivityIndicator{
    
    [HUD hide:YES];
}
//Facebook Button Action
- (IBAction)facebookButtonAction:(id)sender {
    NSLog(@"Facebook Button Clicked");
    [FBSession.activeSession closeAndClearTokenInformation];
    [NSThread detachNewThreadSelector:@selector(displayActivityIndicatore) toTarget:self withObject:nil];
   
    
    
    [MySingletonClass sharedSingleton].loginWithFacebook=YES;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (FBSession.activeSession.isOpen) {
        NSLog(@"Close Session");
        [appDelegate closeSession];
    }
     [appDelegate openSessionWithAllowLoginUI:YES];
    

}


-(void)gotoNextView{
    GroupViewController *groupVC=[[GroupViewController alloc]initWithNibName:@"GroupViewController" bundle:nil];
    groupVC.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    //[self presentModalViewController:groupVC animated:YES ];
    [self presentViewController:groupVC animated:YES completion:nil];
    //[[[[UIApplication sharedApplication] delegate] window] rootViewController];
}
- (IBAction)signUpButtonAction:(id)sender {
    
    NSLog(@"Sign Up Button Clicked");
    
    SignInAndUpViewController *signUp=[[SignInAndUpViewController alloc]initWithNibName:@"SignInAndUpViewController" bundle:nil];
    signUp.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    signUp.action=@"signup";
    
    [self presentViewController:signUp animated:YES completion:nil];
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

@end
