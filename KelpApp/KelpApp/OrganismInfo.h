//
//  OrganismInfo.h
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganismInfo : NSObject

@property (nonatomic,copy) NSString* uniqueId;
@property (nonatomic,copy) NSString* commonName;
@property (nonatomic,copy) NSString* scientificName;
@property (nonatomic,copy) NSString* groupName;
@property (nonatomic,copy) NSString* taxonomy;
@property (nonatomic,copy) NSString* description;
@property (nonatomic,copy) NSString* distribution;
@property (nonatomic,copy) NSString* diet;
@property (nonatomic,copy) NSString* habitat;
@property (nonatomic,copy) NSString* funFacts;

@property (nonatomic,strong,readonly) UIImage* thumbnail;
@property (nonatomic,strong,readonly) NSMutableArray* images;

- (id)initWithID:(NSString*)entryID
      commonName:(NSString*)commonName
       groupName:(NSString*)groupName
  scientificName:(NSString*)scientific
        taxonomy:(NSString*)taxonomy
     description:(NSString*)description
    distribution:(NSString*)distribution
         habitat:(NSString*)habitat
            diet:(NSString*)diet
        funFacts:(NSString*)funFacts;

- (UIImage*)image;
- (NSArray*)imagePaths;

@end
