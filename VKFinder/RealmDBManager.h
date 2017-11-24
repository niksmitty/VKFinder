//
//  RealmDBManager.h
//  VKFinder
//
//  Created by Nikita Votyakov on 23.11.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import <VKSdk.h>

@protocol RealmDBManagerDelegate <NSObject>

-(void)objectInfoIsReady:(NSDictionary*)objInfo forAddingToGeneralArray:(NSMutableArray*)array;

@end

@interface RealmDBManager : NSObject

@property (nonatomic, weak) id<RealmDBManagerDelegate> delegate;

-(void)insertDataBatchIntoDatabase:(NSArray*)dataBatch;
-(void)deleteFromDatabaseAllObjectsOfClass:(Class)class;
-(NSArray*)getAllNonnullValuesOfField:(NSString*)field ofClass:(Class)class;

@end
