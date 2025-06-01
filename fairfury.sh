#!/bin/bash


# Run as root if not already

if [ $(id -u) -ne 0 ]; then

    # Get full path of the script
    SCRIPT_PATH=$(realpath "$0")
    pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "$SCRIPT_PATH" "auth" "$@"
    exit $?

fi


# Continue if "auth" argument is present

if [ "$1" == "auth" ]; then

    shift


    # Load kernel modules

    modprobe i2c-dev
    modprobe i2c-piix4


    ram1addr=0x58
    ram2addr=0x59


    # Send colors and brightness via I2C

    set_color() {

        local red=$1
        local green=$2
        local blue=$3
        local bright=$4


        echo "Setting static R=$red G=$green B=$blue Brightness=$bright"


        # Configure first device

        i2cset -y 0 $ram1addr 0x08 0x53

        sleep 0.020

        i2cset -y 0 $ram1addr 0x09 0x00

        sleep 0.020

        i2cset -y 0 $ram1addr 0x31 $red

        sleep 0.020

        i2cset -y 0 $ram1addr 0x32 $green

        sleep 0.020

        i2cset -y 0 $ram1addr 0x33 $blue

        sleep 0.020

        i2cset -y 0 $ram1addr 0x20 $bright

        sleep 0.020

        i2cset -y 0 $ram1addr 0x08 0x44


        # Configure second device

        i2cset -y 0 $ram2addr 0x08 0x53

        sleep 0.020

        i2cset -y 0 $ram2addr 0x09 0x00

        sleep 0.020

        i2cset -y 0 $ram2addr 0x31 $red

        sleep 0.020

        i2cset -y 0 $ram2addr 0x32 $green

        sleep 0.020

        i2cset -y 0 $ram2addr 0x33 $blue

        sleep 0.020

        i2cset -y 0 $ram2addr 0x20 $bright

        sleep 0.020

        i2cset -y 0 $ram2addr 0x08 0x44

    }


    # Color picker dialog

    color=$(zenity --color-selection --show-palette --title="Select Color" | sed 's/rgb(//;s/)//;s/,/ /g')
    status=$?

    if [ $status -eq 0 ]; then

        # Extract RGB values

        red=$(printf '%02X\n' $(echo $color | awk '{print $1}'))
        green=$(printf '%02X\n' $(echo $color | awk '{print $2}'))
        blue=$(printf '%02X\n' $(echo $color | awk '{print $3}'))

    else

        echo "Color selection cancelled."
        exit 1

    fi


    # Brightness slider (max 100)

    bright=$(zenity --scale --text="Select Brightness" --min-value=0 --max-value=100 --value=50 --step 1)
    status=$?

    if [ $status -eq 0 ]; then

        # Check brightness limit

        if [ $bright -gt 100 ]; then

            echo "Brightness exceeds maximum limit of 0x64."

            exit 1

        fi

        bright_hex=$(printf '%02X\n' $bright)

        set_color "0x$red" "0x$green" "0x$blue" "0x$bright_hex"

    else

        echo "Brightness selection cancelled."

        exit 1

    fi

fi
