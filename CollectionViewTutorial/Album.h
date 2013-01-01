//
//  Album.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@interface Album : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *photos;

- (void)addPhoto:(Photo *)photo;
- (BOOL)removePhoto:(Photo *)photo;

@end
