//
//  VkAPIDataManager.m
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "VkAPIDataManager.h"

@implementation VkAPIDataManager

-(void)getAllItemsIterativelyOfMethod:(NSString*)method withParameters:(NSDictionary*)parameters
{
    int offset = 0;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[parameters copy]];
    [params setObject:@(offset) forKey:VK_API_OFFSET];
    
    VKRequest *firstRequest = [VKRequest requestWithMethod:method parameters:params];
    
    __block int itemsCount = 0, receivedItemsCount = 0;
    
    [firstRequest executeWithResultBlock:^(VKResponse *response) {
        itemsCount = [response.json[@"count"] intValue];
        receivedItemsCount += (int)[(NSArray*)response.json[@"items"] count];
        if (self.delegate)
        {
            [self.delegate dataBatchWasReceived:@[response] withCompletionPercentage:(float)receivedItemsCount/itemsCount];
        }
        [VkAPIDataManager getItemsBatchOfMethod:method withParameters:params andItemsTotalCount:itemsCount completeBlock:^(NSArray * responses, BOOL stop) {
            receivedItemsCount += [VkAPIDataManager getItemsCount:responses];
            if (self.delegate)
            {
                [self.delegate dataBatchWasReceived:responses withCompletionPercentage:(float)receivedItemsCount/itemsCount];
            }
            
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+(void)getItemsBatchOfMethod:(NSString*)method withParameters:(NSMutableDictionary*)params andItemsTotalCount:(int)itemsCount completeBlock:(void (^)(NSArray*, BOOL))completeBlock
{
    int offset = [[params objectForKey:VK_API_OFFSET] intValue];
    int maxCount = [[params objectForKey:VK_API_COUNT] intValue];
    
    int i = 1;
    NSMutableArray *requests = [NSMutableArray new];
    
    while (i < 25 && offset + maxCount <= itemsCount)
    {
        offset += maxCount;
        [params setObject:@(offset) forKey:VK_API_OFFSET];
        VKRequest *currentRequest = [VKRequest requestWithMethod:method parameters:[params copy]];
        [requests addObject:currentRequest];
        i++;
    }
    
    VKBatchRequest *batch = [[VKBatchRequest alloc] initWithRequestsArray:requests];
    [batch executeWithResultBlock:^(NSArray *responses) {
        if (completeBlock)
        {
            BOOL stop = offset + maxCount > itemsCount;
            completeBlock(responses, stop);
            if (!stop)
            {
                [VkAPIDataManager getItemsBatchOfMethod:method withParameters:params andItemsTotalCount:itemsCount completeBlock:completeBlock];
            }
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+(int)getItemsCount:(NSArray*)responses
{
    __block int itemsCount = 0;
    [responses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VKResponse *response = (VKResponse*)obj;
        itemsCount += [(NSArray*)response.json[@"items"] count];
    }];
    return itemsCount;
}

@end
