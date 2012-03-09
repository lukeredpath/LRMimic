# LRMimic, an Objective-C interface for Mimic

[Mimic](http://github.com/lukeredpath/mimic) is a Ruby gem that allows you to create live server stubs for your end-to-end tests.

Whilst Mimic is written in Ruby, it can be run as a standalone component without any pre-configured request stubs and be configured dynamically using it's embedded REST API (see the Mimic README for more information).

Mimic currently used to ship with a rough implementation of an Objective-C wrapper for it's REST API. This is an attempt to build a better, more fluent API.

## Usage

In order to keep tests as deterministic as possible, Mimic runs entirely synchronously. You'll probably never have any reason to use this in anything other than your tests, but if you do you should bear that in mind. As it's communicating with a local server, it's pretty fast anyway.

Using LRMimic requires that a mimic daemon is running (see the Mimic README on how to do this). You may want to start and stop this before and after your tests by using Xcode pre and post actions for your scheme's Test action.

### Creating a new Mimic client

```objc
NSURL *serverURL = [NSURL URLWithString:@"http://localhost:9999"]
LRMimic *mimic = [[LRMimic alloc] initWithServerURL:serverURL];
```

### Stubbing a GET request

```objc
[mimic respondTo:^(LRMimicStub *stub) {
  [stub get:@"/example" itReturns:^(LRMimicStubResponse *response) {}];
}];
```

This will create a default response stub for `GET /example` requests, returning a 200 OK and an empty response body.

### Customising your stub responses

```objc
[mimic respondTo:^(LRMimicStub *stub) {
  [stub get:@"/example" itReturns:^(LRMimicStubResponse *response) {
    [response setStatus:200];
    [response setBody:@"This is my response"];
    [response setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
  }];
}];
```

### Configuring a stub to return an object as JSON (iOS 5 only)

```objc
[mimic respondTo:^(LRMimicStub *stub) {
  [stub get:@"/example" itReturns:^(LRMimicStubResponse *response) {
    [response setStatus:200];
    [response setJSONBody:[NSDictionary dictionaryWithObject:@"bar" forKey:@"foo"]];
  }];
}];
```

This will convert the object to a JSON string using `NSJSONSerialization`, set it as the response body and configure the response `Content-Type` to be `application/json`.

### What about non-GET requests?

LRMimic has methods for stubbing GET, POST, PUT and DELETE requests. See `LRMimic.h` for details.

## License

This is licensed under the same license as `mimic`, which is the MIT license.
