//
//  RHActor.h
//  VideoLibrary
//
//  Created by MIMO on 18/3/18.
//  Copyright © 2018 MIMO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHActor: NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, nonnull) NSString *name;
@property (nonatomic, nullable) NSString *photoURL;

- (nonnull instancetype) initWithId:(NSInteger)id name:(nonnull NSString*)name photoURL:(nullable NSString*)photoURL;

@end





