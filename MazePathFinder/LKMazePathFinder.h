//
//  LKMazePathFinder.h
//  CarPark
//
//  Created by Kam on 9/3/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import <Foundation/Foundation.h>

struct MazePoint {
    NSInteger x;
    NSInteger y;
    NSInteger f;
    NSInteger g;
    NSInteger h;
};
typedef struct MazePoint MazePoint;

@interface LKMazePathFinder : NSObject

- (id)initWithMazeArray:(NSArray *)array;
- (NSArray *)getPathWithStartIndexPoint:(CGPoint)startIndexPoint
                          endIndexPoint:(CGPoint)endIndexPoint
                           ignoreCorner:(BOOL)ignoreCorner;

@end
