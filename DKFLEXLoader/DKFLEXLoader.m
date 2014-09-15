//
//  DKFLEXLoader.m
//  UICatalog
//
//  Created by Danylo Kostyshyn on 8/2/14.
//  Copyright (c) 2014 f. All rights reserved.
//

#import "DKFLEXLoader.h"

#import "FLEXManager.h"

@interface DKFLEXLoader ()

@end

@implementation DKFLEXLoader

__attribute__((constructor))
static void initializer(void)
{
	NSLog(@"FLEX dylib initializer get called.");

//    [[FLEXManager sharedManager] showExplorer];
}

__attribute__((destructor))
static void finalizer(void)
{
	NSLog(@"FLEX dylib finalizer get called.");
}

@end
