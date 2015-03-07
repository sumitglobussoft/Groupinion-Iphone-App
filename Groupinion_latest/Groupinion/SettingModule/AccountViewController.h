//
//  AccountViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 14/08/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UITextFieldDelegate>


//Main Banner.
@property UIImageView *banerImage;
//Email Id..
@property(nonatomic,strong)UITextField *emailIDText;
//Oldpassword text..
@property(nonatomic,strong)UITextField *oldPassword;
//Newpassword text...
@property(nonatomic,strong)UITextField *nwPasword;
//Changepassword Button..
@property(nonatomic,strong)UIButton *changePasswordButton;

//NSData..
@property (nonatomic,strong)NSMutableData *mData;
@property BOOL successData;


@end
