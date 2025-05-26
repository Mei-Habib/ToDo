
//
//  Task.m
//  final
//
//  Created by Macos on 23/04/2025.
//

#import "Task.h"

@implementation Task
+ (BOOL)supportsSecureCoding {
    return YES;
}


- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
        [coder encodeObject:_dis forKey:@"dis"];
        [coder encodeInt:_priority forKey:@"priority"];
        [coder encodeInt:_status forKey:@"status"];
        [coder encodeObject:_endDate forKey:@"endDate"];


}

- (id)initWithCoder:(nonnull NSCoder *)decoder {
    if((self = [super init])){
        _name=[decoder decodeObjectOfClass:[NSString class] forKey:@"name" ];
        _dis=[decoder decodeObjectOfClass:[NSString class] forKey:@"dis" ];
        _priority=[decoder decodeIntForKey:@"priority" ];
        _status=[decoder decodeIntForKey:@"status" ];
        _endDate=[decoder decodeObjectOfClass:[NSDate class] forKey:@"endDate" ];
    }
    return  self;
}

- (BOOL)isEqual:(id)object{
    Task *task=(Task*)object;
    return [self.name isEqualToString:task.name ] ;
}
@end
