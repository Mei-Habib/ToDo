//
//  Task.h
//  final
//
//  Created by Macos on 23/04/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<NSCoding,NSSecureCoding>
@property NSString *name, *dis ;
@property NSDate *endDate ;
@property int priority ,status ;
-(void) encodeWithCoder:(NSCoder *)coder;
-(id)initWithCoder:(NSCoder *)coder;

@end

NS_ASSUME_NONNULL_END
