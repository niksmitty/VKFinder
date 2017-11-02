//
//  PostsViewController.h
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VkAPIDataManager.h"
#import "PostRLMObject.h"

@interface PostsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, VkAPIDataManagerDelegate>
{
    IBOutlet UIProgressView *progressView;
    IBOutlet UIView *bottomPanel;
    
    VkAPIDataManager *apiManager;
    
    RLMResults *tableDataArray;
    RLMNotificationToken *realmNotification;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
