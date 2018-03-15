//
//  OMMovieDetails.h
//  VideoLibrary
//
//  Created by MIMO on 14/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMMovie.h"

@interface OMMovieDetails : OMMovie

@property (nonatomic, nullable) NSString* backDropPath;
@property (nonatomic, nonnull) NSString* overview;
@property (nonatomic, nullable) NSArray* genres;

- (nonnull instancetype)initWithId:(NSInteger)id title:(nonnull NSString*)title posterUrl:(nullable NSString*)posterUrl vote:(float)vote releaseDate:(nonnull NSString*)releaseDatea
backDropPath:(nullable NSString*)backDropPath overview:(nonnull NSString*)overview genres:(nonnull NSArray*)genres;

@end
