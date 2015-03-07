//
//  WebImageOperation.h
//  Groupinion
//
//  Created by Sumit Ghosh on 27/08/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebImageOperation : NSObject

// This takes in a string and imagedata object and returns imagedata processed on a background thread
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;
@end
