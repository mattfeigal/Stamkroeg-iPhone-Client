//
//  Kroeg.h
//  StamKroeg
//
//  Created by Matt Feigal on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface Kroeg : NSObject

//the designated init
-(id) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate name:(NSString *)name;

@property (nonatomic, copy) NSString *name;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
