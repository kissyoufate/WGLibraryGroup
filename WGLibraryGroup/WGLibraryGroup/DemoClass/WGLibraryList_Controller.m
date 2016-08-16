//
//  WGLibraryList_Controller.m
//  WGLibraryGroup
//
//  Created by wanggang on 16/8/16.
//  Copyright © 2016年 wanggang. All rights reserved.
//  自定义相册多选

#import "WGLibraryList_Controller.h"
#import <Photos/Photos.h>

#import "LibraryImageView_Cell.h"

@interface WGLibraryList_Controller () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *libraryListArray;//所有相册
@property (nonatomic,strong)NSMutableArray *imageArray;//所有的相片
@property (nonatomic,strong)NSMutableArray *handSelectArray;//选中的相片

@end

@implementation WGLibraryList_Controller

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"所有照片";

    [self getAllLibraryList];

    [self createLeft];
}

#pragma mark - 左右按钮
- (void)createLeft
{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(0, 0, 40, 40);
    [b setTitle:@"返回" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:b];
    [b addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)returnBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createRight
{
    if (self.handSelectArray.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }else if (self.handSelectArray.count == 1)
    {
        self.navigationItem.rightBarButtonItem = nil;
        //创建
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(0, 0, 40, 40);
        [b setTitle:@"提交" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:b];
        [b addTarget:self action:@selector(handInThePic) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        return;
    }
}

- (void)handInThePic
{
    NSLog(@"选中了%lu长图片",
          (unsigned long)self.handSelectArray.count);
}

#pragma mark - 获取全部相片
- (void)getAllLibraryList
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self.libraryListArray addObject:assetCollection];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self.libraryListArray addObject:cameraRoll];

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 是否同步
    //    options.synchronous = YES;

    //遍历
    for (PHAssetCollection *collection in self.libraryListArray) {
        //相册的名字
        NSLog(@"%@",collection.localizedTitle);
        PHFetchResult<PHAsset *> *asset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];

        for (PHAsset *ass in asset) {
            [[PHImageManager defaultManager] requestImageForAsset:ass targetSize:CGSizeMake(ass.pixelWidth, ass.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [self.imageArray addObject:result];
            }];
        }
    }

    [self createCollection];
}

#pragma mark - 使用CollectionView展示
- (void)createCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((self.view.frame.size.width-3)/4, (self.view.frame.size.width-3)/4);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];

    [collectionView registerNib:[UINib nibWithNibName:@"LibraryImageView_Cell" bundle:nil] forCellWithReuseIdentifier:@"LibraryImageView_Cell"];
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LibraryImageView_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LibraryImageView_Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LibraryImageView_Cell" owner:self options:nil] lastObject];
    }

    cell.showImage = self.imageArray[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LibraryImageView_Cell *cell = (LibraryImageView_Cell *)[collectionView cellForItemAtIndexPath:indexPath];

    if ([self.handSelectArray containsObject:indexPath]) {
        [self.handSelectArray removeObject:indexPath];
        cell.stateIV.image = [UIImage imageNamed:@"ic_sstz_btn_normal"];
    }else
    {
        cell.stateIV.image = [UIImage imageNamed:@"ic_sstz_btn_selected"];
        [self.handSelectArray addObject:indexPath];
    }
    [self createRight];
}

#pragma mark - get方法
- (NSMutableArray *)libraryListArray
{
    if (!_libraryListArray) {
        _libraryListArray = [NSMutableArray array];
    }
    return _libraryListArray;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)handSelectArray
{
    if (!_handSelectArray) {
        _handSelectArray = [NSMutableArray array];
    }
    return _handSelectArray;
}

@end
