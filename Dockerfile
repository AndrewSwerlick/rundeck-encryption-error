FROM alpine:3.4

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENV RDECK_BASE=/opt/rundeck
ENV RDECK_JAR=$RDECK_BASE/app.jar
ENV PATH=$PATH:$RDECK_BASE/tools/bin
ENV RDECK_VERSION=2.6.11

RUN \
  apk --no-cache add \
    curl \
    bash \
    openjdk7-jre\
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
  pip install --upgrade pip python-keyczar

RUN mkdir -p $RDECK_BASE && \
    curl -fsSL https://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-${RDECK_VERSION}.jar -o $RDECK_JAR && \
    java -jar $RDECK_BASE/app.jar --installonly

# Downloading and enabling the ansible rundeck plugin https://github.com/Batix/rundeck-ansible-plugin
RUN \
  mkdir -p $RDECK_BASE/libext && \
  curl -fsSL https://github.com/Batix/rundeck-ansible-plugin/releases/download/2.0.2/ansible-plugin-2.0.2.jar -o $RDECK_BASE/libext/ansible-plugin-2.0.2.jar

RUN unzip -p ${RDECK_BASE}/app.jar pkgs/webapp/WEB-INF/rundeck/plugins/rundeck-jasypt-encryption-plugin-${RDECK_VERSION}.jar > ${RDECK_BASE}/libext/rundeck-jasypt-encryption-plugin-${RDECK_VERSION}.jar

COPY init.sh /bin/rundeck
COPY profile /$RDECK_BASE/etc/profile
COPY rundeck-config.properties /$RDECK_BASE/server/config/rundeck-config.properties

RUN chmod a+x /bin/rundeck

EXPOSE  4440
CMD rundeck
