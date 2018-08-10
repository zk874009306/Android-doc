                                                  LIVE555基础

 
url from

https://blog.csdn.net/ithzhang/article/details/38613359


LIVE555是为流媒体提供解决方案的跨平台C++开源项目。从今天起我们将正式开始深入LIVE555代码。

 

一、各库简要介绍

    LIVE555下包含LiveMedia、UsageEnvironment、BasicUsageEnvironment、GroupSock库，MediaServer简单服务器程序以及其他多个测试demo。

    LiveMedia库：包含一系列处理不同编码格式和封装格式的类，基类是Medium。

    UsageEnvironment库：环境类，用于错误信息的输出。LIVE555中多数类中均包含此类对象指针。其内部包含TaskSchedule抽象类的指针，该类用于任务调度，因此所有包含UsageEnvironment指针的类均可将自己加入到调度中。

    BasicUsageEnvironment库：包含具体环境类和具体TaskScheduler类。UsageEnvironment用于对错误信息的处理，BasicUsageEnvironment类用于以控制台方式输出错误信息。因此想要以其他方式输出错误信息的类，可以从UsageEnvironment派生。BasicTaskSchedule类继承自TaskScheduler抽象类，用以定义具体的调度策略。任何基于LIVE555的应用程序均需要定义自己的BasicEnvironment和TaskScheduler库。如果创建窗口应用程序，在重定义TaskScheduler时，需要与图形环境自己的事件处理框架集成。BasicTaskSheduler使用select模型实现事件的获取和处理。如果想使用更高效的IOCP模型，可以定义自己的BasicTaskScheduler类。BasicTaskScheduler内部有一个循环，循环读取队列中的消息并处理。整个基于BasicTaskScheduler的程序只有一个线程驱动。

    GroupSock库：对各种socket操作的封装，用于收发数据。主要面向组播，但也可以进行单播的收发数据，仅支持UDP，不支持TCP。

    MediaServer 服务器程序：该程序使用BasicUsageEnvironment库实现，因此是一个控制台程序。任务调度类是BasicTaskScheduler类，因此使用Select模型且仅有一个线程在循环处理各种事件。后期如果有时间会实现基于IOCP的MediaServer服务器程序。

    其他测试Demo：基于LIVE555实现的客户端程序，会在需要的时候介绍。

 

二、涉及到的基本概念

 

1.  Souce、Sink

    Souce ：翻译为源、源头。表示数据的提供者，比如通过RTP读取数据，通过文件读取数据或者从内存读取数据，这些均可以作为Souce。

    Sink：翻译为水槽。表示数据的流向、消费者。比如写文件、显示到屏幕等。

    Filter：翻译为过滤器。在数据流从Souce流到Sink的过程中可以设置Filter，用于过滤或做进一步加工。

    在整个LiveMedia中，数据都是从Souce，经过一个或多个Filter，最终流向Sink。在服务器中数据流是从文件或设备流向网络，而在客户端数据流是从网络流向文件或屏幕。

 

    MediaSouce是所有Souce的基类，MediaSink是所有Sink的基类。

 

    从类数量和代码规模可以看到，LiveMedia类是整个LIVE555的核心，其内部包含数十个操作具体编码和封装格式的类。LiveMedia定义的各种Souce均是从文件读取，如果想实现从设备获得实时流的传输，可以定义自己的Souce。

 

2.  ClientSession

    对于每一个连接到服务器的客户端，服务器会为其创建一个ClientSession对象，保存该客户端的socket、ip地址等。同时在该客户端中定义了各种响应函数用以处理和回应客户端的各种请求。新版（2014.7.4）的LIVE555增加了ClientConnection类。用于处理一些与正常播放无关的命令。如命令未找到、命令不支持或媒体文件未找到等。在ClientConnection处理DESCRIBE命令时会创建ClientSession对象，其他命令在ClientSession中处理。

 

3.  MediaSession、MediaSubsession、Track

    LIVE555使用MediaSession管理一个包含音视频的媒体文件，每个MediaSession使用文件名唯一标识。

    使用SubSession管理MediaSession中的一个音频流或视频流。为行文方便我们称音频或视频均为一个媒体文件中的媒体流。因此一个MediaSession可以有多个MediaSubsession，一个管理音频流一个管理视频流。

    在上一篇介绍RTSP协议时，客户端在给服务器发送DESCRIBE查询某个文件的SDP信息时，服务器会给客户端返回该媒体文件所包含的多个媒体流信息。并为每个媒体流分配一个TrackID。如视频流分配为Track1，音频流分配为Track2。此后客户端必须在URL指定要为那个Track发送SETUP命令。

    因此我们可以认为MediaSubsession代表Server端媒体文件的一个Track，也即对应一个媒体流。MediaSession代表Server端一个媒体文件。对于既包含音频又包含视频的媒体文件，MediaSession内包含两个MediaSubsession。

    但MediaSession和MediaSubsession仅代表静态信息，若多个客户端请求同一个文件，服务器仅会创建一个MediaSession。各个客户端公用。为了区分各个MediaSession的状态又定义了StreamState类，用来管理每个媒体流的状态。在MediaSubsession中完成了Souce和Sink连接。Souce对指针象会被设置进sink。在Sink需要数据时，可以通过调用Souce的GetNextFrame来获得。

 

    LIVE555中大量使用简单工厂模式，每个子类均有一个CreateNew静态成员。该子类的构造函数被设置为Protected，因此在外部不能直接通过new来构造。同时，每个类的构造函数的参数中均有一个指向UsageEnvironment的指针，从而可以输出错误信息和将自己加入调度。

 

4. HashTable

    LIVE555内部实现了一个简单哈希表类BasicHashTable。在LIVE555中，有很多地方需要用到该哈希表类。如：媒体文件名与MediaSession的映射，SessionID与ClientSession的映射，UserName和Password的映射等。

 

5. SDP

    SDP是Session Description Protocol的缩写。是一个用来描述多媒体会话的应用层协议，它是基于文本的，用于会话建立过程中的媒体类型和编码方案的协商等。客户端会通过DESCRIBE命令请求查询指定文件的媒体信息。有不明白的可以看下上一篇介绍RTSP、RTP、RTCP的文章。

 

6.  LIVE555中的关键类继承层次（均以对H264码流的处理为例）

   大家可以先混个脸熟，以后会详细介绍。

                  Souce

                                                        

                            

    H264VideoStreamFramer是真正的Souce，它用于从h264文件中读取数据，并组装成帧。在Sink调用GetNextFrame时将帧数据返回给Sink。

 

                  Sink

                                  

    H264VideoRTPSink是真正的Sink，用于完成帧数据的发送。

 

                  SubSession

                                 

    SubSession用于完成Souce和Sink的连接，同时用于管理每个媒体流。

                                                                                                                              

对于H264码流，数据流的流动方向为：

    服务器端：H264VideoStreamFramer ->H264Or5Fragmenter (Filter)r->H264VideoRTPSink

    客户端：H264RTPSouce ->Sink（不同客户端实现不同）

 

     LIVE555类之间关系很是复杂，类之间犬牙交错的关系增大了学习LIVE555的难度，深入学习之前应先熟悉基本流程，对各类的大概功能有所了解，至于细节问题可暂时略过。 

     对于LIVE555的代码风格，本人不是很喜欢：一是成员变量命名方式。二是花括号（{）紧跟在上一行的末尾，没有上下对齐层次清晰。三是多句代码位于同一行，多见于if语句。当然这仅仅是是个人喜好。欢迎大家表达自己的见解。

     文章的最后，让我们来探讨下LIVE555应该如何发音的问题。听过不少人都读成： [liv]（力V555）。个人感觉不对。因为live作为动词讲时，确实是读成：力V，但此时是居住、生存、经历的意思。作为形容词讲时是活的、直播、生动的。此时应读成：赖V。作为一个为流媒体提供解决方案的开源C++项目，应该离直播更近一些吧！个人认为应该读成赖V555。更洋气的读法：赖V Triple Five！这都是个人想当然的读法，没有听过老外如何读，欢迎拍砖！

 

    下节我们将从服务器程序入手，开始介绍LIVE555源码。
