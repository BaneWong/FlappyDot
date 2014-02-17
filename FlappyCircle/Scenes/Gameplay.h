//
//  Gameplay.h
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_OPTIONS(uint32_t, CNPhysicsCategory) {
  FCPhysicsCategoryPlayer = 1 << 0,
  FCPhysicsCategoryGround = 1 << 1,
  FCPhysicsCategoryObstacle = 1 << 2,
  FCPhysicsCategoryObstacleComponent = 1 << 3,
};

@interface Gameplay : SKScene <SKPhysicsContactDelegate>

@end
