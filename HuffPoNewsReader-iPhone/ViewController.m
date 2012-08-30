//
//  ViewController.m
//  HuffPoNewsReader-iPhone
//
//  Created by Geoffrey M. Scott on 8/22/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    api = [[HuffPoAPI alloc] init];
    Section *firstSection = (Section *)[api.sections objectAtIndex:0];
    NSLog (@"First section: %@", firstSection.label);
}

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
    pvc = [[PickerViewController alloc] initWithNibName:@"PickerViewController" bundle:[NSBundle mainBundle] huffPoAPI:api];
    [self presentModalViewController:pvc animated:YES];
}

@end
