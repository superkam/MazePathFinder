//
//  LKMazePathPoint.h
//  CarPark
//
//  Created by Kam on 9/3/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKMazePathPoint : NSObject

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

@property (nonatomic) NSInteger f;
@property (nonatomic) NSInteger g;
@property (nonatomic) NSInteger h;

@property (nonatomic, weak) LKMazePathPoint *parentPoint;

- (id)initWithX:(NSInteger)x
              y:(NSInteger)y;

- (void)calcF;

@end
