//
//  WebImageSearchViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 29/10/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol WebImageSearchViewControllerDelegate;


@interface WebImageSearchViewController : UIViewController <UITextFieldDelegate>
{
    NSUserDefaults *userDefaults;
    CGFloat x, y;
    int totalImages, pages;
    NSString *lastSearchKey;
    UIImage *selectedImage;
    BOOL imageSelected;
}
@property (strong, nonatomic) UIButton *moreButon;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageListArray;
@property (nonatomic, strong) IBOutlet UITextField *searchBoxTextfield;
@property (nonatomic, strong) UIImageView *tickMarkImageView;
@property (nonatomic, weak) id <WebImageSearchViewControllerDelegate> delegate;
-(IBAction)searchButtonClicked:(id)sender;
@end

@protocol WebImageSearchViewControllerDelegate <NSObject>

-(void) webImageSearch :(WebImageSearchViewController *)webSearch
   finishSelectingImage:(UIImage *)selectedImage;
@end
