# Setting up the stellaris board

## lm4flash

```
sudo aptitude install libusb-1.0-0-dev
git clone https://github.com/utzig/lm4tools.git
cd lm4tools/lm4flash
make
```

## ARM toolchain
```
apt-get install flex bison libgmp3-dev libmpfr-dev libncurses5-dev \
    libmpc-dev autoconf texinfo build-essential libftdi-dev python-yaml
git clone https://github.com/esden/summon-arm-toolchain
cd summon-arm-toolchain
./summon-arm-toolchain
```

## Stellarisware 
Get the stellarisware from http://www.ti.com/tool/sw-ek-lm4f120xl
```
mkdir stellarisware; cd stellarisware
unzip ~/Downloads/SW-EK-LM4F120XL-9453.exe
make
```

## Setup udev
```
sudo addgroup stellaris
sudo usermod -aG $USER stellaris
echo 'ATTRS{idVendor}=="1cbe", ATTRS{idProduct}=="00fd", MODE="0660", GROUP="stellaris", SYMLINK+="slaunchpad"' | sudo tee /etc/udev/rules.d/99-stellaris.rules
```

And reboot. 

## Rs232 connection script
```
printf '#!/bin/bash\n screen /dev/slaunchpad 115200 8N1 -S slaunchpad' | sudo tee /usr/local/bin/stellaris-com\n
sudo chmod +x /usr/local/bin/stellaris-com
```

## Test build

Clone this repo and set `SW_DIR` in the makefile to the installation location of stellarisware, then run `make flash`.

## More info
http://recursive-labs.com/blog/2012/10/28/stellaris-launchpad-gnu-linux-getting-started/

http://processors.wiki.ti.com/index.php/Stellaris_LaunchPad

https://github.com/esden/summon-arm-toolchain

https://github.com/utzig/lm4tools
