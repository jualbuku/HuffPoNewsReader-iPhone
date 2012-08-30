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

@interface ViewController : UIViewController {
    @private PickerViewController *pvc;
    @private HuffPoAPI *api;
}

-(IBAction)goToPicker:(id)sender;

@end
