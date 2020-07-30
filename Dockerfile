FROM registry.redhat.io/ubi8/ubi
ARG VERSION
RUN yum --setopt=tsflags=nodocs -y upgrade \
  && yum --setopt=tsflags=nodocs --enablerepo=ubi-8-appstream --enablerepo=rhel-8-for-x86_64-baseos-debug-rpms  -y install \
    ethtool \
    iotop \
    iproute-tc \
    kernel-core-$VERSION \
    kernel-devel-$VERSION \
    kernel-debuginfo-$VERSION \
    less \
    net-tools \
    perf \
    python38 \
    strace \
    systemtap \
    tcpdump \
  && yum clean all
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY probe.stap /usr/local/bin/probe.stap
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
