//
//  MRFViewController.h
//  StamKroeg
//
//  Created by Matt Feigal on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Kroeg.h"
#import <CoreLocation/CoreLocation.h>

@interface MRFViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    //IBOutlet UILabel *labelOutput;
    IBOutlet UIButton *buttonCheckData;
    __weak IBOutlet UILabel *labelStamKroeg;
    __weak IBOutlet UILabel *labelCurrentLocation;
    __weak IBOutlet UITableView *tableViewOutlet;
    
    NSMutableData *jsonData;
    NSURLConnection *connection;
    NSMutableArray *people;
}
@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *people;
@property (nonatomic, retain) Kroeg *stamKroeg;


-(IBAction)loadData:(id)sender;

-(IBAction)setStamkroeg:(id)sender;
-(IBAction)checkMyLocation:(id)sender;



-(void) findLocation;
-(void)foundLocation:(CLLocation *)loc;

@end
