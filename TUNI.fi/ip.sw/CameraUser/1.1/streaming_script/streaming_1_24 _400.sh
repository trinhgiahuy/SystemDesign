QP=24
THREADS=1
CAMERA_MODE=camera_high
RESOLUTION=400x240

ENCODER="Kvazaar_0 -i $CAMERA_MODE -o - --input-res $RESOLUTION --no-rdoq --no-sao --no-deblock \
-q $QP --rd 0 -p 1 --full-intra-search --wpp --owf 1 --threads $THREADS --acc $THREADS \
--vps-period 1 --pu-depth-intra 2-2"

STREAMER="ffmpeg -loglevel error -re -stats -vcodec hevc -probesize 32 -analyzeduration 0 -i - \
-an -vcodec copy -f mpegts -fflags nobuffer udp://192.168.0.1:8557?pkt_size=1880"

./$ENCODER | ./$STREAMER
