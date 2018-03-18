//
//  RHActorDetails.m
//  VideoLibrary
//
//  Created by MIMO on 18/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import "RHActorDetails.h"

@implementation RHActorDetails

-(instancetype)initWithId:(NSInteger)id name:(NSString *)name photoURL:(NSString *)photoURL biography:(NSString *)biography birthday:(NSString *)birthday deathday:(NSString *)deathday placeOfBirth:(NSString *)placeOfBirth
 {
    _biography = biography;
    _birthday = birthday;
    _deathday = deathday;
    _placeOfBirth = placeOfBirth;
    self = [super initWithId:id name:name photoURL:photoURL];
    return self;
}

@end



