//
//  FBIntermediateViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 27/08/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBIntermediateViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *fbDict;
@property (nonatomic, strong) UITextField *emailField, *keyboardTextFld;

@property (strong, nonatomic) IBOutlet UIView *ViewA;
@property (strong, nonatomic) IBOutlet UIToolbar * keyboardToolbar;
@end
