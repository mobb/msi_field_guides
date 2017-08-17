//
//  FactoidInfo.h
//  KelpApp
//
//  Created by Brian Green on 6/1/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoidInfo : NSObject

@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* text;
@property (nonatomic) BOOL expanded;

-(id)initWithTitle:(NSString*)t text:(NSString*)txt expanded:(BOOL)expanded;

@end
