FROM registry.access.redhat.com/ubi8/ubi:latest
ARG VERSION
RUN echo '[rhel8-hack]' > /etc/yum.repos.d/hack.repo && \
  echo 'name = Red Hat Eng Hack' >> /etc/yum.repos.d/hack.repo && \
  echo 'baseurl = http://download-node-02.eng.bos.redhat.com/released/RHEL-8/8.1.0/BaseOS/x86_64/os/' >> /etc/yum.repos.d/hack.repo && \
  echo 'enabled = 1' >> /etc/yum.repos.d/hack.repo && \
  echo 'gpgcheck = 0' >> /etc/yum.repos.d/hack.repo && \
  echo '[rhel8-appstream-hack]' >> /etc/yum.repos.d/hack.repo && \
  echo 'baseurl = http://download-node-02.eng.bos.redhat.com/released/RHEL-8/8.1.0/AppStream/x86_64/os/' >> /etc/yum.repos.d/hack.repo && \
  echo 'enabled = 1' >> /etc/yum.repos.d/hack.repo && \
  echo 'gpgcheck = 0' >> /etc/yum.repos.d/hack.repo && \
  yum --disableplugin=subscription-manager --setopt=tsflags=nodocs -y upgrade \
  && yum --disableplugin=subscription-manager --setopt=tsflags=nodocs -y install \
    ethtool \
    iotop \
    iproute-tc \
    less \
    net-tools \
    perf \
    python38 \
    strace \
    systemtap \
    tcpdump \
  && yum --disableplugin=subscription-manager --setopt=tsflags=nodocs -y install \
  http://download-node-02.eng.bos.redhat.com/brewroot/packages/kernel/$(echo $VERSION | cut -d- -f1)/$(echo $VERSION | cut -d- -f2)/x86_64/kernel-$VERSION.x86_64.rpm \
  http://download-node-02.eng.bos.redhat.com/brewroot/packages/kernel/$(echo $VERSION | cut -d- -f1)/$(echo $VERSION | cut -d- -f2)/x86_64/kernel-core-$VERSION.x86_64.rpm \
  http://download-node-02.eng.bos.redhat.com/brewroot/packages/kernel/$(echo $VERSION | cut -d- -f1)/$(echo $VERSION | cut -d- -f2)/x86_64/kernel-modules-$VERSION.x86_64.rpm \
  http://download-node-02.eng.bos.redhat.com/brewroot/packages/kernel/$(echo $VERSION | cut -d- -f1)/$(echo $VERSION | cut -d- -f2)/x86_64/kernel-debuginfo-$VERSION.x86_64.rpm \
  http://download-node-02.eng.bos.redhat.com/brewroot/packages/kernel/$(echo $VERSION | cut -d- -f1)/$(echo $VERSION | cut -d- -f2)/x86_64/kernel-debuginfo-common-$VERSION.x86_64.rpm \
  && yum clean all
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY probe.stap /usr/local/bin/probe.stap
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
