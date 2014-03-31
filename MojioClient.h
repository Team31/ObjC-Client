//
//  MojioClient.h
//  mojioTesting
//
//  Created by Flynn Howling on 11/7/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MojioClient : NSObject

@property int pagesize;
@property (nonatomic) NSString *Mojio, *appID, *secretKey, *apiToken, *minutes;

-(void) initialize;
-(NSString*)getAPITokenWithUsername:(NSString*)username AndPassword:(NSString*)password;
-(NSMutableDictionary*)getTripData;
-(NSMutableDictionary*)getEventDataForTripWithTripID:(NSString*)tripID;
-(NSMutableDictionary*)getUserData;
-(NSMutableDictionary*)getDevices;
-(BOOL)isUserLoggedIn;
-(BOOL)storeMojioWithDeviceID:(NSString*)deviceID andKey:(NSString*)key andValue:(NSDictionary*)data;
-(NSString*)getStoredMojioWithDeviceID:(NSString*)deviceID andKey:(NSString*)key;
-(BOOL)deleteStoredMojioWithDeviceID:(NSString*)deviceID andKey:(NSString*)key;

    
// internal methods
-(NSString*) getURLWithController:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key;
-(NSData*)sendRequestWithURL:(NSString*)url andData:(NSString*) data andMethod:(NSString*) method andPageSize:(NSString*)pageSize;
-(NSString*)dataByMethodDictWithDict:(NSDictionary*)dict andMethod:(NSString*)method;
-(NSData*)getWithController:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key andPageSize:(NSString*)pageSize;
-(BOOL)putWithController:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key andData:(NSDictionary*)data;
-(BOOL)postWithController:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key andData:(NSDictionary*)data;


@end
