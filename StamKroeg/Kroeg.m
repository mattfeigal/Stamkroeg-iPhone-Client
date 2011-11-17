//
//  Kroeg.m
//  StamKroeg
//
//  Created by Matt Feigal on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Kroeg.h"

@implementation Kroeg


@synthesize name, coordinate;


-(id) init;
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(43.07, -89.32) name:@"The Soundgarden"];
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate name:(NSString *)aName
{
    self = [super init];
    if (self) {
        
        coordinate = aCoordinate;
        [self setName:aName];
    }
    return self;
}


@end
