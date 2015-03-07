//
//  T&CViewController.m
//  Groupinion
//
//  Created by Globussoft 1 on 8/7/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "T&CViewController.h"

@interface T_CViewController ()

@end

@implementation T_CViewController

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
    
    
        //Url of Teams & Conditions....
    
    NSURLResponse *responseCode=nil;
    //Url for Terms and Condition
    NSString *urlStr = [NSString stringWithFormat:@"http://beta.groupinion.com/terms/"];
    NSData *postData=[urlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[postData length]];
    //Prepare request for fetch Terms and condition
    NSMutableURLRequest *request2 = [[NSMutableURLRequest alloc] init] ;
    [request2 setURL:[NSURL URLWithString:urlStr]];
    request2 =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringCacheData                                                                                                          timeoutInterval:60.0];
    [request2 setHTTPMethod:@"POST"];
    [request2 setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request2 setHTTPBody:postData];
    
    NSError *error;
        //DU06BFZ   435294573022
    NSMutableString *htmlString=[[NSMutableString alloc]init];
    NSData *oResponseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&responseCode error:&error];
    NSString *respon=[[NSString alloc] initWithData:oResponseData2 encoding:NSUTF8StringEncoding];
    //Fetch terms and condition String
    NSString *stringStuff=[self stripTags:respon startString:@"<div id=\"body-text\">" upToString:@"</div>"];
    stringStuff = [stringStuff stringByReplacingOccurrencesOfString:@"body-text>" withString:@""];

    NSLog(@"Data in html= %@",respon);
   //Prepare HTML string for display terms and condition
    [htmlString appendString:@"<html>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:@"<div id=\"body-text\">"];
    [htmlString appendString:[NSString stringWithFormat:@"%@",stringStuff]];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    
    //loaf html string to UIWebView
    UIWebView *teamNCondition=[[UIWebView alloc]initWithFrame:CGRectMake(0, 50, 320, 420)];
    [self.view addSubview:teamNCondition];
    [teamNCondition loadHTMLString:htmlString baseURL:nil];
    
}

    //Action for Back to Settings view...
-(void)backToSettings
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Back button pressed");
}

-(NSString *)stripTags:(NSString *)webPage startString:(NSString *)strStart upToString:(NSString *)strEnd{
    
    NSMutableString *html = [NSMutableString stringWithCapacity:[webPage length]];
    NSString *startString=strStart;
    NSString *EndString=strEnd;
    
    NSString *returnString=[[NSString alloc]init];
    NSScanner *scanner = [NSScanner scannerWithString:webPage];
    scanner.charactersToBeSkipped = NULL;
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:startString intoString:&tempText ];
        if (tempText != nil){
            [html appendString:tempText];
        }
        [scanner scanUpToString:EndString intoString:&returnString];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        tempText = nil;
    }
    NSArray *valueArray=[returnString componentsSeparatedByString:@"="];
    NSString *getValue=nil;
    
    if([valueArray count]>2){
        getValue=[valueArray objectAtIndex:1];
        for(int i=2;i<[valueArray count];i++){
            getValue=[getValue stringByAppendingString:[NSString stringWithFormat:@"=%@",[valueArray objectAtIndex:i]]];
        }
    }
    else if ([valueArray count]==1){
        getValue=[NSString stringWithFormat:@"%@",[valueArray objectAtIndex:0]];
    }
    else {
        getValue=[NSString stringWithFormat:@"%@",[valueArray objectAtIndex:1]];
    }
    getValue=[getValue stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [getValue length])];
    return getValue;
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
