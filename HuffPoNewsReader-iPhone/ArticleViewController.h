//
//  ArticleViewController.h
//  HuffPoNewsReader-iPhone
//
//  Created by student on 8/23/12.
//  Copyright (c) 2012 The Hackerati, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HuffPoAPI/Article.h>

@interface ArticleViewController : UIViewController <ArticleGetDelegate>
{
    IBOutlet UIWebView *articleBodyWebView;
    
    NSInteger articleIdentifier;
    Article *article;
}

@property (atomic, strong) IBOutlet UIWebView *articleBodyWebView;
@property NSInteger articleIdentifier;
@property (atomic, strong) Article *article;

-(IBAction)goBack:(id)sender;

@end
