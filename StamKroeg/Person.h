//
//  Person.h
//  StamKroeg
//
//  Created by Matt Feigal on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


@interface Person : NSObject
{
    NSString *firstName;
    NSString *lastName;
    
    NSInteger age;
    NSInteger personID;
    
    
}
@property (copy) NSString *firstName, *lastName;
@property NSInteger age, personID;


@end
