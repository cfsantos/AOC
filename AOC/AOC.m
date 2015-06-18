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
        
        //set initial ants
        for (int counter = 0; counter < numberOfAnts; counter++) {
            Ant *anAnt = [Ant new];
            anAnt.firstCity = counter;
            anAnt.actualCity = counter;
            [array addObject:anAnt];
        }
        self.listOfAnts = [array copy];
        array = nil;
        
        //set best path size to an infinity value
        self.bestPathSize = INFINITY;
        
        //set up all distances between cities
        [self setDistanceBetweenCitiesFromFileName:@"cities"];
        
        //set up initial pheromone path
        [self setInitialPheromone];
        
        //set up the helper of cities not visited
        self.citiesNotVisited = [self initialCitiesNotVisited];
        
        //set up an initial path for all ants
        for (Ant *anAnt in self.listOfAnts) {
            [self buildPathForAnt:anAnt];
        }
        
        //get the best path for initial ants
        [self bestValues];
    }
    
    
    
    return self;
}

//creates a initial value for pheromones
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

//sets initial cities for ants
-(NSArray *)initialCitiesNotVisited{
    NSMutableArray *returnValue = [NSMutableArray new];
    for (int counter = 0; counter < NUMBEROFPOINTS; counter++) {
        returnValue[counter] = @(counter);
    }
    
    return [returnValue copy];
}

//builds a new path for an ant
-(void)buildPathForAnt:(Ant *)ant{
    
    //copy the array of cities not visited
    NSMutableArray *citiesNotVisited = [self.citiesNotVisited mutableCopy];
    
    //first city is already visited, so removes it form cities not visited and add to the list of cities that this ant has visited
    [citiesNotVisited removeObject:@(ant.firstCity)];
    [ant.visitedCities addObject:@(ant.firstCity)];
    
    
    NSMutableArray *arrayOfChances = [NSMutableArray new];
    float probabilityInThisPosition = 0;
    
    while ([citiesNotVisited count] > 0) {
        //repeat until this ant visit all cities
        for (int x = 0; x < [citiesNotVisited count]; x++) {
            
            float pheromoneQuantity = [self pheromoneLevelFromCity:ant.actualCity
                                                            toCity:[citiesNotVisited[x] intValue]];
            
            float cityVisibility = [self cityVisibilityFromCity:ant.actualCity
                                                         toCity:[citiesNotVisited[x] intValue]];
            
            float sumOfChances = [self sumOfChancesForAnt:ant];
            
            float probability = pheromoneQuantity * cityVisibility / sumOfChances;
            if ([citiesNotVisited[x] intValue] == ant.firstCity) {
                probability = -1;
                [arrayOfChances addObject:@(probability)];
            } else {
                probabilityInThisPosition += probability;
                [arrayOfChances addObject:@(probabilityInThisPosition)];
            }
            
            
        }

        float target = [self randonBetweenMinimunValue:0 andMaximunValue:1];
        
        for (int x = 0; x < [citiesNotVisited count]; x++){
            //get chances of this city to be the next city to be visited
            float chances = [arrayOfChances[x] floatValue];
            
            //condition of visit: if randon value is smaller than the chance, then this is the city to be visited
            if (target < chances) {
                
                //get the number of the next city
                int nextCity = [citiesNotVisited[x] intValue];
                
                //increment pathSize of this ant by adding the distance from actual city to the next city
                ant.pathSize += distanceBetweenCities[ant.actualCity][nextCity];
                
                //add the next city to the list of cities this ant already visited
                [ant.visitedCities addObject:citiesNotVisited[x]];
                
                //moves ant to the next city
                ant.actualCity = nextCity;
                
                //removes next city from the list of cities already visited by this ant
                [citiesNotVisited removeObjectAtIndex:x];
                
                //stop condition
                x = [citiesNotVisited count] + 1;
            }
        }
        
        //set the path from last city to the fisrt city
        [self setLastCityForAnt:ant];
    }
    
    //NSLog(@"Path for ant %i: %f - path: %@", ant.firstCity, ant.pathSize, ant.visitedCities);
    NSLog(@"Path for ant %i: %f ", ant.firstCity, ant.pathSize);
    
}

//set the path from last city to the fisrt city
-(void)setLastCityForAnt:(Ant *)ant{
    
    //add the distance from the last visited city to first city
    ant.pathSize += distanceBetweenCities[ant.actualCity][ant.firstCity];
    
    //update visited cities
    [ant.visitedCities addObject:@(ant.firstCity)];
}

//gets the file and set the distances from all cities
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
    
}

//returns the distance based on coordinates from city1 and city2
-(float)distanceBetweenCitiesWithXpoint1:(float)xPoint1
                                 yPoint1:(float)yPoint1
                                 xPoint2:(float)xPoint2
                                 yPoint2:(float)yPoint2{
    
    float part1 = powf((xPoint1 - xPoint2), 2);
    float part2 = powf((yPoint1 - yPoint2), 2);
    
    return sqrtf(part1 + part2);
    
}

//set the matrix of distances of all cities
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

-(float)sumOfChancesForAnt:(Ant *)ant{
    float returnValue = 0;
    for (int counter = 0; counter < NUMBEROFPOINTS; counter++) {
        if (![ant.visitedCities containsObject:@(counter)]) {
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
    if (distance == 0) {
        return 0;
    }
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

#pragma mark - best values

-(void)bestValues{
    for (Ant *anAnt in self.listOfAnts) {
        if (anAnt.pathSize < self.bestPathSize) {
            self.bestPathSize = anAnt.pathSize;
            self.bestPath = anAnt.visitedCities;
        }
    }
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
