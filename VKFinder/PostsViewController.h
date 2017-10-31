//
//  PostsViewController.h
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VkAPIDataManager.h"

@interface PostsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, VkAPIDataManagerDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIProgressView *progressView;
    IBOutlet UIView *bottomPanel;
    
    VkAPIDataManager *apiManager;
}

@property (nonatomic, strong) NSMutableArray *posts;

@end
