source ../../../../../group_settings.sh

echo 'Select simulation (SW/HW): '
read simulation

if [ $simulation == 'SW' ]; then
	echo "SW simulation"
	BIN_NAME=../../../../../TUNI.fi/product/Kvazaar.SW-Timed-Simulation/1.0/sw_SW-Timed-Simulation/Kvazaar_0/Kvazaar_0
elif [ $simulation == 'HW' ]; then
	echo "HW simulation"
	BIN_NAME=../../../../../TUNI.fi/product/Kvazaar.HW-Timed-Simulation/1.0/sw_HW-Timed-Simulation/Kvazaar_0/Kvazaar_0
else
	echo "Select simulation!"
	exit
fi

echo 'LUCs to encode (0=all): '
read LCUS

if [ "$LCUS" -lt 0 ]; then
	echo "LCUs negative!"
	exit
fi 

if [ $LCUS == 0 ]; then
	echo 'Frames to encode (0=all): '
	read FRAMES
fi

if [ "$FRAMES" -lt 0 ]; then
	echo "Frames negative!"
	exit
fi 

$BIN_NAME -i $INPUT_PATH/$SEQUENCE -o $OUTPUT_PATH/outputQP$QP.265 --lcu-limit $LCUS -n $FRAMES --input-res 1920x1080 --no-rdoq --no-sao --no-deblock -q $QP --rd 0 -p 1 --full-intra-search --tiles-width-split u2 --threads 1 --acc 1 2>&1
