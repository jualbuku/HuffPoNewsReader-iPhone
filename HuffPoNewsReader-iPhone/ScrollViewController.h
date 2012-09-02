//
//  ScrollViewController.h
//  HuffPoNewsReader-iPhone
//
//  Created by Victor Chen on 8/27/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HuffPoAPI/HuffPoAPI.h>
@interface ScrollViewController : UIViewController <FeedRefreshDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    id <FeedRefreshDelegate> delegate;

    HuffPoAPI *api;
    Feed *topNewsFeed;
    Feed *politicsFeed;
    Feed *searchFeed;
    Feed *currentFeed;
    
    NSInteger leftLimit;
    NSInteger rightLimit;
    NSData *imgDataa;
    NSString *titleLabell;
}
@property (nonatomic, retain) id  <FeedRefreshDelegate> delegate;
@property (atomic,strong) HuffPoAPI *api;
@property (atomic,strong) Feed *topNewsFeed;
@property (atomic,strong) Feed *politicsFeed;
@property (atomic,strong) Feed *searchFeed;
@property (atomic,strong) Feed *currentFeed;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

//for scrolling

@property (atomic, strong) IBOutlet UIScrollView *scrollView;
@property (atomic, strong) NSMutableArray *pageImages;
@property (atomic, strong) NSMutableArray *pageViews;
@property (atomic, strong) NSMutableArray *titleArray;
@property (atomic,strong) NSMutableArray *labelArray;
@property (atomic, strong) NSMutableArray *viewArray;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end
