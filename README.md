# iOS回调方法总结

声明：未经许可，禁止转载。

回调（callback）就是将一段可执行的代码和一个特定的事件绑定起来，当特定的时间发生时，就会执行这段代码。
在Objective-C中，有四种途径可以试下回调：

 - 目标-动作对（Targe-Action）: 在程序开始等待前，要求“`当事件发生时，向指定的对象发送某个特定的消息`”。这里接受消息的对象是目标（target），消息的选择器（selector）是动作（action）.
 - 辅助对象（Helper Objects）: 在程序开始等待前，要求“`当事件发生时，向遵守相应协议的辅助对象发送消息`”。Delegate 和 DataSource是我们常见的辅助对象
 - 通知（Notification）: 某个对象正在等待某些特定的通知。当其中的某个通知出现时，向指定的对象发送特定的消息。当事件发生时，相关的对象会向通知中心发布通知，然后再有通知中心将通知转发给正在等待该通知的对象
 - Blocks: 在程序开始等待前，声明一个Block对象，当事件发生时，执行这段Block对象。
 
在iOS开发中最常使用的就是辅助对象和Blocks. 下面将会通过四个例子来看一下这四种回调方式都是怎么实现的。
  
  
### 目标-动作对 （Target-Action）
---
- 创建一个NSRunLoop对象和NSTimer对象的程序。

这个程序每隔2秒，NSTimer就会像其目标发送指定的动作消息。此外，在创建一个`Logger`类，这个类的实例将被设置为NSTimer对象的目标。

```
//1. 目标-动作对
// 创建一个Logger的实例logger
Logger *logger = [[Logger alloc]init];
// 每隔2秒，NSTimer对象会向其Target对象logger，发送指定的消息updateLastTime:
__unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                  target:logger
                                                selector:@selector(updateLastTime:)
                                                userInfo:nil
                                                 repeats:YES];
```
输出结果：
![WX20170913-105013@2x](media/15052679055961/WX20170913-105013@2x.png)
Target: `logger`
Action: `logger`对象的`updateLastTime`方法

-  在程序中常见的按钮点击事件也是这种类型。首先，我们用代码创建了一个按钮`btn`，然后为这个按钮添加他的目标为当前的`AppDelegate`(这里仅仅是为了举例，一般我们都是用在ViewController当中)，对应的Action为：`btnClick`。

```
// 创建一个按钮
UIButton *btn = [[UIButton alloc]init];
// 为按钮添加事件
[btn addTarget:self
        action:@selector(btnClick)
forControlEvents:UIControlEventTouchUpInside];
```

```
- (void)btnClick {
    NSLog(@"按钮点击事件");
}
```

从这种目标-动作的回调方式我们可以发现，NSTimer它只负责一件事情`updateLastTime`，btn它只负责`btnClick`。也就是说，对于只做一件事情的对象，我们可以是使用目标动作对。

### 辅助对象 (Delegate/Datasource)
---
- 辅助对象是在iOS开发中相当常见的。比如我们经常使用的UITableView这个空间，相信大家都使用过其中的`UITableViewDelegate`以及`UITableViewDataSource`。

```
self.tableView.delegate = self;
self.tableView.dataSource = self;
```
上面的两行代码，我们在某个`ViewController`当中使用的话，意味着我们将`ViewController`设置成为了`tableView`的辅助对象。当`tableView`需要更新或者是响应某些特定的事件时，就会向该`ViewController`发送消息。
具体发送哪些消息就看我们怎么实现的了，比如我们点击某行需要响应点击事件时，我们就需要实现下面这个方法：

```
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
```
 
关于`UITableView`的使用网上有大量的资料，在这里就不再重复了。我们在这个部分只要明确一点，`UITableView`它的回调方式是通过这种委托对象来实现的，而委托的对象通常是使用它的`ViewController`，我们需要委托对象为`UITableView`完成什么事情，就需要在委托对象`ViewController`中实现相应的协议`Protocol`（也即`delegate`和`datasource`）。

- 下面，我们通过一个网络异步下载的例子，进一步加深了解这种辅助对象的回调。

我们使用`NSURLConnection`从服务器获取数据时，通常都是通过异步方式完成的，`NSURLConnection`通常不会一次就发送全部数据，而是多次的发送块状数据。也就是说，我们需要在程序中不断的响应接受数据的事件。

因此，我们需要一个对象来帮助`NSURLConnection`完成这些操作。继续前面的例子，我们使用`Logger`类的实例来完成。因为要完成`NSURLConnection`的操作，所以`Logger`当中要实现它的协议，在这个简单的例子中，我们只需要实现`NSURLConnection`的三个协议方法就好。

```
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
```
PS: 其中1.2是`NSURLConnectionDataDelegate`, 第三条是`NSURLConnectionDelegate`.

```
//2. 辅助对象
NSURL *url = [NSURL URLWithString:@"https://www.gutenberg.org/cache/epub/205/pg205.txt"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
__unused NSURLConnection *fetchConn = [[NSURLConnection alloc]initWithRequest:request
                                                                     delegate:logger
                                                             startImmediately:YES];
```
在这里，我们将`logger`设置为了`NSURLConnection`的辅助对象，因此网络下载相关的信息都会在辅助对象`logger`中进行响应。
输出的结果如下：
![WX20170913-113155@2x](media/15052679055961/WX20170913-113155@2x.png)

从上面的`UITableView`和`NSURLConnection`的例子中我们可以发现，辅助对象和目标动作对的实现逻辑非常相似，如果吧目标理解为辅助对象，动作理解为协议的话，二者几乎是一一对应的。但是二者的区别主要在于：当要向一个对象发送多个回调的时候，通常选择符合相应协议的辅助对象；如果要向一个对象发送一个回调是，通常使用目标动作对。

辅助对象也常被成为委托对象`delegate`和数据源`datasource`。

### 通知 Notifications
---
上面所说的目标动作对和辅助对象都是向一个对象发送消息，如果要向多个对象发送消息，那么我们就需要使用通知这种方式了。

- 例子1: 我们使用电脑的时候发现，当改变系统的失去设置时，程序中的很多对象都可以知道这一变化。之所以能够实现，是因为这些对象都可以通过通知中心将自己注册成为观察者`Observer`。当系统是时区发生改变的时候，会像通知中心发布`NSSystemTimeZondeDidChangeNotification`通知，然后通知中心将该通知转发给所有注册了该`Name`的观察者。

 同样的，我们继续在`Logger`这个类中继续进行操作。这次，我们`Logger`的实例注册为观察者，让它能够在系统的失去发生变化的时候收到相应的通知。
 
 ```
 [[NSNotificationCenter defaultCenter]addObserver:logger
                                        selector:@selector(zoneChange:)
                                            name:NSSystemTimeZoneDidChangeNotification
                                          object:nil];
return YES;
 ```
 
 ```
 - (void)zoneChange:(NSNotification *)note {
    NSLog(@"The system time zone has changed!");
}
 ```
 (这个例子需要在`My Mac`中执行，才能看到效果)
![WX20170913-115850](media/15052679055961/WX20170913-115850.png)

- 例子2：在这个例子中，我们新建了两个对象`notiA`和`notiB`来接收同一个名为`reveiveNotification`的通知，并且各自都会做出相应的响应。
具体的步骤是：
    - 分别新建`notiA`和`notiB`，并且都将二者注册为接收`reveiveNotification`通知的观察者
    
    ```
    NotificationA *notiA = [[NotificationA alloc]init];
[[NSNotificationCenter defaultCenter] addObserver:notiA
                                         selector:@selector(receiveNotification)
                                             name:@"receiveNotification"
                                           object:nil];
NotificationB *notiB = [[NotificationB alloc]init];
[[NSNotificationCenter defaultCenter] addObserver:notiB
                                         selector:@selector(receiveNotification)
                                             name:@"receiveNotification"
                                           object:nil];
    ```
    
    ```
#import "NotificationA.h"
@implementation NotificationA
- (void)receiveNotification {
NSLog(@"Notification A receive this notification");
}
@end
    ```
    ```
    #import "NotificationB.h"
@implementation NotificationB
- (void)receiveNotification {
    NSLog(@"Notification B receive this notification");
}
@end
    ```
    - 通知中心发出名为`reveiveNotification`的通知的通知。
    
    ```
[[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNotification"
                                                object:nil];
    ```
这样，notiA和notiB都会接收到这个通知，并且做出响应，如图：
![WX20170913-120923@2x](media/15052679055961/WX20170913-120923@2x.png)

因此，在程序中如果需要出发多个(其他对象中)的回调对象时，可以使用通知的方式来完成。

### Blocks
---
上述的委托机制（Delegate）和通过机制（notification）已经能够很好的帮助程序在特定事件发生时调用制定的方法。但是他们都存在一个缺点：回调的设置代码和回调方法的具体实现通常都间隔很远，甚至出现在不同的文件中。
为了克服这个确定，我们可以通过`Block`对象，将回调相关的代码写在同一个代码段中。

- 例子1. 我们在两个ViewController中进行传值。 `BViewController`中有一个`UITextField`，用户输入相应的值，我们在`AViewController`中进行显示。

 在梳理Block回调之前，我们先要明确一点：
 **谁要传值谁就定义含有参数的Block, 谁要调用谁就执行这个Block**
 明确了这一点后，根据我们例子1中的需求，我们需要将`BViewController`中用户的输入传递给`AViewController`。因此`BViewController`需要定义一个Block, 然后在`AViewController`中进行相应的操作。
 在`BViewController.h`文件中：定义CallBackBlock
 
 ```
 #import <UIKit/UIKit.h>
typedef void(^CallBackBlock)(NSString *text); // 定义带有参数text的block
@interface BViewController : UIViewController
@property (nonatomic, copy)CallBackBlock callBackBlock;
@end
 ```
 在`BViewController.m`文件中：将`textFiled`中输入的字符串传递给Block
 
 ```
 - (IBAction)popToA:(id)sender {
    NSLog(@"text:%@",_textField.text);
    self.callBackBlock(_textField.text);
    [self.navigationController popToRootViewControllerAnimated:YES];
}
 ```
 在`AViewController.m`文件中：对`BViewController`传递过来的字符串进行显示
 
 ```
 - (IBAction)getValueFromB:(id)sender {
    BViewController *vc = [[BViewController alloc]init];
    __weak AViewController *weakSelf = self; //避免循环引用
    vc.callBackBlock = ^(NSString *text) {
        weakSelf.textLabel.text = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
 ```

- 例子2：功能同例子1. 
其实刚看例子1的时候花了一些时间，总觉得哪里怪怪的，其实Block回调一种更常见的构建方法如下。
在`BViewController.h`文件中：

    ```
    // 另一种Block回调的实现方式
    - (void)passBlock:(CallBackBlock)block;
    ```
在`BViewController.m`文件中：

    ```
    // 另一种实现方式
    - (void)passBlock:(CallBackBlock)block {
        block(@"这是另外一种方式的...");
    }
    ```
在`AViewController.m`文件中
        
    ```
    - (IBAction)anotherButtonClick:(id)sender {
        BViewController *vc = [[BViewController alloc]init];
        __weak AViewController *weakSelf = self; //避免循环引用
        [vc passBlock:^(NSString *text) {
            weakSelf.anotherTextLabel.text = text;
        }];
    }
    ```
在这个例子中，调用`B`的方法，将Block中包裹的变量传递给`A`，在`A`中对Block进行操作处理这个变量。

### 其他注意事项
---
无论哪种类型的回调，都应该注意避免强引用循环。常见的强引用循环的发生情况，创建的对象和回调对象之间相互拥有，导致两个对象都无法释放。
因此在构建回调方法的时候，应该遵守以下规则：

- 通知中心不拥有观察者。如果某个对象注册成为观察者，那么通常应该在释放该对象时将其移出通知中心。

```
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
```
- 对象不拥有委托对象和数据源方法。如果某个新创建的对象是一个对象的委托对象或数据源方法，那么该对象应该在其`dealloc`方法中取消相应的关联。
- 对象不拥有目标。如果某个新创建的对象是另一个对象的目标，那么该对象应该再起`dealloc`方法中将相应的目标指针赋为nil.
- 在`Block`对象中使用self, 应该使用`weak`指针避免强引用循环。

```
BViewController *vc = [[BViewController alloc]init];
__weak AViewController *weakSelf = self; //避免循环引用
[vc passBlock:^(NSString *text) {
    weakSelf.anotherTextLabel.text = text;
}];
```
- 在`Block`对象中使用实例变量时，应该使用局部强引用。不要直接存取实例变量，使用存取方法。

```
BViewController *vc = [[BViewController alloc]init];
__weak AViewController *weakSelf = self; //避免循环引用
[vc passBlock:^(NSString *text) {
    weakSelf.anotherTextLabel.text = text;
    AViewController *innerSelf = weakSelf; //局部强引用
    NSLog(@"假如AViewController 存在name这个属性的话，它的值为:%@", innderSelf.name);
}];
```

### 参考资料
---
- 《Objective-C编程》(第二版) 王蕾 译. 华中科技大学出版社
- [iOS 简单易懂的 Block 回调使用和解析](http://www.jianshu.com/p/7d32ed28292f)
- [ios - block数据的回调](http://www.cnblogs.com/adampei-bobo/p/5370426.html)


