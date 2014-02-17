//
//  MenuController.m
//  FlappyCircle
//
//  Created by Pablo on 17/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
	// Do any additional setup after loading the view.
  NSLog(@"i new hir");
  [self performSegueWithIdentifier:@"Dupa" sender:nil];
}


@end
