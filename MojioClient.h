//
//  MojioClient.h
//  mojioTesting
//
//  Created by Flynn Howling on 11/7/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MojioClient : NSObject

//@property (strong, nonatomic) NSString *appID, *secretKey, *apiToken;
@property int pagesize;

-(NSString*)getAPIToken:(NSString*)username AndPassword:(NSString*)password;
-(NSMutableDictionary*)getTripData;
-(NSMutableDictionary*)getEventDataForTrip:(NSString*)tripID;
-(NSMutableDictionary*)getUserData;
-(NSMutableDictionary*)getDevices;

-(BOOL)isUserLoggedIn;


-(BOOL)storeMojio:(NSString*)deviceID andKey:(NSString*)key andValue:(NSDictionary*)data;
-(NSString*)getStoredMojio:(NSString*)deviceID andKey:(NSString*)key;
-(BOOL)deleteStoredMojio:(NSString*)deviceID andKey:(NSString*)key;




// CLEANING IN PROCESS
@property (nonatomic) NSString *Mojio, *appID, *secretKey, *apiToken, *minutes;
-(void) initialize;
-(NSString*) getURL:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key;


-(NSData*)sendRequest:(NSString*)url andData:(NSString*) data andMethod:(NSString*) method;

-(NSString*)dataByMethodDict:(NSDictionary*)dict andMethod:(NSString*) method;

-(NSData*)get:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key;

-(BOOL)put:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key andData:(NSDictionary*)data;


@end
