//
//  PhotoCell.h
//  CollectionViewTutorial
//
//  Created by Scott Gardner on 12/31/12.
//  Copyright (c) 2012 Scott Gardner. All rights reserved.
//

@interface PhotoCell : UICollectionViewCell

// Allow consumers to edit properties of the imageView, but not replace the imageView itself
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end
