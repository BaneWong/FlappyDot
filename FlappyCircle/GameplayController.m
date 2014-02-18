//
//  ViewController.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "GameplayController.h"
#import "GameOverController.h"
#import "Gameplay.h"

@import iAd;

@implementation GameplayController

- (void) viewDidLoad
{
  [super viewDidLoad];

  NSNotificationCenter *notifier = [NSNotificationCenter defaultCenter];
  [notifier addObserver:self selector:@selector(segueToGameOver:) name:@"FCGameOver" object:nil];

  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.showsFPS = NO;
  skView.showsNodeCount = NO;
  
  // Create and configure the scene.
  SKScene * scene = [Gameplay sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void) segueToGameOver:(NSNotification *) notification {
  int score = [notification.userInfo[@"score"] integerValue];
  [self setScores:score];

  [self performSegueWithIdentifier:@"FCGameplayToGameOver" sender:nil];
}

- (void) setScores:(int) score {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if([[userDefaults objectForKey:@"highscore"] integerValue] < score){ //highscore was beaten
    [userDefaults setObject:@(score) forKey:@"highscore"];
  }
  
  [userDefaults setObject:@(score) forKey:@"score"];
  [userDefaults synchronize];
  
  
}
  
  


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  UIViewController *destination = [segue destinationViewController];
  destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
  
  [destination requestInterstitialAdPresentation];
}



@end
