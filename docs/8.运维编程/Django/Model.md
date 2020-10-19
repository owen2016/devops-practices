# 模型定义

## models模型类的常用数据类型
- AutoField：自动增长的IntegerField，通常不用指定，不指定时Django会自动创建属性名为id的自动增长属性
- BooleanField：布尔字段，值为`True`或`False`，默认值是None
- NullBooleanField：支持`Null`、`True`、`False`三种值
    > 在HTML表单中体现为CheckboxInput标签。如果要接收null值，请使用NullBooleanField
- CharField：字符串，必须有 max_length 参数指定长度
- SlugField：只能包含字母，数字，下划线和连字符的字符串
    > 通常被用于URLs表示。可选参数max_length=50，prepopulate_from用于指示在admin表单中的可选值
- CommaSeparatedIntegerField：逗号分隔的整数类型
    > 必须接收一个max_length参数。常用于表示较大的金额数目，例如1,000,000元
- TextField：大文本字段，一般超过4000个字符时使用
- IntegerField：整数
- DecimalField：十进制浮点数，有两个必须参数，max_digits数字允许的最大位数，decimal_places小数的最大位数，通常用来表示金额
    > max_digits数字允许的最大位数\
    > decimal_places小数的最大位数
- FloatField：浮点数
- DateField：日期
    > auto_now: 每次执行 save 操作的时候自动记录当前时间，常作为最近一次修改的时间 使用。注意：总是在执行save 操作的时候执行，无法覆盖\
    > auto_now_add: 第一次创建的时候添加当前时间。常作为 创建时间 使用。注意：每次create 都会调用
- TimeField：时间，附加选项和DateField一样
- DateTimeField：日期时间，附加选项和DateField一样
- FileField：上传文件字段，不支持 primary_key 和 unique 选项。否则会报 TypeError 异常
    > 必须设置 FileField.upload_to 选项，这个是 本地文件系统路径，附加在 MEDIA_ROOT 设置的后边，也就是 MEDIA_ROOT 下的子目录相对路径。默认的form widget 是 FileInput
- ImageField：继承于FileField，对上传的内容进行校验，确保是有效的图片
    > 在 FileField 基础上加上是否是合法图片验证功能的一个类型\
    > 除了 FileField 有的属性外，ImageField 另有 height 和 width 属性
- EmailField：在 CharField 基础上附加了 邮件地址合法性验证。不需要强制设定 max_length
- URLField：加了 URL 合法性验证的 CharField
    > 默认max_length=200，可修改

## models模型类的关系
-  一对多关系，models.ForignKey()
    ```
    字段参数:
        to : 设置要关联的表
        to_field : 设置要关联的表的字段。 默认关联的是表的id
        on_delete: 当删除关联表中的数据时，当前表与其关联的行的行为
            models.CASCADE :删除关联数据，与之关联也删除。
            models.DO_NOTHING:删除关联数据，引发错误IntegrityError。
            models.PROTECT: 删除关联数据，引发错误ProtectedError
    ```

-  多对多关系，models.ManyToManyField()
    ```
    字段参数:
        to: 设置要关联的表
        related_name: 设置关联属性名称
    ```

-  一对一关系，models.OntoOneField()
    ```
    1. 一对一的关联关系多用在当一张表的不同字段查询频次差距过大的情况下，将本可以存储在一张表的字段拆开放置在两张表中，然后将两张表建立一对一的关联关系

    2. 字段参数:
        to:设置要关联的表
        to_field:设置要关联的字段
        on_delete: 同ForeignKey字段
    ```

## models模型字段定义的选项
通过选项实现对字段的约束，选项如下：
- null：如果为True，表示允许为空(`数据库层面验证`)，默认值是False。
- blank：如果为True，则该字段允许为空白（`validate验证层面`），默认值是False。
- 对比：null是数据库范畴的概念，blank是表单验证证范畴的。
- db_column：字段的名称，如果未指定，则使用属性的名称。
- db_index：若值为True, 则在表中会为此字段创建索引，默认值是False。
- default：默认值。
- help_text：admin模式下帮助文档，form widget 内显示帮助文本
- primary_key：若为True，则该字段会成为模型的主键字段，默认值是False，一般作为AutoField的选项使用。
- unique：如果为True, 这个字段在表中必须有唯一值，默认值是False。
- unique_for_date：字符串类型，值指向一个DateTimeField 或者 一个 DateField的列名称。日期唯一，如下例中系统将不允许title和pub_date两个都相同的数据重复出现 
- verbose_name：string类型。更人性化的列名，一般用于导出文件，显示为文件的表头列名，数据可以通过queryset语句来获取
- validators：自定义验证，有效性检查。无效则抛出 django.core.validators.ValidationError 异常

## models class Meta

可用的元选项：
- abstract--抽象类
    ```
    1. 这个属性是定义当前的模型类是不是一个抽象类
    2. 所谓抽象类是不会生成相应数据库表的
    3. 般我们用它来归纳一些公共属性字段，然后继承它的子类能够继承这些字段
    ```
- db_table--重写数据表名称
    ```
    默认情况下，Django 会根据模型类的名称和包含它的应用的名称自动指定数据库表名称

    eg: blog_type(blog:APP名称，type：模型类名称)
    ```
- ordering--排序
    ```
    1. 对象默认的顺序，获取一个对象的列表时使用
    2. 它是一个字符串的列表或元组。每个字符串是一个字段名，前面带有可选的“-”前缀表示倒序。前面没有“-”的字段表示正序。使用"?"来表示随机排序

    eg: ordering = ['-order_date'] 按order_date倒序排序
    ```
- verbose_name--模型类的单数名称
- verbose_name_plural--模型类的复数名称
- unique_together--添加unique
    ```
    用来设置的不重复的字段组合：unique_together = (("driver", "restaurant"),)
        1. 它是一个元组的元组，组合起来的时候必须是唯一的
        2. 它在Django后台中被使用，在数据库层上约束数据(比如，在  CREATE TABLE  语句中包含  UNIQUE语句)
    ```
- index_together--添加索引
    ```
    用来设置带有索引的字段组合：
        index_together = (
            ("pub_date", "deadline"),
        )
    列表中的字段将会建立索引
    ```

# 模型案例
```py
from django.db import models

class Book(models.Model):
    id = models.AutoField(verbose_name='主键', blank=False, primary_key=True, help_text="图书记录的主键")
    title = models.CharField(verbose_name='标题', max_length=500, blank=True, default='', help_text="图书的标题")
    sn = models.CharField(verbose_name='图书编号', max_length=25, blank=False, unique=True, help_text="图书编号")
    is_on_shelf = models.BooleanField(verbose_name='当前上架状态', blank=False, default=False, help_text='图书是否上架，False表示未上架，True表示已上架')
    sell_price = models.FloatField(verbose_name='当前售价', blank=True, help_text='图书当前售价')
    description = models.TextField(verbose_name='描述', default='', blank=True, help_text='描述')
    created_time = models.DateTimeField(verbose_name='创建时间', auto_now_add=True, help_text="记录创建时间")
    updated_time = models.DateTimeField(verbose_name='更新时间', auto_now=True, help_text="记录更新时间")
    is_deleted = models.BooleanField(verbose_name='已删除', default=False, help_text="记录是否删除")

    class Meta:
        db_table = 'book'
        ordering = ('-created_time',)
        verbose_name = '图书信息'
        verbose_name_plural = '图书信息'
        # 创建的联合索引
        index_together = ('title', 'sn')
```