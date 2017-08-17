//
//  OrganismGroupInfo.h
//  KelpForest
//
//  Created by Brian Green on 5/25/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganismGroupInfo : NSObject

@property (nonatomic,copy) NSString* name;
@property (nonatomic,strong) UIImage* thumbnail;
@property (nonatomic,strong) NSMutableArray *members;

@end
