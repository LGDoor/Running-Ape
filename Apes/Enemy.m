//
//  Police.m
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "Enemy.h"

@implementation Enemy

@synthesize hp = _hp;

- (void)hit
{
    self.hp -= 1;
}
@end

@implementation Police

+ (Police*)police
{
    Police *police = nil;
    if ((police = [[Police alloc] initWithFile:@"police1.png"]))
    {
        police.hp = 1;
    }
    return police;
}

@end


@implementation Car
+ (Car*)car
{
    Car *car = nil;
    if ((car = [[Car alloc] initWithFile:@"policecar1.png"]))
    {
        car.hp = 2;
    }
    return car;
}

- (void)hit
{
    CCTexture2D* tex;
    
    [super hit];
    switch (self.hp)
    {
        case 1:
            tex = [[CCTextureCache sharedTextureCache] addImage:@"policecar2.png"];
            [self setTexture: tex];
            break;            
        default:
            break;
    }
}
@end

@implementation Airplane

+ (Airplane*)airplane
{
    Airplane *airplane = nil;
    if ((airplane = [[Airplane alloc] initWithFile:@"airplane.png"]))
    {
        airplane.hp = 1;
    }
    return airplane;
}

@end