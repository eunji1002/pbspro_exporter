FROM centos:7

ENV GOROOT /usr/lib/golang
ENV GOPATH /go

WORKDIR /go

RUN set -xeuo && \
    mkdir -p $GOPATH/src/github.com/paratera && \
    mkdir -p $GOPATH/src/golang.org/x

RUN set -xeuo && \
    yum install -y epel-release && \
    yum install -y golang && \
    yum install -y centos-release-scl && \
    yum install -y devtoolset-9-gcc devtoolset-9-gcc-c++ && \
    yum install -y wget which tar openssh-server openssh-clients openssl openssl-devel && \
    yum install -y gcc-c++ make rpm-build libtool hwloc-devel libX11-devel libXt-devel libedit-devel libical-devel ncurses-devel perl postgresql-devel python3-devel tcl-devel tk-devel swig expat-devel libXext libXft autoconf automake && \
    yum install -y expat libedit postgresql-server python3 sendmail tcl tk libical git json-c json-c-devel cmake3 && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN set -xeuo pipefail && \
    git clone https://github.com/DaveGamble/cJSON.git && \
    cd cJSON && \
    cmake3 . && \
    make && \
    make install

RUN set -xeuo pipefail && \
    git clone https://github.com/openpbs/openpbs.git && \
    cd openpbs && \
    ./autogen.sh && \
    CFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" ./configure --prefix=/opt/pbspro && \
    make -j4 && \
    make install && \
    /opt/pbspro/libexec/pbs_postinstall

RUN set -xeuo && \
    cd $GOPATH/src/golang.org/x && \
    git clone https://github.com/golang/tools.git && \
    git clone https://github.com/golang/lint.git && \
    git clone https://github.com/golang/sys.git && \
    git clone https://github.com/golang/crypto.git && \
    go env -w GO111MODULE=off && \
    go get github.com/alecthomas/kingpin && \
    go get github.com/alecthomas/template && \
    go get github.com/alecthomas/template/parse && \
    go get github.com/alecthomas/units && \
    go get github.com/beorn7/perks/quantile && \
    go get github.com/golang/protobuf/proto && \
    go get github.com/juju/errors && \
    go get github.com/deepin-community/golang-protobuf-extensions/pbutil && \
    go get github.com/siddontang/go/log && \
    go get github.com/eunji1002/go_pbs/qstat && \
    go get github.com/eunji1002/go_pbs/utils && \
    go get gopkg.in/alecthomas/kingpin.v2 && \
    go get github.com/prometheus/client_golang/prometheus && \
    go get github.com/prometheus/client_golang/prometheus/promhttp && \
    go get github.com/prometheus/client_model/go && \
    go get github.com/prometheus/common/expfmt && \
    go get github.com/munnerz/goautoneg && \
    go get github.com/prometheus/common/promlog && \
    go get github.com/prometheus/common/model && \
    go get github.com/prometheus/client_golang/prometheus/collectors/version && \
    go get github.com/prometheus/common/version && \
    go get github.com/prometheus/procfs && \
    go get github.com/prometheus/procfs/internal/util && \
    go get github.com/prometheus/procfs/nfs && \
    go get github.com/prometheus/procfs/xfs && \
    go get github.com/sirupsen/logrus && \
    go get github.com/eunji1002/pbspro_exporter/collector

RUN set -xeuo && \
    mkdir -p $GOPATH/src/github.com/paratera && \
    cd $GOPATH/src/github.com/paratera && \
    wget https://github.com/eunji1002/pbspro_exporter/archive/refs/heads/main.zip && \
    unzip main.zip && \
    mv pbspro_exporter-main pbspro_exporter && \
    cd pbspro_exporter && \
    go build

FROM centos:7

COPY /go/src/github.com/pbspro_exporter/pbspro_exporter /usr/bin/pbspro_exporter
COPY /opt/pbspro/lib/libpbs.so.0 /usr/lib/libpbs.so.0
COPY /etc/pbs.conf /etc/pbs.conf
COPY /opt/pbspro /opt/pbspro

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

