//
//  GameConstant.h
//  RunningApe
//
//  Created by 余 向洋 on 12-12-8.
//
//

#import <Foundation/Foundation.h>

//#define GOD_MODE    // uncomment to debug

#define DEFAULT_GLOBAL_SPEED_FACTOR 1

#define GROUND_SCROLL_SPEED (120 * DEFAULT_GLOBAL_SPEED_FACTOR)
#define CITY_A_SCROLL_SPEED (0.35 * GROUND_SCROLL_SPEED)
#define CITY_B_SCROLL_SPEED (0.4 * GROUND_SCROLL_SPEED)

#define POLICE_MOVE_SPEED (1.4 * GROUND_SCROLL_SPEED)
#define CAR_MOVE_SPEED POLICE_MOVE_SPEED
#define AIRPLANE_MOVE_SPEED (2 * GROUND_SCROLL_SPEED)
#define BULLET_MOVE_SPEED (2.3 * GROUND_SCROLL_SPEED)
#define BANANA_MOVE_SPEED (2.3 * GROUND_SCROLL_SPEED)

#define kMaxBananas 3