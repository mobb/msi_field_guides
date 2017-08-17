//
//  OrganismViewController.h
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganismInfo.h"


@interface OrganismViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *factoids;
    UIImage* plusButton;
    UIImage* minusButton;
    
}

@property (nonatomic,strong) OrganismInfo* organismInfo;

@property (weak, nonatomic) IBOutlet UILabel *commonName;
@property (weak, nonatomic) IBOutlet UILabel *scientificName;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UITableView *factoidTable;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollArea;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

- (id)init;
- (IBAction)toggleFactoid:(id)sender;
- (IBAction)showImages:(id)sender;
- (CGFloat)heightForFactoid:(NSInteger)factoidId;


@end
