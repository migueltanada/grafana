FROM centos:7

ENV GRAFANA_VERSION=4.4.2

LABEL name="Grafana" \
      io.k8s.display-name="Grafana" \
      io.k8s.description="Grafana Dashboard for use with Prometheus." \
      io.openshift.expose-services="3000" \
      io.openshift.tags="grafana" \
      build-date="2017-08-05" \
      version=$GRAFANA_VERSION \
      release="1"

# User grafana gets added by RPM
ENV USERNAME=grafana

RUN yum -y update && yum -y upgrade && \
    yum -y install epel-release && \
    yum -y install git unzip nss_wrapper && \
    curl -L -o /tmp/grafana.rpm https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION-1.x86_64.rpm && \
    yum -y localinstall /tmp/grafana.rpm && \
    yum -y clean all && \
    rm /tmp/grafana.rpm && \
    mkdir -p /var/lib/grafana /var/log/grafana /etc/grafana

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

COPY ./root /
RUN /usr/bin/fix-permissions /var/lib/grafana && \
    /usr/bin/fix-permissions /var/log/grafana && \
    /usr/bin/fix-permissions /etc/grafana && \
    /usr/bin/fix-permissions /usr/share/grafana && \
    /usr/bin/fix-permissions /usr/sbin/grafana-server


EXPOSE 3000

ENTRYPOINT ["/usr/bin/rungrafana"]
