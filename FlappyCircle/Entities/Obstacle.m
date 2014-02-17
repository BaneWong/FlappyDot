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
//#define

static int FCRandomInt(int min, int max) {
  return min + arc4random() % (max - min + 1);
}

@implementation Obstacle {
  CGSize _gameplaySize;
  SKSpriteNode *_topComponent;
  SKSpriteNode *_bottomComponent;
}

- (id)initWithSceneSize:(CGSize) size{
  self = [super init];
  if (self) {
    _gameplaySize = size;
    self.position = CGPointMake(120, 10);
    self.name = @"Obstacle";
    [self setupComponents];
  }
  return self;
}

- (void) setupComponents {
  int initialOffset = FCRandomInt(MIN_GAP_Y_CORD, MAX_GAP_Y_CORD);
  NSLog(@"%f", _gameplaySize.height/3);
  _topComponent = [SKSpriteNode node];
  _topComponent.size = CGSizeMake(WIDTH, HEIGHT);
  _topComponent.color = [SKColor greenColor];
  _topComponent.position = CGPointMake(0, GAMEPLAY_HEIGHT + initialOffset);
  [self setupComponentPhysics:_topComponent];
  [self addChild:_topComponent];
  
  _bottomComponent = [SKSpriteNode node];
  _bottomComponent.size = CGSizeMake(WIDTH, HEIGHT);
  _bottomComponent.color = [SKColor blackColor];
  _bottomComponent.position = CGPointMake(0, _topComponent.position.y - HEIGHT - GAP_HEIGHT);
  [self setupComponentPhysics:_bottomComponent];
  [self addChild:_bottomComponent];
  
}

- (void) setupComponentPhysics:(SKSpriteNode *)compenent {
  compenent.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:compenent.size];
  compenent.physicsBody.categoryBitMask = FCPhysicsCategoryObstacle;
  compenent.physicsBody.dynamic = NO;
  compenent.physicsBody.contactTestBitMask = FCPhysicsCategoryPlayer;
  
}

- (void) changeComponentsSize {
  
}

@end
