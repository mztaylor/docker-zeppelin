FROM dockerfile/ubuntu
MAINTAINER mztaylor "https://github.com/mztaylor" 

RUN apt-get update \
  && apt-get install -y openjdk-7-jdk npm maven curl net-tools build-essential git wget unzip python python-setuptools python-dev python-numpy \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
WORKDIR /data


ENV PATH $PATH:$JAVA_HOME/bin

# MAVEN
ENV MAVEN_VERSION 3.3.3
ENV MAVEN_HOME /usr/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s $MAVEN_HOME /usr/maven

# ZEPPELIN
ENV ZEPPELIN_HOME         /zeppelin
ENV ZEPPELIN_CONF_DIR     $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR $ZEPPELIN_HOME/notebook
ENV ZEPPELIN_PORT         8080

RUN git clone https://github.com/apache/incubator-zeppelin.git $ZEPPELIN_HOME
COPY ./install.sh $ZEPPELIN_HOME/install.sh

# INSTALL & CLEAN
WORKDIR $ZEPPELIN_HOME
ONBUILD COPY ./install.sh install.sh
ONBUILD RUN ./install.sh \
  && rm -rf /root/.m2 \
  && rm -rf /root/.npm

CMD "bin/zeppelin.sh"
