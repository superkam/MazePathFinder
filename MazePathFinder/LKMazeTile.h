//
//  LKMazeTile.h
//  CarPark
//
//  Created by Kam on 8/28/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TILE_SIZE CGSizeMake(20, 20)

typedef enum : NSInteger {
    TileTypePath,
    TileTypeWall
} TileType;

@interface LKMazeTile : NSObject

@property (nonatomic, readonly) TileType tileType;
@property (nonatomic, readonly) CGPoint origin;

@property (nonatomic, readonly) NSInteger rowIndex;
@property (nonatomic, readonly) NSInteger colIndex;

- (id)initWithType:(TileType)tileType
            origin:(CGPoint)origin
          rowIndex:(NSInteger)rowIndex
          colIndex:(NSInteger)colIndex;

@end