ObjC-Client
===========

This is the start of an Objective-C Client to access the Mojio API

Installation
============
Download or checkout the MojioClient.h and .m files.

Getting Started
============
To begin developing with the client, you will need your own application ID and secret key. First you will need to create an account and login to the mojio developer center. You may want to start out with their sandbox environment (http://sandbox.developer.moj.io/).

Once you have logged in, you can create a new Application. From here, you will want to copy the Application ID and the Secret Key, these will be required to initialize the client.

Initializing the Client
============
To get started with the client you must initialize an instane of the MojioClient object. Initialization is done the usual way.
``` objective-c
MojioClient *client = [[MojioClient alloc] init];
```
For our project, we created a singleton class with a client property and initialized a single client as such.
``` objective-c
-(MojioClient *) client
{
    if (!_client) _client = [[MojioClient alloc] init];
    [_client initialize];
    return _client;
}
```

Authenticate a Mojio User
============
Now with the client you can make a call to log a user in and recieve an API key.
``` objective-c
NSString *response = [self.client getAPIToken:username AndPassword:password];
self.client.apiToken = response;
```

Fetching Data
============
You can get data from the mojio server from all your trips, or get a trip ID and get more detailed information about that trip.
``` objective-c
//get the trips
NSMutableArray* tripData = [[[[Session sharedInstance] client] getTripData] objectForKey:@"Data"];
if ([tripData count] < 1) {
   // self.tripDataTextView.text = @"No trip data";
    return false;
}
//get the ID for the most recent trip
NSString* tripIDString = [((NSMutableDictionary*)[tripData objectAtIndex:[tripData count]-1]) objectForKey:@"_id"];
    
//get the events for that most recent trip
NSMutableDictionary* tripEvents = [[[Session sharedInstance] client] getEventDataForTrip:tripIDString];
NSMutableArray* tripEventsArray = [tripEvents objectForKey:@"Data"];
```

Using the Mojio Storage
============
With the Mojio API, you are able to store your own private data within their database as key value pairs. These key value pairs will only be accessible by your application.
``` objective-c

//get dict containing all the device data to store to Mojio server
NSDictionary *mojioData = [[NSMutableDictionary alloc] init];
mojioData = [self.device createMojioDictionary];
    
// send a request to mojio server to update the value
if (![[[Session sharedInstance] client] storeMojio:self.device.idNumber andKey:@"deviceData" andValue:mojioData]) {
    NSLog(@"An error occurred during storing");
}
```
``` objective-c
deviceData = [[[Session sharedInstance] client] getStoredMojio:self.idNumber andKey:@"deviceData"];
```