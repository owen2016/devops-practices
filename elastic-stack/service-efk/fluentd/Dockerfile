FROM fluent/fluentd
USER root
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
&& gem install fluent-plugin-elasticsearch
# RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "4.3.1"]
# USER fluent