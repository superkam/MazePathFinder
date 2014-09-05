//
//  LKMazePathView.m
//  CarPark
//
//  Created by Kam on 9/3/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "LKMazePathView.h"
#import "LKMazeTile.h"

@implementation LKMazePathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(context, 5.0f);
    
    CGPoint startPoint = [[self.pathArray firstObject] CGPointValue];
    CGContextMoveToPoint(context, startPoint.y * TILE_SIZE.width + TILE_SIZE.width / 2, startPoint.x * TILE_SIZE.height + TILE_SIZE.height / 2);
    
    for (NSUInteger i = 1; i < self.pathArray.count; ++i) {
        CGPoint point = [[self.pathArray objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, point.y * TILE_SIZE.width + TILE_SIZE.width / 2, point.x * TILE_SIZE.height + TILE_SIZE.height / 2);
    }
    
    CGContextStrokePath(context);
}

@end
