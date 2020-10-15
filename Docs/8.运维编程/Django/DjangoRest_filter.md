# DjangoRest中使用filter

在继承了`GenericAPIView`以及其子类的view中可以设置`filter_backends`属性来使用filter.

例如： 
```
from rest_framework import filters

filter_backends = (filters.OrderingFilter, filters.SearchFilter)
```

## filter分类

>### 1. DjangoFilterBackend (django_filters.rest_framework中)

> 参考文档 [Integration with DRF](https://django-filter.readthedocs.io/en/stable/guide/rest_framework.html)

* Using the new `FilterSet` simply requires changing the import path. Instead of importing from `django_filters`, import from the `rest_framework` sub-package.  Your view class will also need to add `DjangoFilterBackend` to the `filter_backends`.
    ```
    from django_filters import rest_framework as filters

    class ProductList(generics.ListAPIView):
        queryset = Product.objects.all()
        serializer_class = ProductSerializer
        filter_backends = (filters.DjangoFilterBackend,)
        filterset_fields = ('category', 'in_stock')
    ```


* If you want to use the `django-filter` backend by default, add it to the `DEFAULT_FILTER_BACKENDS` setting.

    ```
    # settings.py
    INSTALLED_APPS = [
        ...
        'rest_framework',
        'django_filters',
    ]

    REST_FRAMEWORK = {
        'DEFAULT_FILTER_BACKENDS': (
            'django_filters.rest_framework.DjangoFilterBackend',
            ...
        ),
    }
    ```

* Adding a FilterSet with `filterset_class`

    To enable filtering with a `FilterSet`, add it to the `filterset_class` parameter on your view class.

    ```
    from rest_framework import generics
    from django_filters import rest_framework as filters
    from myapp import Product


    class ProductFilter(filters.FilterSet):
        min_price = filters.NumberFilter(field_name="price", lookup_expr='gte')
        max_price = filters.NumberFilter(field_name="price", lookup_expr='lte')

        class Meta:
            model = Product
            fields = ['category', 'in_stock', 'min_price', 'max_price']


    class ProductList(generics.ListAPIView):
        queryset = Product.objects.all()
        serializer_class = ProductSerializer
        filter_backends = (filters.DjangoFilterBackend,)
        filterset_class = ProductFilter
    ```

* Using the `filterset_fields` shortcut

    You may bypass creating a `FilterSet` by instead adding `filterset_fields` to your view class. This is equivalent to creating a FilterSet with just `Meta.fields`.

    ```
    from rest_framework import generics
    from django_filters import rest_framework as filters
    from myapp import Product


    class ProductList(generics.ListAPIView):
        queryset = Product.objects.all()
        filter_backends = (filters.DjangoFilterBackend,)
        filterset_fields = ('category', 'in_stock')


    # Equivalent FilterSet:
    class ProductFilter(filters.FilterSet):
        class Meta:
            model = Product
            fields = ('category', 'in_stock')
    ```
    **Note that using `filterset_fields` and `filterset_class` together is not supported.**

    ### 如何自定义`FilterBackend`？
    在`filter_backends`加入自定义的FilterBackend

    `self.filter_backends += (UsersStateFilterBackend,)`
    ```
    from rest_framework import filters
    from django.db.models import Q

    class UsersStateFilterBackend(filters.BaseFilterBackend):
    """
    Filter users objects.
    """
    def filter_queryset(self, request, queryset, view):
        request_data = request.GET
        is_active = request_data.get('is_active', '')
        if is_active == '0':
            queryset = OpsUser.objects.filter(Q(is_deleted=False), Q(is_active=False)).all().order_by('id')
        elif is_active == '1':
            queryset = OpsUser.objects.filter(Q(is_deleted=False), Q(is_active=True)).all().order_by('id')

        return queryset
    ```


> ### 2. SearchFilter (rest_framework.filters中)

* The `SearchFilter class` will only be applied if the view has a `search_fields` attribute set. The `search_fields` attribute should be a list of names of text type fields on the model, such as `CharField` or `TextField`.

    ```
    from rest_framework import filters

    class UserListView(generics.ListAPIView):
        queryset = User.objects.all()
        serializer_class = UserSerializer
        filter_backends = [filters.SearchFilter]
        search_fields = ['username', 'email']
    ```
    This will allow the client to filter the items in the list by making queries such as:

    ```
    http://example.com/api/users?search=russell
    # 只需要russel匹配search_fields中任意item的限制规则
    ```

    You can also perform a related lookup on a `ForeignKey` or `ManyToManyField` with the lookup API **double-underscore** notation:

    `search_fields = ['username', 'email', 'profile__profession']`

*  **By default, searches will use `case-insensitive partial matches`. The search parameter may contain multiple search terms, which should be whitespace and/or comma separated. `If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched`.**

    ```
    # 例如以下请求
    # 需要russell，aaa同时匹配search_fields中任意item的限制规则
    http://example.com/api/users?search=russell，aaa
    ```
* 可以通过在`search_fields`前面添加各种字符来限制搜索行为

    * '^' Starts-with search.
    * '=' Exact matches.
    * '@' Full-text search. (Currently only supported Django's PostgreSQL backend.)
    * '$' Regex search.

>### 3. OrderingFilter (rest_framework.filters中)
* The `OrderingFilter` class supports simple query parameter controlled ordering of results.
    ```
    from rest_framework import filters
    class UserListView(generics.ListAPIView):
        queryset = User.objects.all()
        serializer_class = UserSerializer
        filter_backends = [filters.OrderingFilter]
        ordering_fields = ['username', 'email']
        ordering = ['username']
    ```
    **Note:**
    * `ordering` 查询结果集默认排序
    * `ordering_fields` API应在排序过滤器中允许的字段

* 默认查询参数为`ordering`
    ```
    # order users by username
    http://example.com/api/users?ordering=username

    # reverse orderings by prefixing the field name with '-'
    http://example.com/api/users?ordering=-username

    # Multiple orderings
    http://example.com/api/users?ordering=account,username

    ```

