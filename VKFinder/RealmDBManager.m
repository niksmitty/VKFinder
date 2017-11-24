//
//  RealmDBManager.m
//  VKFinder
//
//  Created by Nikita Votyakov on 23.11.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import "RealmDBManager.h"

@implementation RealmDBManager

-(void)insertDataBatchIntoDatabase:(NSArray*)dataBatch
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSMutableArray *objects = [NSMutableArray new];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [dataBatch enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VKResponse *response = (VKResponse*)obj;
            [response.json[@"items"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *objectInfo = (NSDictionary*)obj;
                if (self.delegate)
                {
                    [self.delegate objectInfoIsReady:objectInfo forAddingToGeneralArray:objects];
                }
            }];
        }];
        [realm addObjects:objects];
        [realm commitWriteTransaction];
    });
}

-(void)deleteFromDatabaseAllObjectsOfClass:(Class)class;
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:[class allObjectsInRealm:realm]];
    [realm commitWriteTransaction];
}

-(NSArray*)getAllNonnullValuesOfField:(NSString*)field ofClass:(Class)class
{
    RLMResults *allResults = [class allObjects];
    NSMutableArray *allValues = [NSMutableArray new];
    for (id item in allResults)
    {
        id fieldValue = [item valueForKeyPath:field];
        if (fieldValue != nil)
        {
            [allValues addObject:fieldValue];
        }
    }
    return allValues;
}

@end
