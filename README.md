# TLPhotoBrowser
一个图片浏览框架,支持新闻类型和看大图类型,参考修改自[Charlin大神](https://github.com/nsdictionary)的[CorePhotoBrowser](https://github.com/nsdictionary/CorePhotoBroswerVC).

只加载当前屏幕的左右两张图片,保证滑动时只加载最多三张图片.(经iPod Touch测试滑动起来丝般顺滑)

加载网络图片时,如果传入缩略图,则会在下载完成之前先显示缩略图,下载完大图后有一个平滑的动画切换至大图

新闻类型的浏览方式会把传入的缩略图(如果传了)模糊成背景(参考网易的图片新闻样式)

Demo中有录制的MOV可下载看详细的效果.

![image](https://github.com/Creolophus/TLPhotoBrowser/blob/master/QQ20150714-1@2x.png?raw=true)

![image](https://github.com/Creolophus/TLPhotoBrowser/blob/master/1.gif?raw=true)
