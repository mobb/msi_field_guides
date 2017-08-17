//
//  FAQDatabase.m
//  KelpApp
//
//  Created by Brian Green on 5/30/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "FAQDatabase.h"
#import <sqlite3.h>
#import "FAQInfo.h"

@implementation FAQDatabase

@synthesize FAQs;


+ (FAQDatabase *)sharedDatabase
{
    static FAQDatabase* sharedDatabase = nil;
    if ( !sharedDatabase ) {
        sharedDatabase = [[super allocWithZone:nil] init];
        [sharedDatabase setFAQs:[[NSMutableArray alloc] init]];
    }
    return sharedDatabase;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedDatabase];
}

#pragma mark FAQ database

- (NSString *) getFAQDatabasePath {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:databaseName];
}
// ========================================================================================================================

-(void) checkAndCreateDatabase:(NSString *) databasePath databaseName:(NSString *) dbName {
    
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:databasePath];
    
	// If the database already exists then return without doing anything
	if (success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

// ========================================================================================================================
- (void)loadDatabase:(NSString*)dbName {
    
    databaseName = dbName;
   	[self checkAndCreateDatabase:[self getFAQDatabasePath] databaseName:dbName];
   
	sqlite3 *database;
    
    //@todo change to FAQs!
    
	// Open the database from the users filessytem
	if (sqlite3_open([[self getFAQDatabasePath] UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from faqs";
		sqlite3_stmt *compiledStatement;
		
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                FAQInfo* faqEntry = [self getFAQEntry:compiledStatement];
                [FAQs addObject:faqEntry];
            }
		}
        
        //[self determineGroupNames:database];
		
        // Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
    
    //log how many organisms we loaded
    NSLog(@"loaded [%lu] FAQs",(unsigned long)(unsigned long)[FAQs count]);
    
	sqlite3_close(database);
}

// ========================================================================================================================
- (FAQInfo *) getFAQEntry:(sqlite3_stmt *) statement
{
    
    // Read the data from the result row
    //NSString *faqID         = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
    NSString *questionText  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
    NSString *answerURL     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
    NSString *imagePath     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
    NSString *thumbnailPath = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];

    // Create a new FAQ info object with the data from the database
    FAQInfo *newEntry = [[FAQInfo alloc] initWithData:questionText
                                            answerURL:answerURL
                                            imageName:imagePath
                                        thumbnailName:thumbnailPath];
    
    
    return newEntry;
}

@end
