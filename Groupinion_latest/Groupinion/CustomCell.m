//
//  CustomCell.m
//  Groupinion
//
//  Created by Globussoft 1 on 7/30/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.commentTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 0, 220, 16)];
        self.commentTextLabel.backgroundColor=[UIColor clearColor];
        self.commentTextLabel.textColor=[UIColor darkGrayColor];
        self.commentTextLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:15];
        [self.contentView addSubview:self.commentTextLabel];
        
        self.nickNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 38, 220, 16)];
        self.nickNameLabel.backgroundColor=[UIColor clearColor];
        self.nickNameLabel.textColor=[UIColor grayColor];
        self.nickNameLabel.font=[UIFont fontWithName:@"Arial" size:12];

        [self.contentView addSubview:self.nickNameLabel];

        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(7, 19, 220, 16)];
        self.titleLabel.backgroundColor=[UIColor clearColor];
        self.titleLabel.font=[UIFont fontWithName:@"Arial" size:12];

        self.titleLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:self.titleLabel];
        
        
        self.votedImage = [[UIImageView alloc] initWithFrame:CGRectMake(255, 37, 60, 16)];
        [self.contentView addSubview:self.votedImage];


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
