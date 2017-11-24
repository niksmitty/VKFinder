//
//  CommentsViewController.h
//  VKFinder
//
//  Created by Nikita Votyakov on 08.11.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VkAPIDataManager.h"
#import "RealmDBManager.h"
#import "CommentRLMObject.h"
#import "PostRLMObject.h"
#import "FilterViewController.h"

@interface CommentsViewController : UIViewController<UITableViewDataSource,
                                                     UITableViewDelegate,
                                                     VkAPIDataManagerDelegate,
                                                     RealmDBManagerDelegate,
                                                     UIPopoverPresentationControllerDelegate,
                                                     FilterDelegate>
{
    VkAPIDataManager *apiManager;
    RealmDBManager *dbManager;
    
    RLMResults *tableDataArray;
    RLMNotificationToken *realmNotification;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
