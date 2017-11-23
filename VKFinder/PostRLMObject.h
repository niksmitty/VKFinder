//
//  PostRLMObject.h
//  VKFinder
//
//  Created by Nikita Votyakov on 31.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <Realm/Realm.h>

@interface PostRLMObject : RLMObject

// идентификатор записи
@property NSNumber<RLMInt> *postId;

// идентификатор автора, если запись была опубликована от имени сообщества и подписана пользователем
@property NSNumber<RLMInt> *signerId;

// текст записи
@property NSString *text;

@end
