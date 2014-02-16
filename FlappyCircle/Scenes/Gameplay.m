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

@implementation Gameplay {
  SKSpriteNode *_player;
}

#define IMPULSE_POWER 400
#define GRAVITY CGVectorMake(0, -8)


-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
    
    myLabel.text = @"Flappy Circle";
    myLabel.fontColor = [SKColor blackColor];
    
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame), 400);
    
    [self setupPhysics];
    
    [self addChild:myLabel];
    _player = [Player playerInstance];
    _player.position = CGPointMake(100, 200);
    [self addChild:_player];
    
    Ground *floor = [[Ground alloc] initWithSize:CGSizeMake(self.size.width, 20)];
    [self addChild:floor];
  }
  return self;
}

- (void) setupPhysics {
  self.physicsWorld.gravity = GRAVITY;
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
  _player.physicsBody.velocity = CGVectorMake(0, IMPULSE_POWER);
}

-(void)update:(CFTimeInterval)currentTime {
  
}

@end

