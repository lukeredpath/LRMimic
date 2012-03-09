//
//  FixtureHelpers.m
//  LRMimic
//
//  Created by Luke Redpath on 09/03/2012.
//  Copyright (c) 2012 LJR Software Limited. All rights reserved.
//

#import "FixtureHelpers.h"

NSString *__pathForFixture(NSString *name, NSString *type, id testCase) 
{
  return [[NSBundle bundleForClass:[testCase class]] pathForResource:name ofType:type];
}
