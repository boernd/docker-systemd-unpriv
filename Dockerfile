FROM centos:centos7
MAINTAINER Marcel Wysocki "maci.stgn@gmail.com"
ENV container docker

RUN yum -y update; yum clean all

RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs dbus

RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount \
    display-manager.service graphical.target systemd-logind.service

ADD dbus.service /etc/systemd/system/dbus.service
RUN systemctl enable dbus.service

# Setup kitchen user with passwordless sudo 
RUN useradd -d /home/kitchen -m -s /bin/bash kitchen && \ 
    (echo kitchen:kitchen | chpasswd) && \ 
    mkdir -p /etc/sudoers.d && \ 
    echo 'kitchen ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/kitchen && \ 

    # Setup SSH daemon so test-kitchen can access the container 
    yum -y install openssh-server openssh-clients && \ 
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' && \ 
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \ 
    echo 'OPTIONS="-o UseDNS=no -o UsePAM=no -o PasswordAuthentication=yes"' >> /etc/sysconfig/sshd && \ 
    systemctl enable sshd.service 

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]

CMD  ["/usr/lib/systemd/systemd"]
