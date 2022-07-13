#To find the current COM port :
#dmesg | grep tty

#SourceFile="/home/ubuntu/Miyoo/test.txt"
SourceFile=$1
SourceFilename="$(basename -- "$SourceFile")"
TargetDirectory=/tmp
CurrentCom=/dev/ttyUSB0
SerialSpeed=115200

#pkill -9  "PuTTY"

echo echo> Commands.txt
echo "DoneMsg=\" ==================================== Upload done ==================================== \\\nPress ctrl +c to exit plink\"">> Commands.txt
echo "echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;echo;">> Commands.txt
echo cd "$TargetDirectory">> Commands.txt
echo base64 -d \<\<EOF\> \"$SourceFilename\">> Commands.txt
base64 "$SourceFile">> Commands.txt
echo EOF>> Commands.txt
echo chmod +x "%SourceFilename%">> Commands.txt
echo "echo;echo;echo -e \$DoneMsg">> Commands.txt


cat Commands.txt | sudo plink -serial $CurrentCom -sercfg $SerialSpeed,8,1,N,X -batch -t

exit

