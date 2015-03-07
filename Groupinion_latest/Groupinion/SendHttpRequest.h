//
//  SendHttpRequest.h
//  Groupinion
//
//  Created by Sumit Ghosh on 23/07/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendHttpRequest : NSObject

+(NSString *)sendRequest:(NSString *)urlString;
+ (UIImage *)orientedFixedImage:(UIImage *)image;
@end
