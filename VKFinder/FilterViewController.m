//
//  FilterViewController.m
//  VKFinder
//
//  Created by Nikita Votyakov on 03.11.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"AddFilter";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(done)];
}

-(void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.delegate)
    {
        [self.delegate filterValuesShouldApplyWithCityValue:cityTextField.text];
    }
}

@end
