//
//  GroupMemberCell.h
//  KelpApp
//
//  Created by Brian Green on 5/25/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *scientificName;
@property (weak, nonatomic) IBOutlet UILabel *commonName;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
