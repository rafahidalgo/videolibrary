//
//  OMTVShowDetails.h
//  VideoLibrary
//
//  Created by MIMO on 15/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMTVShow.h"

@interface OMTVShowDetails : OMTVShow

@property (nonatomic,nullable) NSString* backdropPath;
@property (nonatomic, nonnull) NSString* overview;
@property (nonatomic, nullable) NSArray* genres;
@property (nonatomic) NSInteger numberOfSeasons;

- (nonnull instancetype)initWithId:(NSInteger)id name:(nonnull NSString*)name posterUrl:(nullable NSString*)posterUrl vote:(float)vote firstAir:(nonnull NSString*)first_air
backDropPath:(nullable NSString*)backDropPath overview:(nonnull NSString*)overview genres:(nonnull NSArray*)genres seasons:(NSInteger)numberOfSeasons;

@end
