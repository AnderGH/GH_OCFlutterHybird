# GH_OCFlutterHybird


参考官方文档：

[https://flutter.cn/docs/development/add-to-app](https://flutter.cn/docs/development/add-to-app)

[https://flutter.dev/docs/development/add-to-app/](https://flutter.dev/docs/development/add-to-app)

### 一、创建并集成

1. 使用命令行为原生工程创建`flutter`模块

```
flutter create --template module FlutterProject
```

2. 使用`CocoaPods`集成源码

```
flutter_application_path = '../FlutterProject'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'NativeProject' do
  install_all_flutter_pods(flutter_application_path)
end
```

3. 使用命令行打包成`framework`集成

```
flutter build ios-framework --output=some/path/MyApp/Flutter/
flutter build ios-framework --cocoapods --output=some/path/MyApp/Flutter/
```

命令行中加入`--cocoapods`参数会输出`Flutter.podspec`替代`Flutter.framework`，该`podspec`中为官方提供的`Flutter.framework`的集成地址，方便用户集成


### 二、iOS和Flutter混合开发交互方案

#### 1、路由管理

1. 官方方法

`FlutterEngine`是官方提供的管理类，推荐在`App`启动时初始化，由于该类占用内存较多，所以推荐只创建一次，每个`Flutter`页面都使用同一个`FlutterEngine`初始化

`FlutterViewController`是官方提供的控制器，集成`UIViewController`，推荐使用如下方法初始化

```
/**
 * Initializes this FlutterViewController with the specified `FlutterEngine`.
 *
 * The initialized viewcontroller will attach itself to the engine as part of this process.
 *
 * @param engine The `FlutterEngine` instance to attach to. Cannot be nil.
 * @param nibName The NIB name to initialize this UIViewController with.
 * @param nibBundle The NIB bundle.
 */
- (instancetype)initWithEngine:(FlutterEngine*)engine
                       nibName:(nullable NSString*)nibName
                        bundle:(nullable NSBundle*)nibBundle NS_DESIGNATED_INITIALIZER;
```

> 注：官方文档中的隐式`FlutterEngine`创建`FlutterViewController`的方法会产生新的`FlutterEngine`，不推荐使用

使用推荐方法创建的`FlutterViewController`默认加载的`Flutter`端`main.dart`中的`main()`方法，所以会直接展示对应绑定的页面

针对如上流程，当原生打开指定的`Flutter`页面时，初始化`FlutterViewController`后，使用`pushRoute`方法定位到对应的页面

```
/**
 * Instructs the Flutter Navigator (if any) to go back.
 */
- (void)popRoute;

/**
 * Instructs the Flutter Navigator (if any) to push a route on to the navigation
 * stack.
 *
 * @param route The name of the route to push to the navigation stack.
 */
- (void)pushRoute:(NSString*)route;
```

> 注：`pushRoute`方法定位页面后，`main.dart`中的`main()`方法绑定的初始页面依然存在，所以在需要退出`Flutter`页面时，直接从原生关闭

相连多个`Flutter`页面之间建议仍然使用同一个`controller`，减少内存占用，便于整体状态（例如：黑暗模式等）维护

2. 第三方插件`flutter_boost`

`flutter_boost`是咸鱼团队开发的针对`flutter`混合开发的插件，能像原生一样直接打开相应的`flutter`页面，并且集成了对原生`App`前后台状态的监听和原生控制器的生命周期的监听，功能较为完善，混合开发推荐使用

```
/**
 * 初始化FlutterBoost混合栈环境。应在程序使用混合栈之前调用。如在AppDelegate中。本函数默认需要flutter boost来注册所有插件。
 *
 * @param platform 平台层实现FLBPlatform的对象
 * @param callback 启动之后回调
 */
- (void)startFlutterWithPlatform:(id<FLBPlatform>)platform
                         onStart:(void (^)(FlutterEngine *engine))callback;
/**
 * 初始化FlutterBoost混合栈环境。应在程序使用混合栈之前调用。如在AppDelegate中。本函数默认需要flutter boost来注册所有插件。
 *
 * @param platform 平台层实现FLBPlatform的对象
 * @param engine   外部实例化engine后传入
 * @param callback 启动之后回调
 */
- (void)startFlutterWithPlatform:(id<FLBPlatform>)platform
                          engine:(FlutterEngine* _Nullable)engine
                         onStart:(void (^)(FlutterEngine *engine))callback;
```


#### 2、FlutterMethodChannel通信

`FlutterMethodChannel`是官方提供的原生和`Flutter`通信的工具，支持双向通信，通过该实例对象，触发方法，推荐使用单例持久化

通过`FlutterMethodChannel`可以实现对原生容器的修改，包括打开原生页面等

```
/**
 * Invokes the specified Flutter method with the specified arguments, expecting
 * an asynchronous result.
 *
 * @param method The name of the method to invoke.
 * @param arguments The arguments. Must be a value supported by the codec of this
 *     channel.
 * @param callback A callback that will be invoked with the asynchronous result.
 *     The result will be a `FlutterError` instance, if the method call resulted
 *     in an error on the Flutter side. Will be `FlutterMethodNotImplemented`, if
 *     the method called was not implemented on the Flutter side. Any other value,
 *     including `nil`, should be interpreted as successful results.
 */
- (void)invokeMethod:(NSString*)method
           arguments:(id _Nullable)arguments
              result:(FlutterResult _Nullable)callback;
/**
 * Registers a handler for method calls from the Flutter side.
 *
 * Replaces any existing handler. Use a `nil` handler for unregistering the
 * existing handler.
 *
 * @param handler The method call handler.
 */
- (void)setMethodCallHandler:(FlutterMethodCallHandler _Nullable)handler;
```

### 三、`flutter_boost`参考代码

详细内容见`github`

