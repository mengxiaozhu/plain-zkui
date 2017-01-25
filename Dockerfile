FROM qnib/alplain-jdk8

ARG MAVEN_VERSION="3.3.9"
ENV M2_HOME=/usr/lib/mvn \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle/

RUN apk --no-cache add wget \
 && wget -qO - "http://ftp.unicamp.br/pub/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar xfz - -C /opt/ \
 && mv "/opt/apache-maven-$MAVEN_VERSION" "$M2_HOME" \
 && ln -s "$M2_HOME/bin/mvn" /usr/bin/mvn \
 && wget -qO /tmp/master.zip https://github.com/DeemOpen/zkui/archive/master.zip \
 && cd /opt/ \
 && unzip /tmp/master.zip \
 && mv /opt/zkui-master /opt/zkui \
 && apk --no-cache del wget \
 && cd /opt/zkui && mvn clean install \
 && rm -rf /tmp/* /var/cache/apk/* /usr/lib/mvn
RUN echo "grep zkSer /opt/zkui/config.cfg" >> /root/.bash_history
ENV ZKUI_ADMIN_PW=admin \
    ZKUI_USER_PW=user \
    ZKUI_PORT=9090
