# DjangoRest View使用介绍

## class APIView(View)
| 属性             | 值类型 | 作用   | 是否必须 |
| ------------------ | ------ | -------- | ---|
| permission_classes | tuple  | 权限控制 | 否|


| 方法                                       | 作用                                                      |
| -------------------------------------------- | ----------------------------------------------------------- |
| check_permissions(self, request)             | Check if the request should be permitted                    |
| check_object_permissions(self, request, obj) | Check if the request should be permitted for a given object |


## class GenericAPIView(views.APIView)

Base class for all other generic views.

| 属性           | 值类型  | 作用                                                              | 是否必须 |
| ---------------- | ---------- | ------------------------------------------------------------------- | ---- |
| queryset         | QuerySet   | `get_queryset()`使用                                              | 是 |
| serializer_class | serializer | `get_serializer_class()`使用                                      | 是 |
| lookup_field     | string     | If you want to use object lookups other than pk, set 'lookup_field' | 否 |
| lookup_url_kwarg | string     | url中变量                                                        | 否 |
| filter_backends  | tuple      | The filter backend classes to use for queryset filtering            | 否 |
| pagination_class | class      | The style to use for queryset pagination                            | 否 |


| 方法                                | 作用                                                                                                                 |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| get_queryset(self)                    | Get the list of items for this view. Defaults to using `self.queryset`                                                 |
| get_object(self)                      | Returns the object the view is displaying. `使用此方法会调用self.check_object_permissions(self.request, obj)`  |
| get_serializer(self, *args, **kwargs) | Return the serializer instance that should be used for validating and deserializing input, and for serializing output. |
| filter_queryset(self, queryset)       | Given a queryset, filter it with whichever filter backend is in use                                                    |
| paginate_queryset(self, queryset)     | Return a single page of results, or `None` if pagination is disabled.                                                  |

**备注:**

1. 使用GenericAPIView需要自己定义`['get', 'post', 'put', 'patch', 'delete']`方法，来处理对应的http请求.
2. 应该始终使用`get_queryset()`获取查询结果，而不是直接访问`self.queryset`，因为`self.queryset`只被评估一次作为缓存，为所有后续请求使用。
3. `GenericAPIView`提供的默认方法，可以根据需要`override`.直接在class中重写即可.

## 具体的View
`Concrete view classes that provide method handlers by composing the mixin classes with the base view.`


1. CreateAPIView(mixins.CreateModelMixin, GenericAPIView)

    实现了`post`方法,直接创建model的实例.

    只需要提供`queryset`和`serializer_class`，就可以直接使用.

2. ListAPIView(mixins.ListModelMixin, GenericAPIView)

    实现了`get`方法，获取model列表.

    只需要提供`queryset`和`serializer_class`，就可以直接使用.

    需要其他扩展功能需要按需设置`GenericAPIView`的其他属性.

3. RetrieveAPIView(mixins.RetrieveModelMixin, GenericAPIView)

    实现了`get`方法，获取model实例.

    只需要提供`queryset`和`serializer_class`，就可以直接使用.

4. DestroyAPIView(mixins.DestroyModelMixin, GenericAPIView)

    实现了`delete`方法，删除model实例.

    只需要提供`queryset`，就可以直接使用.

5. UpdateAPIView(mixins.UpdateModelMixin, GenericAPIView)

    实现了`put`和`patch`方法，更新model实例.

    只需要提供`queryset`和`serializer_class`，就可以直接使用.

6. ListCreateAPIView(mixins.ListModelMixin, mixins.CreateModelMixin, GenericAPIView)

    `ListAPIView`和`CreateAPIView`的组合.
    
    实现了`get`和`post`方法，用于获取model列表和创建model的实例.

7. RetrieveUpdateAPIView(mixins.RetrieveModelMixin, mixins.UpdateModelMixin, GenericAPIView)

    `RetrieveAPIView`和`UpdateAPIView`的组合.

    实现了`get`、`put`和`patch`方法.

8. RetrieveDestroyAPIView(mixins.RetrieveModelMixin, mixins.DestroyModelMixin, GenericAPIView)

    `RetrieveAPIView`和`DestroyAPIView`的组合.

    实现了`get`和`delete`方法.

9. RetrieveUpdateDestroyAPIView(mixins.RetrieveModelMixin, mixins.UpdateModelMixin, mixins.DestroyModelMixin, GenericAPIView)

    `RetrieveAPIView`、`UpdateAPIView`和`DestroyAPIView`的组合.

    实现了`get`、`put`、`patch`和`delete`方法.


## Demo

1. views.py代码

    ```
    from rest_framework.generics import GenericAPIView, ListCreateAPIView, RetrieveUpdateDestroyAPIView
    from rest_framework.response import Response
    from rest_framework import status
    from rest_framework import pagination
    from rest_framework import filters
    from django_filters.rest_framework import DjangoFilterBackend

    from snippets.models import Snippet
    from snippets.serializers import SnippetSerializer

    class Mypagination(pagination.PageNumberPagination): 
        """自定义分页"""
        page_size = 2  #默认每页显示个数配置
        page_query_param = 'page' # 页面传参的key,默认是page
        page_size_query_param='size'  # 指定每页显示个数参数
        max_page_size = 20 # 每页最多显示个数配置，使用以上配置，可以支持每页可显示2~20条数据


    class SnippetView(ListCreateAPIView):
        """
        创建 snippets
        获取 snippets 
        """
        queryset = Snippet.objects.all()
        serializer_class = SnippetSerializer
        pagination_class = Mypagination
        filter_backends = (filters.OrderingFilter, filters.SearchFilter)
        
        ordering = ('-id',) # 默认查询结果排序

        # 允许排序的字段(http请求中允许的),如果不指定ordering_fields属性，
        # 则默认为可以对serializer_class属性指定的串行器上的任何可读字段进行过滤
        ordering_fields = ('title', )

        # 给filters.SearchFilter使用
        search_fields = ('title',)


    class SnippetUpdateDestroyView(RetrieveUpdateDestroyAPIView):
        """ 
            获取 snippet
            修改 snippet
            删除 snippet
        """
        queryset = Snippet.objects.all()
        serializer_class = SnippetSerializer


    ```

2. 主要路由部分代码
    ```
    主路由
    api_v1 = [
        path('snippets', include('snippets.urls'))
    ]

    urlpatterns = [
        path('admin/', admin.site.urls),
        path('api/v1/', include(api_v1)),
    ]

    snippets.urls
    urlpatterns = [
        path('', SnippetView.as_view()),
        path('/<int:pk>', SnippetUpdateDestroyView.as_view())
    ]
    ```
