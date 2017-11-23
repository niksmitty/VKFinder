//
//  ViewController.m
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "ViewController.h"

static NSArray *SCOPE = nil;
static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"START_WORK";

@interface ViewController () <VKSdkUIDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL];
    
    [super viewDidLoad];
    
    [[VKSdk initializeWithAppId:@"6216100"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized)
        {
            [self startWorking];
        }
        else if (error)
        {
            NSLog(@"%@", [error description]);
        }
    }];
}

-(void)startWorking
{
    [self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
}

-(IBAction)authorize:(id)sender
{
    [VKSdk authorize:SCOPE];
}

-(void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
    if (result.token)
    {
        [self startWorking];
    }
    else if (result.error)
    {
        NSLog(@"Access denied \n%@", result.error);
    }
}

-(void)vkSdkUserAuthorizationFailed
{
    NSLog(@"Access denied");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
{
    [self authorize:nil];
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

-(void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

@end
