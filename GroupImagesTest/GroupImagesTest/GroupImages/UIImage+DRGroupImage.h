//
//  UIImage+DRGroupImage.h
//  cjdy
//
//  Created by shuai on 2019/4/25.
//  Copyright © 2019 SuperSir. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DRGroupImage)
/**
 图片组 本地

 @param array 原生image arr
 @param bgColor 新生成image 背景色
 @return image 组合
 */
+ (UIImage *)groupIconWith:(NSArray *)array bgColor:(UIColor *)bgColor;

/**
 图片组 本地
 @param corner 新生成组合图片背景圆角
 @param array 原生image arr
 @param bgColor 新生成image 背景色
 @return image 组合
 */
+ (UIImage *)groupIconWith:(NSArray *)array corner:(CGFloat)corner bgColor:(UIColor *)bgColor;
/**
 图片组合 网络请求，使用SD缓存到本地磁盘，请求前先去缓存中哈希查找是否有缓存
 
 @param URLArray 图片url 数组
 @param corner 新生成组合图片背景圆角
 @param bgColor 新生成组合图片背景颜色
 @param Success 组合成功回调
 @param Failed 组合失败回调
 */
+ (void )groupIconWithURLArray:(NSArray *)URLArray
                        corner:(CGFloat)corner
                       bgColor:(UIColor *)bgColor
                       Success:(void(^)(UIImage *image))Success
                        Failed:(void(^)(NSString *fail))Failed;
/**
 图片组合 网络请求，使用SD缓存到本地磁盘，请求前先去缓存中哈希查找是否有缓存
 
 @param URLArray 图片url 数组
 @param bgColor 新生成组合图片背景颜色
 @param Success 组合成功回调
 @param Failed 组合失败回调
 */
+ (void)groupIconWithURLArray:(NSArray *)URLArray
                      bgColor:(UIColor *)bgColor
                      Success:(void(^)(UIImage *image))Success
                       Failed:(void(^)(NSString *fail))Failed;

@end

NS_ASSUME_NONNULL_END
