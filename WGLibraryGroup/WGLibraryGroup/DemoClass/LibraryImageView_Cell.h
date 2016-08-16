//
//  LibraryImageView_Cell.h
//  WGLibraryGroup
//
//  Created by wanggang on 16/8/16.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryImageView_Cell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UIImageView *stateIV;

@property (nonatomic,strong)UIImage *showImage;

@end
