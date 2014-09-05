//
//  LKMazeView.h
//  CarPark
//
//  Created by Kam on 8/29/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKMazeTile.h"

@interface LKMazeView : UIView

- (void)drawMazeWithRowCount:(NSUInteger)rowCount
                    colCount:(NSUInteger)colCount
                    tileSize:(CGSize)tileSize;

@end
