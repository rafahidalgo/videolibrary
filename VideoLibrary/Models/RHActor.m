//
//  RHActor.m
//  VideoLibrary
//
//  Created by MIMO on 18/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import "RHActor.h"

@implementation RHActor

-(instancetype)initWithId:(NSInteger)id name:(NSString *)name photoURL:(NSString *)photoURL
{
    _id = id;
    _name = name;
    _photoURL = photoURL;
    return self;
}

@end
