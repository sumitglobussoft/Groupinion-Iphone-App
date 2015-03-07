//
//  MyStuffViewController.m
//  Groupinion
//
//  Created by Sumit Ghosh on 16/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "MyStuffViewController.h"


@interface MyStuffViewController ()

@end

@implementation MyStuffViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Stuff view appear");
}

-(void) viewDidAppear:(BOOL)animated{
    
    //Display First Tab of StuffTabBarController
    [self.stuffTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"myStuff_my_question.png"]];
    [self.stuffTabBarController setSelectedIndex:0];
    [(UINavigationController *)self.stuffTabBarController.selectedViewController popToRootViewControllerAnimated:NO];
    
    //[self.stuffTabBarController.navigationController popToRootViewControllerAnimated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //add banner Image
    
  
    
    //=========================================================
    //Initilizing Tab Bar
    //Tab Bar
    self.stuffTabBarController=[[UITabBarController alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.stuffTabBarController.tabBar.frame=CGRectMake(0, screenHeight - 30,self.view.bounds.size.width , 40);
    self.stuffTabBarController.delegate=self;
    self.stuffTabBarController.tabBarItem.titlePositionAdjustment=UIOffsetMake(0, 10) ;
   
      
    [self.stuffTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"myStuff_my_question.png"]];
    
    [self.stuffTabBarController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];
    
    MyQuestionViewController *myQues=[[MyQuestionViewController alloc]initWithNibName:@"MyQuestionViewController" bundle:nil];
        myQues.title=@"Q";
    
    
    UINavigationController *navigationcontrollerMyQues = [[UINavigationController alloc] initWithRootViewController:myQues] ;
    navigationcontrollerMyQues.navigationBar.hidden=YES;
    
    
    MyAnswersViewController *myAns=[[MyAnswersViewController alloc]initWithNibName:@"MyAnswersViewController" bundle:nil];
    myAns.title=@"A";
    
    
   
    UINavigationController *navigationcontrollerMyAns = [[UINavigationController alloc] initWithRootViewController:myAns] ;
    navigationcontrollerMyAns.navigationBar.hidden=YES;
    
    
    MyProfileViewController *myProfile=[[MyProfileViewController alloc]initWithNibName:@"MyProfileViewController" bundle:nil];
    myProfile.title=@"P";
    UINavigationController *navigationcontrollerMyPro = [[UINavigationController alloc] initWithRootViewController:myProfile] ;
    navigationcontrollerMyPro.navigationBar.hidden=YES;
    
    
    
    self.stuffTabBarController.viewControllers=[NSArray arrayWithObjects:navigationcontrollerMyQues,navigationcontrollerMyAns,navigationcontrollerMyPro, nil];
    
    [self.view addSubview:self.stuffTabBarController.view];
    
    
    
    [self.stuffTabBarController setSelectedIndex:0];
    
    
   
    
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

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //NSLog(@"viewcontroller==%@",viewController.view);
     NSLog(@"tab Bar view==%@",viewController.title);
    NSString *str=[NSString stringWithFormat:@"%@",viewController.title];
    
    
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    }
    
    if(!([str rangeOfString:@"Q"].location==NSNotFound)){
        
        [self.stuffTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"myStuff_my_question"]];
    }
    else if (!([str rangeOfString:@"A"].location==NSNotFound)){
        
        [self.stuffTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"myStuff_my_answers"]];
    }
    else{
        
        [self.stuffTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"myStuff_my_profile"]];
    }
}
 
@end