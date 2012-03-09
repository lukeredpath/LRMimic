//
//  LRMimic.m
//  LRMimic
//
//  Created by Luke Redpath on 08/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import "LRMimic.h"

@interface LRMimic ()
- (void)commitStubs:(LRMimicStub *)stub;
- (NSMutableURLRequest *)mutableAPIRequestForPath:(NSString *)path;
- (void)performRequest:(NSURLRequest *)request expectedStatusCode:(NSUInteger)expectedStatusCode;
@end

@implementation LRMimic {
  NSURL *_serverURL;
}

+ (id)mimicOnHost:(NSString *)host port:(NSUInteger)port
{
  NSString *URLString = [NSString stringWithFormat:@"http://%@:%d", host, port];
  NSURL *serverURL = [NSURL URLWithString:URLString];
  return [[self alloc] initWithServerURL:serverURL];
}

- (id)initWithServerURL:(NSURL *)serverURL
{
  if ((self = [super init])) {
    _serverURL = serverURL;
  }
  return self;
}

- (void)respondTo:(LRMimicRespondToBlock)respondToBlock
{
  LRMimicStub *stub = [[LRMimicStub alloc] init];
  respondToBlock(stub);
  [self commitStubs:stub];
}

- (void)reset
{
  NSMutableURLRequest *request = [self mutableAPIRequestForPath:@"/api/clear"];
  [self performRequest:request expectedStatusCode:200];
}

#pragma mark - Private methods

- (void)commitStubs:(LRMimicStub *)stub
{
  NSDictionary *requestData = [NSDictionary dictionaryWithObject:[stub arrayValue] forKey:@"stubs"];

  NSMutableURLRequest *request = [self mutableAPIRequestForPath:@"/api/multi"];
  [request setHTTPBody:[NSPropertyListSerialization dataFromPropertyList:requestData format:NSPropertyListXMLFormat_v1_0 errorDescription:nil]];
  [request setValue:@"application/plist" forHTTPHeaderField:@"Content-Type"];
  
  [self performRequest:request expectedStatusCode:201];
}

- (NSMutableURLRequest *)mutableAPIRequestForPath:(NSString *)path
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[_serverURL URLByAppendingPathComponent:path]];
  [request setValue:@"co.uk.lukeredpath.LRMimic" forHTTPHeaderField:@"User-Agent"];
  [request setHTTPMethod:@"POST"];
  [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
  return request;
}

- (void)performRequest:(NSURLRequest *)request expectedStatusCode:(NSUInteger)expectedStatusCode
{
  NSHTTPURLResponse *response; NSError *error;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  
  if (response.statusCode != expectedStatusCode) {
    @throw [NSException exceptionWithName:@"MimicBadResponseError" 
                                   reason:[NSString stringWithFormat:@"Mimic did not return a %d response", expectedStatusCode]
                                 userInfo:nil];
  }
}

@end

#pragma mark -

@interface LRMimicStub ()
- (void)stubForPath:(NSString *)path 
         HTTPMethod:(NSString *)HTTPMethod 
         usingBlock:(LRMimicStubResponseBlock)block;
@end

@implementation LRMimicStub {
  NSMutableArray *_responseStubs;
}

- (id)init 
{
  if ((self = [super init])) {
    _responseStubs = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)get:(NSString *)path itReturns:(LRMimicStubResponseBlock)responseBlock
{
  [self stubForPath:path HTTPMethod:@"GET" usingBlock:responseBlock];
}

- (void)post:(NSString *)path itReturns:(LRMimicStubResponseBlock)responseBlock
{
  [self stubForPath:path HTTPMethod:@"POST" usingBlock:responseBlock];
}

- (void)put:(NSString *)path itReturns:(LRMimicStubResponseBlock)responseBlock
{
  [self stubForPath:path HTTPMethod:@"PUT" usingBlock:responseBlock];
}

- (void)delete:(NSString *)path itReturns:(LRMimicStubResponseBlock)responseBlock
{
  [self stubForPath:path HTTPMethod:@"DELETE" usingBlock:responseBlock];
}

- (NSArray *)arrayValue
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:_responseStubs.count];
  
  for (LRMimicStubResponse *response in _responseStubs) {
    [array addObject:[response dictionaryValue]];
  }
  return [array copy];
}

#pragma mark - Private

- (void)stubForPath:(NSString *)path HTTPMethod:(NSString *)HTTPMethod usingBlock:(LRMimicStubResponseBlock)block
{
  LRMimicStubResponse *stubResponse = [[LRMimicStubResponse alloc] initWithMethod:HTTPMethod path:path];
  block(stubResponse);
  [_responseStubs addObject:stubResponse];
}

@end

#pragma mark -

@implementation LRMimicStubResponse {
  NSString *_HTTPMethod;
  NSString *_path;
  NSUInteger _status;
  NSString *_body;
  NSMutableDictionary *_headers;
}

- (id)initWithMethod:(NSString *)HTTPMethod path:(NSString *)path
{
  if ((self = [super init])) {
    _HTTPMethod = HTTPMethod;
    _path = path;
    _headers = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)setStatus:(NSUInteger)status
{
  _status = status;
}

- (void)setBody:(NSString *)body
{
  _body = body;
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
  [_headers setObject:value forKey:field];
}

- (NSDictionary *)dictionaryValue
{
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  [dictionary setObject:[NSNumber numberWithUnsignedInteger:_status] forKey:@"code"];
  [dictionary setObject:_body forKey:@"body"];
  [dictionary setObject:_headers forKey:@"headers"];
  [dictionary setObject:_path forKey:@"path"];
  [dictionary setObject:_HTTPMethod forKey:@"method"];
  return [dictionary copy];
}

@end
