//
//  PostRLMObject.h
//  VKFinder
//
//  Created by Nikita Votyakov on 31.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <Realm/Realm.h>

@interface PostRLMObject : RLMObject

@property NSNumber<RLMInt> *postId;
@property NSNumber<RLMInt> *signerId;
@property NSString *text;

@end
