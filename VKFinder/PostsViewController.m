//
//  PostsViewController.m
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "PostsViewController.h"
#import "Post.h"

@interface PostsViewController ()

@end

@implementation PostsViewController

@synthesize posts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Posts";
    
    posts = [NSMutableArray new];
    
    apiManager = [VkAPIDataManager new];
    apiManager.delegate = self;
    
    [apiManager getAllItemsIterativelyOfMethod:@"wall.get" withParameters:@{VK_API_OWNER_ID: @"-67648156", VK_API_COUNT: @(100)}];
}

#pragma mark - VkAPIDataManager Delegate

-(void)dataBatchWasReceived:(NSArray *)responsesBatch withCompletionPercentage:(float)percent
{
    [responsesBatch enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VKResponse *response = (VKResponse*)obj;
        [response.json[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *postInfo = (NSDictionary*)obj;
            [self addNewPost:postInfo];
        }];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });
}

-(void)addNewPost:(NSDictionary*)postInfo
{
    Post *postItem = [Post new];
    postItem.postId = postInfo[@"id"]?postInfo[@"id"]:NULL;
    postItem.signerId = postInfo[@"signer_id"]?postInfo[@"signer_id"]:NULL;
    postItem.text = postInfo[@"text"]?postInfo[@"text"]:NULL;
    [posts addObject:postItem];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [posts count];
}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell"];
    
    Post *post = posts[indexPath.row];
    
    cell.textLabel.text = post.text;
    
    return cell;
}

@end
