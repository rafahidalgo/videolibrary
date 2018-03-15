//
//  OMMovie.h
//  VideoLibrary
//
//  Created by MIMO on 14/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMMovie : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, nonnull) NSString *title;
@property (nonatomic, nullable) NSString * posterUrl;
@property (nonatomic) float vote;
@property (nonatomic, nonnull) NSString * releaseDate;

- (nonnull instancetype)initWithId:(NSInteger)id title:(nonnull NSString*)title posterUrl:(nullable NSString*)posterUrl vote:(float)vote releaseDate:(nonnull NSString*)releaseDate;

@end
