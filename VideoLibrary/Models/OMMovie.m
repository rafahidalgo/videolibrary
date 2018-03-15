//
//  OMMovie.m
//  VideoLibrary
//
//  Created by MIMO on 14/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import "OMMovie.h"

@implementation OMMovie

- (instancetype)initWithId: (NSInteger)id
                     title:(NSString*)title
                 posterUrl:(NSString*)posterUrl
                      vote:(float)vote
                   releaseDate:(NSString*)releaseDate {
    
    _id = id;
    _title = title;
    _posterUrl = posterUrl;
    _vote = vote;
    _releaseDate = releaseDate;
    
    return self;
}

@end
