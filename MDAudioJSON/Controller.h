//
//  Controller.m
//  MDAudioQuery
//
//  Created by Bailey Carlson on 12/4/10.
//  Copyright 2010 Bailey Carlson. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
#import <YAJL/YAJL.h>

@interface Controller : NSObject <NSApplicationDelegate>
{
	MDQueryRef     query;
	bool		isFinished;
    int         requestItemIndex;
}

- (void)startSearch:(NSString*)searchQuery;
- (void)getPathAtIndex:(int)index withSearchQuery:(NSString*)searchQuery;

@end