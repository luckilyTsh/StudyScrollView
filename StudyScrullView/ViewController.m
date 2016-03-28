//
//  ViewController.m
//  StudyScrullView
//
//  Created by isoftstone on 16/3/22.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@implementation ViewController

//重写image 的setter方法
- (void)setImage:(UIImage *)image {
  _image = image;

  //设定图像视图的内容
  self.imageView.image = image;

  //让图像视图自动根据图像调整大小
  [self.imageView sizeToFit];

  //告诉scrollView要显示图像的大小
  self.scrollView.contentSize = image.size;
}

#pragma mark 懒加载imageView
- (UIImageView *)imageView {
  if (_imageView == nil) {
    _imageView = [[UIImageView alloc] init];

    //将图像视图加入scrollView
    [self.scrollView addSubview:_imageView];
  }

  return _imageView;
}

#pragma mark 懒加载scrollView
- (UIScrollView *)scrollView {
  if (_scrollView == nil) {

    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];

    //设置边距
    _scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);

    //设置隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;

    //设置隐藏垂直滚动条
    _scrollView.showsVerticalScrollIndicator = NO;

    //设置为拖拽图片到边沿时无反弹效果
    _scrollView.bounces = NO;

    //设置代理,实现缩放功能
    _scrollView.delegate = self;

    //设置缩放比例
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.minimumZoomScale = 0.2;

    //设置背景颜色
    _scrollView.backgroundColor = [UIColor redColor];

    [self.view addSubview:_scrollView];
  }

  return _scrollView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  /*
    改成懒加载形式
  UIImage *image = [UIImage imageNamed:@"glk300.jpg"];
  self.imageView = [[UIImageView alloc] initWithImage:image];
  self.scrollView.contentSize = self.imageView.frame.size;
  [self.scrollView addSubview:self.imageView];
   */

  //设置要显示的图像
  self.image = [UIImage imageNamed:@"glk300.jpg"];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

@end
