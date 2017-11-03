//
//  FilterViewController.h
//  VKFinder
//
//  Created by Nikita Votyakov on 03.11.17.
//  Copyright © 2017 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterDelegate <NSObject>

-(void)filterValuesShouldApplyWithCityValue:(NSString*)city;

@end

@interface FilterViewController : UIViewController
{
    IBOutlet UITextField *cityTextField;
}

@property (nonatomic, weak) id<FilterDelegate> delegate;

@end
