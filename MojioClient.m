//
//  MojioClient.m
//  mojioTesting
//
//  Created by Flynn Howling on 11/7/2013.
//  Copyright (c) 2013 team31. All rights reserved.
//

#import "MojioClient.h"

@interface MojioClient()
//The interface within an implementation file is used to store private data
@property NSMutableData *responseData;
@property NSURLConnection *tripConnection;

@end

@implementation MojioClient

-(NSString*)getAPIToken:(NSString*)username AndPassword:(NSString*)password
{
    NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/login/%%7Bid%%7D/begin?id=%@&secretKey=%@&userOrEmail=%@&password=%@&minutes=120",self.appID, self.secretKey, username, password];
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error=nil;
    id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
    if ([response objectForKey:@"_id"]) {
        return [response objectForKey:@"_id"];
    }

    return @"";
}

-(NSMutableDictionary*)getTripData
{
    NSData *returnData = [self get:@"trips" andID:nil andAction:nil andKey:nil];
    id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                     NSJSONReadingMutableContainers error:nil];
    return responseData;
}

-(NSMutableDictionary*)getEventDataForTrip:(NSString*)tripID
{
    //TODO pagesize should be a variable
    NSData *returnData = [self get:@"trips" andID:tripID andAction:@"events" andKey:nil];
    id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                     NSJSONReadingMutableContainers error:nil];
    
    return responseData;
}


-(NSMutableDictionary*)getUserData
{
    //TODO pagesize should be variable
    NSData *returnData = [self get:@"users" andID:nil andAction:nil andKey:nil];
    id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                     NSJSONReadingMutableContainers error:nil];
    return responseData;
}

-(NSMutableDictionary*)getDevices
{
     //TODO pagesize should be variable
     NSData *returnData = [self get:@"mojios" andID:nil andAction:nil andKey:nil];
        
     id responseData=[NSJSONSerialization JSONObjectWithData:returnData options:
                         NSJSONReadingMutableContainers error:nil];
     return responseData;
}

-(BOOL)isUserLoggedIn{
    //if you can get the user data with the current API, the user is logged in
    if ([[self getUserData] objectForKey:@"Data"]) {
        return true;
    }
    return false;
}

-(BOOL)storeMojio:(NSString*)deviceID andKey:(NSString*)key andValue:(NSDictionary*)data{
    // store a key value pair for a device
    // use getStoredMojio with the deviceID key to grab the value
    BOOL status = [self put:@"mojios" andID:deviceID andAction:@"store" andKey:key andData:data];
    return status;
}

-(NSString*)getStoredMojio:(NSString*)deviceID andKey:(NSString*)key{
    NSData *returnData = [self get:@"mojios" andID:deviceID andAction:@"store" andKey:@"deviceData"];
        
    NSString* value=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return value;
}

-(BOOL)deleteStoredMojio:(NSString*)deviceID andKey:(NSString*)key{
    if (self.apiToken) {
        NSString *str = [NSString stringWithFormat:@"http://sandbox.developer.moj.io/v1/mojios/%@/store/%@",deviceID, key];
        NSURL *url = [NSURL URLWithString:str];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [mutableRequest setHTTPMethod:@"DELETE"];
        
        request = [mutableRequest copy];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        // if no response text is given, the put was successful
        if (returnString.length == 0) {
            return true;
        } else {
            return false;
    
        }
    }
    else
    {
        NSLog(@"No user data recieved");
        return false;
    }
}


// initialize all static variables
-(void)initialize{
// initialize all necessary variables
    
    self.Mojio = @"http://sandbox.developer.moj.io/v1";
    self.appID = @"87708830-31B7-464F-85D3-9E8FD22A2A10";
    self.secretKey = @"c861e8a6-e230-4bd4-9c7c-241144071254";
    self.minutes = @"120"; // int32
    
}

// get the request url from the controller (e.g. mojios, apps, login), id, action and key
-(NSString*) getURL:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key {
    
    NSMutableString * url = [[NSMutableString alloc] init];
    [url appendString:(self.Mojio)];

    if ([key length] != 0 && [ID length] != 0 && [action length] != 0) {
        // controller/id/action/action
        [url appendString:@"/"];
        [url appendString:[controller stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"/"];
        [url appendString:[ID stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"/"];
        [url appendString:[action stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"/"];
        [url appendString:[key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else if ([ID length] != 0 && [action length] != 0) {
        // controller/id/action
        [url appendString:@"/"];
        [url appendString:[controller stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"/"];
        [url appendString:[ID stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"/"];
        [url appendString:[action stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    } else if ([ID length] != 0) {
        // controller/id
        [url appendString:@"/"];
        [url appendString:[controller stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"/"];
        [url appendString:[ID stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else if ([action length] != 0) {
        // controller/action
        [url appendString:@"/"];
        [url appendString:[controller stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [url appendString:@"/"];
        [url appendString:[action stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        // controller
        [url appendString:@"/"];
        [url appendString:[controller stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    }
    
    return url;
}

-(NSData*)sendRequest:(NSString*)url andData:(NSString*) data andMethod:(NSString*) method{
    if (self.apiToken) {
    
        if ([method length] == 0)
            method = @"GET";
        
        NSURL *requestUrl = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];

        // set request body data if it's a post or put
        if ([method isEqualToString:@"PUT" ] || [method isEqualToString:@"POST"]) {
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\"%@\"",data] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody: body];
        } else if([method isEqualToString:@"GET"]) {
            // put page limit, desc and page size here
        }
        
        [request addValue:self.apiToken forHTTPHeaderField:@"MojioAPIToken"];
        [request setHTTPMethod:method];
        
        NSHTTPURLResponse *response = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

        return returnData;

    } else {
        NSLog(@"No user data received");
        return nil;
    }
    
}

// convert dictionary to string
-(NSString*)dataByMethodDict:(NSDictionary*)dict andMethod:(NSString*) method{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict                                                  options:0 error:nil];
    
    if (! jsonData) {
        NSLog(@"Got an error");
        return @"";
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *escaped = [[jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\\n"];
        
        return escaped;
    }
}

-(NSData*)get:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key{
    if (self.apiToken) {
        
        NSData *returnData = [self sendRequest:[self getURL:controller andID:ID andAction:action andKey:key] andData:nil andMethod:@"GET"];
        
        return returnData;
    }
    else
    {
        NSLog(@"No user data recieved");
        return nil;
    }
}

-(BOOL)put:(NSString*)controller andID:(NSString*)ID andAction:(NSString*)action andKey:(NSString*)key andData:(NSDictionary*)data {
    if (self.apiToken) {
        NSData *returnData = [self sendRequest:[self getURL:controller andID:ID andAction:action andKey:key] andData:[self dataByMethodDict:data andMethod:@"PUT"] andMethod:@"PUT"];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        // if no response text is given, the put was successful
        if (returnString.length == 0) {
            return true;
        } else {
            return false;
            NSLog(@"%@", returnString);
        }
    }
    else
    {
        NSLog(@"No user data received");
        return false;
    }

}
@end
