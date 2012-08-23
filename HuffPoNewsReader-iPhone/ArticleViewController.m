//
//  ArticleViewController.m
//  HuffPoNewsReader-iPhone
//
//  Created by student on 8/23/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end



@implementation ArticleViewController

@synthesize articleBodyWebView;
@synthesize article;
@synthesize articleIdentifier;

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
	// Do any additional setup after loading the view.
    
    self.article = [[Article alloc] init];
    [self.article setDelegate:self];
    NSLog(@"ArticleViewController: Initialized Article object");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"ArticleViewController: getArticle with identifier %i", articleIdentifier);
    [self.article getArticle:articleIdentifier];
    
    //NSString* htmlContent = @"<html><head><title></title></head><body>Hello world</body></html>";
    //[articleBodyWebView loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) articleDidGet:(Article *)caller
{
    NSLog(@"ArticleViewController: articleDidGet");
    [articleBodyWebView loadHTMLString:caller.body baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}



@end
