//
//  AOC.h
//  AOC
//
//  Created by Claudio Filipi Goncalves dos Santos on 6/15/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUMBEROFPOINTS 52
@interface AOC : NSObject{
    float cityPoint[NUMBEROFPOINTS][2];
    float distanceBetweenCities[NUMBEROFPOINTS][NUMBEROFPOINTS];
}

-(void)setDistanceBetweenCitiesFromFileName:(NSString *)fileName;

@end
