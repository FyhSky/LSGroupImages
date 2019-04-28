//
//  ViewController.m
//  GroupImagesTest
//
//  Created by shuai on 2019/4/28.
//  Copyright © 2019 LS. All rights reserved.
//

#import "ViewController.h"

#import "UIImage+DRGroupImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *testButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"点击加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(testBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:testButton];
    testButton.frame = ({
        CGRect frame;
        frame = CGRectMake((self.view.bounds.size.width - 100)/2, 200, 100, 100);
        frame;
    });
    
}

- (void)testBtnClicked:(UIButton*)button
{
    NSArray *urlArr = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556440345617&di=cdec9da71fb0b284fa94cf6565aae376&imgtype=0&src=http%3A%2F%2Fimg3.redocn.com%2Ftupian%2F20141229%2Fdaimaozidenanhaitouxiangxianmiao_3720144.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556440372247&di=b114c4b7a2e58d0fe87ee4dea7e62bff&imgtype=0&src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2Fd825407e5ecacc907ca974b9cf8997f133a99a9c.jpg",
                        @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556440428814&di=92d761bd546a641a89ca2578e4c0f0fa&imgtype=0&src=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F13%2F19%2F56%2F63858PICNBI_1024.jpg"];
    [UIImage groupIconWithURLArray:urlArr corner:8 bgColor:[UIColor lightGrayColor] Success:^(UIImage * _Nonnull image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
    } Failed:^(NSString * _Nonnull fail) {
        NSLog(@"fail");
    }];
    
    
    
}

@end
