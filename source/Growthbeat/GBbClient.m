//
//  GBClient.m
//  Growthbeat
//
//  Created by Naoyuki Kataoka on 2014/06/13.
//  Copyright (c) 2014 SIROK, Inc. All rights reserved.
//

#import "GBClient.h"
#import "GBUtils.h"
#import "GBHttpClient.h"

@implementation GBClient

@synthesize id;
@synthesize applicationId;
@synthesize modified;
@synthesize created;

+ (GBClient *)createWithApplicationId:(NSString *)applicationId secret:(NSString *)secret {
    
    NSString *path = @"/1/clients";
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    
    if (applicationId) {
        [body setObject:applicationId forKey:@"applicationId"];
    }
    if (secret) {
        [body setObject:secret forKey:@"secret"];
    }
    
    GBHttpRequest *httpRequest = [GBHttpRequest instanceWithRequestMethod:GBRequestMethodPost path:path query:nil body:body];
    
    GBHttpResponse *httpResponse = [[GBHttpClient sharedInstance] httpRequest:httpRequest];
    if(!httpResponse.success){
        // TODO hanlde errors
        NSLog(@"%@", httpResponse.error);
        return nil;
    }
    
    GBClient *client = [GBClient domainWithDictionary:httpResponse.body];
    return client;
    
}

- (id) initWithDictionary:(NSDictionary *)dictionary {

    self = [super init];
    if (self) {
        if ([dictionary objectForKey:@"id"] && [dictionary objectForKey:@"id"] != [NSNull null]) {
            self.id = [dictionary objectForKey:@"id"];
        }
        if ([dictionary objectForKey:@"applicationId"] && [dictionary objectForKey:@"applicationId"] != [NSNull null]) {
            self.applicationId = [dictionary objectForKey:@"applicationId"];
        }
        if ([dictionary objectForKey:@"modified"] && [dictionary objectForKey:@"modified"] != [NSNull null]) {
            self.modified = [GBDateUtils dateWithDateTimeString:[dictionary objectForKey:@"modified"]];
        }
        if ([dictionary objectForKey:@"created"] && [dictionary objectForKey:@"created"] != [NSNull null]) {
            self.created = [GBDateUtils dateWithDateTimeString:[dictionary objectForKey:@"created"]];
        }
    }
    return self;

}

#pragma mark --
#pragma mark NSCoding

- (id) initWithCoder:(NSCoder *)aDecoder {

    self = [super init];
    if (self) {
        if ([aDecoder containsValueForKey:@"id"]) {
            self.id = [aDecoder decodeObjectForKey:@"id"];
        }
        if ([aDecoder containsValueForKey:@"applicationId"]) {
            self.applicationId = [aDecoder decodeObjectForKey:@"applicationId"];
        }
        if ([aDecoder containsValueForKey:@"modified"]) {
            self.modified = [aDecoder decodeObjectForKey:@"modified"];
        }
        if ([aDecoder containsValueForKey:@"created"]) {
            self.created = [aDecoder decodeObjectForKey:@"created"];
        }
    }
    return self;

}

- (void) encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:id forKey:@"id"];
    [aCoder encodeObject:applicationId forKey:@"applicationId"];
    [aCoder encodeObject:modified forKey:@"modified"];
    [aCoder encodeObject:created forKey:@"created"];

}

@end