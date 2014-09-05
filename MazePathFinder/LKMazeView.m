//
//  LKMazeView.m
//  CarPark
//
//  Created by Kam on 8/29/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "LKMazeView.h"
#import "LKMazeTile.h"
#import "LKMazePathView.h"
#import "LKMazePathFinder.h"

typedef enum {
    TouchToPlaceTypeStartPoint,
    TouchToPlaceTypeEndPoint
} TouchToPlaceType;

@interface LKMazeView ()

{
    NSUInteger rowCount;
    NSUInteger colCount;
    CGSize tileSize;
    
    CGPoint tileTopLeftPoint;
    CGFloat mazeWidth;
    CGFloat mazeHeight;
    
    CGPoint startIndexPoint;
    CGPoint endIndexPoint;
    
    TouchToPlaceType touchToPlaceType;
}

@property (strong, nonatomic) NSMutableArray *tileArray;

@property (strong, nonatomic) UIView *startPointView;
@property (strong, nonatomic) UIView *endPointView;
@property (strong, nonatomic) LKMazePathView *pathView;

@property (strong, nonatomic) LKMazePathFinder *mazePathFinder;

@end

@implementation LKMazeView

#pragma mark - Private methods

- (void)drawTileWithTile:(LKMazeTile *)tile
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *tileColor = [UIColor blackColor];
    if (tile.tileType == TileTypePath) {
        tileColor = [UIColor grayColor];
    }
    
    CGContextSetFillColorWithColor(context, tileColor.CGColor);
    
    CGFloat originX = tileTopLeftPoint.x + tile.colIndex * tileSize.width;
    CGFloat originY = tileTopLeftPoint.y + tile.rowIndex * tileSize.height;
    
    CGContextFillRect(context, CGRectMake(originX, originY, tileSize.width, tileSize.height));
}

- (void)drawWall
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2.0f);
    
    
    CGContextMoveToPoint(context, tileTopLeftPoint.x, tileTopLeftPoint.y);
    CGContextAddLineToPoint(context, tileTopLeftPoint.x + mazeWidth, tileTopLeftPoint.y);
    CGContextAddLineToPoint(context, tileTopLeftPoint.x + mazeWidth, tileTopLeftPoint.y + mazeHeight);
    CGContextAddLineToPoint(context, tileTopLeftPoint.x, tileTopLeftPoint.y + mazeHeight);
    CGContextAddLineToPoint(context, tileTopLeftPoint.x, tileTopLeftPoint.y);
    
    CGContextStrokePath(context);
}

- (LKMazeTile *)getTileWithOrigin:(CGPoint)origin
{
    if (origin.x >= tileTopLeftPoint.x
        && origin.x <= tileTopLeftPoint.x + TILE_SIZE.width * colCount
        && origin.y >= tileTopLeftPoint.y
        && origin.y <= tileTopLeftPoint.y + TILE_SIZE.height * rowCount) {
        
        NSUInteger colIndex = (origin.x - tileTopLeftPoint.x) / TILE_SIZE.width;
        NSUInteger rowIndex = (origin.y - tileTopLeftPoint.y) / TILE_SIZE.height;
        
        LKMazeTile *tile = nil;
        for (LKMazeTile *currentTile in self.tileArray) {
            if (currentTile.colIndex == colIndex &&
                currentTile.rowIndex == rowIndex &&
                currentTile.tileType == TileTypePath) {
                tile = currentTile;
                break;
            }
        }
        return tile;
    } else {
        return nil;
    }
}

- (void)placeStartPointOnTile:(LKMazeTile *)tile
{
    NSLog(@"Start: %d, %d", tile.rowIndex, tile.colIndex);
    CGRect startPointViewFrame = CGRectMake(tile.origin.x, tile.origin.y, TILE_SIZE.width, TILE_SIZE.height);
    if (!self.startPointView) {
        self.startPointView = [[UIView alloc] initWithFrame:startPointViewFrame];
        self.startPointView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.startPointView];
    } else {
        self.startPointView.frame = startPointViewFrame;
    }
}

- (void)placeEndPointOnTile:(LKMazeTile *)tile
{
    NSLog(@"End: %d, %d", tile.rowIndex, tile.colIndex);
    CGRect endPointViewFrame = CGRectMake(tile.origin.x, tile.origin.y, TILE_SIZE.width, TILE_SIZE.height);
    if (!self.endPointView) {
        self.endPointView = [[UIView alloc] initWithFrame:endPointViewFrame];
        self.endPointView.backgroundColor = [UIColor redColor];
        [self addSubview:self.endPointView];
    } else {
        self.endPointView.frame = endPointViewFrame;
    }
}

- (void)drawPathBetweenStartAndEndPoint
{
    if (self.mazePathFinder) {
        NSArray *pathArray = [self.mazePathFinder getPathWithStartIndexPoint:startIndexPoint
                                                               endIndexPoint:endIndexPoint
                                                                ignoreCorner:YES];
        if (self.pathView) {
            [self.pathView removeFromSuperview];
            self.pathView = nil;
        }
        
        if ([pathArray count] > 0) {
            self.pathView = [[LKMazePathView alloc] initWithFrame:CGRectMake(tileTopLeftPoint.x,
                                                                             tileTopLeftPoint.y,
                                                                             colCount * TILE_SIZE.width,
                                                                             rowCount * TILE_SIZE.height)];
            [self addSubview:self.pathView];
            self.pathView.pathArray = pathArray;
            [self.pathView setNeedsDisplay];
        }
    }
}


#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.multipleTouchEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (rowCount > 0 && colCount > 0 && tileSize.width > 0 && tileSize.height > 0) {
        
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
        
        if (rowCount * tileSize.height > CGRectGetHeight(self.bounds) ||
            colCount * tileSize.width > CGRectGetWidth(self.bounds)) {
            
            // maze is too big to draw
            CGSize tipLabelSize = CGSizeMake(150, 30);
            CGFloat tipLabelOriginX = (CGRectGetWidth(self.bounds) - tipLabelSize.width) / 2;
            CGFloat tipLabelOriginY = (CGRectGetHeight(self.bounds) - tipLabelSize.height) / 2;
            CGRect tipLabelFrame = CGRectMake(tipLabelOriginX,
                                              tipLabelOriginY,
                                              tipLabelSize.width,
                                              tipLabelSize.height);
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:tipLabelFrame];
            tipLabel.textColor = [UIColor grayColor];
            tipLabel.font = [UIFont systemFontOfSize:14];
            tipLabel.text = @"Canvas is too small.";
            tipLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:tipLabel];
            
        } else {
            
            [self drawWall];
            
            self.tileArray = [[NSMutableArray alloc] initWithCapacity:rowCount * colCount];
            
            // draw maze
            NSMutableArray *mazeIndexArray = [[NSMutableArray alloc] initWithCapacity:rowCount];
            
            for (NSUInteger row = 0; row < rowCount; ++row) {
                
                NSMutableArray *mazeIndexRowArray = [[NSMutableArray alloc] initWithCapacity:colCount];
                
                for (NSUInteger col = 0; col < colCount; ++col) {
                    TileType tileType = (arc4random() % 100 > 30) ? TileTypePath : TileTypeWall;
                    CGFloat originX = tileTopLeftPoint.x + col * tileSize.width;
                    CGFloat originY = tileTopLeftPoint.y + row * tileSize.height;
                    
                    LKMazeTile *tile = [[LKMazeTile alloc] initWithType:tileType
                                                                 origin:CGPointMake(originX, originY)
                                                               rowIndex:row
                                                               colIndex:col];
                    [self drawTileWithTile:tile];
                    
                    [self.tileArray addObject:tile];
                    [mazeIndexRowArray addObject:@((tileType == TileTypePath ? 0 : 1))];
                }
                
                [mazeIndexArray addObject:mazeIndexRowArray];
            }
            
            self.mazePathFinder = [[LKMazePathFinder alloc] initWithMazeArray:mazeIndexArray];
        }
    }
}


#pragma mark - Public methods

- (void)drawMazeWithRowCount:(NSUInteger)theRowCount
                    colCount:(NSUInteger)theColCount
                    tileSize:(CGSize)theTileSize
{
    rowCount = theRowCount;
    colCount = theColCount;
    tileSize = theTileSize;
    touchToPlaceType = TouchToPlaceTypeStartPoint;
    
    mazeWidth = colCount * tileSize.width;
    mazeHeight = rowCount * tileSize.height;
    tileTopLeftPoint = CGPointMake((CGRectGetWidth(self.bounds) - mazeWidth) / 2,
                                   (CGRectGetHeight(self.bounds) - mazeHeight) / 2);
    
    if (self.startPointView) {
        [self.startPointView removeFromSuperview];
        self.startPointView = nil;
    }
    if (self.endPointView) {
        [self.endPointView removeFromSuperview];
        self.endPointView = nil;
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Touch methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    LKMazeTile *tile = [self getTileWithOrigin:touchLocation];
    if (tile) {
        if (touchToPlaceType == TouchToPlaceTypeStartPoint) {
            [self placeStartPointOnTile:tile];
            startIndexPoint = CGPointMake(tile.rowIndex, tile.colIndex);
            touchToPlaceType = TouchToPlaceTypeEndPoint;
        } else {
            [self placeEndPointOnTile:tile];
            endIndexPoint = CGPointMake(tile.rowIndex, tile.colIndex);
            touchToPlaceType = TouchToPlaceTypeStartPoint;
        }
        
        if (self.startPointView && self.endPointView) {
            [self drawPathBetweenStartAndEndPoint];
        }
    }
}

@end
