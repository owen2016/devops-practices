# Fluentd 示例

## 示例1- 监听Apache访问日志

Apache日志文件：/var/log/httpd/access_log
日志文件格式：combined

事件信息收集设定

1. 首先需要配置从哪里收集信息

``` xml
# gather apache access log
<source>
  type tail  ← 指定in_tail插件
  path /var/log/httpd/access_log  ← 指定日志文件路径
  tag apache.access  ← 指定标签，该标签用于 match 条件
  pos_file /var/log/td-agent/httpd-access_log.pos  ← 保存Apache log文件读取位置信息
  format apache2  ← 指定解析的日志文件格式
</source>
```

推荐配置「pos_file」参数，虽然不是必须配置的参数，是记录被监视文件读取位置(如第10行为止已读取)的重要文件。

2. 使用 out_file 插件进行日志文件的保存。

``` xml
<match apache.access>  ← 指定标签
  type file  ← 指定out_file插件
  path /var/log/td-agent/httpd/access.log  ← 指定输出文件
  time_slice_format %Y%m%d  ← 文件添加日期信息
  time_slice_wait 10m  ← 文件添加日期信息
  compress gzip  ← gzip压缩输出文件
</match>
```

out_file插件不仅是输出信息至文件，还可以根据 time_slice_format 参数值进行输出文件的切换，例如参数值为 %Y%m%d 时，输出文件名根据日期后缀变为 .＜年＞＜月＞＜日＞

需注意的是在fluentd，事件发生时间和fluentd接收事件信息时间有时会发生时差，因此会出现输出文件日期和实际内容不相符的情况。例如23:55发生的事件信息的接收事件是0:01，这时用日期切换输出文件可能会导致该事件信息的丢失。

这时可指定 time_slice_wait 参数，该参数是out_file插件根据日期分割输出文件之后，等待多长时间之后向新文件输出信息，在这里10m是10分钟

## 示例2- 监听Nginx访问日志

``` xml
<source>
  @type tail
  @id nginx-access
  @label @nginx
  path /var/log/nginx/access.log
  pos_file /var/lib/fluentd/nginx-access.log.posg
  tag nginx.access
  format /^(?<remote>[^ ]*) (?<host>[^ ]*) \[(?<time>[^\]]*)\] (?<code>[^ ]*) "(?<method>\S+)(?: +(?<path>[^\"]*) +\S*)?" (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)")?$/
  time_format %d/%b/%Y:%H:%M:%S %z
</source>

<source>
  @type tail
  @id nginx-error
  @label @nginx
  path /var/log/nginx/error.log
  pos_file /var/lib/fluentd/nginx-error.log.posg
  tag nginx.error

  format /^(?<time>\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}) \[(?<log_level>\w+)\] (?<pid>\d+).(?<tid>\d+): (?<message>.*)$/
</source>

<label @nginx>
  <match nginx.access>
    @type mongo
    database nginx
    collection access
    host 10.47.12.119
    port 27016

    time_key time
    flush_interval 10s
  </match>
  <match nginx.error>
    @type mongo
    database nginx
    collection error
    host 10.47.12.119
    port 27016

    time_key time
    flush_interval 10s
  </match>
</label>

```

为了匹配，你也需要修改 Nginx 的 log_format 为：

` log_format main '$remote_addr $host [$time_local] $status "$request" $body_bytes_sent "$http_referer" "$http_user_agent"'; `

## 更多配置案例

- <https://docs.fluentd.org/how-to-guides>

``` xml
<source>
  @type tcp
  tag tcp.events # required
  <parse>
    @type regexp
    expression /^(?<field1>\d+):(?<field2>\w+)$/
  </parse>
  port 5170   # optional. 5170 by default
  bind 0.0.0.0 # optional. 0.0.0.0 by default
  delimiter \n # optional. \n (newline) by default
</source>

## built-in TCP input
## @see http://docs.fluentd.org/articles/in_forward
<source>
  @type forward
  @id input_forward
  <security>
    self_hostname input.local
    shared_key liang_handsome
  </security>
</source>

<filter example.*.*>
  @type grep
  regexp1 levelStr (INFO|WARN|ERROR)
</filter>

# Match events tagged with "myapp.access" and
# store them to /var/log/fluent/access.%Y-%m-%d
# Of course, you can control how you partition your data
# with the time_slice_format option.
<match example.*.*>
  @type file
  path E:\software\fluentd\td-agent\log\output_file
</match>

```
