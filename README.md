# pbspro_exporter

## 1. Prometheus 

```bash
# cd prometheus~
# vi prometheus.yml    // add target
# ./prometheus --web.listen-address="0.0.0.0:9090"
```

## 2. Docker build

```bash
# cd pbspro_exporter/docker
# docker build -t pbspro_exporter:latest .

# docker run --name pbspro_exporter -e PBS_ADDR=pbs server 주소 -p 9107:9107 -d 이미지 이름
```

## 3. Docker run

```bash
# docker run -d -p 9107:9107 pbspro_exporter
```
