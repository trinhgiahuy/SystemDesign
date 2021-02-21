source ../../../../../group_settings.sh

#The name and path of the used executable
BIN_NAME=../../../../../TUNI.fi/product/Kvazaar.Simulation-System/1.0/sw_Simulation-System/Kvazaar_0/Kvazaar_0

#Call the inner script with proper parameters
../../../../../TUNI.COMP.CE.400/ip.sw/Scripts/1.0/encode_video.sh $SEQUENCE $QP $BIN_NAME $INPUT_PATH $OUTPUT_PATH | tee ${GID}_${QP}_Kvazaar_encoding_log.txt
