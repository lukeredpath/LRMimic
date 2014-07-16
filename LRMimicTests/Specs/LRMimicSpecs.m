  //
//  LRMimicTests.m
//  LRMimicTests
//
//  Created by Luke Redpath on 08/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import "SpecHelper.h"
#import "LRMimic.h"

SpecBegin(MimicSpecs)

describe(@"LRMimic", ^{
  __block LRMimic *mimic;
  __block NSURL *serverURL;

  beforeAll(^{
    serverURL = [NSURL URLWithString:@"http://localhost:11988"];
    mimic = [[LRMimic alloc] initWithServerURL:serverURL];
  });
  
  beforeEach(^{
    [mimic reset];
  });
  
  it(@"stubs GET requests to return a fixed response", ^{
    [mimic respondTo:^(LRMimicStubs *stubs) {
      [stubs get:@"/example" itReturns:^(LRMimicStubResponse *response) {
        [response setStatus:200];
        [response setBody:@"This is my response"];
        [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
      }];
    }];
    
    performRequest(serverURL, @"GET", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
      expect(response.statusCode).equal(200);
      expect(responseBody).equal(@"This is my response");
      expect([[response allHeaderFields] objectForKey:@"Content-Type"]).equal(@"text/plain");
    });
	});
  
  it(@"stubs POST requests to return a fixed response", ^{
    [mimic respondTo:^(LRMimicStubs *stubs) {
      [stubs post:@"/example" itReturns:^(LRMimicStubResponse *response) {
        [response setStatus:201];
        [response setBody:@"This is my response"];
        [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
      }];
    }];
    
    performRequest(serverURL, @"POST", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
      expect(response.statusCode).equal(201);
      expect(responseBody).equal(@"This is my response");
      expect([[response allHeaderFields] objectForKey:@"Content-Type"]).equal(@"text/plain");
    });
	});
  
  it(@"stubs PUT requests to return a fixed response", ^{
    [mimic respondTo:^(LRMimicStubs *stubs) {
      [stubs put:@"/example" itReturns:^(LRMimicStubResponse *response) {
        [response setStatus:200];
        [response setBody:@"This is my response"];
        [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
      }];
    }];
    
    performRequest(serverURL, @"PUT", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
      expect(response.statusCode).equal(200);
      expect(responseBody).equal(@"This is my response");
      expect([[response allHeaderFields] objectForKey:@"Content-Type"]).equal(@"text/plain");
    });
	});
  
  it(@"stubs DELETE requests to return a fixed response", ^{
    [mimic respondTo:^(LRMimicStubs *stubs) {
      [stubs delete:@"/example" itReturns:^(LRMimicStubResponse *response) {
        [response setStatus:200];
        [response setBody:@"This is my response"];
        [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
      }];
    }];
    
    performRequest(serverURL, @"DELETE", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
      expect(response.statusCode).equal(200);
      expect(responseBody).equal(@"This is my response");
      expect([[response allHeaderFields] objectForKey:@"Content-Type"]).equal(@"text/plain");
    });
	});
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
  
  it(@"stubs requests to return JSON", ^{
    [mimic respondTo:^(LRMimicStubs *stubs) {
      [stubs get:@"/example" itReturns:^(LRMimicStubResponse *response) {
        [response setStatus:200];
        [response setJSONBody:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]];
      }];
    }];
    
    performRequest(serverURL, @"GET", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
      expect(response.statusCode).equal(200);
      expect(responseBody).equal(@"{\"foo\":\"bar\"}");
      expect([[response allHeaderFields] objectForKey:@"Content-Type"]).equal(@"application/json");
    });
	});

#endif
  
  it(@"stubs requests to return a 200 with an empty body if nothing specified", ^{
    [mimic respondTo:^(LRMimicStubs *stubs) {
      [stubs get:@"/example" itReturns:^(LRMimicStubResponse *response) {}];
    }];
    
    performRequest(serverURL, @"GET", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
      expect(response.statusCode).equal(200);
      expect(responseBody).equal(@"");
    });
  });
  
  it(@"stubs requests configured in a plist file", ^{
    [mimic stubRequestsUsingFixtureFile:pathForFixture(@"SampleRequests", @"plist")];
    
    performRequest(serverURL, @"GET", @"/example", ^(NSHTTPURLResponse *response, NSString *responseBody) {
      expect(response.statusCode).equal(200);
      expect(responseBody).equal(@"Response from fixture file");
    });
	});
});

SpecEnd
