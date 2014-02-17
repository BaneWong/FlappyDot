//
//  Obstacle.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "Obstacle.h"
#import "Gameplay.h"
#define GAMEPLAY_HEIGHT 480
#define GAP_HEIGHT 150
#define MIN_GAP_Y_CORD (GAP_HEIGHT - 160)
#define MAX_GAP_Y_CORD 160
#define WIDTH 50
#define HEIGHT GAMEPLAY_HEIGHT


@implementation Obstacle {
  SKSpriteNode *_topComponent;
  SKSpriteNode *_bottomComponent;
}

- (id)initWithPosition:(CGPoint) position{
  self = [super init];
  if (self) {
    self.position = position;
    self.name = @"Obstacle";
    self.size = CGSizeMake(WIDTH, HEIGHT*2);
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = FCPhysicsCategoryObstacle;
    self.physicsBody.contactTestBitMask = FCPhysicsCategoryPlayer;
    self.physicsBody.collisionBitMask = false;
    [self setupComponents];
  }
  return self;
}

- (void) setupComponents {
  _topComponent = [SKSpriteNode node];
  _topComponent.size = CGSizeMake(WIDTH, HEIGHT);
  _topComponent.color = [SKColor blackColor];
  [self setupComponentPhysics:_topComponent];
  
  _bottomComponent = [SKSpriteNode node];
  _bottomComponent.size = CGSizeMake(WIDTH, HEIGHT);
  _bottomComponent.color = [SKColor blackColor];
  [self setupComponentPhysics:_bottomComponent];
  
  [self changeComponentsPosition];
  [self addChild:_topComponent];
  [self addChild:_bottomComponent];
}

- (void) setupComponentPhysics:(SKSpriteNode *)compenent {
  compenent.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:compenent.size];
  compenent.physicsBody.categoryBitMask = FCPhysicsCategoryObstacleComponent;
  compenent.physicsBody.dynamic = NO;
  compenent.physicsBody.contactTestBitMask = FCPhysicsCategoryPlayer;
}

- (void) changeComponentsPosition {
  int randomOffset = FCRandomInt(MIN_GAP_Y_CORD, MAX_GAP_Y_CORD);
  _topComponent.position = CGPointMake(0, GAMEPLAY_HEIGHT + randomOffset);
  _bottomComponent.position = CGPointMake(0, _topComponent.position.y - HEIGHT - GAP_HEIGHT);
}

@end
