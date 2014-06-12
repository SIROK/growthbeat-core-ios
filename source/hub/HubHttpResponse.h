//
//  HubHttpResponse.h
//  hub
//
//  Created by Kataoka Naoyuki on 2014/06/12.
//  Copyright (c) 2014 SIROK, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HubHttpResponse : NSObject {

    NSURLRequest *urlRequest;
    NSHTTPURLResponse *httpUrlResponse;
    NSError *error;
    id body;

}

@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (nonatomic, strong) NSHTTPURLResponse *httpUrlResponse;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id body;

+ (id)instanceWithUrlRequest:(NSURLRequest *)urlRequest httpUrlResponse:(NSHTTPURLResponse *)httpUrlResponse error:(NSError *)error body:(id)body;

@end