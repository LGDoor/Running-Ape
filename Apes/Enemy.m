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
@synthesize batchNode = _batchNode;

- (id)initPolice
{
    if (self = [super initWithSpriteFrameName:@"police1.png"])
    {
        NSMutableArray *policeFrames = [[NSMutableArray alloc] init];
        [policeFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"police1.png"]];
        [policeFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"police2.png"]];
        CCAnimation *policeAnimation = [CCAnimation animationWithFrames:policeFrames delay:0.15f];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:policeAnimation restoreOriginalFrame:NO]]];
        
        self.hp = 1;
        _fire = [CCSprite spriteWithSpriteFrameName:@"police_fire.png"];
        _fire.position = ccp(0, self.contentSize.height / 2);
        _fire.visible = NO;
        _shadow = [CCSprite spriteWithSpriteFrameName:@"police_shadow.png"];
        _shadow.position = ccp(self.contentSize.width / 2 + 2, 0);
        [self addChild:_shadow z:-1];
        [self addChild:_fire z:-1];
    }
    return self;
}

- (void)fireBlink
{
    [_fire runAction:[CCSequence actions:[CCShow action], [CCDelayTime actionWithDuration:0.2], [CCHide action], nil]];
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