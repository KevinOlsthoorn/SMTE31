//
//  City.h
//  HellGlow World
//
//  Created by Kevin Olsthoorn on 14-02-14.
//
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property NSString* name;
@property NSInteger population;
@property NSMutableArray* glowActs;

-(void) showInfo;

@end
