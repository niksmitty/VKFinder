//
//  VkAPIDataManager.h
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk.h>

@protocol VkAPIDataManagerDelegate <NSObject>

-(void)dataBatchWasReceived:(NSArray*)responsesBatch withCompletionPercentage:(float)percent;

@end

@interface VkAPIDataManager : NSObject

@property (nonatomic, weak) id<VkAPIDataManagerDelegate> delegate;

-(void)getAllItemsIterativelyOfMethod:(NSString*)method withParameters:(NSDictionary*)parameters;

@end
