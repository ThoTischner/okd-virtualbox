export PUB_CONN=eth1
export PROV_CONN=eth2
sudo nohup bash -c '
    nmcli con down "$PUB_CONN"
    nmcli con delete "$PUB_CONN"
    # RHEL 8.1 appends the word "System" in front of the connection, delete in case it exists
    nmcli con down "System $PUB_CONN"
    nmcli con delete "System $PUB_CONN"
    nmcli connection add ifname baremetal type bridge con-name baremetal
    nmcli con add type bridge-slave ifname "$PUB_CONN" master baremetal
    nmcli con down "$PUB_CONN"
    nmcli con mod baremetal ipv4.addresses 192.168.5.11/24
    nmcli con mod baremetal ipv4.method manual
    nmcli con up baremetal
    '
sudo nohup bash -c '
    nmcli con down "$PROV_CONN"
    nmcli con delete "$PROV_CONN"
    # RHEL 8.1 appends the word "System" in front of the connection, delete in case it exists
    nmcli con down "System $PROV_CONN"
    nmcli con delete "System $PROV_CONN"
    nmcli connection add ifname provisioning type bridge con-name provisioning
    nmcli con add type bridge-slave ifname "$PROV_CONN" master provisioning
    nmcli connection modify provisioning ipv6.addresses fd00:1101::1/64 ipv6.method manual
    nmcli con down provisioning
    nmcli con up provisioning
    '
