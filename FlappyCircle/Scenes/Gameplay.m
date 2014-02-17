//
//  MyScene.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "Gameplay.h"
#import "Player.h"
#import "Ground.h"
#import "Obstacle.h"

@implementation Gameplay {
  SKSpriteNode *_player;
  NSTimeInterval _lastUpdateTime;
  NSTimeInterval _dt;
  BOOL _gameStarted;
  SKLabelNode *_instructionLabel;
  SKLabelNode *_scoreLabel;
}

#define IMPULSE_POWER 480
#define OBSTACLE_SPEED -250
#define GRAVITY CGVectorMake(0, -11)
#define OBSTACLE_RESPAWN_BORDER -50
#define OBSTACLE_RESPAWN_START 350
#define GAP_BEETWEEN_OBSTACLES 200

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    _instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
    _instructionLabel.text = @"Tap to start playing";
    _instructionLabel.fontColor = [SKColor blackColor];
    _instructionLabel.fontSize = 20;
    _instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 200);
    
    _gameStarted = NO;
    [self setupPhysics];
    
    [self addChild:_instructionLabel];
    
    _player = [Player playerInstance];
    _player.position = CGPointMake(100, 300);
    [self addChild:_player];
    
    [self spawnObstacles];
  }
  return self;
}

- (void) spawnObstacles {
  Ground *floor = [[Ground alloc] initWithSize:CGSizeMake(self.size.width, 20)];
  [self addChild:floor];
  
  
  Obstacle *obstacle1 = [[Obstacle alloc] initWithPosition:CGPointMake(500, 0)];
  Obstacle *obstacle2 = [[Obstacle alloc] initWithPosition:CGPointMake(obstacle1.position.x + GAP_BEETWEEN_OBSTACLES, 0)];
  
  [self addChild:obstacle1];
  [self addChild:obstacle2];
}

- (void) setupPhysics {
  self.physicsWorld.gravity = CGVectorMake(0, 0);
  self.physicsWorld.contactDelegate = self;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
  uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
  
  if(collision == (FCPhysicsCategoryGround | FCPhysicsCategoryPlayer)) {
    NSLog(@"playa hita granda");
  } else if(collision == (FCPhysicsCategoryObstacle | FCPhysicsCategoryPlayer)) {
    NSLog(@"playa hita obstacla");
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if(!_gameStarted) {
    [self startGameplay];
  }
  
  _player.physicsBody.velocity = CGVectorMake(0, IMPULSE_POWER);
}

- (void) startGameplay {
  _gameStarted = YES;
  self.physicsWorld.gravity = GRAVITY;
  [_instructionLabel runAction:[SKAction sequence:@[
                            [SKAction fadeOutWithDuration:1],
                            [SKAction removeFromParent]]]];
}

-(void)update:(CFTimeInterval)currentTime {

  if (_lastUpdateTime) {
      _dt = currentTime - _lastUpdateTime;
  } else {
      _dt = 0;
  }
  _lastUpdateTime = currentTime;
  
  if(_gameStarted) {
    [self enumerateChildNodesWithName:@"Obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
      if(node.position.x > OBSTACLE_RESPAWN_BORDER){
        [self moveNode:node velocity:CGPointMake(OBSTACLE_SPEED, 0)];
      } else {
        [(Obstacle *)node changeComponentsPosition];
        node.position = CGPointMake(OBSTACLE_RESPAWN_START, 0);
      }
    }];
  }
}

-(void) moveNode:(SKNode *)node velocity:(CGPoint )velocity {
  CGPoint amountToMove = FCMultiplyScalar(velocity, _dt);
  node.position = CGPointMake(node.position.x + amountToMove.x, node.position.y + amountToMove.y);
}

@end

