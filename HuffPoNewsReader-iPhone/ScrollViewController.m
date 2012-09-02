//
//  ScrollViewController.m
//  HuffPoNewsReader-iPhone
//
//  Created by Victor Chen on 8/27/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import "ScrollViewController.h"
#import "ArticleViewController.h"
@interface ScrollViewController ()

@end

@implementation ScrollViewController

@synthesize delegate, api, topNewsFeed, politicsFeed, searchFeed, currentFeed;
@synthesize scrollView,pageImages,pageViews,titleArray,labelArray,viewArray;
@synthesize labelTitle;

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
    titleArray = [[NSMutableArray alloc] init];
    labelArray =[[NSMutableArray alloc] init];
    viewArray =[[NSMutableArray alloc] init];
    [self makeLabel];
    api = [[HuffPoAPI alloc] init];
    Section *firstSection = (Section *)[api.sections objectAtIndex:0];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDetailView:)];
    tap.numberOfTouchesRequired=1;
    [scrollView addGestureRecognizer:tap];

    NSLog (@"First section: %@", firstSection.label);
    @try {
        self.topNewsFeed = [self.api feedFactory:@"HuffPoAPITopNewsFeed"];
        [self.topNewsFeed setDelegate:self];
    }
    @catch (NSException *ne) {
        NSLog(@"Failed to instantiate top news feed");
    }
    [self clickOnTopNews];
    [self.topNewsFeed refresh ];
       
    //NSLog(@"view did load title %@",[self.currentFeed getCurrent].title);
    
    // [self displayCurrentArticle: self.topNewsFeed];
    
	// Do any additional setup after loading the view.
    //scrolling
    rightLimit=0;
    leftLimit = 0;
    self.pageImages = [NSMutableArray arrayWithObjects:
                       [UIImage imageNamed:@"photo5.png"],
                       [UIImage imageNamed:@"photo1.png"],
                       [UIImage imageNamed:@"photo2.png"],
                       
                                              nil];
    

        scrollView.pagingEnabled=YES;
    NSInteger pageCount = self.pageImages.count;
    
    // Set up the page control
    //self.pageControl.currentPage = 0;
    //self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
        [self.viewArray addObject:[[UIView alloc]init]];
    }

}
- (IBAction)showDetailView:(id)sender {
    [self performSegueWithIdentifier:@"articleTrans" sender:sender];
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
-(void)makeLabel
{
        for (int i=0; i<3; i++) {
            CGRect labelFrame = CGRectMake(20, 10, 100, 50);
            labelFrame.origin.x = 100.0f;
            labelFrame.origin.y = 400.0f;
            UILabel *newlabel = [[UILabel alloc] init];
            newlabel.frame=labelFrame;
            [labelArray addObject:newlabel];
         }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    CGFloat offsetScrollViewHeight=100;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    NSLog(@"hieghgtt %f",pagesScrollViewSize.height- offsetScrollViewHeight);
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
    CGPoint startPoint =  CGPointMake( self.scrollView.bounds.size.width,0);
    [self.scrollView setContentOffset:startPoint];
}
- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    // self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
//    NSLog(@"first page in loadvisiblepages, %d",firstPage);
//    NSLog(@"last page in loadvisiblepages, %d",lastPage);
//    NSLog(@"current page,%d",page);
    
        
   
    NSLog(@"current page,%d",page);
    // Purge anything before the first page
    //for (NSInteger i=0; i<firstPage; i++) {
      //  [self purgePage:i];
    //}
    for (NSInteger i=0; i<=2; i++) {//for (NSInteger i=firstPage; i<=lastPage; i++) {
    [self loadPage:i];//    [self loadPage:i];
    //}
    //for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
      //  [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    CGRect viewframe = scrollView.bounds;//self.scrollView.bounds;
    viewframe.origin.x = viewframe.size.width *page;
    viewframe.origin.y = -100.0f;
    
    CGRect imgframe = scrollView.bounds;//self.scrollView.bounds;
    imgframe.origin.x = 0;
    imgframe.origin.y = 0;
    UIImageView *newPageView= [UIImageView alloc];
    newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
    newPageView.contentMode = UIViewContentModeScaleAspectFit;
    newPageView.frame=imgframe;
    
    [[viewArray objectAtIndex:page] addSubview:newPageView];
    [[viewArray objectAtIndex:page] addSubview: [labelArray objectAtIndex:page]];
    [[viewArray objectAtIndex:page] setFrame:viewframe];
    [scrollView addSubview:[viewArray objectAtIndex:page]];
         /*
    
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    CGRect frame = scrollView.bounds;//self.scrollView.bounds;
    frame.origin.x = frame.size.width *page;
    frame.origin.y = -100.0f;
    
    
    
    //
    UIView *newView = [UIView alloc];
    //newView.frame = frame
    
    UIImageView *newPageView= [UIImageView alloc];
    newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
    
    
    
    //UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
    newPageView.contentMode = UIViewContentModeScaleAspectFit;
    newPageView.frame = frame;
    [self.scrollView addSubview:newPageView];
    [scrollView addSubview: [labelArray objectAtIndex:page]]; //newlabel];
    [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    //}*/

}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViewLocal{
    // Load the pages which are now on screen
    

    /////////
    CGPoint currentOffset = [self.scrollView contentOffset];
    CGFloat contentWidth = self.scrollView.contentSize.width;
    CGFloat centerOffsetX = (contentWidth - self.scrollView.bounds.size.width) / 2.0;
    CGFloat distanceFromCenter = (currentOffset.x - centerOffsetX);
    

    
    if (distanceFromCenter > (318.0)) {//contentWidth* 6.5/ 24.0)
        NSArray *tempViews = [NSArray arrayWithArray:viewArray];
        for(int i=0.0;i<=1;i++)
        {
            
            CGRect myFrame = self.scrollView.bounds;
            myFrame.origin.x = myFrame.size.width*(float)i;
            myFrame.origin.y= -100.0f;
            UIView *temp = [tempViews objectAtIndex:i+1];
           
            temp.frame = myFrame;
            NSLog(@"origin x %f",temp.frame.origin.x);
            [self.pageViews replaceObjectAtIndex:i withObject:temp];
           
//            
//            [self.pageViews replaceObjectAtIndex:i withObject:[self.pageViews objectAtIndex:i+1]];
        }
        UIView *temp2 = [tempViews objectAtIndex:0];

        CGRect myFrame = self.scrollView.bounds ;
        myFrame.origin.x = myFrame.size.width*2.0;
        myFrame.origin.y= -100.0f;
        temp2.frame = myFrame;
        [self.pageViews replaceObjectAtIndex:2 withObject:temp2];
        
        ///
        CGPoint cur= CGPointMake(scrollViewLocal.bounds.size.width, currentOffset.y);
       // NSLog(@"cur x %f",cur.x);
        [scrollView setContentOffset:cur animated:NO];
        }
    
    /*
     if (distanceFromCenter > (318.0)) {//contentWidth* 6.5/ 24.0)
     NSLog(@"%f",contentWidth);
     NSLog(@"%f",centerOffsetX);
     NSLog(@"%f",self.scrollView.bounds.size.width);
     //if(rightLimit>2){rightLimit=0;}
     NSLog(@"current%f",currentOffset.x);
     NSLog(@"current%f",currentOffset.y);
     NSArray *tempViews = [NSArray arrayWithArray:pageViews];
     for(int i=0.0;i<=1;i++)
     {
     
     CGRect myFrame = self.scrollView.bounds;
     myFrame.origin.x = myFrame.size.width*(float)i;
     myFrame.origin.y= -100.0f;
     UIImageView *temp = [tempViews objectAtIndex:i+1];
     
     temp.frame = myFrame;
     NSLog(@"origin x %f",temp.frame.origin.x);
     [self.pageViews replaceObjectAtIndex:i withObject:temp];
     
     //
     //            [self.pageViews replaceObjectAtIndex:i withObject:[self.pageViews objectAtIndex:i+1]];
     }
     UIImageView *temp2 = [tempViews objectAtIndex:0];
     
     CGRect myFrame = self.scrollView.bounds ;
     myFrame.origin.x = myFrame.size.width*2.0;
     myFrame.origin.y= -100.0f;
     temp2.frame = myFrame;
     [self.pageViews replaceObjectAtIndex:2 withObject:temp2];
     
     ///
     CGPoint cur= CGPointMake(scrollViewLocal.bounds.size.width, currentOffset.y);
     // NSLog(@"cur x %f",cur.x);
     [scrollView setContentOffset:cur animated:NO];
     }

    */
    if (distanceFromCenter < (-318.0)) {//contentWidth* 6.5/ 24.0)

        NSArray *tempViews = [NSArray arrayWithArray:pageViews];
        for(int i=2;i>=1;i--)
        {
            
            CGRect myFrame = self.scrollView.bounds;
            myFrame.origin.x = myFrame.size.width*(float)i;
            myFrame.origin.y= -100.0f;
            UIImageView *temp = [tempViews objectAtIndex:i-1];
            temp.frame = myFrame;
            NSLog(@"origin x %f",temp.frame.origin.x);
            [self.pageViews replaceObjectAtIndex:i withObject:temp];
            
            //
            //            [self.pageViews replaceObjectAtIndex:i withObject:[self.pageViews objectAtIndex:i+1]];
        }
        UIImageView *temp2 = [tempViews objectAtIndex:2];
        
        CGRect myFrame = self.scrollView.bounds ;
        myFrame.origin.x = 0;
        myFrame.origin.y= -100.0f;
        temp2.frame = myFrame;
        [self.pageViews replaceObjectAtIndex:0 withObject:temp2];
        
        ///
        CGPoint cur= CGPointMake(scrollViewLocal.bounds.size.width, currentOffset.y);
        // NSLog(@"cur x %f",cur.x);
        [scrollView setContentOffset:cur animated:NO];
    }

//    if (distanceFromCenter < -1*(contentWidth / 4.0)) {
//        if(leftLimit<0){leftLimit=2;}
//        
//        
//        CGPoint cur= CGPointMake(centerOffsetX, currentOffset.y);
//        [self.scrollView setContentOffset:cur];
//        
//        CGRect frame = self.scrollView.bounds;//self.scrollView.bounds;
//        frame.origin.x = frame.size.width * 1; //1
//        frame.origin.y = -100.0f;
//        
//        
//        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:leftLimit]];//2
//        leftLimit--;
//        newPageView.contentMode = UIViewContentModeScaleAspectFit;
//        newPageView.frame = frame;
//        [self.scrollView addSubview:newPageView];
//        
//        [self.pageViews replaceObjectAtIndex:1 withObject:newPageView];//1
//        // move content by the same amount so it appears to stay still
//        //for (UILabel *label in visibleLabels) {
//        //  CGPoint center = [labelContainerView convertPoint:label.center toView:self];
//        //center.x += (centerOffsetX - currentOffset.x);
//        //label.center = [self convertPoint:center toView:labelContainerView];
//        
//    }

    
    
    /////////
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //enshore that the end of scroll is fired because apple are twats...
    //if(leftRight==4)
    //[self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0];

    //NSLog(@"scrolling");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setLabelTitle:nil];
    [self setPageImages:nil];
    [self setPageViews:nil];
    [self setScrollView:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollVieww
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSLog(@"endd");
//    if(leftRight==0){
//        scrollView.contentOffset = CGPointMake(320*(pageImages.count-2), 0);
//        
//    }else if(leftRight==pageImages.count-1){
//        scrollVieww.contentOffset = CGPointMake(320, 0);
//            }

   
}

//end of scrolling
// HuffPo API
- (void)clickOnShowSections
{
    // Get the list of sections from the HuffPo API and cache for fast access
    NSArray *sectionArray = self.api.sections;
    Section *section = (Section *)[sectionArray objectAtIndex:0];
}

- (void)clickOnTopNews
{
    self.currentFeed = self.topNewsFeed;
    [self.currentFeed refresh];
    // Calls feedDidRefresh delegate method, below, to display the current item
}

- (void)clickOnPolitics
{
    self.currentFeed = self.politicsFeed;
    [self.currentFeed refresh];
    // Calls feedDidRefresh delegate method, below, to display the current item
}

- (void)clickOnSearch
{
    self.currentFeed = self.searchFeed;
    // *** NOT IMPLEMENTED *** [self.searchFeed searchWithQuery:@"look for me"];
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
    [self displayCurrentArticle: self.topNewsFeed];
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
    [self goToLastArticle];
    NSString *last = [NSString stringWithFormat:@"%@", [callingFeed getCurrent].title];
    [self goToNextArticle];
    NSString *first = [NSString stringWithFormat:@"%@", [callingFeed getCurrent].title];
    [self goToNextArticle];
    NSString *second = [NSString stringWithFormat:@"%@", [callingFeed getCurrent].title];
    NSLog(@"title Array got feed here");
   
    titleArray = [NSMutableArray arrayWithObjects:
                 last,first,second,
                
                  nil];
    for (int i=0; i<3; i++) {
        [[labelArray objectAtIndex:i] setText:[titleArray objectAtIndex:i]];
        //[[labelArray objectAtIndex:i] setText:[NSString stringWithFormat:@"%d",i]];
    }
       

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
    
    titleLabell = currentItem.title;
    NSLog(@"displaycurrent  titlelabell %@",titleLabell);
    NSLog(@"victor title, %@",[topNewsFeed getCurrent].title);
    NSURL* imgURL = [NSURL URLWithString:currentItem.imageURL];
    NSLog(@"victor imgurl, %@",[topNewsFeed getCurrent].imageURL);
    imgDataa = [[NSData alloc] initWithContentsOfURL:imgURL];
    labelTitle.text=titleLabell;
   
   
}

@end
