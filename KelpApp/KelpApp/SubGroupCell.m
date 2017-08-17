//
//  SubGroupCell.m
//  KelpApp
//
//  Created by Brian Green on 8/23/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "SubGroupCell.h"

@implementation SubGroupCell

//@synthesize subGroupImage;
@synthesize subGroupLabel;

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
