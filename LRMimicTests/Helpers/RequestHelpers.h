//
//  RequestHelpers.h
//  LRMimic
//
//  Created by Luke Redpath on 09/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LRMimicTestPerformRequestBlock)(NSHTTPURLResponse *, NSString *);

void performRequest(NSURL *serverURL, NSString *HTTPMethod, NSString *path, LRMimicTestPerformRequestBlock callback);
