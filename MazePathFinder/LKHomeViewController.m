//
//  LKViewController.m
//  CarPark
//
//  Created by Kam on 8/28/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "LKHomeViewController.h"
#import "LKMazeConfigViewController.h"
#import "LKMazeView.h"

@interface LKHomeViewController ()

<LKMazeConfigViewControllerDelegate>

@property (weak, nonatomic) IBOutlet LKMazeView *mazeView;

@end

@implementation LKHomeViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    for (UIViewController *childViewController in self.childViewControllers) {
        if ([childViewController isKindOfClass:[LKMazeConfigViewController class]]) {
            ((LKMazeConfigViewController *)childViewController).delegate = self;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LKMazeConfigViewControllerDelegate

- (void)mazeConfigViewController:(LKMazeConfigViewController *)mazeConfigViewController
        generateMazeWithRowCount:(NSUInteger)rowCount
                        colCount:(NSInteger)colCount
{
    [self.mazeView drawMazeWithRowCount:rowCount colCount:colCount tileSize:TILE_SIZE];
}

@end
