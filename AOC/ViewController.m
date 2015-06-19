//
//  ViewController.m
//  AOC
//
//  Created by Claudio Filipi Goncalves dos Santos on 6/15/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import "ViewController.h"
#import "AOC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AOC *aoc = [[AOC alloc] initWithNumberOfAnts:NUMBEROFPOINTS];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [aoc findBestPath];
        NSLog(@"best path size = %f", aoc.bestPathSize);
    });
    
    
    
    
    //[aoc setDistanceBetweenCitiesFromFileName:@"cities"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
