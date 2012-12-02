//
//  Police.m
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "Enemy.h"

@implementation Police

+ (Police*)police
{
    Police *police = nil;
    if ((police = [[Police alloc] initWithFile:@"police1.png"]))
    {
        
    }
    return police;
}

@end


@implementation Car
@synthesize hp = _hp;
+ (Car*)car
{
    Car *car = nil;
    if ((car = [[Car alloc] initWithFile:@"policecar1.png"]))
    {
        car.hp = 2;
    }
    return car;
}
@end