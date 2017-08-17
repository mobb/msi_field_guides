//
//  OrganismDatabase.m
//  KelpForest
//
//  Created by Brian Green on 5/16/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "OrganismDatabase.h"
#import "OrganismInfo.h"
#import "OrganismGroupInfo.h"
#import <sqlite3.h>

@implementation OrganismDatabase


+ (OrganismDatabase *)sharedDatabase
{
    static OrganismDatabase* sharedDatabase = nil;
    if ( !sharedDatabase ) {
        sharedDatabase = [[super allocWithZone:nil] init];
    }
    return sharedDatabase;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedDatabase];
}


- (NSArray *)organismsInGroup:(NSString*)groupName
{
    NSArray *groupList = [organismsByGroup objectForKey:groupName];
    return groupList;
}

// ======================================================================================================================


- (NSArray *)groups
{
    //only create and sort the group list once?
    
    NSArray *preSorted = [organismGroups allValues];
    NSArray* sorted = [preSorted sortedArrayUsingSelector:@selector(compare:)];
    return sorted;
    //return [organismGroups allValues];
}




// ======================================================================================================================
- (OrganismGroupInfo*)groupInfo:(NSString *)groupName
{
    OrganismGroupInfo* groupInfo = [organismGroups objectForKey:groupName];
    
    
    return groupInfo;
}

// ======================================================================================================================

- (void)addOrganism:(OrganismInfo*)entry
{
    if ( !allOrganisms) {
        allOrganisms = [[NSMutableArray alloc] init];
    }
    
    if ( !organismsByGroup ) {
        organismsByGroup = [[NSMutableDictionary alloc] init];
    }

    if ( !organismGroups ) {
        organismGroups = [[NSMutableDictionary alloc] init];
    }
    
    if ( !organismByGroupParts ) {
        organismGroups = [[NSMutableDictionary alloc] init];
    }
    
    [allOrganisms addObject:entry];

/*
    //the groups are "xyz - abc", split them into 2 (Algae - Green)
    NSArray *elements = [[entry groupName] componentsSeparatedByString: @" - "];
    if ( [elements count] == 2 ) {
        NSString* groupPart1 = [elements objectAtIndex:0];
        NSString* groupPart2 = [elements objectAtIndex:1];
        
        NSMutableDictionary* topLevelGroups = [organismByGroupParts objectForKey:groupPart1];
        if ( topLevelGroups == nil ) {
            topLevelGroups = [[NSMutableDictionary alloc] init];
            [organismByGroupParts setObject:topLevelGroups forKey:groupPart1];
        }
        
        NSMutableArray* subgroupArray = [topLevelGroups objectForKey:groupPart2];
        if ( subgroupArray == nil ) {
            subgroupArray = [[NSMutableArray alloc] init];
            [topLevelGroups setObject:subgroupArray forKey:groupPart2];
        }
        [subgroupArray addObject:entry];
    }
*/
    

    NSMutableArray* groupArray = [organismsByGroup objectForKey:[entry groupName]];
    if ( groupArray == nil ) {
        groupArray = [[NSMutableArray alloc] init];
        [organismsByGroup setObject:groupArray forKey:[entry groupName]];
    }
    [groupArray addObject:entry];

    
    // slightly different take: this one has name and thumbnail
    OrganismGroupInfo *groupInfo = [organismGroups objectForKey:[entry groupName]];
    if ( groupInfo == nil ) {
        groupInfo = [[OrganismGroupInfo alloc] init];
        [groupInfo setName:[entry groupName]];
        [organismGroups setObject:groupInfo forKey:[entry groupName]];
    }
    
    [[groupInfo members] addObject:entry];
    
}

#pragma mark KelpForest database

- (NSString *) getKelpForestDatabasePath {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:[self databaseName]];
}

// ========================================================================================================================

-(void) checkAndCreateDatabase:(NSString *) databasePath databaseName:(NSString *) databaseName {
    
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
    
	// If the database already exists then return without doing anything
	if (success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

// ========================================================================================================================
- (void)loadDatabase:(NSString*)dbName {
    
    [self setDatabaseName:dbName];
   	[self checkAndCreateDatabase:[self getKelpForestDatabasePath] databaseName:dbName];

    
	sqlite3 *database;
    
    
	// Open the database from the users filessytem
	if (sqlite3_open([[self getKelpForestDatabasePath] UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from organisms";
		sqlite3_stmt *compiledStatement;
		
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                OrganismInfo* kelpForestEntry = [self getKelpForestEntry:compiledStatement];
                [self addOrganism:kelpForestEntry ];
			}
		}
        
        //[self determineGroupNames:database];
		
        // Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
   
    //log how many organisms we loaded
    NSLog(@"loaded [%u] organisms",[allOrganisms count]);
    
    
    //NSArray *myKeys = [organismGroups allKeys];
    //NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  
	sqlite3_close(database);
}

// ========================================================================================================================
- (OrganismInfo *) getKelpForestEntry:(sqlite3_stmt *) statement
{
    
    // Read the data from the result row
    NSString *entryID     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
    
    NSString *commonName  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
    NSString *groupName   = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
    NSString *scientific  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
    NSString *taxonomy    = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
    NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
    NSString *distribution= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
    NSString *habitat     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
    NSString *diet        = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
    NSString *funFacts    = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
   // NSString *refs        = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
    //    NSString *zone        = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
    //NSString *imageUrls   = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
    
    //NSLog(@"ID[%@]",entryID );
    
    // split the group names...
    NSArray *elements = [groupName componentsSeparatedByString: @" - "];
    
    if ( [elements count] == 2 ) {
        //NSLog(@"group[%@] subGroup[%@]",[elements objectAtIndex:0], [elements objectAtIndex:1]);
        groupName = [elements objectAtIndex:0];
    }
    
    // Create a new tidepool object with the data from the database
    OrganismInfo *newEntry = [[OrganismInfo alloc] initWithID:entryID
                                                         commonName:commonName
                                                          groupName:groupName
                                                     scientificName:scientific
                                                           taxonomy:taxonomy
                                                        description:description
                                                       distribution:distribution
                                                            habitat:habitat
                                                               diet:diet
                                                           funFacts:funFacts ];
    
    
    


    // can use these methods as well.
    //[newEntry setTaxonomy:taxonomy];
    //[newEntry setTaxonomy:taxonomy];
    
    
    return newEntry;
}

// ========================================================================================================================

- (NSMutableArray *) getKelpForestEntriesByGroup:(NSString *) groupName
{
    // Setup the database object
	sqlite3 *database;
    
	NSString *dbPath = [self getKelpForestDatabasePath];
    
    // Init the Array
	NSMutableArray* groupInfo = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
        const char *sqlStatement = (const char *) [[NSString stringWithFormat:@"select * from organisms where groupName = \"%@\"", groupName] UTF8String];
        
		sqlite3_stmt *compiledStatement;
		
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                OrganismInfo* kelpForestOrganism = [self getKelpForestEntry:compiledStatement];
                
				// Add the tidepool object to the tidepoolEntries Array
				[groupInfo addObject:kelpForestOrganism];
			}
		}
		
        // Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
    
    return groupInfo;
}



@end
