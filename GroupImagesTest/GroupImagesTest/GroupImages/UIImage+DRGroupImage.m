//
//  UIImage+DRGroupImage.m
//  cjdy
//
//  Created by shuai on 2019/4/25.
//  Copyright © 2019 SuperSir. All rights reserved.
//

#import "UIImage+DRGroupImage.h"
#import "UIImageView+WebCache.h"
#import <SDWebImageManager.h>

@implementation UIImage (DRGroupImage)


/**
 图片组合 网络请求，使用SD缓存到本地磁盘，请求前先去缓存中哈希查找是否有缓存

 @param URLArray 图片url 数组
 @param corner 新生成组合图片背景圆角
 @param bgColor 新生成组合图片背景颜色
 @param Success 组合成功回调
 @param Failed 组合失败回调
 */
+(void)groupIconWithURLArray:(NSArray *)URLArray
                      corner:(CGFloat)corner
                     bgColor:(UIColor *)bgColor
                     Success:(void(^)(UIImage *image))Success
                      Failed:(void(^)(NSString *fail))Failed
{
    UIImage *cacheImage;
    
    NSString *cacheKey = [URLArray componentsJoinedByString:@"-"];
    
    SDImageCache* cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    cacheImage = [cache imageFromDiskCacheForKey:cacheKey];
    
    if (cacheImage) {
        if (Success) {
            Success(cacheImage);
        }
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    dispatch_group_t g = dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    
    //3.添加任务,让队列调度,任务执行情况,最后通知调度组
    for (int i = 0; i<URLArray.count;  i++) {
        NSURL *url = [NSURL URLWithString:URLArray[i]];
        //请求
        dispatch_group_enter(g);
        dispatch_group_async(g, globalQueue, ^{
            NSLog(@"task %d%@",i,[NSThread currentThread]);
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [imageArray addObject:image];
            }else{
                [imageArray addObject:[UIImage imageNamed:@"dr_placeholder_avatar_icon"]];
            }
            dispatch_group_leave(g);
        });
    }
    //4.所有任务执行完毕后,通知调度组
    //用一个调度组,可以监听全局队列的任务,主队列去执行最后的任务
    //dispatch_group_notify 本身也是异步的!
    dispatch_group_notify(g, dispatch_get_main_queue(), ^{
        //更新UI,通知用户
//        NSLog(@"OK更新UI,通知用户 %@",[NSThread currentThread]);
        imageView.image = [UIImage groupIconWith:imageArray corner:corner bgColor:[UIColor groupTableViewBackgroundColor]];
        [[SDImageCache sharedImageCache] storeImage:imageView.image forKey:cacheKey toDisk:YES completion:^{
            NSLog(@"缓存图片成功%@",[NSThread currentThread]);
        }];
        
        if (Success) {
            Success(imageView.image);
        }
        if (Failed) {
            Failed(@"头像下载失败");
        }
    });
//    NSLog(@"come %@", [NSThread currentThread]);
}
+ (void)groupIconWithURLArray:(NSArray *)URLArray
                           bgColor:(UIColor *)bgColor
                           Success:(void(^)(UIImage *image))Success
                            Failed:(void(^)(NSString *fail))Failed
{
    
    UIImage *cacheImage;
    
    NSString *cacheKey = [URLArray componentsJoinedByString:@"-"];
    
    SDImageCache* cache = [SDImageCache sharedImageCache];
    //此方法会先从memory中取。
    cacheImage = [cache imageFromDiskCacheForKey:cacheKey];
    
    if (cacheImage) {
        if (Success) {
            Success(cacheImage);
        }
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    dispatch_group_t g = dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    //3.添加任务,让队列调度,任务执行情况,最后通知调度组
    for (int i = 0; i<URLArray.count;  i++) {
        NSURL *url = [NSURL URLWithString:URLArray[i]];
        //请求
        dispatch_group_enter(g);
        dispatch_group_async(g, globalQueue, ^{
            NSLog(@"task %d%@",i,[NSThread currentThread]);
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [imageArray addObject:image];
            }else{
                [imageArray addObject:[UIImage imageNamed:@"dr_placeholder_avatar_icon"]];
            }
            dispatch_group_leave(g);
        });
    }
    //4.所有任务执行完毕后,通知调度组
    //用一个调度组,可以监听全局队列的任务,主队列去执行最后的任务
    //dispatch_group_notify 本身也是异步的!
    dispatch_group_notify(g, dispatch_get_main_queue(), ^{
        //更新UI,通知用户
        //        NSLog(@"OK更新UI,通知用户 %@",[NSThread currentThread]);
        imageView.image = [UIImage groupIconWith:imageArray bgColor:[UIColor groupTableViewBackgroundColor]];
        [[SDImageCache sharedImageCache] storeImage:imageView.image forKey:cacheKey toDisk:YES completion:^{
            NSLog(@"缓存图片成功%@",[NSThread currentThread]);
        }];
        
        if (Success) {
            Success(imageView.image);
        }
        if (Failed) {
            Failed(@"头像下载失败");
        }
    });
    //    NSLog(@"come %@", [NSThread currentThread]);
    
    
}

+ (UIImage *)groupIconWith:(NSArray *)array bgColor:(UIColor *)bgColor {
    
    CGSize finalSize = CGSizeMake(100, 100);
    CGRect rect = CGRectZero;
    rect.size = finalSize;
    
    UIGraphicsBeginImageContext(finalSize);
    
    if (bgColor) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0, 100);
        CGContextAddLineToPoint(context, 100, 100);
        CGContextAddLineToPoint(context, 100, 0);
        CGContextAddLineToPoint(context, 0, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    if (array.count >= 2) {
        
        NSArray *rects = [self eachRectInGroupWithCount2:array.count];
        int count = 0;
        for (id obj in array) {
            
            if (count > rects.count-1) {
                break;
            }
            
            UIImage *image;
            
            if ([obj isKindOfClass:[NSString class]]) {
                image = [UIImage imageNamed:(NSString *)obj];
            } else if ([obj isKindOfClass:[UIImage class]]){
                image = (UIImage *)obj;
            } else {
                NSLog(@"%s Unrecognizable class type", __FUNCTION__);
                break;
            }
            
            CGRect rect = CGRectFromString([rects objectAtIndex:count]);
            [image drawInRect:rect];
            count++;
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)groupIconWith:(NSArray *)array corner:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor {
    
    CGSize finalSize = CGSizeMake(100, 100);
    CGRect rect = CGRectZero;
    rect.size = finalSize;
    
    UIGraphicsBeginImageContext(finalSize);
    
    if (bgColor) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        /*画圆角矩形*/
        CGSize rectSize = finalSize;
        CGContextMoveToPoint(context, rectSize.width, cornerRadius * 2);  // 开始坐标右边开始
        CGContextAddArcToPoint(context, rectSize.width, rectSize.height, rectSize.width - 10, rectSize.height, cornerRadius);  // 右下角
        CGContextAddArcToPoint(context, 0, rectSize.height, 0, rectSize.height - 10, cornerRadius); // 左下角
        CGContextAddArcToPoint(context, 0, 0, cornerRadius * 2, 0, cornerRadius); // 左上角
        CGContextAddArcToPoint(context, rectSize.width, 0, rectSize.width, cornerRadius * 2, cornerRadius); // 右上角
 
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    if (array.count >= 2) {
        
        NSArray *rects = [self eachRectInGroupWithCount2:array.count];
        int count = 0;
        for (id obj in array) {
            
            if (count > rects.count-1) {
                break;
            }
            
            UIImage *image;
            
            if ([obj isKindOfClass:[NSString class]]) {
                image = [UIImage imageNamed:(NSString *)obj];
            } else if ([obj isKindOfClass:[UIImage class]]){
                image = (UIImage *)obj;
            } else {
                NSLog(@"%s Unrecognizable class type", __FUNCTION__);
                break;
            }
            
            CGRect rect = CGRectFromString([rects objectAtIndex:count]);
            [image drawInRect:rect];
            count++;
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSArray *)eachRectInGroupWithCount:(NSInteger)count {
    
    NSArray *rects = nil;
    
    CGFloat sizeValue = 100;
    CGFloat padding = 8;
    
    CGFloat eachWidth = (sizeValue - padding*3) / 2;
    
    CGRect rect1 = CGRectMake(sizeValue/2 - eachWidth/2, padding, eachWidth, eachWidth);
    
    CGRect rect2 = CGRectMake(padding, padding*2 + eachWidth, eachWidth, eachWidth);
    
    CGRect rect3 = CGRectMake(padding*2 + eachWidth, padding*2 + eachWidth, eachWidth, eachWidth);
    if (count == 3) {
        rects = @[NSStringFromCGRect(rect1), NSStringFromCGRect(rect2), NSStringFromCGRect(rect3)];
    } else if (count == 4) {
        CGRect rect0 = CGRectMake(padding, padding, eachWidth, eachWidth);
        rect1 = CGRectMake(padding*2, padding, eachWidth, eachWidth);
        rects = @[NSStringFromCGRect(rect0), NSStringFromCGRect(rect1), NSStringFromCGRect(rect2), NSStringFromCGRect(rect3)];
    }
    
    return rects;
}

+ (NSArray *)eachRectInGroupWithCount2:(NSInteger)count {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    
    CGFloat sizeValue = 100;
    CGFloat padding = 2;
    
    CGFloat eachWidth;
    
    if (count <= 4) {
        eachWidth = (sizeValue - padding*3) / 2;
        [self getRects:array padding:padding width:eachWidth count:4];
    } else {
        padding = padding / 2;
        eachWidth = (sizeValue - padding*4) / 3;
        [self getRects:array padding:padding width:eachWidth count:9];
    }
    
    if (count < 4) {
        [array removeObjectAtIndex:0];
        CGRect rect = CGRectFromString([array objectAtIndex:0]);
        rect.origin.x = (sizeValue - eachWidth) / 2;
        [array replaceObjectAtIndex:0 withObject:NSStringFromCGRect(rect)];
        if (count == 2) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
            
            for (NSString *rectStr in array) {
                CGRect rect = CGRectFromString(rectStr);
                rect.origin.y -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array removeAllObjects];
            [array addObjectsFromArray:tempArray];
        }
    } else if (count != 4 && count <= 6) {
        [array removeObjectsInRange:NSMakeRange(0, 3)];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:6];
        
        for (NSString *rectStr in array) {
            CGRect rect = CGRectFromString(rectStr);
            rect.origin.y -= (padding+eachWidth)/2;
            [tempArray addObject:NSStringFromCGRect(rect)];
        }
        [array removeAllObjects];
        [array addObjectsFromArray:tempArray];
        
        if (count == 5) {
            [tempArray removeAllObjects];
            [array removeObjectAtIndex:0];
            
            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        }
        
    } else if (count != 4 && count < 9) {
        if (count == 8) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        } else {
            [array removeObjectAtIndex:2];
            [array removeObjectAtIndex:0];
        }
    }
    
    return array;
}

+ (void)getRects:(NSMutableArray *)array padding:(CGFloat)padding width:(CGFloat)eachWidth count:(int)count {
    
    for (int i=0; i<count; i++) {
        int sqrtInt = (int)sqrt(count);
        int line = i%sqrtInt;
        int row = i/sqrtInt;
        CGRect rect = CGRectMake(padding * (line+1) + eachWidth * line, padding * (row+1) + eachWidth * row, eachWidth, eachWidth);
        [array addObject:NSStringFromCGRect(rect)];
    }
}

@end

