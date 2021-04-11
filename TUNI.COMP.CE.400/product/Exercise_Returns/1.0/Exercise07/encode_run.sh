#insert file name of the sequence here
SEQUENCE=mBosphorus_1920x1080_120fps_420_8bit_YUV.yuv
#insert QP value here
QP=27
#insert ID of your group here
GID=05

#The name of the used executable
BIN_NAME=./Kvazaar_0

#The relative path to the videos, both input and output
VIDEO_PATH=.

#Kvazaar log file
LOGFILE=${GID}_${QP}_Kvazaar_accelerated_encoding_log.txt

#Number of frames to encode
N_FRAMES=10

#date and time when encoding begun
echo 'ENCODING STARTED AT: '`date`
#launching the encoder with parameters
$BIN_NAME -i $VIDEO_PATH/$SEQUENCE -o $VIDEO_PATH/acc_output_QP$QP.265 --input-res 1920x1080 --no-rdoq --no-sao --no-deblock -q $QP --rd 0 -p 1 --full-intra-search --tiles-width-split u2 --threads 1 --acc 1 -n $N_FRAMES 2>&1 | tee $LOGFILE
#date and time when encoding finished
echo 'ENCODING FINISHED AT: '`date`
#inform which QP were used
echo 'USED QP '$QP
