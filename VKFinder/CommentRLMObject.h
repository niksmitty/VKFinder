//
//  CommentRLMObject.h
//  VKFinder
//
//  Created by Nikita Votyakov on 08.11.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <Realm/Realm.h>

@interface CommentRLMObject : RLMObject

// идентификатор комментария
@property NSNumber<RLMInt> *commentId;

// идентификатор автора комментария
@property NSNumber<RLMInt> *signerId;

// текст комментария
@property NSString *text;

@end
