//
//  City.m
//  HellGlow World
//
//  Created by Kevin Olsthoorn on 14-02-14.
//
//

#import "City.h"
#import "GlowAct.h"

@implementation City

-(void) showInfo {
    if (self.glowActs.count == 1) // If amount of acts equals 1.
        NSLog(@"In the city of %@ there are currently living %ld people. There is 1 act", self.name, self.population);
    else // If amount of acts are not 1 (more or less).
        NSLog(@"In the city of %@ there are currently living %ld people. There are %ld acts", self.name, self.population, self.glowActs.count);
    
    NSLog(@"------- Act information -------");
    for (NSInteger i = 0; i < self.glowActs.count; i++)
    {
        GlowAct* currentAct = [self.glowActs objectAtIndex:i];
        NSLog(@"- Act nr. %ld:", i+1);
        [currentAct showInfo];
    }
}

-(id) init {
    // Basic constructor.
    if (self == [super init])
    {
        self.glowActs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
