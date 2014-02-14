//
//  City.m
//  HellGlow World
//
//  Created by Kevin Olsthoorn on 14-02-14.
//
//

#import "City.h"

@implementation City

-(void) showInfo {
    NSLog(@"In the city of %@ there are currently living %ld people.", self.name, self.population);
}

@end
