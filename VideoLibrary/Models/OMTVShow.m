//
//  OMTVShow.m
//  VideoLibrary
//
//  Created by MIMO on 14/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import "OMTVShow.h"

@implementation OMTVShow

- (instancetype)initWithId:(NSInteger)id
                      name:(NSString*)title
                 posterUrl:(NSString*)posterUrl
                      vote:(float)vote
                 firstAir:(NSString*)releaseDate {
    
    _id = id;
    _name = title;
    _posterUrl = posterUrl;
    _vote = vote;
    _first_air = releaseDate;
    
    return self;
}

@end
