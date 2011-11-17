//
//  Person.m
//  StamKroeg
//
//  Created by Matt Feigal on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"


@implementation Person


@synthesize firstName, lastName, age, personID;


-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}


@end
