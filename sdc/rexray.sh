#!/bin/bash

mkdir -p /etc/rexray
REXRAY_VERSION=0.8.1

wget https://dl.bintray.com/emccode/rexray/stable/0.8.1/rexray-Linux-x86_64-${REXRAY_VERSION}.tar.gz
tar -C /usr/bin/ -xzf rexray-Linux-x86_64-${REXRAY_VERSION}.tar.gz

cat > /etc/rexray/config.yml << EOF
rexray:
  logLevel: info
  storageDrivers:
  - scaleio
  modules:
    default-docker:
      type:     docker
      desc:     The default docker module.
      host:     unix:///etc/docker/plugins/rexray.sock
      spec:     /etc/docker/plugins/rexray.spec
      disabled: false
scaleio:
  endpoint:             https://$(cat /stack_name)-primary-mdm-1:443/api
  insecure:		true
  userName:             admin
  password:             password1?
  systemID:		$(cat /system_id)
  protectionDomainName: domain1
  storagePoolName:      pool1
  thinOrThick:		ThinProvisioned
EOF

rexray start -l debug -f
