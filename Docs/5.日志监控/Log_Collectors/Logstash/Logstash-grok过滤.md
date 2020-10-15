# 过滤

logstash直接输入预定义好的 JSON 数据，这样就可以省略掉 filter/grok 配置,但是在我们的生产环境中，日志格式往往使用的是普通的格式，因此就不得不使用logstash的filter/grok进行过滤