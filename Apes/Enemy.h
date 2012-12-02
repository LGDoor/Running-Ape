//
//  Police.h
//  Apes
//
//  Created by 余 向洋 on 12-12-1.
//
//

#import "cocos2d.h"

@interface Police : CCSprite
+ (Police*)police;
@end

@interface Car : CCSprite

@property (nonatomic, assign) int hp;
+ (Car*)car;
@end