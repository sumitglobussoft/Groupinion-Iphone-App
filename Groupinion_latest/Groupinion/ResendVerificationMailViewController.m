//
//  ResendVerificationMailViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 14/08/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "ResendVerificationMailViewController.h"
#import "SendHttpRequest.h"
#import "JSON.h"
@interface ResendVerificationMailViewController ()

@end

@implementation ResendVerificationMailViewController

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
    
    //add banner Image Of Groupinion
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 52)];
    bannerImage.image=[UIImage imageNamed:@"group.png"];
    [self.view addSubview:bannerImage];
    
    UIImageView *secondBanner=[[UIImageView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 35)];
    [self.view addSubview:secondBanner];
    
    secondBanner.image=[UIImage imageNamed:@"verifymail.png"];
    
    
    NSString *text= @"New accounts are active for 48 hours the email needs to be verified. Please verify your email by clicking on the sent to you upon signup to continue using Groupinion.";
    
    UITextView *detailsText = [[UITextView alloc]initWithFrame:CGRectMake(10, 100, 300, 150)];
    detailsText.scrollEnabled=NO;
    detailsText.editable=NO;
    detailsText.backgroundColor=[UIColor clearColor];
    detailsText.textColor=[UIColor blueColor];
    detailsText.font = [UIFont fontWithName:@"Arial" size:17];
    detailsText.text = text;
    [self.view addSubview:detailsText];
    
    
    UIButton *resendMailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resendMailButton setBackgroundImage:[UIImage imageNamed:@"resendmail.png"] forState:UIControlStateNormal];
    resendMailButton.layer.cornerRadius=5.0;
    resendMailButton.clipsToBounds=YES;
    resendMailButton.frame=CGRectMake(35, 260, 250, 30);
    [self.view addSubview:resendMailButton];
    [resendMailButton addTarget:self action:@selector(resendVerificationMail) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setBackgroundImage:[UIImage imageNamed:@"back_resend.png"] forState:UIControlStateNormal];
    buttonBack.layer.cornerRadius=5.0;
    buttonBack.clipsToBounds=YES;
    buttonBack.frame=CGRectMake(35, 300, 250, 30);
    [self.view addSubview:buttonBack];
    [buttonBack addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)backButtonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Resend mail
-(void)resendVerificationMail{
    //http://beta.groupinion.com/android/resendverificationmail/index.php?email=
    
    NSString *str=[NSString stringWithFormat:@"http://beta.groupinion.com/android/resendverificationmail/index.php?email=%@",self.email];
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Email = %@",str);
    
    NSString *response  = [SendHttpRequest sendRequest:str];
    
    NSLog(@"Response to re send mail= %@",response);
    
    if ([response isEqualToString:@"error"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        //{"Status":"0","Message":"Email field should not be empty"}
        
        //{"Status":"1","Message":"Verification Mail send please check your inbox."}
        
        NSDictionary *dict = [response JSONValue];
        
        NSString *status = [dict objectForKey:@"Status"];
        
        if ([status isEqualToString:@"0"]) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        else{
         
           UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"" message:@"Verification mail send please check your inbox." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=2;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==2) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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

@end
