//
//  PostsViewController.m
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "PostsViewController.h"

@interface PostsViewController ()

@end

@implementation PostsViewController

@synthesize tableView;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // Load objects from realm db
    tableDataArray = [PostRLMObject allObjects];
    
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
    self.navigationItem.title = @"Posts";
    
    bottomPanel.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(refreshAllItems)];
}

#pragma mark - VkAPIDataManager Delegate

-(void)dataBatchWasReceived:(NSArray *)responsesBatch withCompletionPercentage:(float)percent
{
    [self insertDataBatchIntoDatabase:responsesBatch];
    
    progressView.progress = percent;
    if (percent == 1.)
    {
        bottomPanel.hidden = YES;
    }
}

#pragma mark - Actions with Database

-(void)insertDataBatchIntoDatabase:(NSArray*)dataBatch
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *posts = [NSMutableArray new];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [dataBatch enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VKResponse *response = (VKResponse*)obj;
            [response.json[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *postInfo = (NSDictionary*)obj;
                [self addNewPost:postInfo toPostsArray:posts];
            }];
        }];
        [realm addObjects:posts];
        [realm commitWriteTransaction];
    });
}

-(void)deleteAllObjectsFromDatabase
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:[PostRLMObject allObjectsInRealm:realm]];
    [realm commitWriteTransaction];
}

#pragma mark - Actions

-(void)addNewPost:(NSDictionary*)postInfo toPostsArray:(NSMutableArray*)posts
{
    PostRLMObject *postItem = [PostRLMObject new];
    postItem.postId = postInfo[@"id"]?postInfo[@"id"]:[NSNull null];
    postItem.signerId = postInfo[@"signer_id"]?postInfo[@"signer_id"]:[NSNull null];
    postItem.text = postInfo[@"text"]?postInfo[@"text"]:[NSNull null];
    [posts addObject:postItem];
}

-(void)refreshAllItems
{
    [self deleteAllObjectsFromDatabase];
    
    bottomPanel.hidden = NO;
    progressView.progress = 0.;

    [apiManager getAllItemsIterativelyOfMethod:@"wall.get" withParameters:@{VK_API_OWNER_ID: /*@"-67648156"*/@"-86830443", VK_API_COUNT: @(100)}];
}

#pragma mark - Table View Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Items count: %d", (int)[tableDataArray count]);
    return [tableDataArray count];
}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell"];
    
    PostRLMObject *postItem = tableDataArray[indexPath.row];
    
    cell.textLabel.text = postItem.text;
    cell.detailTextLabel.text = [postItem.postId stringValue];
    
    return cell;
}

@end
