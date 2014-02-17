//
//  ViewController.m
//  FlappyCircle
//
//  Created by Pablo on 16/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "GameOverController.h"
#import "GameOver.h"

@implementation GameOverController

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSLog(@"ova gama");
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.showsFPS = NO;
  skView.showsNodeCount = NO;
  
  // Create and configure the scene.
  SKScene * scene = [GameOver sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:scene];
}


- (BOOL)prefersStatusBarHidden {
  return YES;
}



@end
