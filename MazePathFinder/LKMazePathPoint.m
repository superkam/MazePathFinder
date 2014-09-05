//
//  LKMazePathPoint.m
//  CarPark
//
//  Created by Kam on 9/3/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "LKMazePathPoint.h"

@implementation LKMazePathPoint

- (id)initWithX:(NSInteger)x
              y:(NSInteger)y
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.f = 0;
        self.g = 0;
        self.h = 0;
    }
    return self;
}

- (void)calcF
{
    self.f = self.g + self.h;
}

@end
