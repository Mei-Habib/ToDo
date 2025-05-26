//
//  DetailsViewController.h
//  final
//
//  Created by Macos on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property Task *task;
@property BOOL fromDone;
@end

NS_ASSUME_NONNULL_END
