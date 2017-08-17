//
//  GroupInfo.h
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfo : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSMutableArray *members;

@end
