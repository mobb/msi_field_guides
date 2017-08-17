//
//  FactoidInfo.m
//  KelpApp
//
//  Created by Brian Green on 6/1/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "FactoidInfo.h"

@implementation FactoidInfo

@synthesize title;
@synthesize text;
@synthesize expanded;

-(id)initWithTitle:(NSString*)t text:(NSString*)tx expanded:(BOOL)ex
{
    self = [super init];
    if (self ) {
    
        [self setTitle:t];
        [self setText:tx];
        [self setExpanded:ex];
        
    }
    return self;
}

@end
