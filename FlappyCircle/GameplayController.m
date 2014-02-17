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
  [notifier addObserver:self selector:@selector(segueToGameOver) name:@"FCGameOver" object:nil];

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

- (void) segueToGameOver {
  [self performSegueWithIdentifier:@"FCGameplayToGameOver" sender:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"seguje");
  
  UIViewController *destination = [segue destinationViewController];
  destination.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
  
  [destination requestInterstitialAdPresentation];
}



@end
