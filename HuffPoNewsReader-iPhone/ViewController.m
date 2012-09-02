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
//add-gesture-to-main
@synthesize labelTitle, labelTagline;
@synthesize imgImg;
@synthesize gestureHandlerView;
@synthesize delegate, topNewsFeed, politicsFeed, searchFeed, currentFeed;
//end of add-gesture-to-main

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self->api = [[HuffPoAPI alloc] init];
    Section *firstSection = (Section *)[api.sections objectAtIndex:0];
    NSLog (@"First section: %@", firstSection.label);
    
    //add-gesture-to-main
    UISwipeGestureRecognizer *swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goToNextArticle)];
    swipeRight.numberOfTouchesRequired=1;
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goToPreviousArticle)];
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
    [self clickOnTopNews];

    //end of add-gesture-to-main

    
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
    
    [self.topNewsFeed moveNext];
    [self displayCurrentArticle: self.currentFeed];
}

- (void)goToPreviousArticle
{
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
    pvc = [[PickerViewController alloc] initWithNibName:@"PickerViewController" bundle:[NSBundle mainBundle] huffPoAPI:self.api];
    [self presentModalViewController:pvc animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"articleTrans"])
    {
        NSLog(@"test");
        ArticleViewController *articleViewController = [segue destinationViewController];
        articleViewController.articleIdentifier = 1784166;
    }
}

@end
