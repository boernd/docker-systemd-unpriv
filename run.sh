#!/bin/bash
sudo date
CONTAINER=$(sudo docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro maci/systemd /usr/lib/systemd/systemd)
echo ${CONTAINER}
echo "to enter docker container run: 
        docker exec -t -i ${CONTAINER} /bin/bash"
