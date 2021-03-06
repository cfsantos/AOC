//
//  Ant.h
//  AOC
//
//  Created by Claudio Filipi Goncalves dos Santos on 6/15/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUMBEROFPOINTS 52

@interface Ant : NSObject{
    float chancesOfGoingToCity[NUMBEROFPOINTS];
}

@property(nonatomic, strong)NSMutableArray *visitedCities;
@property(nonatomic, strong)NSMutableArray *citiesNotVisited;
@property(nonatomic)float pathSize;
@property(nonatomic)int firstCity;
@property(nonatomic)int actualCity;

-(void)setChances:(float)chances forCity:(int)city;
-(instancetype)init;

@end
