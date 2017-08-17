//
//  OrganismGroupInfo.m
//  KelpForest
//
//  Created by Brian Green on 5/25/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "OrganismGroupInfo.h"
#import "OrganismInfo.h"

@implementation OrganismGroupInfo

@synthesize name;
@synthesize thumbnail;
@synthesize members;


- (id)init
{
    self = [super init];
    if (self ){
        members = [[NSMutableArray alloc] init];
    }
    return self;
}
-(UIImage*)thumbnail
{
    // if we dont already have the thumbnail image, use the first member in the list
    if ( thumbnail == nil ) {
        if ( [members count] > 0 ) {
            thumbnail = [[members objectAtIndex:0] thumbnail];
        }
    }
    return thumbnail;
}

- (NSComparisonResult)compare:(OrganismGroupInfo *)otherGroup
{
    return [[self name] compare:[otherGroup name]];
}

@end
