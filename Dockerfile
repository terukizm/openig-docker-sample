FROM openjdk:8-jdk
MAINTAINER KOIZUMI Teruaki <teru.kizm [at] gmail.com>

ENV OPENIG_VERSION=4.0.0

ENV JETTY_VERSION=8.2.0.v20160908
ENV JETTY_PORT=8080
ENV JETTY_USER=jetty
ENV JETTY_HOME=/usr/local/jetty

# Download and Install Jetty
RUN mkdir -p /usr/local/src \
  && wget -q http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.zip -O /usr/local/src/jetty.zip \
  && unzip -q /usr/local/src/jetty.zip -d /usr/local/src \
  && rm -rf /usr/local/src/jetty.zip \
  && mv /usr/local/src/jetty-distribution-${JETTY_VERSION} ${JETTY_HOME}

# Set Config
RUN sed -i -e "4i JETTY_PORT=${JETTY_PORT}" ${JETTY_HOME}/bin/jetty.sh \
  && sed -i -e "5i JETTY_HOME=${JETTY_HOME}" ${JETTY_HOME}/bin/jetty.sh \
  && sed -i -e "6i JETTY_USER=${JETTY_USER}" ${JETTY_HOME}/bin/jetty.sh

# Deploy OpenIG
COPY war/openig-war-${OPENIG_VERSION}.war ${JETTY_HOME}/webapps/root.war

# Add Jetty User
RUN useradd -m -c "Jetty System User" jetty -s /bin/bash \
  && chown -R ${JETTY_USER}:${JETTY_USER} ${JETTY_HOME} \
  && chmod +x ${JETTY_HOME}/bin/*.sh

# Mount Data Volume
RUN mkdir -p /data/.openig \
  && ln -snf /home/{JETTY_USER}/.openig /openig
VOLUME /openig

# Jetty Run
USER ${JETTY_USER}
WORKDIR ${JETTY_HOME}
EXPOSE ${JETTY_PORT}
CMD ["bin/jetty.sh", "run"]
