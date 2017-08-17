//
//  OrganismInfo.m
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "OrganismInfo.h"

@implementation OrganismInfo

@synthesize uniqueId;
@synthesize commonName;
@synthesize scientificName;
@synthesize groupName;
@synthesize taxonomy;
@synthesize distribution;
@synthesize description;
@synthesize diet;
@synthesize habitat;
@synthesize funFacts;

@synthesize thumbnail;
@synthesize images;

- (id)initWithID:(NSString*)entryID
      commonName:(NSString*)comName
       groupName:(NSString*)grpName
  scientificName:(NSString*)sciName
        taxonomy:(NSString*)tax
     description:(NSString*)desc
    distribution:(NSString*)dist
         habitat:(NSString*)hab
            diet:(NSString*)di
        funFacts:(NSString*)ffs
{
    self = [super init];
    if (self ) {
        self.uniqueId = entryID;
        self.commonName = comName;
        self.groupName = grpName;
        self.scientificName = sciName;
        self.taxonomy = tax;
        self.description = desc;
        self.distribution = dist;
        self.habitat = hab;
        self.diet = di;
        self.funFacts = ffs;
    }
    
    return self;
}

-(id)thumbnail
{
    if ( thumbnail == nil ) {
        
        NSString* fileType = @"png";
        
        //NSString* imageURL = [[self._imageURLList objectAtIndex:index] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *fileName = [NSString stringWithFormat:@"%@_sm", uniqueId];
        NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
        
        if ( imagePath == nil ) {
            fileName = [NSString stringWithFormat:@"%@", uniqueId];
            imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType inDirectory:@"Thumbnail_Images"];
        }
        
        if ( imagePath != nil ) {
            thumbnail = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return thumbnail;
}


-(UIImage*)image
{
    NSString *fileName = [NSString stringWithFormat:@"%@", uniqueId];
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];

    if ( imagePath == nil ) {
        fileName = [NSString stringWithFormat:@"%@_1", uniqueId];
        imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
    }

    if ( imagePath ) {
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    
    NSLog(@"unable to find image for [%@]",uniqueId);
    return nil;
}

-(id)images
{
    if (images == nil ) { //@todo DO NOT store these
        
        images = [[NSMutableArray alloc] init];
        UIImage *tempImage = nil;
        
        //we need to determine how many images exist
        NSString *fileName = [NSString stringWithFormat:@"%@", uniqueId];
        NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
        if ( imagePath != nil ) {
            tempImage = [UIImage imageWithContentsOfFile:imagePath];
        }
        
        if ( tempImage != nil ) {
            [images addObject:tempImage];
        }
        else {
            int idx = 1;
           
            fileName = [NSString stringWithFormat:@"%@_%d", uniqueId, idx];
            imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
            tempImage = [UIImage imageWithContentsOfFile:imagePath];

            if ( tempImage != nil ) {
                [images addObject:tempImage];
                
            }
        }
    }
    return images;
}

- (NSArray*)imagePaths
{
    NSMutableArray* imagePaths = [[NSMutableArray alloc] init];

    NSString *fileName = [NSString stringWithFormat:@"%@", uniqueId];
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"]; //@todo remove the extension?
    if ( imagePath != nil ) {
        [imagePaths addObject:imagePath];
        //NSLog(@"found single image[%@]",imagePath);
    }
    else {
    
        int idx = 1;
        BOOL done = NO;
    
        while ( !done ) {
            fileName = [NSString stringWithFormat:@"%@_%d", uniqueId,idx];
            imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
        
            if ( imagePath != nil ) {
                [imagePaths addObject:imagePath];
                ++idx;
            }
            else {
                done = YES;
                //NSLog(@"loaded [%d] images for [%@]",idx-1,uniqueId);
            }
            
        }
    }
    return imagePaths;
}
@end
