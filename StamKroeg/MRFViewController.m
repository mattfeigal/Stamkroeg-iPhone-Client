//
//  MRFViewController.m
//  StamKroeg
//
//  Created by Matt Feigal on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MRFViewController.h"
#import "Person.h"

@implementation MRFViewController

@synthesize responseData, people, stamKroeg;

//If you need this URL outside of this class, declare it as extern in the interface file.
//NSString * const kMRFDataSource = @"http://dl.dropbox.com/u/45384685/json/stamkroeg.txt";
//NSString * const kMRFDataSource = @"http://localhost/~glmt/json/stamkroeg.txt";
//NSString * const kMRFDataSource = @"http://192.168.1.183/~glmt/json/sample.txt";
NSString * const kMRFDataSource = @"http://10.0.1.6:9292/checkins.json?lat=4.8917959&lng=52.3629809";

-(IBAction)loadData:(id)sender
{
    NSLog(@"Hi there");
    
    jsonData = [[NSMutableData alloc] init];
    
    NSURLRequest *postRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kMRFDataSource]];
    
    connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self startImmediately:YES];
    


        
}


-(IBAction)setStamkroeg:(id)sender
{
    NSLog(@"Setting location!");
    stamKroeg = nil;
    //[self findLocation];
    [locationManager startUpdatingLocation];
}



- (IBAction)checkMyLocation:(id)sender {
    NSLog(@"Checking location!");
    //[self findLocation];
    [locationManager startUpdatingLocation];

    
}




-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        //Not necessary to start at the moment - the MKMapView knows how to locate itself
        //[locationManager startUpdatingLocation];
        
        people = [[NSMutableArray alloc] init];
//        Person *karin = [[Person alloc] init];
//        [karin setFirstName:@"karin"];
//        [karin setLastName:@"van der meer"];
//        [people addObject:karin];
                         
        
    }
    
    return self;
}

-(void)findLocation
{

    //wipe out old stamKroeg data, and create it again from locationmanager data.
    [locationManager startUpdatingLocation];
    //[activityIndicator startAnimating];
    //[locationTitleField setHidden:YES];
}

-(void)foundLocation:(CLLocation *)loc
{
    
    //The CLLocation calls DidUpdateToLocation method on this class as the callback. Therefore unless I want to make a second class, I need to do some annoying logic with the feedback information. BOTH buttons call the startUpdatingLocation, but I need to check state of variables to see if I am updating the StamKroeg or checking other locations.
    
    CLLocationCoordinate2D coord = [loc coordinate];
    
    if (!stamKroeg)
    {
        //Kroeg *kr = [[Kroeg alloc] initWithCoordinate:coord name:@"Bergse bossen"];
        stamKroeg = [[Kroeg alloc] initWithCoordinate:coord name:@"Bergse bossen"];
        [labelStamKroeg setText:[NSString stringWithFormat:@"φ:%.4F, λ:%.4F", coord.latitude, coord.longitude]];  
    }
    

    CLLocation *oldKroegLocation = [[CLLocation alloc] initWithLatitude:stamKroeg.coordinate.latitude longitude:stamKroeg.coordinate.longitude];
    CLLocationDistance meters = [loc distanceFromLocation:oldKroegLocation];
                                                           
                                                           
    [labelCurrentLocation setText:[NSString stringWithFormat:@"φ:%.4F, λ:%.4F\n%.1F meters distance", coord.latitude, coord.longitude, meters]]; 
      
    //For now, stop updating location. But I want to try tracking this every few minutes, so add a button later!
    [locationManager stopUpdatingLocation];
    
}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //wipe out previous data
    [jsonData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [jsonData appendData:data];
    
}
- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
//Do we still need to release connections now?
//    [connection release];
  
    NSLog(@"Error: %@", [error localizedDescription]);
    jsonData = nil;
    conn = nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Received data: %@", jsonString);

    NSError *jsonParsingError = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParsingError];
    
    NSArray *peopleDicts = [jsonDict objectForKey:@"people"];
    for (NSDictionary *personDict in peopleDicts)
    {
        //NSNumber *personDictID = [personDict objectForKey:@"id"];
        //NSString *personDictFirstName = [personDict objectForKey:@"firstName"];
        
        //NSLog(@"ID %@: %@", personDictID, personDictFirstName);
        
        Person *person = [[Person alloc] init];
        //[person setPersonID:personDictID];
        [person setFirstName:[personDict objectForKey:@"name"]];
        [person setLastName:[personDict objectForKey:@"mobile_number"]];
        
        [people addObject:person];
        NSLog(@"Added %@", [person description]);
        
    }
    
    //Should probably do something much fancier....
    //[labelOutput setText:@"Data received"];
    
    //Refresh the table
    [tableViewOutlet reloadData];
    //Hmmm. This doesn't work. I think I need to hand off the change to the TableView
//    [[self tableViewOutlet] reloadData];
    
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return  [[[BNRItemStore defaultStore] allItems] count];
    return [people count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Create an instance of UITableViewCell, with default appearance
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    //check for a reusable cell first, use that if it exists.
    UITableViewCell *cell = [tableViewOutlet dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:@"UITableViewCell"];
    }
    //set the text on the cell with the description of the item
    //that is at the nth index of the items, where n = row that this cell
    //will appear in on the tableview
    
    //BNRItem *p = [[[BNRItemStore defaultStore] allItems] objectAtIndex:[indexPath row]];
    Person *p = [people objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[p description]];
    
    return cell;
}
 
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@", newLocation);
    
    //How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    //CLLocationManagers will return the last found location of the
    //device first, you don't want the data in this case. 
    //If this location was made more than 3 minutes ago, ignore it
    if(t< -180) {
        //This is cached data, you don't want it, keep looking
        return;
    }
    [self foundLocation:newLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
}



#pragma mark - View lifecycle


-(void)dealloc
{
    //Hey, we are stopping - Stop sending me messages, locationManager!
    [locationManager setDelegate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    labelStamKroeg = nil;
    labelCurrentLocation = nil;
    tableViewOutlet = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
