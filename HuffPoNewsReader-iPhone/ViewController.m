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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self->api = [[HuffPoAPI alloc] init];
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
