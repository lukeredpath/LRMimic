//
//  LRMimicTests.m
//  LRMimicTests
//
//  Created by Luke Redpath on 08/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import <SenTestingKit/SenTestCase.h>
#import "LRMimic.h"

typedef void (^LRMimicTestPerformRequestBlock)(NSHTTPURLResponse *, NSString *);

void performRequest(NSURL *serverURL, NSString *HTTPMethod, NSString *path, LRMimicTestPerformRequestBlock callback);

void performRequest(NSURL *serverURL, NSString *HTTPMethod, NSString *path, LRMimicTestPerformRequestBlock callback) {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[serverURL URLByAppendingPathComponent:path]];

  [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
  [request setHTTPMethod:HTTPMethod];
  
  NSHTTPURLResponse *response; NSError *error;
  
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  
  callback(response, responseBody);
}

@interface LRMimicTests : SenTestCase
@end

@implementation LRMimicTests {
  NSURL *serverURL;
  LRMimic *mimic;
}

- (void)setUp
{
  [super setUp];
  
  serverURL = [NSURL URLWithString:@"http://localhost:11988"];
  mimic = [LRMimic mimicOnHost:@"localhost" port:11988];
  
  [mimic reset];
}

- (void)tearDown
{
  [super tearDown];
}

- (void)testStubbingGetRequestToReturnAFixedResponse
{
  [mimic respondTo:^(LRMimicStub *stub) {
    [stub get:@"/example" itReturns:^(LRMimicStubResponse *response) {
      [response setStatus:200];
      [response setBody:@"This is my response"];
      [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    }];
  }];
  
  performRequest(serverURL, @"GET", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
    STAssertEquals(response.statusCode, 200, 
       @"Expected the response to have the correct status code.");
    
    STAssertEqualObjects(responseBody, @"This is my response", 
       @"Expected the response to have the correct body.");
    
    STAssertEqualObjects(@"text/plain", [[response allHeaderFields] objectForKey:@"Content-Type"],
       @"Expected the response to have the correct content-type header");

  });
}

- (void)testStubbingPostRequestToReturnAFixedResponse
{
  [mimic respondTo:^(LRMimicStub *stub) {
    [stub post:@"/example" itReturns:^(LRMimicStubResponse *response) {
      [response setStatus:201];
      [response setBody:@"This is my response"];
      [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    }];
  }];
 
  performRequest(serverURL, @"POST", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
    STAssertEquals(response.statusCode, 201, 
      @"Expected the response to have the correct status code.");
    
    STAssertEqualObjects(responseBody, @"This is my response", 
      @"Expected the response to have the correct body.");
    
    STAssertEqualObjects(@"text/plain", [[response allHeaderFields] objectForKey:@"Content-Type"],
      @"Expected the response to have the correct content-type header");
    
  });
}

- (void)testStubbingPutRequestToReturnAFixedResponse
{
  [mimic respondTo:^(LRMimicStub *stub) {
    [stub put:@"/example" itReturns:^(LRMimicStubResponse *response) {
      [response setStatus:200];
      [response setBody:@"This is my response"];
      [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    }];
  }];
  
  performRequest(serverURL, @"PUT", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
    STAssertEquals(response.statusCode, 200, 
      @"Expected the response to have the correct status code.");
    
    STAssertEqualObjects(responseBody, @"This is my response", 
      @"Expected the response to have the correct body.");
    
    STAssertEqualObjects(@"text/plain", [[response allHeaderFields] objectForKey:@"Content-Type"],
      @"Expected the response to have the correct content-type header");
    
  });
}

- (void)testStubbingDeleteRequestToReturnAFixedResponse
{
  [mimic respondTo:^(LRMimicStub *stub) {
    [stub delete:@"/example" itReturns:^(LRMimicStubResponse *response) {
      [response setStatus:200];
      [response setBody:@"This is my response"];
      [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    }];
  }];
  
  performRequest(serverURL, @"DELETE", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
    STAssertEquals(response.statusCode, 200, 
      @"Expected the response to have the correct status code.");
    
    STAssertEqualObjects(responseBody, @"This is my response", 
      @"Expected the response to have the correct body.");
    
    STAssertEqualObjects(@"text/plain", [[response allHeaderFields] objectForKey:@"Content-Type"],
      @"Expected the response to have the correct content-type header");
    
  });
}

@end

