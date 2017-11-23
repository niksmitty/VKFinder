//
//  CommentsViewController.m
//  VKFinder
//
//  Created by Nikita Votyakov on 08.11.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController ()

@end

@implementation CommentsViewController

@synthesize tableView;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // Load objects from realm db
    tableDataArray = [CommentRLMObject allObjects];
    
    // Initialize VkAPIDataManager
    apiManager = [VkAPIDataManager new];
    apiManager.delegate = self;
    
    // Set realm notification block
    __weak typeof(self) weakSelf = self;
    realmNotification = [tableDataArray addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        
        UITableView *tv = weakSelf.tableView;
        
        if (!change)
        {
            [tv reloadData];
            return;
        }
        
        [tv beginUpdates];
        [tv deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv endUpdates];
    }];
}

#pragma mark - UI

-(void)setupUI
{
    self.navigationItem.title = @"Comments";
    
    UIImage *refreshImage = [UIImage imageNamed:@"refreshAllItems"];
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [refreshButton setBackgroundImage:refreshImage forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshAllItems) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItems = @[refreshBtn];
}

#pragma mark - VkAPIDataManager Delegate

-(void)dataBatchWasReceived:(NSArray *)responsesBatch withCompletionPercentage:(float)percent
{
    /*[self insertDataBatchIntoDatabase:responsesBatch];
    
    progressView.progress = percent;
    if (percent == 1.)
    {
        bottomPanel.hidden = YES;
    }*/
}

#pragma mark - Actions

-(void)refreshAllItems
{
    /*[self deleteAllObjectsFromDatabase];
    
    bottomPanel.hidden = NO;
    progressView.progress = 0.;*/
    
    [apiManager getAllItemsIterativelyOfMethod:@"wall.getComments" withParameters:@{VK_API_OWNER_ID: /*@"-67648156"*/@"-86830443", VK_API_COUNT: @(100)}];
}

#pragma mark - Table View Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Items count: %d", (int)[tableDataArray count]);
    return [tableDataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    CommentRLMObject *commentItem = tableDataArray[indexPath.row];
    
    cell.textLabel.text = commentItem.text;
    cell.detailTextLabel.text = [commentItem.commentId stringValue];
    
    return cell;
}

@end
