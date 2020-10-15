# Nginx配置

nginx配置文件主要分成四个部分：

- main，全局设置，影响其它部分所有设置
- server，主机服务相关设置，主要用于指定虚拟主机域名、IP和端口
- location，URL匹配特定位置后的设置，反向代理、内容篡改相关设置
- upstream，上游服务器设置，负载均衡相关配置

他们之间的关系式：server继承main，location继承server；upstream既不会继承指令也不会被继承