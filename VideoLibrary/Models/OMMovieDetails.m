//
//  OMMovieDetails.m
//  VideoLibrary
//
//  Created by MIMO on 14/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import "OMMovieDetails.h"

@implementation OMMovieDetails

- (instancetype)initWithId:(NSInteger)id
                     title:(NSString *)title
                 posterUrl:(NSString *)posterUrl
                      vote:(float)vote
               releaseDate:(NSString *)releaseDate
              backDropPath:(NSString *)backDropPath
                  overview:(NSString *)overview
                    genres:(NSArray *)genres {
    
    _backDropPath = backDropPath;
    _overview = overview;
    _genres = genres;
    
    self = [super initWithId:id title:title posterUrl:posterUrl vote:vote releaseDate:releaseDate];
    
    return self;
}

@end
