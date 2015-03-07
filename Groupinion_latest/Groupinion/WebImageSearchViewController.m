//
//  WebImageSearchViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 29/10/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "WebImageSearchViewController.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
@interface WebImageSearchViewController () <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end

@implementation WebImageSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)backButtonClicked{
    [self.searchBoxTextfield resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Prepare UI
    imageSelected = NO;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 50, 320, 40);
    
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:(CGFloat)182/255 green:(CGFloat)196/255 blue:(CGFloat)215/255 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:(CGFloat)89/255 green:(CGFloat)116/255 blue:(CGFloat)152/255 alpha:1.0] CGColor], nil];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    UIImageView *bannerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    bannerImage.image=[UIImage imageNamed:@"selectimage_hedder_btn.png"];
    [self.view addSubview:bannerImage];
    //Add Setting Button To View
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame= CGRectMake(10, 8, 60, 35);
    
    backBtn.enabled=YES;
    [backBtn setBackgroundImage:[UIImage imageNamed:@"cancel_new"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    //Search text field
    self.searchBoxTextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 55, 250, 30)];
    self.searchBoxTextfield.delegate = self;
    self.searchBoxTextfield.placeholder = @"Enter Keyword";
    self.searchBoxTextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.searchBoxTextfield.returnKeyType = UIReturnKeySearch ;
    [self.view addSubview:self.searchBoxTextfield];
    
    //====================================
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(260, 8, 57, 35);
    [doneButton setBackgroundImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    [self.searchBoxTextfield becomeFirstResponder];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, 320, 435)];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.scrollView setContentSize:CGSizeMake(320, 1200)];
    self.moreButon = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.moreButon setTitle:@"More Images" forState:UIControlStateNormal];
    [self.moreButon setBackgroundImage:[UIImage imageNamed:@"more_images.png"] forState:UIControlStateNormal];
    //[self.moreButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.moreButon addTarget:self action:@selector(moreImages) forControlEvents:UIControlEventTouchUpInside];
    
    totalImages = 0;
    x=10;
    y=10;
    pages=0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
-(void) displayActivityHUDIndicator{
    HUD = [[MBProgressHUD alloc]init];
    HUD.dimBackground = YES;
    HUD.delegate = self;
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
-(IBAction)searchButtonClicked:(id)sender{
    [self.searchBoxTextfield resignFirstResponder];
    if([lastSearchKey isEqualToString:self.searchBoxTextfield.text] || [self.searchBoxTextfield.text isEqualToString:@""]){
        return;
    }
    [NSThread detachNewThreadSelector:@selector(displayActivityHUDIndicator) toTarget:self withObject:nil];
    
    
    //        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 90, 320, 435)];
    //        [self.view addSubview:self.scrollView];
    //        self.scrollView.backgroundColor = [UIColor whiteColor];
    //        [self.scrollView setContentSize:CGSizeMake(320, 1200)];
    
    if (self.imageListArray) {
        [self.imageListArray removeAllObjects];
        for (UIView *v in [self.scrollView subviews]) {
            [v removeFromSuperview];
        }
    }
    else{
        self.imageListArray = [[NSMutableArray alloc] init];
    }
    x=10;
    y=10;
    pages=0;
    totalImages=0;
    
    
    //save search key
    lastSearchKey = self.searchBoxTextfield.text;
    self.searchButton.enabled=NO;
    
    NSString *searchKey = self.searchBoxTextfield.text;
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    //check last search key
    NSString *lastStoreSearchKey = [userDefaults objectForKey:@"GroupinionLastSearchKeyWord"];
    //check last search key
    if ([searchKey isEqualToString:lastStoreSearchKey]) {
        //get list of images from user defaults
        self.imageListArray = [userDefaults objectForKey:@"GroupinionLastSearchImageList"];
        
        
        for (int i =0; i<self.imageListArray.count; i++) {
            
            [self displayImages];
        }
        
        [self.scrollView addSubview:self.moreButon];
        if (self.imageListArray.count%3==0) {
            self.moreButon.frame = CGRectMake(10, y+15, 86, 15);
        }
        else{
            self.moreButon.frame = CGRectMake(10, y+115, 86, 15);
        }
    }
    else{
        //Search on Google
        [self getGoogleImagesForQuery:searchKey withPage:0];
    }
    
    
    [HUD hide:YES];
}

//API to fetch images from Google
- (void)getGoogleImagesForQuery:(NSString*)query withPage:(int)page
{
    @try {
        //https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=6&q=nature&start=0&&imgsz=medium
        //https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=fuzzy%20monkey
        //https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=fuzzy%20monkey&callback=processResults
        //Query for search image on google on the basis of entered key
        NSString *urlString = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&q=%@&start=%d&&imgsz=xxlarge",query,page];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSString *urlString = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=monkey"];
        
        
        NSHTTPURLResponse   * response;
        NSError *error;
        NSLog(@"url==%@",urlString);
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request= [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100.0];
        
        NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *respo=nil;
        if(error){
            respo=@"error";
            NSLog(@"url==%@\n error=%@",urlString,error);
        }
        else{
            //Fetch image url
            respo=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"respo==%@",respo);
            
            NSDictionary *dict = [respo JSONValue];
            NSDictionary *dict2 = [dict objectForKey:@"responseData"];
            if (dict2 == (NSDictionary*)[NSNull null]) {
                return;
            }
            NSArray *respoAry = [dict2 objectForKey:@"results"];
            // NSLog(@"\n\nResponse Array = %@",respoAry);
            // NSLog(@"Count = %lu",(unsigned long)respoAry.count);
            for (int i=0; i<respoAry.count; i++) {
                [self.imageListArray addObject:[respoAry objectAtIndex:i]];
                [self displayImages];
            }
            
            ;
            [self.scrollView addSubview:self.moreButon];
            self.moreButon.frame = CGRectMake(10, y+115, 86, 15);
            //save image list and ented key to User Defaults
            [userDefaults setObject:self.imageListArray forKey:@"GroupinionLastSearchImageList"];
            [userDefaults setObject:self.searchBoxTextfield.text forKey:@"GroupinionLastSearchKeyWord"];
            [userDefaults synchronize];
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@",exception);
    }
    @finally {
        NSLog(@"Finally Blog Executed");
    }
}
-(void)displayImages{
    
    //Initilize imageview for display image
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 99, 100)];
    imgView.tag = totalImages;
    imgView.userInteractionEnabled=YES;
    NSDictionary *imageDictionary = [self.imageListArray objectAtIndex:totalImages];
    [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageDictionary objectForKey:@"unescapedUrl"]]]];
    [self.scrollView addSubview:imgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tap.numberOfTapsRequired=1;
    [imgView addGestureRecognizer:tap];
    totalImages = totalImages+1;
    if (totalImages != 1 && totalImages%3==0) {
        x = 10;
        y = y+103;
        self.scrollView.contentSize = CGSizeMake(320, y+200);
    }
    else{
        x = x + 100;
    }
}
//handle Tap on image
-(void) handleTapGesture:(id)sender{
    
    if (!self.tickMarkImageView) {
        self.tickMarkImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Overlay.png"]];
        [self.scrollView addSubview:self.tickMarkImageView];
    }
    
    UIView *v = (UIControl *)sender;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)v;
    UIImageView *img = (UIImageView *)tap.view;
    selectedImage = img.image;
    imageSelected = YES;
    //    NSLog(@"img tag = %d",img.tag);
    //    NSLog(@"img x = %f",img.frame.origin.x);
    //    NSLog(@"img y = %f",img.frame.origin.y);
    self.tickMarkImageView.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y, 99, 100);
}
- (void)viewDidUnload {
    [self setSearchButton:nil];
    [super viewDidUnload];
}
//Fetch more images
-(void) moreImages{
    [NSThread detachNewThreadSelector:@selector(displayActivityHUDIndicator) toTarget:self withObject:nil];
    sleep(7);
    
    [self getGoogleImagesForQuery:lastSearchKey withPage:self.imageListArray.count];
    if (x==10) {
        self.moreButon.frame = CGRectMake(10, y+15, 86, 15);
    }
    else{
        self.moreButon.frame = CGRectMake(10, y+115, 86, 15);
    }
    [HUD hide:YES];
}

//Done button Action
-(void) doneButtonClicked:(id)sender{
    //check image selected or not
    if (imageSelected==NO) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Selecte image first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    //Called delegate method and pass selected image
    //Delgate define in AskViewController
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webImageSearch:finishSelectingImage:)]) {
        [self.delegate webImageSearch:self finishSelectingImage:selectedImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Textfield Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self searchButtonClicked:nil];
    return YES;
}



@end
