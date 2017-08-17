//
//  FAQInfo.m
//  KelpApp
//
//  Created by Brian Green on 5/23/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "FAQInfo.h"

@implementation FAQInfo

@synthesize uniqueId;
@synthesize question;
@synthesize answerURL;
@synthesize imageName;


-(id)initWithData:(NSString*)q answerURL:(NSString*)url imageName:(NSString*)image thumbnailName:(NSString*)thumbnail
{
    self = [super init];
    if ( self ) {
        self.question = q;
        self.answerURL = url;
        imageName = image;
        thumbnailName = thumbnail;
        
    }
    return self;
}

-(id)initWithQuestion:(NSString *)q uniqueID:(NSString*)ident
{
    self = [super init];
    if ( self ) {
        self.question = q;
        self.uniqueId = ident;
        
        //these are cur
        self.answerURL = [NSString stringWithFormat:@"FAQ_%@",uniqueId];
        imageName = [NSString stringWithFormat:@"kelp_FAQ_%@",uniqueId];
        
    }
    return self;
}

- (UIImage*)thumbnail
{
    //if ( thumbnail == nil ) {
    UIImage *thumbnail = nil;
            //load the thumbnail
        NSString *fileName = [NSString stringWithFormat:@"%@", thumbnailName];
        NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        thumbnail = [UIImage imageWithContentsOfFile:imagePath];
    //}
    return thumbnail;
}

- (UIImage*)image
{
    UIImage* image = nil;
    NSString *fileName = [NSString stringWithFormat:@"%@", imageName];
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil ];//]inDirectory:@"FAQs/images"];
    
    if ( imagePath ) {
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    else {
        NSLog(@"### unable to find [%@]",imagePath);
    }

    return image;
}

-(NSString*)imagePath
{
    NSString *fileName = [NSString stringWithFormat:@"%@", imageName];
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil ];//]inDirectory:@"FAQs/images"];

    return imagePath;
}
@end
