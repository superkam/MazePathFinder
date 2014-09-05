//
//  LKMazePathFinder.m
//  CarPark
//
//  Created by Kam on 9/3/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "LKMazePathFinder.h"
#import "NSMutableArray+LKMaze.h"

#define STEP 10
#define OBLIQUE 14

@interface LKMazePathFinder ()

@property (nonatomic, strong) NSArray *mazeArray;

@property (nonatomic, strong) NSMutableArray *openList;
@property (nonatomic, strong) NSMutableArray *closeList;

@end

@implementation LKMazePathFinder

#pragma mark - Private methods

- (BOOL)canReachWithX:(NSInteger)x
                    y:(NSInteger)y
{
    return [[[self.mazeArray objectAtIndex:x] objectAtIndex:y] integerValue] == 0;
}

- (BOOL)canReachWithStartPoint:(LKMazePathPoint *)startPoint
                             x:(NSInteger)x
                             y:(NSInteger)y
                isIgnoreCorner:(BOOL)isIgnoreCorner
{
    if (![self canReachWithX:x y:y]
        || [self.closeList pointExistsWithX:x y:y]) {
        return NO;
    } else {
        if (ABS(x - startPoint.x) + ABS(y - startPoint.y) == 1) {
            return YES;
        } else {
            if ([self canReachWithX:ABS(x - 1) y:y] && [self canReachWithX:x y:ABS(y - 1)]) {
                return YES;
            } else {
                return isIgnoreCorner;
            }
        }
    }
}

- (NSMutableArray *)findSurroundPointsForPoint:(LKMazePathPoint *)point
                                  ignoreCorner:(BOOL)ignoreCorner
{
    NSMutableArray *surroundPoints = [[NSMutableArray alloc] init];
    
    for (NSInteger x = point.x - 1; x <= point.x + 1; x++) {
        for (NSInteger y = point.y - 1; y <= point.y + 1; y++) {
            if (x >= 0 && x < self.mazeArray.count
                && y >= 0 && y < ((NSArray *)[self.mazeArray objectAtIndex:point.x]).count) {
                if ([self canReachWithStartPoint:point
                                               x:x
                                               y:y
                                  isIgnoreCorner:ignoreCorner]) {
                    [surroundPoints addObject:[[LKMazePathPoint alloc] initWithX:x y:y]];
                }
            }
        }
    }
    return surroundPoints;
}

- (void)foundPoint:(LKMazePathPoint *)point
         tempStart:(LKMazePathPoint *)tempStart
{
    NSInteger g = [self calcGForStartPoint:tempStart point:point];
    if (g < point.g) {
        point.parentPoint = tempStart;
        point.g = g;
        [point calcF];
    }
}

- (void)notFoundPoint:(LKMazePathPoint *)point
       tempStartPoint:(LKMazePathPoint *)tempStartPoint
             endPoint:(LKMazePathPoint *)endPoint
{
    point.parentPoint = tempStartPoint;
    point.g = [self calcGForStartPoint:tempStartPoint point:point];
    point.g = [self calcHForEndPoint:endPoint point:point];
    [point calcF];
    [self.openList addObject:point];
}

- (NSInteger)calcGForStartPoint:(LKMazePathPoint *)startPoint
                          point:(LKMazePathPoint *)point
{
    NSInteger g = (ABS(point.x - startPoint.x) + ABS(point.y - startPoint.y)) == 2 ? STEP : OBLIQUE;
    NSInteger parentG = point.parentPoint ? point.parentPoint.g : 0;
    return g + parentG;
}

- (NSInteger)calcHForEndPoint:(LKMazePathPoint *)endPoint
                        point:(LKMazePathPoint *)point
{
    NSInteger step = ABS(point.x - endPoint.x) + ABS(point.y - endPoint.y);
    return step * STEP;
}

- (LKMazePathPoint *)findPathWithStartPoint:(LKMazePathPoint *)startPoint
                                   endPoint:(LKMazePathPoint *)endPoint
                               ignoreCorner:(BOOL)ignoreCorner
{
    [self.openList addObject:startPoint];
    while (self.openList.count > 0) {
        
        // Find the point have min f
        NSArray *resultArray = [self.openList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            LKMazePathPoint *point1 = (LKMazePathPoint *)obj1;
            LKMazePathPoint *point2 = (LKMazePathPoint *)obj2;
            
            NSComparisonResult result = [@(point1.f) compare: @(point2.f)];
            return result == NSOrderedDescending;
        }];
        self.openList = [resultArray mutableCopy];
        
        LKMazePathPoint *tempStart = [self.openList firstObject];
        [self.closeList addObject:tempStart];
        [self.openList removeObject:tempStart];
        
        NSMutableArray *surroundPoints = [self findSurroundPointsForPoint:tempStart ignoreCorner:NO];
        for (LKMazePathPoint *point in surroundPoints) {
            if ([self.openList pointExists:point]) {
                [self foundPoint:point tempStart:tempStart];
            } else {
                [self notFoundPoint:point tempStartPoint:tempStart endPoint:endPoint];
            }
        }
        if ([self.openList getPoint:endPoint]) {
            return [self.openList getPoint:endPoint];
        }
    }
    return [self.openList getPoint:endPoint];
}

#pragma mark - Lifecycle

- (id)initWithMazeArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.mazeArray = array;
        self.openList = [[NSMutableArray alloc] init];
        self.closeList = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public methods

- (NSArray *)getPathWithStartIndexPoint:(CGPoint)startIndexPoint
                          endIndexPoint:(CGPoint)endIndexPoint
                           ignoreCorner:(BOOL)ignoreCorner
{
    self.openList = [[NSMutableArray alloc] init];
    self.closeList = [[NSMutableArray alloc] init];
    
    LKMazePathPoint *startPoint = [[LKMazePathPoint alloc] initWithX:startIndexPoint.x
                                                                   y:startIndexPoint.y];
    LKMazePathPoint *endPoint = [[LKMazePathPoint alloc] initWithX:endIndexPoint.x
                                                                 y:endIndexPoint.y];
    
    LKMazePathPoint *parentPoint = [self findPathWithStartPoint:startPoint
                                                       endPoint:endPoint
                                                   ignoreCorner:ignoreCorner];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    while (parentPoint) {
        [resultArray addObject:[NSValue valueWithCGPoint:CGPointMake(parentPoint.x, parentPoint.y)]];
        parentPoint = parentPoint.parentPoint;
    }
    return [resultArray copy];
}

@end
