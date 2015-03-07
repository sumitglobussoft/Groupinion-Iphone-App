//
//  SettingViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 17/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "SettingViewController.h"
#import "AccountsViewController.h"
#import "FeedBackViewController.h"
#import "T&CViewController.h"

@interface SettingViewController ()
{
    UIButton *alertBtn;
    BOOL selectedCheck;
    UIImageView *ChckNUnChckImage;
}
@end

@implementation SettingViewController
@synthesize stringView;
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
    
    selectedCheck = YES;
    
    //add banner Image Of Groupinion
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"setting_header.png"];
    [self.view addSubview:bannerImage];
    
        //Back button..
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame=CGRectMake(5, 5, 50, 40);
    [backButton setBackgroundImage:[UIImage imageNamed:@"Back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    
    //===================================================================
    //Add Setting Button To View
    UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingBtn.frame=CGRectMake(260, 8, 50, 35);
    //settingBtn.layer.borderWidth=1.0f;
    //settingBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    settingBtn.clipsToBounds=YES;
//    settingBtn.layer.cornerRadius=10.0f;
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    
    //===================================================================
    //Add Setting Button To View
    alertBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    alertBtn.frame=CGRectMake(30, 80, 260, 35);
    alertBtn.layer.borderWidth=1.0f;
    alertBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    alertBtn.clipsToBounds=YES;
    alertBtn.layer.cornerRadius=5.0f;
    [alertBtn setBackgroundImage:[UIImage imageNamed:@"alerts.png"] forState:UIControlStateNormal];
    [alertBtn addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertBtn];
    
    
    //Check and UnCheck ImageView on alert button...
    ChckNUnChckImage=[[UIImageView alloc]initWithFrame:CGRectMake(230,2,28,30)];
    ChckNUnChckImage.image=[UIImage imageNamed:@"check.png"];
        //selectedCheck=YES;
    [alertBtn addSubview:ChckNUnChckImage];
    
    
    //===================================================================
    //Add Setting Button To View
    UIButton *accountBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    accountBtn.frame=CGRectMake(30, 130, 260, 35);
    accountBtn.layer.borderWidth=1.0f;
    accountBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    accountBtn.clipsToBounds=YES;
    accountBtn.layer.cornerRadius=5.0f;
    [accountBtn setBackgroundImage:[UIImage imageNamed:@"account.png"] forState:UIControlStateNormal];
    [accountBtn addTarget:self action:@selector(accountButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountBtn];
    
    //===================================================================
    //Add Setting Button To View
    UIButton *feedbackBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    feedbackBtn.frame=CGRectMake(30, 180, 260, 35);
    feedbackBtn.layer.borderWidth=1.0f;
    feedbackBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    feedbackBtn.clipsToBounds=YES;
    feedbackBtn.layer.cornerRadius=5.0f;
    [feedbackBtn setBackgroundImage:[UIImage imageNamed:@"feedback.png"] forState:UIControlStateNormal];
    [feedbackBtn addTarget:self action:@selector(feedbackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedbackBtn];
    
    
    //===================================================================
    //Add Setting Button To View
    UIButton *termsConBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    termsConBtn.frame=CGRectMake(30, 230, 260, 35);
    termsConBtn.layer.borderWidth=1.0f;
    termsConBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    termsConBtn.clipsToBounds=YES;
    termsConBtn.layer.cornerRadius=5.0f;
    [termsConBtn setBackgroundImage:[UIImage imageNamed:@"terms_condition.png"] forState:UIControlStateNormal];
    [termsConBtn addTarget:self action:@selector(termsConditionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:termsConBtn];
    
    //===================================================================
    //Add Setting Button To View
    UIButton *logOutBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    logOutBtn.frame=CGRectMake(30, 280, 260, 35);
    logOutBtn.layer.borderWidth=1.0f;
    logOutBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    logOutBtn.clipsToBounds=YES;
    logOutBtn.layer.cornerRadius=5.0f;
    [logOutBtn setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutBtn];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToSettings
{
[self.navigationController popToRootViewControllerAnimated:YES];
        
}

-(void)settingButtonClicked{
    NSLog(@"Setting Button Clicked");
}
-(void)alertButtonClicked:(id)sender{
    
    if (selectedCheck==YES) {
        selectedCheck=NO;
        ChckNUnChckImage.image=[UIImage imageNamed:@"uncheck.png"];

    }
    else if (selectedCheck==NO)
    {
        selectedCheck = YES;
        ChckNUnChckImage.image=[UIImage imageNamed:@"check.png"];

    }
    

    NSLog(@"Alert Button Clicked");
    [(UIButton *)sender setSelected:![(UIButton *)sender isSelected]];
}

-(void)accountButtonClicked{
    AccountsViewController *accountView=[[AccountsViewController alloc]init];
    [self.navigationController pushViewController:accountView animated:YES];

    
    NSLog(@"Account Button Action Call");
}

-(void)feedbackButtonClicked{
    
    FeedBackViewController *feedBackView=[[FeedBackViewController alloc]init];
    [self.navigationController pushViewController:feedBackView animated:YES];
    
    NSLog(@"Feedback Button Clicked");
}

-(void)termsConditionButtonClicked{
    T_CViewController *tcViewController=[[T_CViewController alloc]init];
    [self.navigationController pushViewController:tcViewController animated:YES];
    
    
    NSLog(@"Terms And Condition Button Action Call");
}


-(void)logoutButtonClicked{
    NSLog(@"Log Out Button Action Call");
}

@end
