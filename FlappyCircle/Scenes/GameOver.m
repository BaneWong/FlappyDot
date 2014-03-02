//
//  GameOver.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver {
  SKLabelNode *_retryLabel;
  SKLabelNode *_menuLabel;
  SKLabelNode *_scoreLabel;
  SKLabelNode *_highscoreLabel;
  SKAction *_playPointSound;
  SKAction *_playHighscoreSound;
  int _score;
  int _oldHighscore;
}

- (id)initWithSize:(CGSize)size score:(int)score{
    if (self = [super initWithSize:size]) {
      self.backgroundColor = [SKColor whiteColor];
      _score = score;
      _playPointSound = [SKAction playSoundFileNamed:@"scorePoint.wav" waitForCompletion:NO];
      _playHighscoreSound = [SKAction playSoundFileNamed:@"highscore.wav" waitForCompletion:NO];
      [self setScores];
      [self setupLabels];
      [self performSelector:@selector(animateLabels) withObject:self afterDelay:0.5];
      
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
  
  _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _scoreLabel.text = @"Score:  0";
  _scoreLabel.fontColor = [SKColor blackColor];
  _scoreLabel.fontSize = 18;
  _scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 160);
  [self addChild:_scoreLabel];
  
  _highscoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _highscoreLabel.text = [NSString stringWithFormat:@"Best: %2i", _oldHighscore];
  _highscoreLabel.fontColor = [SKColor redColor];
  _highscoreLabel.fontSize = 18;
  _highscoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 200);
  [self addChild:_highscoreLabel];
  
  _retryLabel = [SKLabelNode labelNodeWithFontNamed:@"Minecraftia"];
  _retryLabel.name = @"retryButton";
  _retryLabel.text = @"Tap to retry";
  _retryLabel.fontColor = [SKColor redColor];
  _retryLabel.fontSize = 20;
  _retryLabel.position = CGPointMake(CGRectGetMidX(self.frame), 90);
  [_retryLabel runAction:[SKAction fadeOutWithDuration:0]];
  [self addChild:_retryLabel];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSNotificationCenter *notifier = [NSNotificationCenter defaultCenter];
  [notifier postNotificationName:@"FCRetry" object:self userInfo:nil];
}

- (void) animateLabels {
  int waitProportion = 20;
  if(_score==0){
    [self fadeInRetryLabel];
  }
  
  for(int i=1; i<=_score; i++){
    [self runAction:[SKAction sequence:@[
   [SKAction waitForDuration: (float)i/waitProportion],
    [SKAction runBlock:^{
      _scoreLabel.text = [NSString stringWithFormat:@"Score: %2i", i];
      [self runAction:_playPointSound];
      if(_oldHighscore < i) {
        _highscoreLabel.text = [NSString stringWithFormat:@"Best: %2i", i];
        if(_oldHighscore == i - 1){
          [_highscoreLabel runAction:[SKAction scaleTo:1.2 duration:0.1]];
          [self runAction:_playHighscoreSound];
        }
        
        if(_score == i) {
          [_highscoreLabel runAction:[SKAction sequence:@[
            [SKAction waitForDuration:0.1],
            [SKAction scaleTo:1 duration:0.1]
          ]]];
        }
      }
    }]]]];
    
    if(i==_score) {
      [self fadeInRetryLabel];
    }
  }
}

- (void) fadeInRetryLabel {
  [_retryLabel runAction:[SKAction fadeInWithDuration:0.3]];
}


- (void) setScores {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  _oldHighscore = [userDefaults integerForKey:@"highscore"];
  
  if([userDefaults integerForKey:@"highscore"] < _score){ //highscore was beaten
    [userDefaults setInteger:_score forKey:@"highscore"];
  }
  
  [userDefaults synchronize];
}


@end
