//
//  AppDelegate.m
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupInfo.h"
#import "GroupsViewController.h"
#import "OrganismInfo.h"
#import "OrganismDatabase.h"
#import "OrganismGroupInfo.h"
#import <sqlite3.h>


#import "GroupMemberViewController.h"

#import "FAQInfo.h"
#import "FAQViewController.h"
#import "FAQDatabase.h"

#import "ImageViewController.h"
#import "SectionedGroupView.h"
#import "OrganismDetailViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    OrganismDatabase *database = [OrganismDatabase sharedDatabase];
    [database loadDatabase:@"kelpforest13.sql"];
    

    FAQDatabase *faqDatabase = [FAQDatabase sharedDatabase];
    [faqDatabase loadDatabase:@"FAQ_database.sql"];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0 green:0.3 blue:0.1 alpha:1.0]]; //find a better green


    // check to see if we are on an ipad.. if so, we are
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        //UISplitViewController* svc = (UISplitViewController*)self.window.rootViewController;
        
        UISplitViewController *svcx = (UISplitViewController *)self.window.rootViewController;
        if ( [svcx isKindOfClass:[UISplitViewController class]] ) {
            
            NSLog(@"is a SVC");
        }
            
        UINavigationController *leftNavController = [svcx.viewControllers objectAtIndex:0];
        SectionedGroupView *sgv = (SectionedGroupView *)[leftNavController topViewController];
        OrganismDetailViewController* detail = [svcx.viewControllers objectAtIndex:1 ];
        
        //RightViewController *rightViewController = [splitViewController.viewControllers objectAtIndex:1];
        
        
        
        
        //UINavigationController* navcon = (UINavigationController*)self.window.rootViewController;
        //UISplitViewController* svc = [[navcon viewControllers] objectAtIndex:0 ];

        
        //SectionedGroupView* sgv = [[svc viewControllers] objectAtIndex:0 ];
        
        //OrganismDetailViewController* detail = [[svc viewControllers] objectAtIndex:1 ];
        [sgv setDelegate:detail];
        [svcx setDelegate:detail];
        
        
        //NSArray* groups = [database groups];
        //use the first entry of the groups array (is this the short names?)
        
        NSArray* subGroups = [database subGroupsInGroup:@"Algae"];
        [sgv setSubGroups:subGroups];
        
    }
    
    
    
  /*
    UITabBarController *tabcon = (UITabBarController*)self.window.rootViewController;
    
    {
        UINavigationController* navcon = [[tabcon viewControllers] objectAtIndex:0];
        GroupsViewController* groupcon = [[navcon viewControllers] objectAtIndex:0];
    
        [groupcon setGroups:groupsInfo];
    }
  */
    {
        /*
        UINavigationController* navcon = [[tabcon viewControllers] objectAtIndex:2];
        GroupMemberViewController* groupMembers = [[navcon viewControllers] objectAtIndex:0];
        
        OrganismGroupInfo *groupInfo = [database groupInfo:@"Algae"];
        
        [navcon setTitle:[groupInfo name]];
        
        [groupMembers setGroupInfo:groupInfo];
         */
    }
    
    {
        //UINavigationController* navcon = [[tabcon viewControllers] objectAtIndex:1];
        //FAQViewController* faqvc = [[navcon viewControllers] objectAtIndex:0];
        //[faqvc setFAQs:FAQs];
    }
    
    {
    //    UINavigationController* navcon = [[tabcon viewControllers] objectAtIndex:2];
  //      ImageViewController* ivc = [[navcon viewControllers] objectAtIndex:0];
//        [ivc setImageName:@"1_1.png"];
        
    }
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSString *) getKelpForestDatabasePath {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"kelpforest2.sql"];
}

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

#pragma mark -
#pragma mark KelpForest database

// ========================================================================================================================

-(void) readKelpForestEntitiesFromDatabase {
	// Setup the database object
	sqlite3 *database;
    
  
    
	// Open the database from the users filessytem
	if (sqlite3_open([[self getKelpForestDatabasePath] UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "select * from organisms";
		sqlite3_stmt *compiledStatement;
		
        if (sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                /*
                KelpForestEntry* kelpForestEntry = [self getKelpForestEntry:compiledStatement];
				
                // Add the tidepool object to the tidepoolEntries Array
				[_kelpForestEntries addObject:kelpForestEntry];
                
                
                NSMutableArray* groupArray = [groupDictionary objectForKey:[kelpForestEntry groupName]];
                if ( groupArray == nil ) {
                    groupArray = [[NSMutableArray alloc] init];
                    [groupDictionary setObject:groupArray forKey:[kelpForestEntry groupName]];
                }
                [groupArray addObject:kelpForestEntry];
                
                [[OrganismDatabase sharedDatabase] addOrganism:kelpForestEntry ];
                 */
			}
		}
        
        //[self determineGroupNames:database];
		
        // Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
}


@end
