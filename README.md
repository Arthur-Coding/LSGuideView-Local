# LSGuideView-Local
   这是一个简单的加载本地图片实现引导页的视图。当然，其实不仅限于实现引导页，也可以用于加载滑动视图、轮播图实现等等。
   #This is a simple to load the local image to achieve the guide page view. Of course, in fact, not only realize the guidance page, can also be used to load the slide view, carousel figure implementation and so on.
   
   导入：
   #Import:
   pod 'LSGuideView-Local'
   
   使用：
   1.调用初始化方法，设置frame与图片数组(建议数组红存放图片路径)
   #Call initialization method, set the frame and picture array (the proposed array of red storage image path)
   - (instancetype)initWithFrame:(CGRect)frame and:(NSArray *)imgArr；
   2.若开启自动定时轮播
   #If you open the automatic timing carousel：
   - (void)openCarouselWithTimeInterval:(NSInteger)timeInterval;
   3.封装了一个类似于UITableView的reloadDate的刷新方法，可以更新图片数组，再调用- (void)reloadData;实现刷新
   #Package of a reloadDate similar to the UITableView refresh method, you can update the image array, and then call - (void) reloadData; refresh
