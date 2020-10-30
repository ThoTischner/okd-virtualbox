# okd-virtualbox
Install okd on virtualbox

Not tested cause my macbook is missing VmcsShadowing CPU feature so virtualbox nested virtualization is super slow..

## Prerequisites
* Vagrant
* vagrant-dns -> `vagrant plugin install vagrant-dns`
* Virtualbox

## HowTo IPI
We will use infra-ecosphere to manage virtualbox machines via IPMI \
DNS is managed by vagrant-dns
```
# bootstrap nodes / setup dns
cd vagrant
vagrant plugin install vagrant-dns
vagrant up
vagrant dns --install
vagrant dns --start

# on workstation 
# install infra-ecosphere (ipmi - virtuablox wrapper)
cd
git clone https://github.com/ThoTischner/infra-ecosphere
cd infra-ecosphere
go get github.com/rmxymh/go-virtualbox
go get github.com/htruong/go-md2
go get github.com/gorilla/mux
go get github.com/jmcvetta/napping
go build && go install
cd <okd-virtualbox-repo>
# run ipmi server
~/go/bin/infra-ecosphere

# provisioner-1
vagrant ssh provisioner-1
sudo dnf install -y golang git-core OpenIPMI-libs
echo "export GOPATH=/home/vagrant/go" >> .bash_profile
echo 'export GOBIN=$GOPATH/bin' >> .bash_profile
source $.
git clone https://github.com/ThoTischner/infra-ecosphere
cd infra-ecosphere
go get github.com/rmxymh/go-virtualbox
go get github.com/htruong/go-md2
go get github.com/gorilla/mux
go get github.com/jmcvetta/napping
go build && go install
cd ipmi-proxy
go build && go install
# copy infra-ecosphere_proxy.cfg to infra-ecosphere.cfg on the vm
# run ipmi proxy
sudo /home/vagrant/go/buin/ipmi-proxy

# Now start baremetal IPI install like it is described in the okd docs..
```

## Hints

Check if $VERSION in the docs exist https://mirror.openshift.com/pub/openshift-v4/clients/ocp/ and correct
