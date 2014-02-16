//
//  Obstacle.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "Obstacle.h"
#import "Gameplay.h"

#define GAP 2
#define MIN_GAP_Y 50
#define MAX_GAP_Y (_gameplay.size.height - 50)
#define WIDTH 50
#define HEIGHT 100


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
  int initialRand = 200;
  _topComponent = [SKSpriteNode node];
  _topComponent.size = CGSizeMake(WIDTH, HEIGHT);
  _topComponent.color = [SKColor greenColor];
  _topComponent.position = CGPointMake(0, _gameplaySize.height - initialRand);
  [self setupComponentPhysics:_topComponent];
  [self addChild:_topComponent];
  
  _bottomComponent = [SKSpriteNode node];
  _bottomComponent.size = CGSizeMake(WIDTH, HEIGHT);
  _bottomComponent.color = [SKColor blackColor];
  _bottomComponent.position = CGPointMake(0, _topComponent.position.y - HEIGHT - GAP);
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
