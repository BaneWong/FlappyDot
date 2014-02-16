//
//  Obstacle.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "Obstacle.h"
#import "Gameplay.h"

#define GAP 50
#define INITIAL_X 130
#define WIDTH 50

@implementation Obstacle {
  CGSize _gameplaySize;
  SKSpriteNode *_topComponent;
  SKSpriteNode *_bottomComponent;
}

- (id)initWithSceneSize:(CGSize) size{
  self = [super init];
  if (self) {
    _gameplaySize = size;
    self.position = CGPointMake(INITIAL_X, 10);
    self.name = @"Obstacle";
    [self setupComponents];
  }
  return self;
}

- (void) setupComponents {
  _topComponent = [SKSpriteNode node];
  _topComponent.size = CGSizeMake(WIDTH, 100);
  _topComponent.color = [SKColor greenColor];
  _topComponent.position = CGPointMake(INITIAL_X, _gameplaySize.height - _topComponent.size.height/2);
  [self setupComponentPhysics:_topComponent];
  [self addChild:_topComponent];
  
  _bottomComponent = [SKSpriteNode node];
  _bottomComponent.size = CGSizeMake(WIDTH, 100);
  _bottomComponent.color = [SKColor blackColor];
  _bottomComponent.position = CGPointMake(INITIAL_X, 0);
  [self setupComponentPhysics:_bottomComponent];
  [self addChild:_bottomComponent];
  
}

- (void) setupComponentPhysics:(SKSpriteNode *)compenent {
  compenent.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:compenent.size];
  compenent.physicsBody.categoryBitMask = FCPhysicsCategoryObstacle;
  compenent.physicsBody.dynamic = NO;
  compenent.physicsBody.contactTestBitMask = FCPhysicsCategoryPlayer;
  
}

@end
