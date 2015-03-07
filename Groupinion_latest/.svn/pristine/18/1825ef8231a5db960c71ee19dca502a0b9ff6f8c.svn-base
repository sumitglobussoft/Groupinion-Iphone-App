//
//  MySingletonClass.m
//  Groupinion
//
//  Created by Sumit Ghosh on 22/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "MySingletonClass.h"
static MySingletonClass *sharedSingleton;


@implementation MySingletonClass
@synthesize groupinionUserID;
@synthesize loginWithFacebook;
@synthesize reported;
@synthesize categoryListArray;
@synthesize fbLoginSuccessed;
@synthesize profileImage;
@synthesize about_me;
@synthesize avtarImage;
@synthesize refreshMyAnswer;
@synthesize refreshMyQuestion;
@synthesize shareFB;
@synthesize groupViewController;

@synthesize totalNotification;
@synthesize refreshMyprofile;
@synthesize refreshNotification;
@synthesize refresh;

+(MySingletonClass *)sharedSingleton{
    @synchronized(self){
        
        if(!sharedSingleton){
            sharedSingleton=[[MySingletonClass alloc]init];
        }
    }return sharedSingleton;
}
@end
