                                     LIVE555研究之二RTSP、RTP/RTCP协议介绍

url from  https://blog.csdn.net/ithzhang/article/details/38346557 

一、概述

    RTSP(Real-Time Stream Protocol )是一种基于文本的应用层协议，在语法及一些消息参数等方面，RTSP协议与HTTP协议类似。

    RTSP被用于建立的控制媒体流的传输，它为多媒体服务扮演“网络远程控制”的角色。RTSP本身并不用于传送媒体流数据。媒体数据的传送可通过RTP/RTCP等协议来完成。

  基本的RTSP操作过程

   首先，客户端连接到流服务器并发送一个OPTIONS命令查询服务器提供的方法收到服务器的回应后，发送DESCRIBE命令查询某个媒体文件的SDP信息。流服务器通过一个SDP描述来进行回应，回应信息包括流数量、媒体类型等信息。客户端分析该SDP描述，并为会话中的每一个流发送一个SETUP命令，SETUP命令告诉服务器客户端用于接收媒体数据的端口。流媒体连接建立完成后，客户端发送一个PLAY命令，服务器就开始传送媒体流数据。在播放过程中客户端还可以向服务器发送PAUSE等其他命令控制流的播放。通信完毕，客户端可发送TERADOWN命令来结束流媒体会话。

   是通过wireshark抓包获得的完整客户端与服务器进行的RTSP交互。黑色字体表示客户端请求，红色字体表示服务器回应。

OPTIONS rtsp://10.34.3.80/D:/a.264 RTSP/1.0
 
CSeq: 2
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
RTSP/1.0 200 OK
 
CSeq: 2
 
Date: Tue, Jul 22 2014 02:41:21 GMT
 
Public: OPTIONS, DESCRIBE, SETUP, TEARDOWN, PLAY, PAUSE, GET_PARAMETER, SET_PARAMETER
 
DESCRIBE rtsp://10.34.3.80/D:/a.264 RTSP/1.0
 
CSeq: 3
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
Accept: application/sdp
 
RTSP/1.0 200 OK
 
CSeq: 3
 
Date: Tue, Jul 22 2014 02:41:21 GMT
 
Content-Base: rtsp://10.34.3.80/D:/a.264/
 
Content-Type: application/sdp
 
Content-Length: 494
 
 
 
v=0
 
o=- 1405995833260880 1 IN IP4 10.34.3.80
 
s=H.264 Video, streamed by the LIVE555 Media Server
 
i=D:/a.264
 
t=0 0
 
a=tool:LIVE555 Streaming Media v2014.07.04
 
a=type:broadcast
 
a=control:*
 
a=range:npt=0-
 
a=x-qt-text-nam:H.264 Video, streamed by the LIVE555 Media Server
 
a=x-qt-text-inf:D:/a.264
 
m=video 0 RTP/AVP 96
 
c=IN IP4 0.0.0.0
 
b=AS:500
 
a=rtpmap:96 H264/90000
 
a=fmtp:96 packetization-mode=1;profile-level-id=42001E;sprop-parameter-sets=Z0IAHpWoLQSZ,aM48gA==
 
a=control:track1
 
SETUP rtsp://10.34.3.80/D:/a.264/track1 RTSP/1.0
 
CSeq: 4
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
Transport: RTP/AVP;unicast;client_port=60094-60095
 
RTSP/1.0 200 OK
 
CSeq: 4
 
Date: Tue, Jul 22 2014 02:41:25 GMT
 
Transport: RTP/AVP;unicast;destination=10.34.3.80;source=10.34.3.80;client_port=60094-60095;server_port=6970-6971
 
Session: 54DAFD56;timeout=65
 
PLAY rtsp://10.34.3.80/D:/a.264/ RTSP/1.0
 
CSeq: 5
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
Session: 54DAFD56
 
Range: npt=0.000-
 
RTSP/1.0 200 OK
 
CSeq: 5
 
Date: Tue, Jul 22 2014 02:41:25 GMT
 
Range: npt=0.000-
 
Session: 54DAFD56
 
RTP-Info: url=rtsp://10.34.3.80/D:/a.264/track1;seq=10244;rtptime=2423329550
 
GET_PARAMETER rtsp://10.34.3.80/D:/a.264/ RTSP/1.0
 
CSeq: 6
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
Session: 54DAFD56
 
RTSP/1.0 200 OK
 
CSeq: 6
 
Date: Tue, Jul 22 2014 02:41:25 GMT
 
Session: 54DAFD56
 
Content-Length: 10
 
 
 
//终止
 
TEARDOWN rtsp://10.34.3.80/D:/a.264/ RTSP/1.0
 
CSeq: 7
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
Session: 54DAFD56
 
RTSP/1.0 200 OK
 
CSeq: 7
 
Date: Wed, Jul 30 2014 07:13:35 GMT
 
 
     可以发现RTSP协议的格式与http协议很类似，都是基于文本的协议，语法也基本相同。但是它们并不相同，有以下主要差别：

        首先，方法名称不同。RTSP新增了DESCRIBE、SETUP、PLAY等方法。

       其次，HTTP协议是无状态的协议，方法之间的发送并无明显的次序关系。而RTSP是有状态的协议，各方法存在次序关系。

在者，HTTP协议可以以内带载荷数据的方式传送数据，如网页数据。而RTSP仅仅提供流播放的控制，并不传送流媒体数据。流媒体数据可以通过RTP/RTCP的方式传送。

 

二、RTSP消息

    1. RTSP请求消息格式

     方法名称 URL RTSP版本   回车换行

     消息头   回车换行  回车换行

     消息体    回车换行

 

    方法名称包括OPTIONS、DESCRIBE、SETUP、PLAY、TEARDOWN等。

    URL是接受方的地址，如:rtsp://192.168.0.1/video1.3gp。

    RTSP版本一般是RTSP/1.0

    消息的每一行都会以回车换行结尾，为了便于定位识别，消息头的最后一行有两个回车换行。

    消息体有时是可选的。

 

2. 回应消息格式

    RTSP版本状态码对应文本解释回车换行

    消息头       回车换行回车换行

    消息体    回车换行

 

    RTSP版本一般为RTSP/1.0。

    状态码表示对应消息的执行结果。

    部分状态码与文本解释对应列表如下：

   状态码       文本解释                      含义

  “200”         OK                              执行成功

  “400”         Bad Request                 错误请求

  “404”        Not Found                  未找到

  “500”        Internal Server Error   服务器内部错误

 

3. 各方法详细介绍

(1)OPTIONS

     客户端使用OPTION来查询服务器提供的方法。服务器会在public字段给出自己提供方法集合。从上面的抓包中可以看到此服务器提供了OPTIONS、DESCRIBE、 SETUP、 TEARDOWN、 PLAY,、PAUSE,、GET_PARAMETER、SET_PARAMETER等方法。

    OPTIONS方法并不是必须的。客户端可以绕过OPTIONS，直接向服务器发送其他消息。

CSeq字段表示请求的序号。客户端的每一个请求都会被赋值一个序号。每个请求消息也会对应一个同样序号的回应消息。

     OPTIONS消息可以在任何时间发送。有的客户端会定时向服务器发送OPTION消息。而服务器也可以通过是否定时收到OPTIONS消息来判断客户端是否在线。但并不是所有客户端和服务器都这样做。

     User Agent

     该域用于用户标识.不同公司或是不同的客户端。不同客户端发出的消息中的这个域的内容都不大相同。有时会指明客户端的版本号、型号等等。

     下面的对话中该字段指明采用VLC作为客户端，并给出版本号和使用LIVE555库的版本。


OPTIONS rtsp://10.34.3.80/D:/a.264 RTSP/1.0
 
CSeq: 2                                                                                              //请求序号
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
RTSP/1.0 200 OK
 
CSeq: 2                                                                                              //回复序号
 
Date: Tue, Jul 22 2014 02:41:21 GMT
 
Public: OPTIONS, DESCRIBE, SETUP, TEARDOWN, PLAY, PAUSE, GET_PARAMETER, SET_PARAMETER
 
 

(2)DESCRIBE

 

    DESCRIBE消息是由客户端发送到服务器端，用于客户端得到请求链接中指定的媒体文件的相关描述，一般是SDP信息。SDP（Session Description Protocol）包含了会话的描述、媒体编码类型、媒体的码率等信息。对于流媒体服务而言，以下几个域是在SDP中一定要包含的。

“a=control:”

“a=range:”

“a=rtpmap:”

“a=fmtp:”

     当一个录像中即包含音频又包含视频时，会有多个上述结构。每个媒体描述以m开始。下面绿色和黄色背景的字体分别表示对视频和音频媒体的描述。请求中的Accept字段用于指定客户端可以接受的媒体描述信息类型，此处为SDP信息。

    

DESCRIBE rtsp://10.34.3.80/D:/a.264 RTSP/1.0
 
CSeq: 3
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
Accept: application/sdp                                //请求获得SDP信息
 
RTSP/1.0 200 OK
 
CSeq: 3
 
Date: Tue, Jul 22 2014 02:41:21 GMT
 
Content-Base: rtsp://10.34.3.80/D:/a.264/                   //指明对某媒体的描述信息
 
Content-Type: application/sdp                                   //请求类型
 
Content-Length: 494                                                //SDP长度
 
 
 
v=0                                            //Version SDP协议的版本
 
o=- 1405995833260880 1 IN IP4 10.34.3.80            //Origion  会话的发起者信息
 
s=H.264 Video, streamed by the LIVE555 Media Server  //会话名称
 
 
 
i=D:/a.264                                                              //会话的描述信息
 
t=0 0                                                                      //会话的开始和结束时间
 
a=tool:LIVE555 Streaming Media v2014.07.04          //Attribute
 
a=type:broadcast
 
a=control:*                                                             //控制信息
 
a=range:npt=0-
 
a=x-qt-text-nam:H.264 Video, streamed by the LIVE555 Media Server
 
a=x-qt-text-inf:D:/a.264
 
m=video 0 RTP/AVP 96            //发送方所支持的媒体类型（视频）等信息
 
c=IN IP4 0.0.0.0               //会话连接信息，支出真正的媒体流使用的IP地址。
 
b=AS:500                                //视频带宽
 
a=rtpmap:96 H264/90000          //媒体属性行，视频（H264为视频格式，90000为采样率）
 
a=fmtp:96 packetization-mode=1;profile-level-id=42001E;sprop-parameter-sets=Z0IAHpWoLQSZ,aM48gA==
 
a=control:track1                       //该视频使用的track为1
 
 
 
m=audio 0 RTP/AVP 97         //媒体类型（音频）以下均是对该音频的描述信息
 
b=AS:19                              //音频带宽
 
a=rtpmap:97 MP4A-LATM/11025/1     //视频格式（MP4A-LATM为视频格式，11025为采样率）
 
a=fmtp:97 profile-level-id=15; object=2; cpresent=0; config=40002A103FC0
 
a=mpeg4-esid:101=x-envivio-verid:00011118
 
a=control:trackID=2               /该音频使用的track为2
 
 

    m行又称媒体行，描述了发送方所支持的媒体类型等信息，需要详细说明下。

    m=audio 3458  RTP/AVP  0   96   97   

    第一个参数audio为媒体名称：表明支持音频类型。

    第二个参数3488为端口号，表明UE在本地端口为3458上发送音频流。

    第三个参数RTP/AVP为传输协议，表示基于UDP的RTP协议。

    第四到七个参数为所支持的四种净荷类型编号。

    a=rtpmap:0   PCMU

    a=rtpmap:96  G726-32/8000

    a=rtpmap:97  AMR-WB

    a行为媒体的属性行，以属性的名称：属性值的方式表示。

   格式为：a=rtpmap:<净荷类型><编码名称>

   净荷类型0固定分配给了PCMU，

   净荷类型96对应的编码方案为G.726,为动态分配的。

   净荷类型97对应的编码方式为自适应多速率宽带编码（AMR-WB），为动态分配的。           

对于视频

    m=video 3400 RTP/AVP 98  99

   第一个参数video为媒体名称：表明支持视频类型。

   第二个参数3400为端口号，表明UE在本地端口为3400上发送视频流。

   第三个参数RTP/AVP为传输协议,表示RTP over UDP。

   第四、五参数给出了两种净荷类型编号

   a=rtpmap:98  MPV

   a=rtpmap:99  H.261

   净荷类型98对应的编码方案为MPV,为动态分配的。

   净荷类型97对应的编码方式为H.261，为动态分配的。

 

(3)SETUP

    SETUP消息用于确定转输机制，建立RTSP会话。客户端也可以在建立RTSP后再次发出一个SETUP请求为正在播放的媒体流改变传输参数，服务器可能同意这些参数。若不同意，会回应 "455 Method Not Valid In This State"。

     Request 中的Transport头字段指定了客户端可接受的数据传输参数；

     Response中的Transport 头字段包含了由服务器确认后的传输参数。

    如果该请求不包含SessionID，则服务器会产生一个SessionID。

 

SETUP rtsp://10.34.3.80/D:/a.264/track1 RTSP/1.0   //track1表示对1号通道进行设置
 
CSeq: 4
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)   //客户端版本信息
 
Transport: RTP/AVP;unicast;client_port=60094-60095       //约定传输参数 RTP/AVP表示采用RTP over UDP， unicast表示单播，用以区别组播。Client_port约定客户端RTP端口为60094，RTCP端口为60095
 
RTSP/1.0 200 OK
 
CSeq: 4
 
Date: Tue, Jul 22 2014 02:41:25 GMT
 
Transport: RTP/AVP;unicast;destination=10.34.3.80;source=10.34.3.80;client_port=60094-60095;server_port=6970-6971 //服务器端所指定的传输参数
 
Session: 54DAFD56;timeout=65    //SessionID          

 

    从上面的SETUP会话中可以看到RTP端口用偶数表示，RTCP对于tcp端口相邻的奇数端口。

    上面展示的是RTP over UDP方式。以下为使用RTP over TCP的SETUP对话。

SETUP rtsp://10.34.3.80/D:/a.264/track1 RTSP/1.0   //track1表示对1号通道进行设置
 
CSeq: 4
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)  
 
Transport: RTP/AVP/TCP;unicast;interleaved= 0-1
 
RTSP/1.0 200 OK
 
CSeq: 4
 
Date: Tue, Jul 22 2014 02:41:25 GMT
 
Transport:
 
 RTP/AVP/TCP;interleaved=0-1
 
Session: 54DAFD56;timeout=65
 
    可以看到SETUP命令的Transport字段为RTP/AVP/TCP，同时多了一个interleaved=0-1字段。由于RTP over TCP将RTP包和RTCP包发至同一个TCP端口，因此使用interleaved的值来区分到底是RTP还是RTCP包。Interleaved=0表示RTP包，interleaved=1表示RTCP包。

 

(4)PLAY

     PLAY方法通知服务器按照SETUP中指定的机制开始传送数据。服务器会从PLAY消息指定范围的开始时间开始传送数据，直到该范围结束。服务器可能会将PLAY请求放到队列中，后一个PLAY请求需要等待前一个PLAY请求完成才能得到执行。

     Range指定了播放开始的时间。如果在这个指定时间后收到消息，那么播放立即开始。

不含Range头的PLAY请求也是合法的，此时将从媒体流开始位置播放，直到媒体流被暂停。如果媒体流通过PAUSE暂停，媒体流传输将在暂停点继续传输。如果媒体流正在播放，那么该PLAY请求将不起作用。客户端可以利用此来测试服务器是否存活。

PLAY rtsp://10.34.3.80/D:/a.264/ RTSP/1.0
 
CSeq: 5
 
User-Agent: LibVLC/2.0.7 (LIVE555 Streaming Media v2012.12.18)
 
Session: 54DAFD56                 //SessionID，SETUP回应中返回
 
Range: npt=0.000-   /                /指定开始播放的时间
 
RTSP/1.0 200 OK
 
CSeq: 5
 
Date: Tue, Jul 22 2014 02:41:25 GMT
 
Range: npt=0.000- 
 
Session: 54DAFD56
 
RTP-Info: url=rtsp://10.34.3.80/D:/a.264/track1;seq=10244;rtptime=2423329550  //RTP信息
 
 
   Url字段为RTP参数对应的流媒体链接地址，seq字段为流媒体第一个包的序列号，rtptime为range域对应的RTP时间戳

 

(5)PAUSE

 

    PAUSE消息通知服务器暂停流传输的传输。如果请求URL中指定了具体的媒体流，那么只有该媒体流的播放被暂停。可以指定仅暂停音频，此后的播放将会静音。如果请求URL指定了一组流，那么在该组中的所有流的传输将被暂停。服务器有可能不支持PAUSE消息。例如，实时流就有可能不支持暂停。当一个服务器不支持某一个消息时，会回应给客户端“501 Not Implemented”。

 

    PAUSE请求中可能包含一个Range头，用来指定媒体流暂停的时间点，称之为暂停点。Range头必须包含一个精确的值，而不是一个时间范围。如果Range头指定了一个时间超出了PLAY请求的范围，服务器将将返回"457 Invalid Range" 。如果Range头缺失，那么在收到暂停消息后媒体流传输立即暂停，并将暂停点设置成当前播放时间。

 

(6) TEARDOWN

    TEARDOWN请求终止了给定URL的媒体流传输，并释放了与该媒体流相关的资源。

 

三、RTP/RTCP协议

     RTP是实时传输协议（Real-Time Transport Protocol）的缩写。是针对多媒体数据流的实时传输协议。通常建立在UDP协议之上，也可以建立在TCP协议之上。有人将其归为应用层协议，也有人将其归为传输层协议，这都是可以的。Rtp协议提供了时间戳和序列号。发送端在采样时设置时间戳，接收端收到后，会按照时间戳依次播放。RTP本身只保证实时数据的传输，并不能为按顺序传送的数据包提供可靠的传送机制，也不提供流量和拥塞控制，它依靠RTCP来提供这些服务。

             

    版本号（V）:0-1  2b 用来标识使用的RTP版本。

    填充位（P）:2  1b 如果该位被置为1，则RTP包的尾部会跟附加的填充字节。

    扩展位（X）：3 1b 如果该位被置为1，则RTP包的尾部会跟附加扩展帧头。

    CSRC计数器（CC）: 4-7 4b 固定头部后跟着的CSRC数目。

    标记位（M）: 8 1b 该位的解释由配置文档解释。

    载荷类型（PT）:9-15 7b标识RTP载荷的类型。

    序列号（SN）: 16- 31 16b发送方在发送完每一个RTP包后会将该域 的值加1，接收方可以通过检测序列号来判断是否出现RTP丢包现象。注意：序列号的初始值是随机的。

    时间戳：32 32b 该包中第一个字节的采样时刻。时间戳有一个初始值，随着时间的流逝而不断增加。即使此时没有包被发出，时间戳也会不段增加。时间戳是实现去除抖动和实现同步必不可少的。

    SSRC:同步源标识符： 32b  RTP包的来源，在同一个RTP会话中不能 有两个相同的SSRC值。该字段是根据一定的算法随机生成。

    CSRC List:贡献源列表 0-15个，每项32b 用来标识对一个RTP混合器产生的新包有贡献的所有RTP包的源。

 

RTCP协议

   RTCP是实时控制协议（Real-Time Control Protocol）的缩写。RTCP通常与RTP配合使用，用以管理传输质量在当前进程之间的交换信息。在RTP会话期间，各参与者周期性的传送RTCP包，RTCP包中包含已发送数据包的数量、丢失的数据包的数量等统计资料。服务器可以利用这些信息动态的改变传输速率，甚至改变有效载荷的类型。RTP和RTCP配合使用，可以有效且以最小的开销达到最佳传输效率，非常适合传送实时流。

 

    RTSP通常使用RTP协议来传送实时流，RTP一般使用偶数端口，而RTCP使用相邻的奇数端口，即RTP端口号+1。

     在RTCP通信控制中，RTCP协议的功能是通过不同类型的RTCP包来实现的。RTCP也是基于UDP包来传送的，主要有五种类型的封包：

    1.SR：发送端报告，由发送RTP数据报的应用程序或中端发出的。

    2.RR：接收端报告，由接受但不发送RTP数据报的应用程序或中端发出。

    3.SDES: 源描述，传递与会话成员有关的标识信息的载体，如用户名、邮件、电话等。

   4.BYE: 通知离开，通知回话中的其他成员将退出会话。

   5.APP: 由应用程序自己定义，作为RTCP协议的扩展。

                             

    版本（V）：同RTP包头部

    填充(P) ：同RTP包头部。

    接收报告计数器（RC）:5b 该SR包中接收的报告块的数目。

    包类型（PT）： 8bit SR包类型为200

    长度（length）：SR包以32bit为1单位的长度减1

    同步源（SSRC）：SR包发送的同步源标识符。与对应RTP包中的SSRC一样。

    NTP时间戳（Network Time Protocol）:SR包发送时的绝对时间。用于同步不同的流。

    RTP时间戳：与NTP时间戳对应，与RTP包中的时间戳具有相同的初始值。

    Send’s Packet count：从开始发包到产生这个SR包的这段时间内发送者发送的有效数据的总字节数，不包括头部和填充，发送者改变SSRC时，该域要清零。

    同步源n的SSRC标识符：该报告中包含的是从该源接收到的包的统计信息。

    丢失率：表明从上一个SR或RR包发出依来从同步源n发送的RTP包的丢失率。

    累计丢失数据：从开始接受SSRC_n的包到发送SR这个时间段内SSRC_n发送的RTP丢失的总数目。

    收到的扩展最大序列号：从SSRC_n收到的从RTP数据包中的最大序列号。

    接收抖动（Interarrival jitter）：RTP数据包接收时间的统计方差估计。

    上次SR时间戳（Last SR）：取最近从SSRC_n收到的SR包中的NTP时间戳中的中间32bit。如果还未收到SR包，则为0。

    上次依赖SR延迟（Delay since Last SR）：从上次SSRC_n收到SR包到发送本包的延迟。

 

音视频同步

    传送的音频和视频流位于两个不同的RTP会话中，每个RTP包均有自己的时间戳，同时RTCP包中的NPT字段（Network Protocol Time）保存的绝对时间可以用来将音视频映射到同一时间轴上，从而实现音视频同步。

 

    上述各协议在TCP/IP中的位置

                                    

 

          下篇文章将介绍LIVE555基础。
