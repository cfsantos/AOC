//
//  AOC.h
//  AOC
//
//  Created by Claudio Filipi Goncalves dos Santos on 6/15/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ant.h"


@interface AOC : NSObject{
    float cityPoint[NUMBEROFPOINTS][2];
    float distanceBetweenCities[NUMBEROFPOINTS][NUMBEROFPOINTS];
    float pheromone[NUMBEROFPOINTS][NUMBEROFPOINTS];
}

//array of ants
@property(nonatomic, strong)NSArray *listOfAnts;

//helper that returns the list of all cities
@property(nonatomic, strong)NSArray *citiesNotVisited;

//best path found
@property(nonatomic, strong)NSArray *bestPath;

//size of the best path
@property(nonatomic)float bestPathSize;


-(instancetype)initWithNumberOfAnts:(int)numberOfAnts;
-(void)findBestPath;


@end
