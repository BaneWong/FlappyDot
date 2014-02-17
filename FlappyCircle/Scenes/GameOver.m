//
//  GameOver.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver {
  int _score;
  SKLabelNode *_retryLabel;
  SKLabelNode *_menuLabel;
}

- (id)initWithSize:(CGSize)size score:(int) score{
    if (self = [super initWithSize:size]) {
      _score = score;
      self.backgroundColor = [SKColor whiteColor];
      [self setupLabels];
      
    }
    return self;
}

- (void) setupLabels {
  SKLabelNode *_infoLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _infoLabel.text = @"Game Over";
  _infoLabel.fontColor = [SKColor blackColor];
  _infoLabel.fontSize = 30;
  _infoLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 100);
  [self addChild:_infoLabel];
  
  SKLabelNode *_scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _scoreLabel.text = [NSString stringWithFormat:@"Your score: %i", _score];
  _scoreLabel.fontColor = [SKColor blackColor];
  _scoreLabel.fontSize = 15;
  _scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 160);
  [self addChild:_scoreLabel];
  
  SKLabelNode *_recordLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _recordLabel.text = [NSString stringWithFormat:@"Your best: %i", _score];
  _recordLabel.fontColor = [SKColor redColor];
  _recordLabel.fontSize = 15;
  _recordLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 200);
  [self addChild:_recordLabel];
  
  _retryLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _retryLabel.text = @"Retry?";
  _retryLabel.fontColor = [SKColor blackColor];
  _retryLabel.fontSize = 18;
  _retryLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 90, 50);
  [self addChild:_retryLabel];
  
  _menuLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _menuLabel.text = @"Main Menu";
  _menuLabel.fontColor = [SKColor blackColor];
  _menuLabel.fontSize = 18;
  _menuLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 70, 50);
  [self addChild:_menuLabel];
}


@end
