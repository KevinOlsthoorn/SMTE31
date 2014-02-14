//
//  main.m
//  HellGlow World
//
//  Created by Kevin Olsthoorn on 14-02-14.
//
//

#import <Foundation/Foundation.h>
#import "GlowAct.h"
#import "City.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Log the string HellGlow, World!
        NSLog(@"HellGlow, World!");
        
        // Creating the light acts and show their information.
        GlowAct* blueLightAct = [GlowAct alloc];
        blueLightAct.name = @"The Bluelight act";
        blueLightAct.startTime = @"22:20";
        blueLightAct.rating = 8;
        [blueLightAct showInfo];
        
        GlowAct* greenLightAct = [GlowAct alloc];
        greenLightAct.name = @"The Greenlight act";
        greenLightAct.startTime = @"22:50";
        greenLightAct.rating = 7;
        [greenLightAct showInfo];
        
        // Creating the city and show it's information.
        City* city = [[City alloc] init];
        city.name = @"Eindhoven";
        city.population = 220000;
        [city.glowActs addObject:blueLightAct];
        [city.glowActs addObject:greenLightAct];
        [city showInfo];
        
    }
    return 0;
}

