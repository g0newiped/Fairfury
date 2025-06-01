
# FairFury 🌈

A bash script to control RGB lighting on Kingston FURY RAM modules via I2C interface.

## Features
- GUI color picker using Zenity
- Brightness control (0-100)
- Supports dual RAM modules
- Automatic root authentication
- Tested on DDR4 Kingston FURY RAM
- **Currently supports only fixed color mode** (no animations or effects yet)

## Requirements

- Linux system with I2C support
- `i2c-tools` package
- `zenity` for GUI dialogs
- `pkexec` for root authentication

## Installation

1. Install dependencies:
```bash
sudo apt-get install i2c-tools zenity
```

2. Make the script executable:
```bash
chmod +x fairfury.sh
```

## Usage

Simply run the script:
```bash
./fairfury.sh
```

The script will:
1. Request root permissions automatically
2. Load necessary kernel modules
3. Show a color picker dialog
4. Show a brightness slider
5. Apply the selected color and brightness to both RAM modules

## Technical Details

- Default I2C addresses: `0x58` and `0x59` for Kingston DDR4 RAM modules
- Requires `i2c-dev` and `i2c-piix4` kernel modules
- **Why the 20ms delays?** I2C is a relatively slow protocol, and RAM modules need a bit of time to process each command. These small delays ensure reliable communication and prevent commands from being lost or ignored. Think of it like giving the RAM a moment to "digest" each instruction! 😊

## Compatibility

- **Tested on**: Kingston DDR4 RAM modules
- **May work on**: Other Kingston RAM models by modifying the I2C addresses in the script

To use with different RAM modules, edit these lines in the script:
```bash
ram1addr=0x58  # Change to your RAM's I2C address
ram2addr=0x59  # Change to your RAM's I2C address
```

## Finding Your RAM's I2C Address

To discover your RAM modules' I2C addresses:
```bash
sudo i2cdetect -y 0
```

## 🤝 Contributing

Got it working with your RAM? Awesome! Please help others by sharing your setup:

1. **Open an issue** with:
   - Your RAM model (e.g., Kingston FURY Beast DDR4)
   - The I2C addresses that worked for you
   - Any modifications you made

2. **Submit a PR** if you've added support for new RAM models or improved the script!

Your contributions help make FairFury better for everyone. Every RAM model we support is one less proprietary software someone needs to install! 💪

## Troubleshooting

If the script doesn't work:
- Ensure I2C is enabled in your system
- Check if your Kingston RAM modules support RGB control via I2C
- Verify the I2C addresses match your hardware using `i2cdetect`
- Make sure you have the correct permissions

## ☕ Support This Project

If FairFury helped you avoid proprietary software and made your RGB dreams come true on Linux, consider buying me a coffee!

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?business=HCVH7CV47XQTU&no_recurring=0&currency_code=BRL)

Crypto donations:

    BTC: bc1qsd895wxf4yd8cfxh7e6dvz5wsj04kuwe8eh67j
    TON: UQD3cU_D1uJMKCcWDPWisysc8P4ZKbNWvmlm6hCgiM6BNjsI

Every donation helps keep this project alive and motivates more open-source RGB tools! 🚀

## License: MIT

## Disclaimer

This tool is not affiliated with Kingston Technology. Use at your own risk.

## 📬 Feedback

Found a bug? Have a suggestion? Feel free to open an issue! 🐧✨
