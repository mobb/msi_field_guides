//
//  OrganismDatabase.h
//  KelpForest
//
//  Created by Brian Green on 5/16/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrganismInfo;
@class OrganismGroupInfo;

@interface OrganismDatabase : NSObject
{

    NSMutableArray* allOrganisms;
    NSMutableDictionary* organismsByGroup;
    
    NSMutableDictionary *organismGroups;
    
    NSMutableDictionary *organismSubGroups;
}

@property (nonatomic,copy) NSString* databaseName;


+ (OrganismDatabase *)sharedDatabase;

//- (id)initFromDatabase:(NSString*)dbName;
- (void)loadDatabase:(NSString*)dbName;

- (NSArray *)organismsInGroup:(NSString*)groupName;
- (NSArray *)groups;

- (NSArray *)subGroupsInGroup:(NSString*)groupName;

- (void)addOrganism:(OrganismInfo*)entry;
- (OrganismGroupInfo*)groupInfo:(NSString*)groupName;


@end
