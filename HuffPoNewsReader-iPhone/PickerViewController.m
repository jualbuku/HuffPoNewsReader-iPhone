//
//  PickerViewController.m
//  HuffPoNewsReader-iPhone
//
//  Created by student on 8/23/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

@synthesize pickerView, huffPoSections, mlabel, api;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil huffPoAPI:(HuffPoAPI *) huffPoAPI
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.api = huffPoAPI;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //get the sections
    huffPoSections = self.api.sections;
    
    [pickerView selectRow:1 inComponent:0 animated:NO];
    mlabel.text= [[huffPoSections objectAtIndex:[pickerView selectedRowInComponent:0]] label];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// PickerViewDelegate and PickerViewDataSource methods
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    mlabel.text=[[huffPoSections objectAtIndex:row] label];
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

//custom methods
- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)getSection:(id)sender {
    NSLog(@"Go button pressed");
    NSLog([NSString stringWithFormat:@"Section selected: %@", [[huffPoSections objectAtIndex:[pickerView selectedRowInComponent:0]] label]]);
}

- (IBAction)appearSectionSelector:(id)sender {
    
    actionSheet = [[UIActionSheet alloc]                initWithTitle:nil 
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
//    CGRect pickerFrame = CGRectMake(0, 70, 0, 0);
    
    pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [actionSheet addSubview:pickerView];
    //[pickerView release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    //[closeButton addTarget:self action:dismissPicker forControlEvents:UIControlEventValueChanged];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    //[closeButton release];
    
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 480)];
    
    
//    /* first create a UIActionSheet, where you define a title, delegate and a button to close the sheet again */
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select section" delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil]; 
//    //actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    
//    /* Initialize a UIPickerView with 100px space above it, for the button of the UIActionSheet. */
//    UIPickerView* positionPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,100, 320, 216)];
//    pickerView.showsSelectionIndicator = YES;
//    positionPicker.dataSource = self; 
//    positionPicker.delegate = self;  
//    
//    /* Add the UIPickerView to the UIActionSheet */
//    [actionSheet addSubview:positionPicker];  
//    
//    /* Add the UIActionSheet to the view */
//    [actionSheet showInView:self.view];  
//    
//    /* Make sure the UIActionSheet is big enough to fit your UIPickerView and it's buttons */
//    [actionSheet setBounds:CGRectMake(0,0, 320, 411)];  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clicked a button at index %@", buttonIndex);
  
}

-(void)dismissActionSheet:(id)sender {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
