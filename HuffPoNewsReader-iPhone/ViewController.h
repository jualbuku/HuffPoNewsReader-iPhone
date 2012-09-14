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

@interface ViewController : UIViewController<UIGestureRecognizerDelegate, FeedRefreshDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {
    
    //add-gesture-to-main
    id <FeedRefreshDelegate> delegate;
    IBOutlet UIView *gestureHandlerView;
    
    Feed *topNewsFeed;
    Feed *sectionFeed;
    Feed *searchFeed;
    Feed *currentFeed;
    //end of add-gesture-to-main
    
    //@private PickerViewController *pvc;
    @private HuffPoAPI *api;
    
    @private UIActionSheet *sectionActionSheet;
    @private UIPickerView *sectionPickerView;
    @private NSArray *huffPoSections;
    @private NSInteger sectionIdx;
}

@property (atomic, strong) HuffPoAPI *api;

-(IBAction)goToPicker:(id)sender;
-(IBAction)appearSectionSelector:(id)sender;
-(void)dismissActionSheet:(id)sender;

//add-gesture

@property (atomic,strong) IBOutlet UIView *gestureHandlerView;
@property (nonatomic, retain) id  <FeedRefreshDelegate> delegate;
@property (atomic,strong) Feed *topNewsFeed;
@property (atomic,strong) Feed *sectionFeed;
@property (atomic,strong) Feed *searchFeed;
@property (atomic,strong) Feed *currentFeed;
@property (weak, nonatomic) IBOutlet UITextView *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *labelTagline;
@property (weak, nonatomic) IBOutlet UIImageView *imgImg;

@property (atomic, strong) NSArray *huffPoSections;
@property (atomic, strong) UIPickerView *sectionPickerView;

@end
