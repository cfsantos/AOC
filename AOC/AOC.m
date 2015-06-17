//
//  AOC.m
//  AOC
//
//  Created by Claudio Filipi Goncalves dos Santos on 6/15/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import "AOC.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation AOC

-(instancetype)initWithNumberOfAnts:(int)numberOfAnts{
    self = [super init];
    if (self) {
        NSMutableArray *array = [NSMutableArray new];
        for (int counter = 0; counter < numberOfAnts; counter++) {
            Ant *anAnt = [Ant new];
            anAnt.firstCity = counter;
            anAnt.actualCity = counter;
            [array addObject:anAnt];
        }
        self.listOfAnts = [array copy];
        array = nil;
        
        self.citiesNotVisited = [self initialCitiesNotVisited];
    }
    
    return self;
}

-(void)setInitialPheromone{
    for (int x = 0; x < NUMBEROFPOINTS; x++) {
        for (int y = 0; y < NUMBEROFPOINTS; y++) {
            if (x == y) {
                pheromone[x][y] = 0;
            } else {
                pheromone[x][y] = 0.000000001;
            }
        }
    }
}

-(NSArray *)initialCitiesNotVisited{
    NSMutableArray *returnValue = [NSMutableArray new];
    for (int counter = 0; counter < NUMBEROFPOINTS; counter++) {
        returnValue[counter] = @(counter);
    }
    
    return [returnValue copy];
}

-(void)buildPathForAnt:(Ant *)ant{
    NSMutableArray *citiesNotVisited = [self.citiesNotVisited mutableCopy];
    [citiesNotVisited removeObject:@(ant.firstCity)];
    [ant.visitedCities addObject:@(ant.firstCity)];
    
    NSMutableArray *arrayOfChances = [NSMutableArray new];
    
    for (int x = 0; x < NUMBEROFPOINTS; x++) {
        
        float pheromoneQuantity = [self pheromoneLevelFromCity:ant.actualCity toCity:x];
        float cityVisibility = [self cityVisibilityFromCity:ant.actualCity toCity:x];
        float sumOfChances = [self sumOfChancesForAnt:ant];
        
        float probability = pheromoneQuantity * cityVisibility / sumOfChances;
        if (x == ant.firstCity) {
            probability = 0;
        }
        
        [arrayOfChances addObject:@(probability)];
    }
    float sumOfChances = [self sumOfChancesForAnt:ant];
    float target = [self randonBetweenMinimunValue:0 andMaximunValue:sumOfChances];
    
    for (int x = 0; x < NUMBEROFPOINTS; x++){
        //TODO: get point for this chance
        
    }
    
}

-(void)setDistanceBetweenCitiesFromFileName:(NSString *)fileName{
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"txt"];
    
    NSString *fileString = [NSString stringWithContentsOfFile:path
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    NSArray *fileComponents = [fileString componentsSeparatedByString:@"\n"];
    
    int counter = 0;
    for (NSString *aLine in fileComponents) {
        NSArray *fileComponents = [aLine componentsSeparatedByString:@" "];
        cityPoint[counter][0] = [fileComponents[1] floatValue];
        cityPoint[counter][1] = [fileComponents[2] floatValue];
        counter++;
    }
    
    [self setDistanceBetweenCities];
    
    NSLog(@"Cities points: %f", cityPoint);
    
}

-(float)distanceBetweenCitiesWithXpoint1:(float)xPoint1
                                 yPoint1:(float)yPoint1
                                 xPoint2:(float)xPoint2
                                 yPoint2:(float)yPoint2{
    
    float part1 = powf((xPoint1 - xPoint2), 2);
    float part2 = powf((yPoint1 - yPoint2), 2);
    
    return sqrtf(part1 + part2);
    
}

-(void)setDistanceBetweenCities{
    for (int x = 0; x < NUMBEROFPOINTS; x++) {
        for (int y = 0; y< NUMBEROFPOINTS; y++) {
            distanceBetweenCities[x][y] = [self distanceBetweenCitiesWithXpoint1:cityPoint[x][1]
                                                                         yPoint1:cityPoint[x][2]
                                                                         xPoint2:cityPoint[y][1]
                                                                         yPoint2:cityPoint[y][2]];
        }
    }
}

#pragma mark - walking into cities

-(void)nextAntsCity{
    for (Ant *anAnt in self.listOfAnts) {
        for (int counter = 0; counter < NUMBEROFPOINTS; counter++) {
            
            //if this ant didn't visited this city
            if (![anAnt.visitedCities containsObject:@(counter)]) {
                float pheromoneQuantity = [self pheromoneLevelFromCity:anAnt.actualCity toCity:counter];
                float cityVisibility = [self cityVisibilityFromCity:anAnt.actualCity toCity:counter];
                float sumOfChances = [self sumOfChancesForAnt:anAnt];
                
                float probability = pheromoneQuantity * cityVisibility / sumOfChances;
                
            } else {
                //city already visited, chances are 0
                [anAnt setChances:0 forCity:counter];
            }
        }
    }
}

-(float)sumOfChancesForAnt:(Ant *)ant{
    float returnValue = 0;
    for (int counter = 0; counter < NUMBEROFPOINTS; counter++) {
        if ([ant.visitedCities containsObject:@(counter)]) {
            if (ant.actualCity != counter) {
                float pheromoneQuantity = [self pheromoneLevelFromCity:ant.actualCity toCity:counter];
                float cityVisibility = [self cityVisibilityFromCity:ant.actualCity toCity:counter];
                returnValue += pheromoneQuantity * cityVisibility;
            }
            
        }
    }
    return returnValue;
}

-(float)pheromoneLevelFromCity:(int)fromCity toCity:(int)toCity{
    return pheromone[fromCity][toCity];
}

-(float)cityVisibilityFromCity:(int)fromCity toCity:(int)toCity{
    float distance = distanceBetweenCities[fromCity][toCity];
    return [self cityVisibilityForDistance:distance];
}

-(float)cityVisibilityForDistance:(float)distance{
    return 1/distance;
}

-(float)chancesOfGointToCity:(int)toCity fromCity:(int)fromCity{
    return 0;
}

-(void)updatePheromone{
    
    
}

#pragma mark - utils

-(int)randonIntBetweenLowerBound:(int)lowerBound andUpperBound:(int)upperBound{
    return lowerBound + arc4random() % (upperBound - lowerBound);
}

//generates a float randon between 2 values
-(float)randonBetweenMinimunValue:(float)minimunValue andMaximunValue:(float)maximunValue{
    return ((float)arc4random() / ARC4RANDOM_MAX * (maximunValue - minimunValue)) + minimunValue;
}

@end
