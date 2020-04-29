# simple-java-maven-app

本示例基于Java和Maven生成一个HelloWorld程序.

    - 使用Maven build Java程序
   
    - 使用场景： Maven 编译Java程序， 以及Jenkinsfile中使用Ansible的例子.

This repository is for the
[Build a Java app with Maven](https://jenkins.io/doc/tutorials/build-a-java-app-with-maven/)
tutorial in the [Jenkins User Documentation](https://jenkins.io/doc/).

The repository contains a simple Java application which outputs the string
"Hello world!" and is accompanied by a couple of unit tests to check that the
main application works as expected. The results of these tests are saved to a
JUnit XML report.

The `jenkins` directory contains an example of the `Jenkinsfile` (i.e. Pipeline)
you'll be creating yourself during the tutorial and the `scripts` subdirectory
contains a shell script with commands that are executed when Jenkins processes
the "Deploy" stage of your Pipeline.
