//
//  MainMenuViewController.m
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "MainMenuViewController.h"
#import <VKSdk.h>

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];
}

-(void)logout:(id)sender
{
    [VKSdk forceLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)getPosts:(id)sender
{
    [self performSegueWithIdentifier:@"GET_POSTS" sender:self];
}

-(IBAction)getComments:(id)sender
{
    [self performSegueWithIdentifier:@"GET_COMMENTS" sender:self];
}

@end
