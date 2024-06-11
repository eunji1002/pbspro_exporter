#!/bin/bash

readonly IMGPRJ=localhost
readonly IMGNAME=pbspro_exporter
readonly IMGTAG=latest
readonly CNAME=pbspro_exporter

docker rm -f $CNAME

docker run \
	--name $CNAME \
	--network host \
	--restart always \
	-e PBS_ADDR=34.64.188.40 \
	-e EXPORTER_PORT=9107 \
	-d $IMGPRJ/$IMGNAME:$IMGTAG
