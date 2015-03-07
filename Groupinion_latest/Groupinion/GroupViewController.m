//
//  GroupViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 15/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "GroupViewController.h"
#import "QuestionsViewController.h"
#import "AskViewController.h"
#import "MyStuffViewController.h"
#import "MySingletonClass.h"

#import "SendHttpRequest.h"

#define PushNotificationDeviceToken @"GroupinionPushNotificationDeviceToken"
#define CheckFirstRun @"CheckGroupinionFirstRun"


@interface GroupViewController ()
{
    
}
@end

@implementation GroupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [MySingletonClass sharedSingleton].groupViewController=self;
    }
    return self;
}


//Saving device token to DataBase
-(void)saveDeviceTokenToDB: (NSString *)tokenString{
    
    // http://beta.groupinion.com/android/iphone_device/register.php?userid=&regId=
    
    //Parameter Require userid and regId(device token)
    NSString *uid = [MySingletonClass sharedSingleton].groupinionUserID;
    NSString *urlString  = [NSString stringWithFormat:@"http://beta.groupinion.com/android/iphone_device/register.php?userid=%@&regId=%@",uid,tokenString];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *response = [SendHttpRequest sendRequest:urlString];
    
    NSLog(@"response to save device token= %@", response);
    
    if ([response isEqualToString:@"error"]) {
        
    }
    else{
        
        //{"Status":"0","Message":"Duplicate entry 'b4d17f8fad6ff5ea7ef9be20e1762ec0901bcc922c4b6e0fcad9689f2375590d' for key 'IphoneRegid'"}
        
        if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
            NSLog(@"Error to save device token");
            
            
            if ([response rangeOfString:@"Duplicate entry"].location != NSNotFound) {
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:@"1" forKey:CheckFirstRun];
                NSLog(@"Duplicate Entry");
                
            }
        }
        else{
            NSLog(@"token Saved ");
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:@"1" forKey:CheckFirstRun];
        }
    }
    
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[UITabBar appearance] setSelectionIndicatorImage:
//     [UIImage imageNamed:@"tab_select_indicator"]];
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
     NSString *tokenString = [userDefault objectForKey:PushNotificationDeviceToken];
    NSString *firstRun = [userDefault objectForKey:CheckFirstRun];
    
    // Check First Run
    //if First run save device token to Server by calling service
    if ((!firstRun || ![firstRun isEqualToString:@"1"]) && tokenString != nil) {
        
        NSLog(@"Call web service to save device token");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // send your notification here instead of in updateFunction
            //[[NSNotificationCenter defaultCenter] post...];
            [self saveDeviceTokenToDB:tokenString];
            
        });
    }
    else{
        NSLog(@"Don't do anything");
    }
    
    
    //Creating Tab Bar Controller
    self.myTabBarController=[[UITabBarController alloc]init];
    [self.myTabBarController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];
    
    
    self.myTabBarController.tabBar.frame=CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
    
    QuestionsViewController *ques=[[QuestionsViewController alloc]initWithNibName:@"QuestionsViewController" bundle:nil];
    ques.tabBarItem.image=[UIImage imageNamed:@"tab_bar_Ques.png"];
    UINavigationController *navigationcontroller = [[UINavigationController alloc] initWithRootViewController:ques] ;
    ques.title=@"Questions";

    navigationcontroller.navigationBar.hidden=YES;
    
    //Setting Text color, Font
    [ques.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor whiteColor], UITextAttributeTextColor,
                                             [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                             [UIFont fontWithName:@"Helvetica" size:15.0], UITextAttributeFont, nil]
                                   forState:UIControlStateNormal];
    
    AskViewController *ask=[[AskViewController alloc]initWithNibName:@"AskViewController" bundle:nil];
    
     UINavigationController *navigationcontrollerAsk = [[UINavigationController alloc] initWithRootViewController:ask] ;
    navigationcontrollerAsk.navigationBar.hidden=YES;
    ask.title=@"Ask";
    ask.tabBarItem.image=[UIImage imageNamed:@"tabBar_Ask.png"];
    
    [ask.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor whiteColor], UITextAttributeTextColor,
                                             [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                             [UIFont fontWithName:@"Helvetica" size:15.0], UITextAttributeFont, nil]
                                   forState:UIControlStateNormal];
    
    MyStuffViewController *stuff=[[MyStuffViewController alloc]initWithNibName:@"MyStuffViewController" bundle:nil];
     UINavigationController *navigationcontrollerStuff = [[UINavigationController alloc] initWithRootViewController:stuff] ;
    navigationcontrollerStuff.navigationBar.hidden=YES;
    stuff.tabBarItem.image=[UIImage imageNamed:@"tab_bar_stuff.png"];
    stuff.title=@"My Stuff";
    
    [stuff.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor whiteColor], UITextAttributeTextColor,
                                            [NSValue valueWithUIOffset:UIOffsetMake(0,0)], UITextAttributeTextShadowOffset,
                                            [UIFont fontWithName:@"Helvetica" size:15.0], UITextAttributeFont, nil]
                                  forState:UIControlStateNormal];
    

    self.myTabBarController.viewControllers=[NSArray arrayWithObjects:navigationcontroller,navigationcontrollerAsk,navigationcontrollerStuff, nil];
    self.myTabBarController.delegate=self;
    [self.view addSubview:self.myTabBarController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark Tab Bar Delegate
/*------------------------------
 Tab Bar Delegate Method  Check selected Tab and send notification to Selected View Controller to reset View
 *---------------------------------------*/
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    NSString *str=[NSString stringWithFormat:@"%@",viewController.title];
    
    if([str rangeOfString:@"My Stuff"].location !=NSNotFound){
        NSLog(@"tab Bar view title==%@",viewController.title);
        [viewController.tabBarController setSelectedIndex:0];
        [self.myTabBarController setSelectedIndex:2];
       
        
    }
    else if ([str rangeOfString:@"Ask"].location !=NSNotFound){
        //makeyesnoQuestion notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"makeyesnoQuestion" object:nil];
    }
    else if ([str rangeOfString:@"Questions"].location !=NSNotFound){
        BOOL refresh = [MySingletonClass sharedSingleton].sendNotification;
        if (refresh==YES) {
            //Refresh Question page
           [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAfterFilter" object:nil]; 
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideView" object:nil];
        }
        
    }
}

@end
