//
//  RequestHelpers.m
//  LRMimic
//
//  Created by Luke Redpath on 09/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import "RequestHelpers.h"

void performRequest(NSURL *serverURL, NSString *HTTPMethod, NSString *path, LRMimicTestPerformRequestBlock callback) {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[serverURL URLByAppendingPathComponent:path]];
  
  [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
  [request setHTTPMethod:HTTPMethod];
  
  NSHTTPURLResponse *response; NSError *error;
  
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  
  callback(response, responseBody);
}
