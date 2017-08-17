//
//  OrganismViewController.m
//  KelpApp
//
//  Created by Brian Green on 5/22/13.
//  Copyright (c) 2013 BDG. All rights reserved.
//

#import "OrganismViewController.h"
#import "FactoidInfo.h"
#import "FactoidDetailCell.h"
#import "FactoidHeaderCell.h"
#import "ScrollableImageViewController.h"
#import "PagedImageViewController.h"
#import "PagedPhotoViewController.h"

@interface OrganismViewController ()


@end

@implementation OrganismViewController

@synthesize organismInfo;
@synthesize commonName;
@synthesize scientificName;
@synthesize mainImage;
@synthesize description;
@synthesize descLabel;

- (id)init
{
    self = [super init];
    if (self ) {
        
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    {
        NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"btn_plus" ofType:@"png"];
        plusButton = [UIImage imageWithContentsOfFile:imagePath];
    }

    {
        NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"btn_minus" ofType:@"png"];
        minusButton = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    //CGRect imageFrame = [[self mainImage] frame];
    
    UIImage* image = [organismInfo image];
    CGSize imageSize = [image size];
    CGRect ivBounds = [mainImage frame];
    CGSize ivSize = ivBounds.size;
    
    CGFloat imageScale = fminf(ivSize.width/imageSize.width, ivSize.height/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    
    CGPoint btnOrigin = ivBounds.origin;
    btnOrigin.x += ( ivSize.width - scaledImageSize.width ) * 0.5;
    btnOrigin.y += ( ivSize.height - scaledImageSize.height ) * 0.5;
    
    CGRect btnBounds = CGRectMake(btnOrigin.x, btnOrigin.y, scaledImageSize.width, scaledImageSize.height);
    
    /*
    CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)),
                                   roundf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)),
                                   roundf(scaledImageSize.width),
                                   roundf(scaledImageSize.height));
    */
    
    [[self mainImage] setImage:[organismInfo image]];
    
    [[self commonName] setText:[organismInfo commonName]];
    [[self scientificName] setText:[organismInfo scientificName]];
    [[self descLabel] setText:[organismInfo description]];
 
    // position the image button directly on top 
//    [[self imageButton] setFrame:[[self mainImage] frame] ];
    [[self imageButton] setFrame:btnBounds ];
    CGRect imageFrameR = [[self mainImage] frame];
    
    // determine how many images the organism has... if more than one, add the 'plus' button
    if ( [[organismInfo imagePaths] count ] > 1 ) {
        
        UIImageView *imageBtnView = [[UIImageView alloc] initWithImage:plusButton ];
        //should set the auto-resize, but for now...
        CGRect imBtnFrame = CGRectMake( imageFrameR.size.width - 16.0, imageFrameR.size.height - 16.0, 16.0, 16.0 );
        [imageBtnView setFrame:imBtnFrame];
    
        [[self mainImage] addSubview:imageBtnView];
    }
    
    
    // preapre the taxonomy string: replace the ,s with new lines, add ':'
    //CGRect afterImageFrame = [[self mainImage] frame];
 
    NSString* taxonomyStr = [[NSString alloc] init];
    NSArray *taxonomyParts = [[organismInfo taxonomy] componentsSeparatedByString: @","];
        
    for ( int i = 0; i < [taxonomyParts count]; i++) {
        NSString* text = [[taxonomyParts objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@": "];
        NSString *entry = [taxonomyStr stringByAppendingString: text];
        taxonomyStr = [entry stringByAppendingString: @"\r"];
    }
   
    // create aan populate the 'factoid' area
    [[self factoidTable] setDataSource:self];
    [[self factoidTable] setDelegate:self];
    
    factoids = [[NSMutableArray alloc] init];
 
    // Factoid - FunFacts
    if ( [[organismInfo funFacts] length] > 0 ) {
        [factoids addObject: [[FactoidInfo alloc] initWithTitle:@"Fun Facts" text:[organismInfo funFacts] expanded:NO]];
    }
    
    // Factoids - Distribution
    if ( [[organismInfo distribution] length] > 0 ) {
        [factoids addObject: [[FactoidInfo alloc] initWithTitle:@"Distribution" text:[organismInfo distribution] expanded:NO]];
    }

    // Factoids - Habitat
    if ( [[organismInfo habitat] length] > 0 ) {
        [factoids addObject: [[FactoidInfo alloc] initWithTitle:@"Habitat" text:[organismInfo habitat] expanded:NO]];
    }
    
    // Factoid - diet
    if ( [[organismInfo diet] length] > 0 ) {
        [factoids addObject: [[FactoidInfo alloc] initWithTitle:@"Diet" text:[organismInfo diet] expanded:NO]];
    }
    
    // Factoid - Taxonomy
    if ( [taxonomyStr length] > 0 ) {
        [factoids addObject: [[FactoidInfo alloc] initWithTitle:@"Taxonomy" text:taxonomyStr expanded:NO]];
    }
    
    [self factoidTable].separatorStyle = UITableViewCellSeparatorStyleNone;
    [self factoidTable].separatorColor = [UIColor clearColor];
    
    
    // we need to calculate the size of the scoll area (and configure it thus)
    
    CGSize contentSize = [[self scrollArea] contentSize];
    contentSize.height *= 1.5;
    
    //[[self scrollArea] setContentSize:contentSize];
    CGFloat kPadding = 20.0;
    
    CGSize totalSize = [[self view] bounds].size;
 
    CGSize viewSize = [[self view] bounds].size;;
    CGRect frameR = CGRectMake(0.0,0.0, viewSize.width, viewSize.height );
    
    [[self scrollArea] setFrame:frameR];
    [[self scrollArea] setBounds:frameR];
    
    int uiNextY = 0;
    
    {
        UILabel* dLabel = [self descLabel];
        CGRect dLabelFrameR = [dLabel frame];
        CGSize dLabelFrameSize = dLabelFrameR.size;
        CGSize availableSize = CGSizeMake( dLabelFrameSize.width, CGFLOAT_MAX );

        uiNextY = dLabelFrameR.origin.y;
        
        CGSize reqSize =  [[organismInfo description] sizeWithFont:[dLabel font] constrainedToSize:availableSize];
        dLabelFrameR.size.height = reqSize.height;
        
        [dLabel setFrame:dLabelFrameR];
        
        uiNextY += dLabelFrameR.size.height + 20.0;
        totalSize.height = uiNextY;
        
        //NSLog(@"label position[%fx%f]",dLabelFrameR.origin.x, dLabelFrameR.origin.y );
    }
    
    /*
    UITextView *descView = [self description];
    UIEdgeInsets insets = [descView contentInset];

    // using the frame of the 'description' text area, determine the required height.
    CGRect descFrameR =[[self description] frame];
    CGSize descFrameSize = descFrameR.size;
    CGSize availableSize = CGSizeMake( descFrameSize.width, 10000.0 );
    CGSize descReqSize =  [[organismInfo description] sizeWithFont:[descView font] constrainedToSize:availableSize];
    
    
    
    //does this take the insets into consideration?
    descReqSize.height += 20.0;
   
    descFrameR.size.height = descReqSize.height + insets.top + insets.bottom;
    [[self description] setFrame:descFrameR];   
    
    totalSize.height = descFrameR.origin.y;
    totalSize.height += descFrameR.size.height + kPadding;
    */
    
    // use this to position the table view:
    CGRect factoidFrameR = [[self factoidTable] frame];
    factoidFrameR.origin.y = uiNextY;
    
    totalSize.height += factoidFrameR.size.height +kPadding;
    [[self scrollArea] setContentSize:totalSize];
    
    
    //[[self description] setFrame:descFrameR];
    [[self factoidTable] setFrame:factoidFrameR];
    
    //NSLog(@"scroll content[%fx%f]",totalSize.width,totalSize.height);
    //NSLog(@"factoid position[%fx%f]",factoidFrameR.origin.x, factoidFrameR.origin.y );
 
    
    
    [self.navigationItem setTitle:[organismInfo commonName]];
}

// =============================================================================================================================

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:[organismInfo commonName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOrganismInfo:(OrganismInfo *)info
{
    organismInfo = info;

}
#pragma mark - segue

- (IBAction)showImages:(id)sender {
    
    [self performSegueWithIdentifier:@"ShowPhotoViewer" sender:self];
    //[self performSegueWithIdentifier:@"ShowImagePages" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ( [[segue identifier] isEqualToString:@"ShowPhotoViewer" ] ) {

        // little trick to set the text of the "Back" button
        [self.navigationItem setTitle:@"Back"];
        
        //
        PagedPhotoViewController* ppvc = [segue destinationViewController];
        [ppvc setPhotoPaths:[organismInfo imagePaths]];
        [ppvc setPhotoTitle:[organismInfo commonName]];
    }
   
    
}
#pragma mark - table view

//- (CGFloat)tableView:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [factoids count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    FactoidInfo *info = [factoids objectAtIndex:section];
    return [info expanded] ? 1 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *CellIdentifier = @"FactoidHeaderCell";
    //FactoidHeaderCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CellIdentifier];
    FactoidHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    FactoidInfo* factoid = [factoids objectAtIndex:section];
    [[cell label] setText:[factoid title]];
    
    [[cell button] setTag:section];
    [[cell bigButton] setTag:section];
    
    if ( [factoid expanded] ) {
        [[cell button] setImage:minusButton forState:UIControlStateNormal];
    }
    else {
        [[cell button] setImage:plusButton forState:UIControlStateNormal ];
    }
    
    // bit of a hack to deal with the "no index path for table cell' nonsense
    UIView *view = [[UIView alloc] initWithFrame:[cell frame]];
    [view addSubview:cell];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FactoidDetailCell";
    FactoidDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    FactoidInfo* factoid = [factoids objectAtIndex:[indexPath section]];
    [[cell details] setText:[factoid text]];
    
    return cell;
}

/* borrowed from Reef */
#define CELL_CONTENT_MARGIN 14
#define FONT_SIZE 14

- (CGFloat)heightForFactoid:(NSInteger)factoidId
{
    FactoidInfo* factoid = [factoids objectAtIndex:factoidId];
    if ( factoid == nil ) {
        return 0.0;
    }
    
    NSString *text = [factoid text];
        
    CGRect boundingR = [self.factoidTable bounds];
    CGSize bounds = boundingR.size;
        
        
    // need to calculate (or know) the width)
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(bounds.width - (CELL_CONTENT_MARGIN * 2), CGFLOAT_MAX);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
    
    
    /*
    CGSize maxLabelSize = CGSizeMake(bounds.width - (CELL_CONTENT_MARGIN * 2), CGFLOAT_MAX);

    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:FONT_SIZE] forKey:NSFontAttributeName];
    CGRect xlabelSize = [text boundingRectWithSize:maxLabelSize
                                           options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin
                                        attributes:stringAttributes
                                        context:nil];
    
    NSLog(@"%.1fx%.1f -- %.2f %.2f",size.width,size.height,xlabelSize.size.width,xlabelSize.size.height);
    
    
    UILabel *xlabel = [[UILabel alloc] init];
    xlabel.font = [UIFont systemFontOfSize:14];
    xlabel.text = text;
    xlabel.numberOfLines = 0;
    
    CGSize xsize = [xlabel sizeThatFits:maxLabelSize];
    */
    
    
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    // return the height, with a bit of extra padding in
    CGFloat height = MAX(size.height, 24.0f);
    return height + 10.0; //(CELL_CONTENT_MARGIN * 2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForFactoid:[indexPath section]];
    
    // Get the text so we can measure it
    FactoidInfo* factoid = [factoids objectAtIndex:[indexPath section]];
    if ( [factoid expanded] == FALSE ) {
        return 0.0;
    }
    
    NSString *text = [factoid text]; 
    
    CGRect boundingR = [tableView bounds];
    CGSize bounds = boundingR.size;
    
    
    // need to calculate (or know) the width)
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(bounds.width - (CELL_CONTENT_MARGIN * 2), CGFLOAT_MAX);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint];
    
    //NSLog(@"[%d|%d] size[%f]",[indexPath section],[indexPath row],size.height);
    
    
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    CGFloat height = MAX(size.height, 34.0f); // + 10 below
    // return the height, with a bit of extra padding in
    return height + 10.0; //(CELL_CONTENT_MARGIN * 2);
}
    
  /*
    
    NSString* text = [NSString stringWithFormat:[_factEntries objectAtIndex:indexPath.section], indexPath.section, indexPath.row];
    
    UIFont *cellFont = [UIFont fontWithName:FONT size:FONT_SIZE];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 10;
}
*/

- (IBAction)toggleFactoid:(id)sender
{
    UIButton *buttonClicked = (UIButton *)sender;
    NSInteger buttonID = [buttonClicked tag];
    
    
 	[self.factoidTable beginUpdates];

    CGRect ftFrame = self.factoidTable.frame;
    CGFloat ftHeight = ftFrame.size.height;
    
    FactoidInfo* factoid = [factoids objectAtIndex:buttonID];
    [factoid setExpanded:![factoid expanded]];
   
    
    [self.factoidTable reloadSections:[NSIndexSet indexSetWithIndex:buttonID] withRowAnimation:NO];

    
    //NSIndexPath* path = [[NSIndexPath alloc] initWithIndex:buttonID];
    NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:buttonID];
    NSArray* paths = [[NSArray alloc] initWithObjects:path, nil ];
    
    CGFloat factoidY = [self heightForFactoid:buttonID];
    
    if ( [factoid expanded] == TRUE ) {
        [[self factoidTable] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        ftFrame.size.height += factoidY;
        
        //[[xheader button] setImage:plusButton forState:UIControlStateNormal];
    }
    else {
        [[self factoidTable] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        ftFrame.size.height -= factoidY;
        
        //[[xheader button] setImage:minusButton forState:UIControlStateNormal];
    }
   
    [self.factoidTable endUpdates];

    
    //scrollView.contentSize = CGSizeMake(320, _scrollSize);
    
    [self.factoidTable setFrame:ftFrame];

    CGFloat deltaSize = ftFrame.size.height - ftHeight;
    
    // we need to adjust the content size of the scroll view now.
    CGSize svContentSize = [[self scrollArea] contentSize];
   // NSLog(@"content size [%.2fx%.2f]  delta[%.2f]",svContentSize.width, svContentSize.height, deltaSize);

    svContentSize.height += deltaSize;
    [[self scrollArea] setContentSize:svContentSize ]; //]animated:NO];
    
    /*
    CGSize contentSize = [[self factoidTable] contentSize];
    //NSLog(@"factoid tabel [%fx%f]",contentSize.width,contentSize.height);

    CGRect factoidFrameR = [[self factoidTable] frame];
    factoidFrameR.size.height = contentSize.height;
    [[self factoidTable] setFrame:factoidFrameR]; //@do this after?
    
    
    CGSize svContentSize = [[self scrollArea] contentSize];
    svContentSize.height = factoidFrameR.origin.y + contentSize.height + 20.0;
    [[self scrollArea] setContentSize:svContentSize];
    */
}
@end
