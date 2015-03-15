//
//  GrowthbeatCore.m
//  GrowthbeatCore
//
//  Created by Kataoka Naoyuki on 2014/06/13.
//  Copyright (c) 2014年 SIROK, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowthbeatCore.h"
#import "GBOpenUrlIntentHandler.h"
#import "GBNoopIntentHandler.h"

static GrowthbeatCore *sharedInstance = nil;
static NSString *const kGBLoggerDefaultTag = @"GrowthbeatCore";
static NSString *const kGBHttpClientDefaultBaseUrl = @"https://api.growthbeat.com/";
static NSString *const kGBPreferenceDefaultFileName = @"growthbeat-preferences";

@interface GrowthbeatCore () {
    
    GBClient *client;
    GBLogger *logger;
    GBHttpClient *httpClient;
    GBPreference *preference;
    BOOL initialized;
    
}

@property (nonatomic, strong) GBClient *client;
@property (nonatomic, strong) GBLogger *logger;
@property (nonatomic, strong) GBHttpClient *httpClient;
@property (nonatomic, strong) GBPreference *preference;
@property (nonatomic, assign) BOOL initialized;

@end

@implementation GrowthbeatCore

@synthesize client;
@synthesize logger;
@synthesize httpClient;
@synthesize preference;
@synthesize initialized;

@synthesize intentHandlers;

+ (GrowthbeatCore *) sharedInstance {
    @synchronized(self) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0f) {
            return nil;
        }
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
        return sharedInstance;
    }
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.client = nil;
        self.logger = [[GBLogger alloc] initWithTag:kGBLoggerDefaultTag];
        self.httpClient = [[GBHttpClient alloc] initWithBaseUrl:[NSURL URLWithString:kGBHttpClientDefaultBaseUrl]];
        self.preference = [[GBPreference alloc] initWithFileName:kGBPreferenceDefaultFileName];
        self.initialized = NO;
        self.intentHandlers = @[[[GBOpenUrlIntentHandler alloc] init], [[GBNoopIntentHandler alloc] init]];
    }
    return self;
}

- (void)initializeWithApplicationId:(NSString *)applicationId credentialId:(NSString *)credentialId {
    
    if (initialized) {
        [logger warn:@"GrowthbeatCore is already initialized."];
        return;
    }
    initialized = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [logger info:@"Initializing... (applicationId:%@)", applicationId];
        
        self.client = [GBClient load];
        if (client && [client.application.id isEqualToString:applicationId]) {
            [logger info:@"Client already exists. (id:%@)", client.id];
            return;
        }
        
        [preference removeAll];
        
        [logger info:@"Creating client... (applicationId:%@)", applicationId];
        self.client = [GBClient createWithApplicationId:applicationId credentialId:credentialId];
        if(!client) {
            [logger info:@"Failed to create client."];
            return;
        }
        
        [GBClient save:client];
        [logger info:@"Client created. (id:%@)", client.id];
        
    });
    
}

- (GBClient *)waitClient {
    
    while (true) {
        if(client != nil)
            return client;
        usleep(100 * 1000);
    }
    
}

#pragma mark --
#pragma mark GBIntentHandler

- (BOOL)handleIntent:(GBIntent *)intent {
    
    for (id <GBIntentHandler> intentHandler in self.intentHandlers) {
        if ([intentHandler handleIntent:intent]) {
            return YES;
        }
    }
    
    return NO;
    
}

@end
