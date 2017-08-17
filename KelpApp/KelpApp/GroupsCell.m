//
//  GroupsCell.m
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "GroupsCell.h"

@implementation GroupsCell

@synthesize groupImage;
@synthesize groupName;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
