//
//  NSMutableArray+LKMaze.m
//  CarPark
//
//  Created by Kam on 9/3/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "NSMutableArray+LKMaze.h"

@implementation NSMutableArray (LKMaze)

- (BOOL)pointExists:(LKMazePathPoint *)point
{
    for (LKMazePathPoint *existingPoint in self) {
        if (existingPoint.x == point.x &&
            existingPoint.y == point.y) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)pointExistsWithX:(NSInteger)x
                       y:(NSInteger)y
{
    for (LKMazePathPoint *existingPoint in self) {
        if (existingPoint.x == x &&
            existingPoint.y == y) {
            return YES;
        }
    }
    return NO;
}

- (LKMazePathPoint *)getPointWithX:(NSInteger)x
                                 y:(NSInteger)y
{
    for (LKMazePathPoint *existingPoint in self) {
        if (existingPoint.x == x &&
            existingPoint.y == y) {
            return existingPoint;
        }
    }
    return nil;
}
- (LKMazePathPoint *)getPoint:(LKMazePathPoint *)point
{
    for (LKMazePathPoint *existingPoint in self) {
        if (existingPoint.x == point.x &&
            existingPoint.y == point.y) {
            return existingPoint;
        }
    }
    return nil;
}

- (void)removePointWithX:(NSInteger)x
                       y:(NSInteger)y
{
    for (LKMazePathPoint *existingPoint in self) {
        if (existingPoint.x == x &&
            existingPoint.y == y) {
            [self removeObject:existingPoint];
        }
    }
}

@end
