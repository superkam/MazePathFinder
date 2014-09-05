//
//  LKMazeTile.m
//  CarPark
//
//  Created by Kam on 8/28/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "LKMazeTile.h"

@interface LKMazeTile ()

@end

@implementation LKMazeTile

#pragma mark - Lifecycle

- (id)initWithType:(TileType)tileType
            origin:(CGPoint)origin
          rowIndex:(NSInteger)rowIndex
          colIndex:(NSInteger)colIndex
{
    self = [super init];
    if (self) {
        _tileType = tileType;
        _origin = origin;
        _rowIndex = rowIndex;
        _colIndex = colIndex;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Tile [row:%u, col:%u, origin:(%g, %g)]", self.rowIndex, self.colIndex, self.origin.x, self.origin.y];
}

@end
