# cdemu-rpi
Hardware emulation of CD-ROM with the help of Rapsberry Pi Zero W 2 

## How to use
1. Build Docker image.
```
    $ docker build -t raspi-image . 
```
2. Build Raspberry Pi OS image.
```
    $docker run --privileged -v c:\temp:/build --name raspi-image -it --rm raspi-image
```
3. Burn Raspberry Pi OS image to the SD card. Insert it into the Rapsberry Pi Zero 2 W.
4. Connect Rapsberry Pi Zero 2 W to the computer via a USB cable.
5. Wait until the computer recognizes USB Mass Storage device. 
6. Copy ISO images you want to emulate to it.
7. Find Virtual COM Port which is created in Windows after connecting the Rapsberry Pi Zero 2 W.
8. Use PuTTY to connect to COM Port. Baud Rate: 115200, Data Bits: 8, Parity: None. 
9. Login in PuTTY to Raspberry Pi OS. User: pi, password: raspberry.
10. Input the following command:
```
    $ sudo cdemu-cmd
```
11. If you want to send command from the smartphone, you need to pair Rapsberry Pi with it
12. Input the following command:
```
    $ sudo bluetoothctl
```  
13. Make Rapberry Pi discoverable:
```
    discoverable on
```
14. Connect to it via Bluetooth from the smartphone. Select 'yes' on the Raspberry Pi and the smartphone.
15. Exit from bluetoothctl.
```
    exit
```    
16. Run Serial Bluetooth Terminal on the smartphone and connect to the Raspberry Pi from it.
17. You can send commands to the emulator now.

## Available commands 

1. hdd — switch to the emulate hdd mode.
2. cdrom — switch to the emulate cdrom mode.
3. list — list an available ISO images.
4. insert <num> — insert ISO image for the emulation.
5. eject — eject ISO image.
6. help — list the available commands in the current mode.

