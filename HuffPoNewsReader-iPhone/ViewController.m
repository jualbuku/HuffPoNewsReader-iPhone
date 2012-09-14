//
//  ViewController.m
//  HuffPoNewsReader-iPhone
//
//  Created by Geoffrey M. Scott on 8/22/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import "ViewController.h"
#import "ArticleViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize api;
@synthesize labelTitle, labelTagline;
@synthesize imgImg;
@synthesize gestureHandlerView;
@synthesize delegate, topNewsFeed, sectionFeed, searchFeed, currentFeed;
@synthesize sectionPickerView, huffPoSections;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self->api = [[HuffPoAPI alloc] init];
    Section *firstSection = (Section *)[api.sections objectAtIndex:0];
    NSLog (@"First section: %@", firstSection.label);
    
    //add-gesture-to-main
    
    // Swipe right loads previous article (finger direction right)
    UISwipeGestureRecognizer *swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goToPreviousArticle)];
    swipeRight.numberOfTouchesRequired=1;
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    
    // Swipe left loads next article (finger direction left)
    UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goToNextArticle)];
    swipeLeft.numberOfTouchesRequired=1;
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDetailView:)];
    tap.numberOfTouchesRequired=1;
    
    [gestureHandlerView addGestureRecognizer:swipeRight];
    [gestureHandlerView addGestureRecognizer:swipeLeft];
    [gestureHandlerView addGestureRecognizer:tap];
    
    @try {
        self.topNewsFeed = [self.api feedFactory:@"HuffPoAPITopNewsFeed"];
        [self.topNewsFeed setDelegate:self];
    }
    @catch (NSException *ne) {
        NSLog(@"Failed to instantiate top news feed");
    }
    
    @try {
        self.sectionFeed = [self.api feedFactory:@"HuffPoAPISectionFeed"];
        [self.sectionFeed setDelegate:self];
    }
    @catch (NSException *ne) {
        NSLog(@"Failed to instantiate section feed");
    }
    
    
    [self clickOnTopNews];

    //end of add-gesture-to-main

    // set up section picker
    huffPoSections = self.api.sections;
    
    [sectionPickerView selectRow:1 inComponent:0 animated:NO];
    NSLog(@"%@",[[huffPoSections objectAtIndex:[sectionPickerView selectedRowInComponent:0]] label]);
}
- (IBAction)showDetailView:(id)sender {
    [self performSegueWithIdentifier:@"articleTrans" sender:sender];
}

//add-gesture-to-main
- (void)clickOnTopNews
{
    self.currentFeed = self.topNewsFeed;
    [self.currentFeed refresh];
    // Calls feedDidRefresh delegate method, below, to display the current item
}



- (void)goToFirstArticle
{
    [self.currentFeed moveFirst];
    [self displayCurrentArticle: self.currentFeed];
    
}

- (void)goToLastArticle
{
    
    [self.currentFeed moveLast];
    [self displayCurrentArticle: self.currentFeed];
}


- (void)goToNextArticle
{
    //[self.currentFeed moveNext];
    //[self displayCurrentArticle: self.currentFeed];
    NSLog(@"load next");
    [self.topNewsFeed moveNext];
    [self displayCurrentArticle: self.currentFeed];
}

- (void)goToPreviousArticle
{
    NSLog(@"load previous");
    [self.currentFeed movePrevious];
    [self displayCurrentArticle: self.currentFeed];
}
// FeedRefreshDelegate methods
- (void)feedDidRefresh: (Feed *)callingFeed
{
    [self displayCurrentArticle: callingFeed];
}

- (void)displayCurrentArticle: (Feed *)callingFeed
{
    FeedItem *currentItem = [callingFeed getCurrent];
    
    NSLog(@"Identifier: %@", currentItem.identifier);
    NSLog(@"Title: %@", currentItem.title);
    NSLog(@"Image URL: %@", currentItem.imageURL);
    NSLog(@"Author NName: %@", currentItem.authorName);
    NSLog(@"Date Published: %@", currentItem.datePublished);
    NSLog(@"Tag Line: %@", currentItem.tagLine);
    NSLog(@"URL: %@", currentItem.url);
    
    labelTitle.text = currentItem.title;
    labelTagline.text = currentItem.tagLine;
    NSLog(@"victor title, %@",[topNewsFeed getCurrent].title);
    NSURL* imgURL = [NSURL URLWithString:currentItem.imageURL];
    NSLog(@"victor imgurl, %@",[topNewsFeed getCurrent].imageURL);
    NSData* imgData = [[NSData alloc] initWithContentsOfURL:imgURL];
    imgImg.image= [UIImage imageWithData:imgData];
}
//end of add-to-gesture


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)goToPicker:(id)sender {
    //pvc = [[PickerViewController alloc] initWithNibName:@"PickerViewController" bundle:[NSBundle mainBundle] huffPoAPI:self.api];
    //[self presentModalViewController:pvc animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"articleTrans"])
    {
        NSLog(@"test");
        ArticleViewController *articleViewController = [segue destinationViewController];
        //articleViewController.articleIdentifier = 1784166;
        articleViewController.articleIdentifier = [[self.currentFeed getCurrent].identifier integerValue];
        NSLog(@"%d",[[self.currentFeed getCurrent].identifier integerValue]);
    }
}


#pragma mark Section Picker View
- (IBAction)appearSectionSelector:(id)sender {
    
    sectionActionSheet = [[UIActionSheet alloc]                initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [sectionActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
    //    CGRect pickerFrame = CGRectMake(0, 70, 0, 0);
    
    sectionPickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    sectionPickerView.showsSelectionIndicator = YES;
    sectionPickerView.dataSource = self;
    sectionPickerView.delegate = self;
    
    [sectionActionSheet addSubview:sectionPickerView];
    //[pickerView release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    //[closeButton addTarget:self action:dismissPicker forControlEvents:UIControlEventValueChanged];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [sectionActionSheet addSubview:closeButton];
    //[closeButton release];
    
    [sectionActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [sectionActionSheet setBounds:CGRectMake(0, 0, 320, 480)];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clicked a button at index %d", buttonIndex);
    
}

-(void)dismissActionSheet:(id)sender {
    [sectionActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"set section here to %@",[[huffPoSections objectAtIndex:sectionIdx] label]);
    
    [(HuffPoAPISectionFeed *)sectionFeed setSection:[[huffPoSections objectAtIndex:sectionIdx] apiParam]]; // This is bad!
    self.currentFeed = self.sectionFeed;
    [self.currentFeed refresh];
}

// PickerViewDelegate and PickerViewDataSource methods
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //currentSectionName = [[huffPoSections objectAtIndex:row] label];
    sectionIdx = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [huffPoSections count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [[huffPoSections objectAtIndex:row] label];
}


@end
