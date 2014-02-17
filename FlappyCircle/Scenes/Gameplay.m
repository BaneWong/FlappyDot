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
#import "GameOver.h"

@implementation Gameplay {
  SKSpriteNode *_player;
  NSTimeInterval _lastUpdateTime;
  NSTimeInterval _dt;
  BOOL _gameRunning;
  
  SKLabelNode *_instructionLabel;
  SKLabelNode *_scoreLabel;
  int _score;
  
  SKNode *_labelsLayer;
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
    
    _gameRunning = NO;
    [self setupPhysics];
    
    _player = [Player playerInstance];
    _player.position = CGPointMake(100, 300);
    [self addChild:_player];
    
    [self spawnObstacles];
    [self setupLabels];
  }
  return self;
}

- (void) setupLabels {
  _instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _instructionLabel.text = @"Tap to start playing";
  _instructionLabel.fontColor = [SKColor blackColor];
  _instructionLabel.fontSize = 20;
  _instructionLabel.position = CGPointMake(CGRectGetMidX(self.frame), 200);
  [self addChild:_instructionLabel];
  
  _score = 0;
  _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _scoreLabel.fontColor = [SKColor redColor];
  _scoreLabel.fontSize = 20;
  _scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 50);
  [self addChild:_scoreLabel];
  [self updateScoreLabel];
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
    [self gameOver];
  } else if(collision == (FCPhysicsCategoryObstacleComponent | FCPhysicsCategoryPlayer)) {
    [self gameOver];
  }
}

- (void) didEndContact:(SKPhysicsContact *)contact {
  uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
  
  if(collision == (FCPhysicsCategoryObstacle | FCPhysicsCategoryPlayer)) {
    _score += 1;
    [self updateScoreLabel];
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if(!_gameRunning) {
    [self startGameplay];
  }
  
  _player.physicsBody.velocity = CGVectorMake(0, IMPULSE_POWER);
}

- (void) startGameplay {
  _gameRunning = YES;
  self.physicsWorld.gravity = GRAVITY;
  [_instructionLabel runAction:[SKAction sequence:@[
                            [SKAction fadeOutWithDuration:0.5],
                            [SKAction removeFromParent]]]];
}

- (void) gameOver {
  _gameRunning = NO;
  SKScene * gameOverScene = [[GameOver alloc] initWithSize:self.size score:_score];
  SKTransition *reveal = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:1];
  [self runAction:[SKAction sequence:@[
                          [SKAction waitForDuration:1],
                          [SKAction runBlock:^{
                            [self.view presentScene:gameOverScene transition:reveal];
                  }]]]];
}

-(void)update:(CFTimeInterval)currentTime {

  if (_lastUpdateTime) {
      _dt = currentTime - _lastUpdateTime;
  } else {
      _dt = 0;
  }
  _lastUpdateTime = currentTime;
  
  if(_gameRunning) {
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

- (void)updateScoreLabel {
  _scoreLabel.text = [NSString stringWithFormat:@"Score: %i", _score];
}

@end

