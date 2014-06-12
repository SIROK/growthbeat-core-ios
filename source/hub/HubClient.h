//
//  HubClient.h
//  hub
//
//  Created by Naoyuki Kataoka on 2014/06/13.
//  Copyright (c) 2014 SIROK, Inc. All rights reserved.
//

#import "HubDomain.h"

@interface HubClient : HubDomain <NSCoding> {

    NSString *id;
    NSString *applicationId;
    NSDate *modified;
    NSDate *created;

}

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSDate *modified;
@property (nonatomic, strong) NSDate *created;

+ (HubClient *)createWithApplicationId:(NSString *)applicationId secret:(NSString *)secret;

@end