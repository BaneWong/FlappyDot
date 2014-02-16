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

+ (Player *) playerInstance {
  static Player *_playerInstance = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    _playerInstance = [[Player alloc] init];
  });
  return _playerInstance;
}


- (id)init
{
  self = [super init];
  if (self) {
    SKTexture *playerTexture = [SKTexture textureWithImageNamed:@"circle"];
    self.texture = playerTexture;
    self.size = CGSizeMake(playerTexture.size.height/4,playerTexture.size.width/4);
    
    [self setupPhysics];
  }
  return self;
}


- (void) setupPhysics {
  self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
  self.physicsBody.categoryBitMask = FCPhysicsCategoryPlayer;
  
}

@end
