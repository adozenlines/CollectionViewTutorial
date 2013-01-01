//
//  ViewController.m
//  CollectionViewTutorial
//
//  Created by Scott Gardner on 12/31/12.
//  Copyright (c) 2012 Scott Gardner. All rights reserved.
//

#import "CollectionViewController.h"
#import "PhotoAlbumLayout.h"
#import "PhotoCell.h"
#import "Album.h"
#import "Photo.h"
#import "AlbumTitleReusableView.h"

static NSString * const kPhotoCellIdentifier = @"PhotoCell";
static NSString * const kAlbumTitleIdentifier = @"AlbumTitle";

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet PhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSOperationQueue *thumnailQueue;
@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:kPhotoCellIdentifier];
    [self.collectionView registerClass:[AlbumTitleReusableView class] forSupplementaryViewOfKind:kPhotoAlbumLayoutAlbumTitleKind withReuseIdentifier:kAlbumTitleIdentifier];
    self.albums = [@[] mutableCopy];
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    NSInteger photoIndex = 0;
    
    for (int a = 0; a < 12; a++) {
        Album *album = [Album new];
        album.name = [NSString stringWithFormat:@"Photo Album %d", a + 1];
        
        // Randomize number of photos on each stack
        NSInteger photoCount = arc4random() % 4 + 2;
        
        for (int p = 0; p < photoCount; p++) {
            // There are up to 25 photos available to load from the repo
            NSString *photoFileName = [NSString stringWithFormat:@"thumbnail%d.jpg", photoIndex % 25];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFileName];
            Photo *photo = [Photo photoWithImageURL:photoURL];
            [album addPhoto:photo];
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    self.thumnailQueue = [NSOperationQueue new];
    self.thumnailQueue.maxConcurrentOperationCount = 3;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // Handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ? 45.0f : 25.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
    } else {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.albums count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    Album *album = self.albums[section];
    return [album.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellIdentifier forIndexPath:indexPath];
    Album *album = self.albums[indexPath.section];
    Photo *photo = album.photos[indexPath.item];
    
    // Load photo images in background
    __weak CollectionViewController *weakSelf = self;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = photo.image;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Then set photo on the main thread if the cell is still visible
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                // Re-obtain cell for item at index path, since the cell may have been reused (if user was able to add/remove/rearrange photos, we'd need to also look up the index path again based on the specific album and photo)
                PhotoCell *cell = (PhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    // Prioritize loading the top photo (also set zIndex in -[PhotoAlbumLayout prepareLayout])
    operation.queuePriority = indexPath.item == 0 ? NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumnailQueue addOperation:operation];
    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AlbumTitleReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kAlbumTitleIdentifier forIndexPath:indexPath];
    Album *album = self.albums[indexPath.section];
    titleView.titleLabel.text = album.name;
    return titleView;
}

#pragma mark - UICollectionViewDelegate



@end
