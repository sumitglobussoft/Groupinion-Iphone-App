//
//  CustomRatingCell.m
//  Groupinion
//
//  Created by Globussoft 1 on 8/2/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "CustomRatingCell.h"

@implementation CustomRatingCell
@synthesize initilized;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        

             self.categoryName=[[UILabel alloc]initWithFrame:CGRectMake(60, 4, 250, 32)];
            self.categoryName.font=[UIFont fontWithName:@"Arial-BoldMT" size:14];
             self.categoryName.backgroundColor=[UIColor clearColor];
            [self.contentView addSubview:self.categoryName];
               
            self.ratingImage=[[UIImageView alloc]initWithFrame:CGRectMake(60, 40, 15, 10)];
             [self.contentView addSubview:self.ratingImage];
        
        initilized = NO;
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(3, 8, 47,45);
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
