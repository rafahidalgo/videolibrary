//
//  OMTVShowDetails.m
//  VideoLibrary
//
//  Created by MIMO on 15/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import "OMTVShowDetails.h"

@implementation OMTVShowDetails

- (instancetype) initWithId:(NSInteger)id name:(NSString*)name
                  posterUrl:(NSString*)posterUrl
                       vote:(float)vote
                   firstAir:(NSString*)first_air
               backDropPath:(NSString*)backDropPath
                   overview:(NSString*)overview
                     genres:(NSArray*)genres
                    seasons:(NSInteger)numberOfSeasons {
    
    _backdropPath = backDropPath;
    _overview = overview;
    _genres = genres;
    _numberOfSeasons = numberOfSeasons;
         
                        
                        self = [super initWithId:id name:name posterUrl: posterUrl vote:vote firstAir:first_air];
                        
    return self;
}

@end
