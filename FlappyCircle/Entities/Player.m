//
//  Player.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "Player.h"
#import "Gameplay.h"

@implementation Player


- (id)init
{
  self = [super init];
  if (self) {
    SKTexture *playerTexture = [SKTexture textureWithImageNamed:@"circle"];
    self.texture = playerTexture;
    self.size = CGSizeMake(playerTexture.size.height, playerTexture.size.width);
    
    [self setupPhysics];
  }
  return self;
}


- (void) setupPhysics {
  self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
  self.physicsBody.categoryBitMask = FCPhysicsCategoryPlayer;
  self.physicsBody.collisionBitMask = FCPhysicsCategoryObstacleComponent | FCPhysicsCategoryGround;
  self.physicsBody.allowsRotation = NO;
  self.physicsBody.usesPreciseCollisionDetection = YES;
}

@end
