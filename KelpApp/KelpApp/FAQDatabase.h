//
//  FAQDatabase.h
//  KelpApp
//
//  Created by Brian Green on 5/30/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAQDatabase : NSObject
{
    NSString *databaseName;
    
}

@property (nonatomic,strong) NSMutableArray *FAQs;

+ (FAQDatabase*)sharedDatabase;

- (void)loadDatabase:(NSString*)dbName;


@end
