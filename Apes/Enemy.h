//
//  Police.h
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "cocos2d.h"

@interface Enemy : CCSprite
@property (nonatomic, assign) int hp;

- (void)hit;
@end

@interface Police : Enemy
+ (Police*)police;
@end

@interface Car : Enemy
+ (Car*)car;
@end