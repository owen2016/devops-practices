# VS Code 使用

## Tips 总结

### 1. VSCode显示空格和tab符号

1.打开setting,在搜索框中输入`renderControlCharacters`,选中勾选框,即可显示tab

![](http://cdn.devopsing.site/renderControlCharacters.JPG)

2.在搜索框中输入`renderWhitespace`,选择all,即可显示空格.

![](http://cdn.devopsing.site/renderWhitespace.JPG)

## 插件扩展

- <https://marketplace.visualstudio.com/VSCode>

### Markdown

```text
- Markdown Preview Enhanced    预览与展示，以pdf文档样式的效果来显示内容，默认配置
- Markdown Toc    生成目录，需要配置参数
- Markdown PDF    可以简单地将编写的.md文件转换成PDF等格式的文件，设置常用配置
- Markdownlint    语法规整和风格检查
- Markdown Preview Github Stying    使用Github样式来渲染Markdown，朴素简洁

- Markdown All in One    功能组合包，包含了书写Markdown需要用到的常用功能和设置（键盘快捷方式，目录，自动预览等），默认配置
```

### Common

```text
- Chinese (Simplified) Language Pack for Visual Studio Code：中文界面

- Git History    提供可视化的 Git 版本树管理，可通过命令面板或界面按钮激活
- GitLens    增强内置Git 功能, 显示丰富的git日志，文件历史、行历史等

- Visual Studio IntelliCode    微软官方提供的基于 AI 辅助的自动补全功能，支持 Python、TypeScript/JavaScript和Java语言
- TabNine    强大的 AI 辅助智能补全，支持几乎所有编程语言
- Code Spell Checker    代码拼写检查, 检查代码中的单词拼写错误并给出错误拼写单词的建议

- Settings Sync   使用GitHub Gist同步多台计算机上的设置，代码段，主题，文件图标，启动，键绑定，工作区和扩展
- Code Runner    万能语言运行环境, 不用搭建各种语言的开发环境，选中一段代码直接运行，非常适合学习或测试各种开发语言
- Docker    管理本地容器

- filesize    在状态栏中显示当前文件大小，点击后还可以看到详细创建、修改时间
- vscode-icons    文件图标，实现对各种文件类型的文件前的图标进行优化显示，，可以直接通过文件的图标快速知道文件类型
- Rainbow Brackets    为圆括号，方括号和大括号提供彩虹色
- Bracket Pair Colonizer 2    彩虹括号，使用彩虹色区分标注不同的括号对
- Indent-Rainbow    用四种不同颜色交替着色文本前面的缩进
- Log File Highlighter    日志文件高亮，主要是针对 INFO、WARN、ERROR 高亮，方便查看日志文件
- TODO Highlight    高亮显示代码中的 TODO、FIXME 及其他注解

- Atuo Rename Tag    修改 html 标签，自动帮你完成头部和尾部闭合标签的同步修改
- RegExp Preview and Editor    通过命令面板启动，在分栏页面中编辑正则表达式，并以数据流图可视化显示正则语法结构
```

### Office

```text
- PDF: vscode-pdf    直接打开浏览pdf格式的二进制文件

Draw.io Integration
绘制流程图、脑图和UML图，新建扩展名为 .drawio、.dio 、.drawio.svg 文件即可进入编辑
- https://github.com/hediet/vscode-drawio
- https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio

```

### Remote Development

```text
- Remote Development
  https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack

- Remote - SSH：基于 SSH 的远程开发
- Remote - Containers：基于 Docker 容器的远程开发
- Remote - WSL：基于 Windows Subsystem for Linux(wsl) 的远程开发
```

### Format

```text
- Beautify 代码格式化（Javascript, JSON, CSS, Sass, and HTML）
- ESLint 代码检查，关注语法规则和代码风格，可以用来保证写出语法正确、风格统一的代码。
- Prettier 严格基于规则的代码格式化程序, 解析代码并使用自定义规则重新打印代码，从而实现风格一致
- SonarLint
```

### Language

```text
### Java
Java Extension Pack
- Debugger for Java
- Language Support for Java(TM) by Red Hat
- Visual Studio IntelliCode
- Maven for Java
- Java Test Runner
- Java Dependency Viewer

Spring Boot Extension Pack
- Spring Boot Tools
- Spring Boot Dashboard
- Spring Initializer Java Support

CheckStyle for Java
Java Decompiler
Lombok Annotations Support


### Python
- Python Extension Pack
- python snippets
- pylint


### Bash
- Bash IDE
- shellman
- Shell-format
- Bash Debug


### Jenkins
- JenkinsFile Support
- Groovy Lint, Format and Fix
```