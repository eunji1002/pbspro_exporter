FROM rockylinux:8.9 as builder

ENV GOROOT /usr/lib/golang
ENV GOPATH /go

WORKDIR /go

RUN  set -xeuo && \
    #curl -o /etc/yum.repos.d/Rocky-Base.repo http://mirrors.aliyun.com/repo/Rocky-8.repo && \
    dnf -y install golang && \
    mkdir -p $GOPATH/src/github.com/paratera && \
    mkdir -p $GOPATH/src/golang.org/x

RUN set -xeuo && \
    dnf install -y 'dnf-command(config-manager)' && \
    dnf install -y epel-release && \
    dnf config-manager --set-enabled powertools && \
    dnf groupinstall "Development Tools" -y && \
    dnf install -y sudo tar wget openssh-server openssh-clients openssl openssl-devel && \
    dnf install -y gcc make rpm-build libtool hwloc-devel libX11-devel libXt-devel libedit-devel libical-devel ncurses-devel perl postgresql-devel python3-devel tcl-devel tk-devel swig expat-devel libXext libXft autoconf automake && \
    dnf install -y expat libedit postgresql-server python3 sendmail tcl tk libical cjson-devel

RUN set -xeuo && \
    git clone https://github.com/openpbs/openpbs.git && \
    cd openpbs && \
    ./autogen.sh && \
    ./configure --prefix=/opt/pbspro && \
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
    go get github.com/alecthomas/kingpin &&\
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


FROM rockylinux:8.9 as running

COPY --from=builder /go/src/github.com/paratera/pbspro_exporter/pbspro_exporter /usr/bin/pbspro_exporter
COPY --from=builder /opt/pbspro/lib/libpbs.so.0 /usr/lib/libpbs.so.0
COPY --from=builder /etc/pbs.conf /etc/pbs.conf
COPY --from=builder /opt/pbspro /opt/pbspro

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
