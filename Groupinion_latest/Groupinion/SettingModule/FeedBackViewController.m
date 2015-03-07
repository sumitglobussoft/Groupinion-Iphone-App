//
//  FeedBackViewController.m
//  Groupinion
//
//  Created by Globussoft 1 on 8/6/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "FeedBackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingViewController.h"
#import "JSON.h"
#import "MySingletonClass.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

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

        //Main banner...
    banerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    banerImage.image=[UIImage imageNamed:@"group.png"];
    [self.view addSubview:banerImage];
    
        //Back button..
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(10, 8, 60, 35);
    [backButton setBackgroundImage:[UIImage imageNamed:@"Back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
        //Description Label..
    feedBackDescription=[[UILabel alloc]initWithFrame:CGRectMake(5, 55, self.view.bounds.size.width-20, 90)];
    feedBackDescription.text=@"We want your feedback! Something broken?   Anything we can do better? Let us know by writing us below. Of course we'd love to know what you like as well!";
    feedBackDescription.numberOfLines=7;
    feedBackDescription.font=[UIFont fontWithName:@"Arial" size:15];
    [self.view addSubview:feedBackDescription];
    
        
    //Insert FeedBack...
    commentHereText=[[UITextView alloc]initWithFrame:CGRectMake(10, 150, self.view.bounds.size.width-20, 140)];
    commentHereText.layer.cornerRadius=5.f;
    commentHereText.delegate=self;
    [commentHereText setReturnKeyType:UIReturnKeyDone];
    [commentHereText setText:@"Insert your questions or comment here"];
    [commentHereText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:11]];
    [commentHereText setTextColor:[UIColor grayColor]];
    [commentHereText.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [commentHereText.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [commentHereText.layer setBorderWidth: 2.0];
    [commentHereText.layer setCornerRadius:5.0f];
    [commentHereText.layer setMasksToBounds:YES];
    [self.view addSubview:commentHereText];
    
        //Submit Button...
    submitButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"submit.png"] forState:UIControlStateNormal];
    submitButton.frame=CGRectMake(10, 310, self.view.bounds.size.width-20, 40);
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}
//Action for Back to Settings view...
-(void)backToSettings
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Back button pressed");
}

-(void)submitButtonClicked
{
    //Perform Validation
    if ([commentHereText.text isEqualToString:@"Insert your questions or comment here"] || [commentHereText.text isEqualToString:@""]) {
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter text first" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show ];
        return;
    }
    NSString *uid=[MySingletonClass sharedSingleton].groupinionUserID;
    NSString *feedBackUrl=[NSString stringWithFormat:@"http://beta.groupinion.com/android/feedback/index.php?id=%@&message=%@",uid,commentHereText.text];
    feedBackUrl = [feedBackUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *jsonstring1  = [dict JSONRepresentation];
    
    NSLog(@"ssss  ===%@",jsonstring1);
    NSString *post1 = [NSString stringWithFormat:@"&json=[%@]",jsonstring1];
        //[dict release];
    NSLog(@"56566=====%@",post1);
    
    [self sendHTTPPost:jsonstring1 :feedBackUrl] ;

    NSLog(@"Submit button clicked");
    
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
        // [activityIndicator stopAnimating];
	[alert show];
	
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
    
    
    //Check Response status
    if ([json_string rangeOfString:@""].location != NSNotFound) {
        // {"Status":"0","Message":"id not found"}
        NSDictionary *dict = [json_string JSONValue];
        [[[UIAlertView alloc]initWithTitle:@"Error" message:[dict objectForKey:@"Message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show ];
        
    }
    else{
        
        if ([json_string isEqualToString:@"true"]) {
            
            commentHereText.text=@"";
            [[[UIAlertView alloc]initWithTitle:@"FeedBack sent" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show ];
            NSLog(@"FeedBack sent");
        }
        else{
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try after some time" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show ];
            NSLog(@"FeedBack not sent");
        }
    }
}


#pragma mark -
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
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [commentHereText resignFirstResponder];
    self.view.frame=CGRectMake(0, 0, 320, 480);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.view.frame=CGRectMake(0, -50, 320, 480);
    if (textView.textColor == [UIColor grayColor]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        textView.textColor = [UIColor grayColor];
        textView.text = @"Insert your questions or comment here";
        [textView resignFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        self.view.frame=CGRectMake(0, 0, 320, 480);
        if(textView.text.length == 0){
            textView.textColor = [UIColor grayColor];
            textView.text = @"Insert your questions or comment here";
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
