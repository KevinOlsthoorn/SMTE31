//
//  GlowAct.m
//  HellGlow World
//
//  Created by Kevin Olsthoorn on 14-02-14.
//
//

#import "GlowAct.h"

@implementation GlowAct

-(void) showInfo {
    NSLog(@"The act is called %@ and wil start at %@. People gave it a rating of %ld.", self.name, self.startTime, self.rating);
}

@end
