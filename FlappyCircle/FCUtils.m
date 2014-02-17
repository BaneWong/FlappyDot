//
//  FCUtils.m
//  FlappyCircle
//
//  Created by Pablo on 17/02/14.
//  Copyright (c) 2014 Pablo. All rights reserved.
//

#import "FCUtils.h"

int FCRandomInt(int min, int max) {
  return min + arc4random() % (max - min + 1);
}

CGPoint FCMultiplyScalar(const CGPoint a, const CGFloat b){
  return CGPointMake(a.x * b, a.y * b);
}
