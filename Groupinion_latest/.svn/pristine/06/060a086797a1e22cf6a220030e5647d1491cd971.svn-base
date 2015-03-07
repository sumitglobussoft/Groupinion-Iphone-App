//
//  FriendpickerCell.m
//  Groupinion
//
//  Created by Sumit Ghosh on 25/10/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "FriendpickerCell.h"

@implementation FriendpickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.proPicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 45, 50)];
        self.proPicImageView.backgroundColor= [UIColor clearColor];
        [self.contentView addSubview:self.proPicImageView];
        
       self.namelable =[[UILabel alloc]initWithFrame:CGRectMake(55, 10, 250, 30)];
        self.namelable.font=[UIFont systemFontOfSize:15.0f];
        self.namelable.textColor=[UIColor blackColor];
        self.namelable.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.namelable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
