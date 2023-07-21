# MBUS_Water
readout some MBUS Watercounter values and send it to the influx DB





git clone https://github.com/rscada/libmbus
  ls
  cd libmbus/
  ls
 ./build.sh
sudo make install


mbus-serial-scan -d -b 2400 -r 5  /dev/ttyUSB0 



testing with 

mbus-serial-request-data -b 2400 /dev/ttyUSB0 1



