#!/bin/bash 

#30 seconds seems to be ideal, any more frequent and the data
sleeptime=10
#gpio write 25 1

get_water_data () {
    COUNTER=0
    while [  $COUNTER -lt 4 ]; do
        #Get water data
        #zaehler=`/home/pi/libmbus/build/bin/mbus-serial-request-data -b 2400 /dev/ttyAMA0 1 | grep -A1 Volume | grep Value | grep -o '[0-9]\+'`
        #zaehler=`/usr/local/bin/mbus-serial-request-data -b 2400 /dev/ttyAMA0 1 | grep -A1 Volume | grep Value | grep -o '[0-9]\+'`
        zaehler=`/usr/local/bin/mbus-serial-request-data -b 2400 /dev/ttyUSB0 1 | grep -A1 Volume | grep Value | grep -o '[0-9]\+'`
        
        if [[ $zaehler -le 0 ]];
                then
                echo "Retry getting data - received some invalid data from the read"
            else
                #We got good data - exit this loop
                COUNTER=10
        fi
        let COUNTER=COUNTER+1
    done
}

#print_data () {
#    echo "zaehler: $zaehler"
#}

write_data () {
    #Write the data to the database
    curl -i -XPOST 'http://192.168.1.9:8086/write?db=water' --data-binary "zaehler,sensor=zaehler value=$zaehler"
}

#Prepare to start the loop and warn the user
echo "Press [CTRL+C] to stop..."
while :
do
    #Sleep between readings
    sleep "$sleeptime"

    get_water_data

    if [[ $zaehler -le 0 ]];
        then
            echo "Skip this datapoint - something went wrong with the read"

        else
            #Output console data for future reference
 #           print_data
            write_data
    fi
#sleeptime=10
done
