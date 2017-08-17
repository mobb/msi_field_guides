//
//  FAQInfo.h
//  KelpApp
//
//  Created by Brian Green on 5/23/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAQInfo : NSObject
{
    //NSString* imageName;
    NSString* thumbnailName;
}

@property (nonatomic,copy) NSString* uniqueId;
@property (nonatomic,copy) NSString* question;
@property (nonatomic,copy) NSString* answerURL;
@property (nonatomic,readonly) NSString *imageName;

-(id)initWithData:(NSString*)q answerURL:(NSString*)url imageName:(NSString*)image thumbnailName:(NSString*)thumbnail;

-(id)initWithQuestion:(NSString *)q uniqueID:(NSString*)ident;

-(UIImage*)image;
-(UIImage*)thumbnail;
-(NSString*)imagePath;

@end
