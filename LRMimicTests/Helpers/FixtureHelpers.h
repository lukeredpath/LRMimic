//
//  FixtureHelpers.h
//  LRMimic
//
//  Created by Luke Redpath on 09/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *__pathForFixture(NSString *name, NSString *type, id testCase);

#define pathForFixture(name, type) __pathForFixture(name, type, self)
