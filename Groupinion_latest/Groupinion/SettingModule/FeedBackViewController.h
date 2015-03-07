//
//  FeedBackViewController.h
//  Groupinion
//
//  Created by Globussoft 1 on 8/6/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController<UITextViewDelegate>
{
    UIImageView *banerImage;
    UILabel *feedBackDescription;
    UITextView *commentHereText;
    UIButton *submitButton;
    
    NSMutableData *mData;
    BOOL successData;
    
}


@end
