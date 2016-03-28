# StudyScrollView

### 前言
为了方便新人学习和交流特把我之前学习UIScrollView时所总结的文档贡献出来，这里有最基础的UIScrollView使用方法，也有UIScrollView使用注意事项。如有不足之处请评论到下方或者私信与我。

# UIScrollView 简介

UIScrollView是展示滚动视图的一个类，继承UIView，有UITableView、UITextView等子类。可以展示比屏幕更大的内容，支持上下左右滚动、缩小放大内容。

# 最简单的使用方法

利用UIScrollView来显示一个比屏幕大的图片。
```
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
[super viewDidLoad];

//创建要显示的图片
UIImage *image = [UIImage imageNamed:@"glk300.jpg"];
self.imageView = [[UIImageView alloc] initWithImage:image];

//将图片的大小设置为UIScrollView要显示的范围
self.scrollView.contentSize = self.imageView.frame.size;
[self.scrollView addSubview:self.imageView];
}
```
运行程序，可以看到图片可以简单显示了。

### 延伸

当然，这是最简单的方法，标准的做法是利用懒加载的方式，代码如下，当然，这只是延伸部分。可以选择性跳过

```
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@end

@implementation ViewController

//重写image 的setter方法
- (void)setImage:(UIImage *)image
{
_image = image;

//设定图像视图的内容
self.imageView.image = image;

//让图像视图自动根据图像调整大小
[self.imageView sizeToFit];

//告诉scrollView要显示图像的大小
self.scrollView.contentSize = image.size;
}

//懒加载imageView
- (UIImageView *)imageView
{
if (_imageView == nil) {
_imageView = [[UIImageView alloc] init];

//将图像视图加入scrollView
[self.scrollView addSubview:_imageView];
}

return _imageView;
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
```

> 注意：本代码示例是先在```StoryBoard```中拖入```UIScrollView```控件然后在代码中往```UIScrollView```中添加```UIImageView```。如果是直接在```StoryBoard```中往```UIScrollView```中添加```UIImageView```控件则需要关闭```autolayout```，否则无法滚动。也就是说**如果是直接在```StoryBoard```中往```UIScrollView```中添加子控件则必须关闭```autolayout```，否则无法滚动**

这时运行程序发现可以滚动查看图片，但是出现一个问题，如下图所示，图片虽然能够显示完整，但是只能用手指向上拖拽时才能看到图片的底部。（注：红色为UIScrollView）
![1.gif](http://upload-images.jianshu.io/upload_images/1617669-d91c8075fb78f8ac.gif?imageMogr2/auto-orient/strip)

这是因为UIScrollView没有做自动布局。
自动布局设置如下：
![自动布局.gif](http://upload-images.jianshu.io/upload_images/1617669-af4466cfb2984a61.gif?imageMogr2/auto-orient/strip)

# UIScrollView常用属性

## 常用属性

```
@property(nonatomic)       CGPoint                  contentOffset;               
// default CGPointZero。
//在滚轴视图中，contentOffset属性可以跟踪UIScrollView的具体位置，你能够自己获取和设置它，contentOffset的值是你当前可视内容在滚轴视图上面偏移原来的左上角那个点的偏移量，有contentOffset.x和contentOffset.y。

@property(nonatomic)       CGSize                   contentSize;                 
// default CGSizeZero。
//contentSize是内容的大小，也就是可以滚动的大小。默认是0，没有滚动效果。

@property(nonatomic)       UIEdgeInsets              contentInset; 
// default UIEdgeInsetsZero. add additional scroll area aroundcontent
//contentInset增加你在contentSize中指定的内容能够滚动的上下左右区域数量。contentInset.top、contentInset.buttom、contentInset.left、contentInset.right分别表示上面，下面，左边和右边的距离。
```
如下图所示：
![1.png](http://upload-images.jianshu.io/upload_images/1617669-ce96fcb64b58edde.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
@property(nonatomic) BOOL bounces;
设置UIScrollView是否需要弹簧效果

@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled; 
设置UIScrollView是否能滚动

@property(nonatomic) BOOL showsHorizontalScrollIndicator;
是否显示水平滚动条

@property(nonatomic) BOOL showsVerticalScrollIndicator;
是否显示垂直滚动条

@property(nonatomic) BOOL bounces;                   
默认是YES，就是滚动超过边界会反弹，有反弹回来的效果。如果是NO，那么滚动到达边界会立即停止

```
如果UIScrollView无法滚动，可能是以下原因：
没有设置contentSize
scrollEnabled = NO
没有接收到触摸事件:userInteractionEnabled = NO
没有取消autolayout功能（如果在Storyboard中添加了ScrollView的子控件，要想scrollView滚动，必须取消autolayout）


# UIScrollView的缩放功能

UIScrollView的缩放功能就是可以通过两手指在屏幕上的捏合来控制图片的缩放，让图片放大或缩小。

实现UIScrollView的缩放功能其实是通过代理来实现的，当UIScrollView检测到屏幕上有手指的捏合动作时会给代理发送一条消息，询问代理要缩放的内容是什么。

- 实现代理
```self.scrollView.delegate = self;```
- 遵守代理
```@interface ViewController ()<UIScrollViewDelegate>```
- 实现代理方法
```
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
return self.imageView;
}
```
- 设置缩放比例
```
//设置缩放比例
self.scrollView.maximumZoomScale = 2.0;
self.scrollView.minimumZoomScale = 0.2;
```
ok，完成缩放功能。

# 代码 
[github](https://github.com/luckilyTsh/StudyScrollView.git)



# 参考
[参考1](http://blog.csdn.net/hero_wqb/article/details/49870101)
[参考2](http://blog.csdn.net/zuoanlangren/article/details/16748571)