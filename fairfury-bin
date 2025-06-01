#!/bin/bash

# Script para autenticação e execução dos comandos como root
if [ $(id -u) -ne 0 ]; then
    pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "$0" "auth" "$@"
    exit $?
fi

# Verifica se o primeiro argumento é "auth" para continuar a execução
if [ "$1" == "auth" ]; then
    shift # Remove o primeiro argumento ("auth")

    # Carrega os módulos de kernel necessários
    modprobe i2c-dev
    modprobe i2c-piix4

    ram1addr=0x58
    ram2addr=0x59

    # Função para enviar as cores e o brilho para os dispositivos via I2C
    set_color() {
        local red=$1
        local green=$2
        local blue=$3
        local bright=$4

        echo "Setting static R=$red G=$green B=$blue Brightness=$bright"

        # Comandos para configurar o primeiro dispositivo
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

        # Comandos para configurar o segundo dispositivo
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

    # Diálogo para selecionar a cor
    color=$(zenity --color-selection --show-palette --title="Selecione a Cor" | sed 's/rgb(//;s/)//;s/,/ /g')
    status=$?
    if [ $status -eq 0 ]; then
        # Extrai os valores de vermelho, verde e azul do resultado
        red=$(printf '%02X\n' $(echo $color | awk '{print $1}'))
        green=$(printf '%02X\n' $(echo $color | awk '{print $2}'))
        blue=$(printf '%02X\n' $(echo $color | awk '{print $3}'))
    else
        echo "Seleção de cor cancelada."
        exit 1
    fi

    # Diálogo para selecionar o brilho com limite máximo de 0x64 (100 em decimal)
    bright=$(zenity --scale --text="Selecione o Brilho" --min-value=0 --max-value=100 --value=50 --step 1)
    status=$?
    if [ $status -eq 0 ]; then
        # Verifica se o brilho está dentro do limite máximo permitido
        if [ $bright -gt 100 ]; then
            echo "O valor do brilho excede o limite máximo de 0x64."
            exit 1
        fi
        bright_hex=$(printf '%02X\n' $bright)
        set_color "0x$red" "0x$green" "0x$blue" "0x$bright_hex"
    else
        echo "Seleção de brilho cancelada."
        exit 1
    fi
fi
