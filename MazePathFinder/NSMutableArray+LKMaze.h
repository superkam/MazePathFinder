//
//  NSMutableArray+LKMaze.h
//  CarPark
//
//  Created by Kam on 9/3/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKMazePathPoint.h"

@interface NSMutableArray (LKMaze)

- (BOOL)pointExists:(LKMazePathPoint *)point;
- (BOOL)pointExistsWithX:(NSInteger)x
                       y:(NSInteger)y;
- (LKMazePathPoint *)getPointWithX:(NSInteger)x
                                 y:(NSInteger)y;
- (LKMazePathPoint *)getPoint:(LKMazePathPoint *)point;
- (void)removePointWithX:(NSInteger)x
                       y:(NSInteger)y;

@end
