//
//  LKMazeConfigViewController.m
//  CarPark
//
//  Created by Kam on 8/28/14.
//  Copyright (c) 2014 The Kam's. All rights reserved.
//

#import "LKMazeConfigViewController.h"

#define IPAD_DEFAULT_MAZE_WIDTH 30
#define IPAD_DEFAULT_MAZE_HEIGHT 30

#define IPHONE_DEFAULT_MAZE_WIDTH 15
#define IPHONE_DEFAULT_MAZE_HEIGHT 15

@interface LKMazeConfigViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mazeWidthLabel;
@property (weak, nonatomic) IBOutlet UIStepper *mazeWidthStepper;
@property (weak, nonatomic) IBOutlet UILabel *mazeHeightLabel;
@property (weak, nonatomic) IBOutlet UIStepper *mazeHeightStepper;

@end

@implementation LKMazeConfigViewController

#pragma mark - Private methods

- (void)updateMazeSizeLabels
{
    self.mazeWidthLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.mazeWidthStepper.value];
    self.mazeHeightLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.mazeHeightStepper.value];
}

#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.mazeWidthStepper.value = IPAD_DEFAULT_MAZE_WIDTH;
        self.mazeHeightStepper.value = IPAD_DEFAULT_MAZE_HEIGHT;
    } else {
        self.mazeWidthStepper.value = IPHONE_DEFAULT_MAZE_WIDTH;
        self.mazeHeightStepper.value = IPHONE_DEFAULT_MAZE_HEIGHT;
    }
    
    
    [self updateMazeSizeLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)mazeWidthChanged
{
    [self updateMazeSizeLabels];
}

- (IBAction)mazeHeightchanged
{
    [self updateMazeSizeLabels];
}

- (IBAction)generateMaze
{
    [self.delegate mazeConfigViewController:self
                   generateMazeWithRowCount:(unsigned long)self.mazeHeightStepper.value
                                   colCount:(unsigned long)self.mazeWidthStepper.value];
}

@end
