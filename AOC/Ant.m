//
//  Ant.m
//  AOC
//
//  Created by Claudio Filipi Goncalves dos Santos on 6/15/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import "Ant.h"

@implementation Ant

-(void)setChances:(float)chances forCity:(int)city{
    chancesOfGoingToCity[city] = chances;
}

@end
