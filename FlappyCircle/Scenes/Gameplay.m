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
  BOOL _gameRunning;
  BOOL _gameEnded;
  
  SKLabelNode *_instructionLabel;
  SKLabelNode *_scoreLabel;
  SKLabelNode *_highscoreLabel;
  SKLabelNode *_titleLabel;
  int _score;
  SKAction *_playDeathSound;
  SKAction *_playPointSound;
  SKAction *_playStartSound;
  
  SKNode *_labelsLayer;
}

#define IMPULSE_POWER 530
#define OBSTACLE_SPEED -220
#define GRAVITY CGVectorMake(0, -12)
#define OBSTACLE_RESPAWN_BORDER -50
#define OBSTACLE_RESPAWN_START 350
#define GAP_BEETWEEN_OBSTACLES 200

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    
    _gameRunning = NO;
    _gameEnded = NO;
    [self setupPhysics];
    
    _player = [[Player alloc] init];
    _player.position = CGPointMake(100, 300);
    [self addChild:_player];
    _playDeathSound = [SKAction playSoundFileNamed:@"circleDie.wav" waitForCompletion:NO];
    _playPointSound = [SKAction playSoundFileNamed:@"scorePoint.wav" waitForCompletion:NO];
    _playStartSound = [SKAction playSoundFileNamed:@"jump.wav" waitForCompletion:NO];
    
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
  [_scoreLabel runAction:[SKAction fadeOutWithDuration:0]];
  [self addChild:_scoreLabel];
  [self updateScoreLabel];
  
  int highscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"] integerValue];
  _highscoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _highscoreLabel.text = [NSString stringWithFormat:@"Best: %i", highscore];
  _highscoreLabel.fontColor = [SKColor redColor];
  _highscoreLabel.fontSize = 18;
  _highscoreLabel.position = CGPointMake(self.size.width - 70, 10);
  [self addChild:_highscoreLabel];
  
  _titleLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _titleLabel.text = @"Flappy Dot";
  _titleLabel.fontColor = [SKColor blackColor];
  _titleLabel.fontSize = 30;
  _titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 100);
  [self addChild:_titleLabel];
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
    [self gameOver];
  } else if(collision == (FCPhysicsCategoryObstacleComponent | FCPhysicsCategoryPlayer)) {
    [self gameOver];
  }
}

- (void) didEndContact:(SKPhysicsContact *)contact {
  uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
  
  if(collision == (FCPhysicsCategoryObstacle | FCPhysicsCategoryPlayer)) {
    if(_gameRunning){
      _score += 1;
      [self runAction:_playPointSound];
      [self updateScoreLabel];
    }
  }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if(!_gameRunning && !_gameEnded) {
    [self startGameplay];
  }
  
  _player.physicsBody.velocity = CGVectorMake(0, IMPULSE_POWER);
}

- (void) startGameplay {
  [self runAction:_playStartSound];
  _gameRunning = YES;
  self.physicsWorld.gravity = GRAVITY;
  SKAction *acRemoveLabel = [SKAction sequence:@[
                              [SKAction fadeOutWithDuration:0.3],
                              [SKAction removeFromParent]]];
  
  [_scoreLabel runAction:[SKAction fadeInWithDuration:0.3]];
  [_instructionLabel runAction:acRemoveLabel];
  [_highscoreLabel runAction:acRemoveLabel];
  [_titleLabel runAction:acRemoveLabel];
}

- (void) gameOver {
  _gameRunning = NO;
  _gameEnded = YES;
  [self runAction:_playDeathSound];
  _player.physicsBody = nil;
  [self setGameOverEffects];
  
  [self runAction:[SKAction sequence:@[
                            [SKAction waitForDuration:0.8],
                            [SKAction runBlock:^{
                              NSNotificationCenter *notifier = [NSNotificationCenter defaultCenter];
                              [notifier postNotificationName:@"FCGameOver" object:self userInfo:@{@"score":@(_score)}];
                            }]]]];
    
}

- (void) setGameOverEffects {
  SKAction *deathAnimation = [SKAction sequence:@[
                                [SKAction runBlock:^{
                                  self.backgroundColor = [SKColor redColor];
                                }],
                                [SKAction waitForDuration:0.05],
                                [SKAction runBlock:^{
                                  self.backgroundColor = [SKColor whiteColor];
                                }]]];
  
  [self runAction:deathAnimation];
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

