//
//  OMTVShow.h
//  VideoLibrary
//
//  Created by MIMO on 14/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMTVShow : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nullable) NSString * posterUrl;
@property (nonatomic) float vote;
@property (nonatomic, nonnull) NSString * first_air;

- (nonnull instancetype)initWithId:(NSInteger)id name:(nonnull NSString*)name posterUrl:(nullable NSString*)posterUrl vote:(float)vote firstAir:(nonnull NSString*)first_air;

@end
