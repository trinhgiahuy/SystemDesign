#file name of the sequence
SEQUENCE=$1
#QP value
QP=$2
#The name and path of the used executable
BIN_NAME=$3
#The path to the videos, both input and output
INPUT_PATH=$4
OUTPUT_PATH=$5

#date and time when encoding begun
START_DATE=`date`

#launching the encoder with parameters
$BIN_NAME -i $INPUT_PATH/$SEQUENCE -o $OUTPUT_PATH/outputQP$QP.265 --input-res 1920x1080 --no-rdoq --no-sao --no-deblock -q $QP --rd 0 -p 1 --full-intra-search --tiles-width-split u2 --threads 1 --acc 1 2>&1
#date and time when encoding begun
echo 'ENCODING STARTED AT: '$START_DATE
#date and time when encoding finished
echo 'ENCODING FINISHED AT: '`date`
#inform which QP were used
echo 'USED QP '$QP
#size of the files
INPUT_SIZE=`stat -c "%s" $INPUT_PATH/$SEQUENCE`
OUTPUT_SIZE=`stat -c "%s" $OUTPUT_PATH/outputQP$QP.265`
echo 'SIZE OF THE INPUT FILE (KiB): '`expr $INPUT_SIZE / 1024`
echo 'SIZE OF THE OUTPUT FILE (KiB): '`expr $OUTPUT_SIZE / 1024`
