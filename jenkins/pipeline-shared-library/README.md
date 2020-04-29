## Shared library开发步骤
1. 创建目录结构
    ```
    mkdir -p resources/org/foo src/org/foo vars
    (root)
    +- src                     # Groovy source files
    |   +- org
    |       +- foo
    |           +- Bar.groovy  # for org.foo.Bar class
    +- vars
    |   +- foo.groovy          # for global 'foo' variable
    |   +- foo.txt             # help for 'foo' variable
    +- resources               # resource files (external libraries only)
    |   +- org
    |       +- foo
    |           +- bar.json    # static helper data for org.foo.Bar
    ```
2. 写shared library  
    在目录vars中的文件就能够在pipeline中引用
    如:
    ```
    // vars/sayHello.groovy
    def call(String name = 'human') {
        // Any valid steps can be called from this code, just like in other
        // Scripted Pipeline
        echo "Hello, ${name}."
    }
    ```
3. 将该文件目录提交至Git(SVN等)仓库

## Shared library使用步骤
1. Manage Jenkins ==> Configure System ==>Global Pipeline Libraries点击Add添加Global Pipeline Libraries.  
Name属性不应太长,在pipeline中是通过关键字library加Name属性来引用library, 然后添加shared library的SCM信息.
2. 在Jenkins文件中添加library关键词引用shared library,如下所示:  
    *Jenkinsfile*
    ```
    library 'hello'

    pipeline {
        agent any
        stages {
            stage('Build') {
                steps {
                    sayHello('World')
                }
            }
        }
    }
    ```

## 文档
https://jenkins.io/doc/book/pipeline/shared-libraries/  
http://groovy-lang.org/single-page-documentation.html  
https://testerhome.com/topics/10782(备用:https://www.jianshu.com/p/cc32441ae3b6)
