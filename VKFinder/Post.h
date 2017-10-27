//
//  Post.h
//  VKFinder
//
//  Created by Nikita Votyakov on 27.10.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, strong) NSNumber *postId;
@property (nonatomic, strong) NSNumber *signerId;
@property (nonatomic, strong) NSString *text;

@end
