//
//  FriendsPickerViewController.h
//  Groupinion
//
//  Created by Sumit Ghosh on 25/10/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendsPickerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *frndsListArray;
@property (nonatomic, strong) UITableView *frndsListTableView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) NSMutableArray *selectedFriendList;

@end

@protocol FriendPickerDelegate <NSObject>

- (void) friendpickerControllerDidCancel:(FriendsPickerViewController *)friendPicker;
- (void) friendPickerController: (FriendsPickerViewController *)friendPicker didFinishPickingFriends:(NSMutableArray *)friendListArray;
@end

@interface FriendsPickerViewController() 
@property (nonatomic, weak) id <FriendPickerDelegate> delegate;
@end