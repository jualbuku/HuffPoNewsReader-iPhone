//
//  ViewController.h
//  HuffPoNewsReader-iPhone
//
//  Created by Geoffrey M. Scott on 8/22/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HuffPoAPI/HuffPoAPI.h>
#import "PickerViewController.h"

@interface ViewController : UIViewController<UIGestureRecognizerDelegate, FeedRefreshDelegate> {
    
    //add-gesture-to-main
    id <FeedRefreshDelegate> delegate;
    IBOutlet UIView *gestureHandlerView;
    
    Feed *topNewsFeed;
    Feed *politicsFeed;
    Feed *searchFeed;
    Feed *currentFeed;
    //end of add-gesture-to-main

    
    
    
    @private PickerViewController *pvc;
    @private HuffPoAPI *api;
}

@property (atomic, strong) HuffPoAPI *api;

-(IBAction)goToPicker:(id)sender;



//add-gesture

@property (atomic,strong) IBOutlet UIView *gestureHandlerView;
@property (nonatomic, retain) id  <FeedRefreshDelegate> delegate;
@property (atomic,strong) Feed *topNewsFeed;
@property (atomic,strong) Feed *politicsFeed;
@property (atomic,strong) Feed *searchFeed;
@property (atomic,strong) Feed *currentFeed;
@property (weak, nonatomic) IBOutlet UITextView *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *labelTagline;
@property (weak, nonatomic) IBOutlet UIImageView *imgImg;
- (IBAction)changeNews:(id)sender;
-(void)detectRight;
//end of add-gesture-to-main
@end
