//
//  Ground.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "Ground.h"
#import "Gameplay.h"

@implementation Ground

- (id)initWithSize:(CGSize)size {
  self = [super init];
  if (self) {
    self.size = size;
    self.color = [SKColor blackColor];
    self.position = CGPointMake(self.size.width/2, -self.size.height/2);
    [self setupPhysics];
  }
  return self;
}

- (void) setupPhysics {
  self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
  self.physicsBody.categoryBitMask = FCPhysicsCategoryGround;
  self.physicsBody.contactTestBitMask = FCPhysicsCategoryPlayer;
  self.physicsBody.dynamic = NO;
}

@end
