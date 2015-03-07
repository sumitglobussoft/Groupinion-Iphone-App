//
//  AppDelegate.m
//  Groupinion
//
//  Created by Sumit Ghosh on 15/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "AppDelegate.h"
#import "SendHttpRequest.h"
#import "ViewController.h"
#import "JSON.h"
#import "MySingletonClass.h"
#import "ShareToFacebookViewController.h"
#import "FBIntermediateViewController.h"
#import "Flurry.h"
#import <BugSense-iOS/BugSenseController.h>

#define GroupinionAlertValue @"CheckGroupinionAlert"
#define PushNotificationDeviceToken @"GroupinionPushNotificationDeviceToken"
#define CheckFirstRun @"CheckGroupinionFirstRun"

#define FlurryAppkey @"HDKVBC432FK7G3R9WMHF"
#define BugsenseAppKey @"4a45a0c6"

NSString *const FBSessionStateChangedNotification =
@"com.globussoft.sampleTestAppleID:FBSessionStateChangedNotification";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
    // KIIP Integration (Rajeev)
    Kiip *kiip = [[Kiip alloc] initWithAppKey:KP_APP_KEY andSecret:KP_APP_SECRET];
    
    // Listen for Kiip events
    kiip.delegate = self;
    
    [Kiip setSharedInstance:kiip];
//----------------------------------------------------
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    
    self.userDefault = [NSUserDefaults standardUserDefaults];
    //Check Alert Setting
    NSString *alertValue = [self.userDefault objectForKey:GroupinionAlertValue];
    NSLog(@"alertValue = %@",alertValue);
    
    if (!alertValue || [alertValue isEqualToString:@"1"]) {
        NSLog(@"Alert Not Set");
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    else{
        NSLog(@"Alert set to 0");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    }
    
    
    
    //Enable Remote Notification
    [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    self.window.rootViewController = self.viewController;
    [FBSession.activeSession closeAndClearTokenInformation];
    
    [self.window makeKeyAndVisible];
    return YES;
}

//Register device for Notification
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    
    //Fetch deveice token
    NSString *receiveString= [NSString stringWithFormat:@"%@",deviceToken];
    receiveString = [receiveString stringByReplacingOccurrencesOfString:@" " withString:@""];
    receiveString = [receiveString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    receiveString = [receiveString stringByReplacingOccurrencesOfString:@">" withString:@""];
    //Saving device token to User Default
    [self.userDefault setObject:receiveString forKey:PushNotificationDeviceToken];
    
    NSLog(@"Device Token String Value = %@", receiveString);
   
}
//Notification Receiver Method
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"Dictionary = %@", userInfo);
    //refreshBubble
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBubble" object:nil];
    
    BOOL ref=[MySingletonClass sharedSingleton].refresh;
    
    if (ref==YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAfterAction" object:nil]; 
    }
    else{
        [MySingletonClass sharedSingleton].refresh=YES;
    }
    

   
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // exit(0);
    // http://graph.facebook.com/%@/picture?type=small
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [MySingletonClass sharedSingleton].refresh=NO;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Saving current time to user default
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    NSDate *cuDate =[NSDate date];
    NSLog(@"cu Date =%@",cuDate);
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"mm"];
    NSString *ccc=[fo stringFromDate:cuDate];
    NSLog(@"cccc=%@",ccc);
    [user setObject:ccc forKey:@"GRO_Main_Feed_lastrefreshtime"];
    // Send notification for refresh All Data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshView" object:nil];
    [MySingletonClass sharedSingleton].refresh=NO;
    //UIApplicationDidBecomeActiveNotification
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
//-(void)signinWithFacebook{
//    if (FBSession.activeSession.isOpen) {
//        [self closeSession];
//    } else {
//        // The user has initiated a login, so call the openSession method
//        // and show the login UX if necessary
//        [self openSessionWithAllowLoginUI:YES];
//    }
//}


//--------------------------
//Closing Facebook Session
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}
// Check Facebook session
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error accessToken:(NSString *)acessToken

{
    switch (state) {
        case FBSessionStateClosedLoginFailed:
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self.viewController stopActivityIndicator];
            
            // handle error here, for example by showing an alert to the user
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not login with Facebook" message:@"Facebook login failed. Please check your Facebook settings on your phone." delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            
            break;
        }
            
            
        case FBSessionStateOpen:
            if (FBSession.activeSession.isOpen) {
                //if session open, request for user info
                [FBRequestConnection
                 startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                   id<FBGraphUser> user,
                                                   NSError *error) {
                     if (!error) {
                         NSString *userInfo = @"";
                         userInfo = [userInfo
                                     stringByAppendingString:
                                     [NSString stringWithFormat:@"Name: %@\n\n",
                                      user.id]];
                         NSLog(@"userinfo = %@",userInfo);
                         NSArray *ary=[userInfo componentsSeparatedByString:@":"];
                         if([ary count]>1){
                             userInfo=[ary objectAtIndex:1];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                             NSLog(@"sender id=%@",userInfo);
                         }
                         else{
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@"Name:" withString:@""];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@" " withString:@""];
                             userInfo=[userInfo stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                             }
                         
                         
                         [MySingletonClass sharedSingleton].fbUserID=userInfo;
                         
                         bool fbLogin=[MySingletonClass sharedSingleton].loginWithFacebook;
                         //Check login request or not
                         if(fbLogin==YES){
                             //if login save facebook data to server
                             [self newSaveDataToServer:acessToken];
                             
                         }
                         else{
                             //Switch to Share view and share on Facebook
                             ShareToFacebookViewController *share=[MySingletonClass sharedSingleton].shareFB;
                             [share firstCallMethod];
                            
                         }
                     }
                 }];
            }
            break;
            
        default:
            break;
    }
    
}
//Facebook Login Method
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    //Assiging Permission
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"basic_info",@"email",@"status_update",@"user_photos",@"user_birthday",@"user_about_me",@"user_friends",@"photo_upload",@"read_friendlists", nil];
    //Creating session
    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
    // Set the active session 
    [FBSession setActiveSession:session];
    //Login to facebook with Permission
    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
            completionHandler:^(FBSession *session,
                                FBSessionState status,
                                NSError *error) {
                
                if (error==nil) {
                    
                    FBAccessTokenData *tokenData= session.accessTokenData;
                    
                    NSString *accessToken = tokenData.accessToken;
                    NSLog(@"AccessToken==%@",accessToken);
                    
                    //Send to check session
                    [self sessionStateChanged:session
                                        state:FBSessionStateOpen
                                        error:error accessToken:accessToken];
                    
                }
                else{
                    [self.viewController stopActivityIndicator];
                    NSLog(@"Session not open==%@",error);
                }
                
                // Respond to session state changes,
                // ex: updating the view
            }];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [FBSession.activeSession handleOpenURL:url];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==2) {
        
        [self logoutFlow];
    }
}

//-------------
//Checking Facebook id exist on Database or not
-(void)checkFacebookIDExistOrNot:(NSMutableDictionary *)dict{
    //Link : https://beta.groupinion.com/android/getdatabyfbid/index.php?fbid=100003337246475
    
    NSString *fbID=[NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
    
    //servcice fr check Facebook ID
    NSString *checkUrlString = [NSString stringWithFormat:@"https://beta.groupinion.com/android/getdatabyfbid/index.php?fbid=%@",fbID];
    checkUrlString = [checkUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *response=[SendHttpRequest sendRequest:checkUrlString];
    NSLog(@"Response to check FBID=%@",response);
    
    if ([response isEqualToString:@"error"]) {
        NSLog(@"Error try Again");
        [FBSession.activeSession closeAndClearTokenInformation];
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
     
        //{"Status":"1","ID":"992","Email":"Rakesh@facebook.com"}
        //{"Status":"0","Message":"Given Facebook Id in not valid."}
        /*--------------
         /if status 0 Facebook id not exist display FBIntermediateViewController
         if status 1 means id exist display Home Page
-----------------------------------------------*/
         if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
            
            NSLog(@"Go to next view");
            
            self.fbInter = [[FBIntermediateViewController alloc]initWithNibName:@"FBIntermediateViewController" bundle:nil];
            self.fbInter.fbDict=dict;
            self.window.rootViewController = self.fbInter;
        }
        else{
            NSDictionary *dataDict = [response JSONValue];
            
            NSString *cemail=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"Email"]];
            
            
            
            
            NSString *fname=[NSString stringWithFormat:@"%@",[dict objectForKey:@"first_name"]];
            NSString *email=@"";
            NSString *gender=[NSString stringWithFormat:@"%@",[dict objectForKey:@"sex"]];
            
            NSString *accessToken=[NSString stringWithFormat:@"%@",[dict objectForKey:@"AccessToken"]];
            
            //Save User info to database
            NSString *sendUrl = [NSString stringWithFormat:@"http://beta.groupinion.com/android/latest_fbdetails_new/index.php?fname=%@&email=%@&cemail=%@&gender=%@&fid=%@&access_token=%@",fname,email,cemail,gender,fbID,accessToken];
            sendUrl = [sendUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *response = [SendHttpRequest sendRequest:sendUrl];
            
            NSLog(@"response= %@",response);
            
            if ([response isEqualToString:@"error"]) {
                NSLog(@"Error");
                [FBSession.activeSession closeAndClearTokenInformation];
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            }
            else{
                
                //{"Status":"0","Message":"All fields are mandatory"}
                if ([response rangeOfString:@"\"Status\":\"0\""].location != NSNotFound) {
                    [FBSession.activeSession closeAndClearTokenInformation];
                    NSDictionary *d = [response JSONValue];
                    NSString *mes=[NSString stringWithFormat:@"%@",[d objectForKey:@"Message"]];
                    
                    [[[UIAlertView alloc] initWithTitle:@"" message:mes delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                }//End if block status check
                else{
                    
                    //{"Status":"1","ID":"974","avatarImage":"100001247293233","Default_image_status":"0"} 
                    
                    NSDictionary *d = [response JSONValue];
                    
                    
                    NSString *userID=[d objectForKey:@"ID"];
                    
                    [MySingletonClass sharedSingleton].groupinionUserID=userID;
                    NSLog(@"dict app delegate===%@",d);
                    
                    
                    NSString *picSetStatus=[d objectForKey:@"Default_image_status"];
                    UIImage *profilePic=nil;
                    // check Profile pic already set or not
                    if ([picSetStatus isEqualToString:@"1"]) {
                        
                        NSString *profileImageString=[d objectForKey:@"avatarImage"];
                        if ([profileImageString rangeOfString:@"jpg"].location == NSNotFound) {
                            profileImageString=[NSString stringWithFormat:@"%@.jpg",profileImageString];
                        }
                        [MySingletonClass sharedSingleton].avtarImage=profileImageString;
                        
                        
                        profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",profileImageString]]]];
                        
                    }//End if block picSetStatus
                    else{
                        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",fbID]];
                        
                        profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                    }//End else block picSetStatus
                    
                    [MySingletonClass sharedSingleton].avtarImage=@"0_avatar_75_75.jpg";
                    [MySingletonClass sharedSingleton].profileImage=profilePic;
                    [MySingletonClass sharedSingleton].totalNotification = [NSString stringWithFormat:@"%@",[d objectForKey:@"Total Notifications"]];
                    
                    
                    //[self.viewController gotoNextView];
                    [MySingletonClass sharedSingleton].reported=YES;
                    [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
                    [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
                    [MySingletonClass sharedSingleton].refreshMyprofile=YES;
                    
                    NSLog(@"nn=%@",[MySingletonClass sharedSingleton].totalNotification);
                    
                    [self.viewController gotoNextView];
                    
                }//End Block Else status check
                
            }//End else block response Error check
            
        }//End else block first status check
        
    }//End Else Block response Error
}


-(void)makeRootViewController{
    self.groupViewcontroller = [[GroupViewController alloc] initWithNibName:@"GroupViewController" bundle:nil];
    self.window.rootViewController = self.groupViewcontroller;
    
    [self.window makeKeyAndVisible];
}

-(void)logoutFlow{
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
}
//Fetch Facebook user info
-(void)newSaveDataToServer:(NSString *)accessToken{
    
   [FBRequestConnection startWithGraphPath:@"me/" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection,id result, NSError *error){
        
        if (error) {
            NSLog(@"Error to create Album on Facebook=%@",error);
        }
        else{
            if (result==nil) {
                UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
                alert.tag=2;
                [alert show];
            }//result nil
            else{
                
                NSMutableDictionary *dict=result;
                
                NSLog(@"dictttt===%@",dict);
                
                NSLog(@"FBID=%@",[dict objectForKey:@"id"]);
                NSLog(@"first_name=%@",[dict objectForKey:@"first_name"]);
                NSLog(@"bio=%@",[dict objectForKey:@"bio"]);
                NSLog(@"birthday=%@",[dict objectForKey:@"birthday"]);
                NSLog(@"email=%@",[dict objectForKey:@"email"]);
                NSLog(@"gender=%@",[dict objectForKey:@"gender"]);

                NSString *name=[dict objectForKey:@"first_name"];
                NSString *email=[dict objectForKey:@"email"];
                NSString *sex=[dict objectForKey:@"gender"];
                NSString *fbID=[dict objectForKey:@"id"];
                NSString *about_me = [dict objectForKey:@"bio"];
                
                [MySingletonClass sharedSingleton].nickName=name;
                [MySingletonClass sharedSingleton].about_me=about_me;
                
                /*---------------------
                 if email not return by Facebook first check id exist or not
                 ------------------------*/
                if (email==nil || email==NULL || (NSNull *)email==[NSNull null]) {
                    
                    email=@"";
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                    if (!((NSNull *)name ==[NSNull null] && (NSNull *)sex==[NSNull null])) {
                        [dict setObject:name forKey:@"first_name"];
                        [dict setObject:email forKey:@"email"];
                        [dict setObject:sex forKey:@"sex"];
                        [dict setObject:fbID forKey:@"uid"];
                    }
                    [dict setObject:accessToken forKey:@"AccessToken"];
                    
                    [self checkFacebookIDExistOrNot:dict];
                    
                    
                }//End if block email check
                else{
                    
                    // https://beta.groupinion.com/android/latest_fbdetails/index.php?fname=&email=&gender=&fid=&access_token=
                    
                     //if email return by facebook save user info to server
                    
                    NSString *urlString = [NSString stringWithFormat:@"http://beta.groupinion.com/android/latest_fbdetails/index.php?fname=%@&email=%@&gender=%@&fid=%@&access_token=%@",name,email,sex,fbID,accessToken];
                    
                    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"urlstring==%@",urlString);
                    
                    NSString *responseString=[SendHttpRequest sendRequest:urlString];
                    
                    if([responseString isEqualToString:@"error"]){
                        NSLog(@"error");
                        [FBSession.activeSession closeAndClearTokenInformation];
                        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    }//End if Block responsestring Error Check
                    else{
                        
                        if([responseString rangeOfString:@"\"Status\":\"0\""].location != NSNotFound){
                            // {"Status":"0","Message":"All fields are mandatory"}
                            
                            // NSArray *ary=[responseString JSONValue];
                            NSDictionary *dict11 = [responseString JSONValue];
                            NSString *msg = [dict11 objectForKey:@"Message"];
                            [FBSession.activeSession closeAndClearTokenInformation];
                            [[[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                        }//End if Block responseString Status Check
                        
                        else{
                            
                            NSDictionary *dict=[responseString JSONValue];
                            NSString *userID=[dict objectForKey:@"ID"];
                            
                            [MySingletonClass sharedSingleton].groupinionUserID=userID;
                            NSLog(@"dict app delegate===%@",dict);
                            
                            //Fetch current points of user
                            [self setPointsInSingleton:dict];
                            
                            NSString *picSetStatus=[dict objectForKey:@"Default_image_status"];
                            UIImage *profilePic=nil;
                            //check profile pic is set or not
                            if ([picSetStatus isEqualToString:@"1"]) {
                                
                                NSString *profileImageString=[dict objectForKey:@"avatarImage"];
                                if ([profileImageString rangeOfString:@"jpg"].location == NSNotFound) {
                                    profileImageString=[NSString stringWithFormat:@"%@.jpg",profileImageString];
                                }
                                [MySingletonClass sharedSingleton].avtarImage=profileImageString;
                                
                                
                                profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.groupinion.com/app3/modules/boonex/photos/data/avatar_75_75/%@",profileImageString]]]];
                                
                            }//End if block picSetStatus
                            else{
                                NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small",fbID]];
                                
                                profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                            }//End else block picSetStatus
                            
                            
                            [MySingletonClass sharedSingleton].avtarImage=@"0_avatar_75_75.jpg";
                            [MySingletonClass sharedSingleton].profileImage=profilePic;
                            [MySingletonClass sharedSingleton].totalNotification = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Total Notifications"]];
                            //[self.viewController gotoNextView];
                            [MySingletonClass sharedSingleton].reported=YES;
                            [MySingletonClass sharedSingleton].refreshMyAnswer=YES;
                            [MySingletonClass sharedSingleton].refreshMyQuestion=YES;
                            [MySingletonClass sharedSingleton].refreshMyprofile=YES;
                            
                            [self.viewController gotoNextView];
                            
                        }//End Else Block response Status Check
                        
                        
                    }//End Else block response string error check
                    
                }//End else Block email null Check
                
            }//End else block check result nil
            
        }
        
    }];
    
   
}

#pragma mark -
#pragma mark KiipDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) kiip:(Kiip *)kiip didStartSessionWithPoptart:(KPPoptart *)poptart error:(NSError *)error {
    NSLog(@"kiip:didStartSessionWithPoptart:%@ error:%@", poptart, error);
    
    if (error) {
        [self showError:error];
    }
    if (poptart) {
        // Since we've implemented this delegate method, Kiip will no longer show the poptart automatically
        [poptart show];
    }
}

- (void) kiip:(Kiip *)kiip didEndSessionWithError:(NSError *)error {
    NSLog(@"kiip:didEndSessionWithError:%@", error);
    
    if (error) {
        [self showError:error];
    }
}

- (void) kiip:(Kiip *)kiip didStartSwarm:(NSString *)leaderboardId {
    NSLog(@"kiip:didStartSwarm:%@", leaderboardId);
    
    // Enter "swarm" mode
    // http://docs.kiip.com/en/guide/swarm.html
}

- (void) kiip:(Kiip *)kiip didReceiveContent:(NSString *)contentId quantity:(int)quantity transactionId:(NSString *)transactionId signature:(NSString *)signature {
    NSLog(@"kiip:didReceiveContent:%@ quantity:%d transactionId:%@ signature:%@", contentId, quantity, transactionId, signature);
    
    // Add quantity amount of content to player's profile
    // e.g +20 coins to user's wallet
    // http://docs.kiip.com/en/guide/android.html#getting_virtual_rewards
}
- (void)showError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
-(void)setPointsInSingleton:(NSDictionary*)dict{
    //Rajeev (KIIP)
    NSString *strPoints = [dict objectForKey:@"points"];
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

@end