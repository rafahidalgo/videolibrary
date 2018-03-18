//
//  RHActorDetails.h
//  VideoLibrary
//
//  Created by MIMO on 18/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHActor.h"

@interface RHActorDetails: RHActor

@property (nonatomic, nullable) NSString *biography;
@property (nonatomic, nullable) NSString *birthday;
@property (nonatomic, nullable) NSString *deathday;
@property (nonatomic, nullable) NSString *placeOfBirth;

- (nonnull instancetype) initWithId:(NSInteger)id name:(nonnull NSString*)name photoURL:(nullable NSString*)photoURL biography:(nullable NSString*)biography birthday:(nullable NSString*)birthday deathday:(nullable NSString*)deathday placeOfBirth:(nullable NSString*)placeOfBirth;

@end

