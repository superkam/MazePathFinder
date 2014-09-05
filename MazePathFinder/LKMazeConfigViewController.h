//
//  LKMazeConfigViewController.h
//  CarPark
//
//  Created by Kam on 8/28/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKMazeConfigViewController;

@protocol LKMazeConfigViewControllerDelegate <NSObject>

- (void)mazeConfigViewController:(LKMazeConfigViewController *)mazeConfigViewController
        generateMazeWithRowCount:(NSUInteger)rowCount
                        colCount:(NSInteger)colCount;

@end

@interface LKMazeConfigViewController : UIViewController

@property (weak, nonatomic) id <LKMazeConfigViewControllerDelegate> delegate;

@end
