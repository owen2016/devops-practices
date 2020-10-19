# SEO

[TOC]

SEO（Search Engine Optimization）：汉译为搜索引擎优化。是一种方式：利用搜索引擎的规则提高网站在有关搜索引擎内的自然排名。目的是让其在行业内占据领先地位，获得品牌收益。很大程度上是网站经营者的一种商业行为，将自己或自己公司的排名前移。

网站搜索引擎优化任务主要是认识与了解其它搜索引擎怎样紧抓网页、怎样索引、怎样确定搜索关键词等相关技术后，以此优化本网页内容，确保其能够与用户浏览习惯相符合，并且在不影响网民体验前提下使其搜索引擎排名得以提升，进而使该网站访问量得以提升，最终提高本网站宣传能力或者销售能力的一种现代技术。基于搜索引擎优化处理，其实就是为让搜索引擎更易接受本网站，搜索引擎往往会比对不同网站的内容，再通过浏览器把内容以最完整、直接及最快的速度提供给网络用户

## 新站告诉搜索引擎

很多新手站长，网站上线后没有主动的向搜索引擎提交，spider在短期内无法第一时间发现新网站，这个时候我们
需要把网站URL地址主动的告诉搜索引擎。

常见的搜索引擎链接提交入口，是新网站通知搜索引擎抓取的最佳通常。

百度链接提交入口 http://zhanzhang.baidu.com/linksubmit/url
Google网站登录口：https://www.google.com/webmasters/tools/submit-url
360搜索引擎登录入口：http://info.so.360.cn/site_submit.html
搜狗网站收录提交入口:http://www.sogou.com/feedback/urlfeedback.php
必应网站提交登录入口：http://www.bing.com/toolbox/submit

## 提交百度收录

建立了自己的网站，就需要快速的让自己的网站被搜索引擎网站收录，如何让自己的网站快速被百度收录呢？

在百度和谷歌上分别搜索

`site:devopsing.site`

其中的域名换成你的博客域名，如果此前没有进行过操作，应该是搜不到的，并且搜索出来的结果含有搜索引擎提交入口
分别进入搜索引擎提交入口 (<https://ziyuan.baidu.com/site/index#/>)，添加域名，选择验证网站，有3种验证方式，本文推荐采用HTML标签验证

![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201018073157.png)

下面百度针对不同的链接提交进行了解释。

1、主动推送：最为快速的提交方式，推荐您将站点当天新产出链接立即通过此方式推送给百度，以保证新链接可以及时被百度收录。
2、自动推送：最为便捷的提交方式，请将自动推送的JS代码部署在站点的每一个页面源代码中，部署代码的页面在每次被浏览时，链接会被自动推送给百度。可以与主动推送配合使用。
3、sitemap：您可以定期将网站链接放到sitemap中，然后将sitemap提交给百度。百度会周期性的抓取检查您提交的sitemap，对其中的链接进行处理，但收录速度慢于主动推送。
4、手动提交：一次性提交链接给百度，可以使用此种方式。

友情提示：并不是说使用了提交就百分百会收录，只是增加被收录发现机率。

如果你的内容都是抄袭转载来的，未经过任何加工处理，反而会带来负责影响，比如说降权。
您可以提交想被百度收录的链接，百度搜索引擎会按照标准处理，但不保证一定能够收录您提交的链接

### 添加站点地图-sitemap

```shell
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
```

``` shell
sitemap:
path: sitemap.xml
baidusitemap:
path: baidusitemap.xml
```

博客的public文件夹下面就会出现站点地图sitemap.xml和baidusitemap.xml,然后分别在百度和谷歌上提交站点地图就好了

### 主动推送(API推送)到百度

某些主机，比如Github，禁止百度爬虫访问博客，导致博客无法被百度收录。多亏百度提供了主动提交的接口，这才有了个补救的方法。

除此之外， 使用主动推送还会达到如下功效：

- 及时发现：可以缩短百度爬虫发现您站点新链接的时间，使新发布的页面可以在第一时间被百度收录
- 保护原创：对于网站的最新原创内容，使用主动推送功能可以快速通知到百度，使内容可以在转发之前被百度发现

**参考：**

- <https://github.com/huiwang/hexo-baidu-url-submit>

- <https://hui-wang.info/2016/10/23/Hexo%E6%8F%92%E4%BB%B6%E4%B9%8B%E7%99%BE%E5%BA%A6%E4%B8%BB%E5%8A%A8%E6%8F%90%E4%BA%A4%E9%93%BE%E6%8E%A5/>

1. 首先，在Hexo根目录下，安装本插件：
`npm install hexo-baidu-url-submit --save`

2. 然后，同样在根目录下，把以下内容配置到_config.yml文件中:

``` shell
baidu_url_submit:
  count: 3 ## 比如3，代表提交最新的三个链接
  host: www.hui-wang.info ## 在百度站长平台中注册的域名
  token: your_token ## 请注意这是您的秘钥， 请不要发布在公众仓库里!
  path: baidu_urls.txt ## 文本文档的地址， 新链接会保存在此文本文档里
```

3. 其次，记得查看_config.ym文件中url的值， 必须包含是百度站长平台注册的域名（一般有www）， 比如:

```shell
# URL
url: http://www.devopsing.site
root: /
permalink: :year/:month/:day/:title/
```

4. 最后，加入新的deployer:

``` shell
deploy:
- type: git
  repo:
    coding: https://用户名:密码@git.coding.net/bellonor/bellonor.git,master
- type: baidu_url_submitter
```

执行hexo deploy的时候，新的连接就会被推送了。

实现原理
推送功能的实现，分为两部分：

- 新链接的产生， hexo generate 会产生一个文本文件，里面包含最新的链接
- 新链接的提交， hexo deploy 会从上述文件中读取链接，提交至百度搜索引擎

### 自动推送到百度

自动推送JS代码是百度站长平台最新推出的轻量级链接提交组件，站长只需将自动推送的JS代码放置在站点每一个页面源代码中，当页面被访问时，页面链接会自动推送给百度，有利于新页面更快被百度发现。

![](https://gitee.com/owen2016/pic-hub/raw/master/pics/20201018220605.png)

``` js
<script>
(function(){
    var bp = document.createElement('script');
    var curProtocol = window.location.protocol.split(':')[0];
    if (curProtocol === 'https') {
        bp.src = 'https://zz.bdstatic.com/linksubmit/push.js';
    }
    else {
        bp.src = 'http://push.zhanzhang.baidu.com/push.js';
    }
    var s = document.getElementsByTagName("script")[0];
    s.parentNode.insertBefore(bp, s);
})();
</script>
```

一般在以下参考目录中加入JS，这样全站都有了

`blog\themes\hiker\layout\_partial\head.ejs`

**为什么自动推送可以更快的将页面推送给百度搜索？**
基于自动推送的实现原理问题，当新页面每次被浏览时，页面URL会自动推送给百度，无需站长汇总URL再进行API推送操作。

借助用户的浏览行为来触发推送动作，省去了站长人工操作的时间。

**自动推送和API推送有什么区别？**
已经在使用链接提交里的API推送（或sitemap）的网站还需要再部署自动推送代码吗？

二者之间互不冲突，互为补充。已经使用API推送的站点，依然可以部署自动推送的JS代码，二者一起使用。

## 参考

- <https://ziyuan.baidu.com/college/courseinfo?id=267&page=1>