//
//  PickerViewController.h
//  HuffPoNewsReader-iPhone
//
//  Created by student on 8/23/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HuffPoAPI/HuffPoAPI.h>

@interface PickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>{
    @private IBOutlet UIPickerView *pickerView;
    @private IBOutlet UILabel *mlabel;
    @private NSArray *huffPoSections;
    @private HuffPoAPI *api;
    @private UIActionSheet *actionSheet;    
}

@property (atomic, strong) UILabel *mlabel;
@property (atomic, strong) IBOutlet UIPickerView *pickerView;
//@property (atomic, strong) IBOutlet UIButton *doneButton;
@property (atomic, strong) NSArray *huffPoSections;
@property (atomic, strong) HuffPoAPI *api;

-(IBAction)getSection:(id)sender;
-(IBAction)goBack:(id)sender;
-(IBAction)appearSectionSelector:(id)sender;
-(void)dismissActionSheet:(id)sender;

//custom constructor to pass API
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil huffPoAPI:(HuffPoAPI *) huffPoAPI;

@end
