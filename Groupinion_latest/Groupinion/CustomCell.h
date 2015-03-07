//
//  CustomCell.h
//  Groupinion
//
//  Created by Globussoft 1 on 7/30/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property(nonatomic,strong)UILabel *commentTextLabel;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *votedImage;
@end
