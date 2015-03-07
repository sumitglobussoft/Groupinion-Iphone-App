//
//  WebImageOperation.m
//  Groupinion
//
//  Created by Sumit Ghosh on 27/08/13.
//  Copyright (c) 2013 Sumit Ghosh. All rights reserved.
//

#import "WebImageOperation.h"
#import <QuartzCore/QuartzCore.h>


@implementation WebImageOperation

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
    dispatch_release(downloadQueue);
}
@end
