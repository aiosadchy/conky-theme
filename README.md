# conky-theme
A simple text-only conky configuration

## Installation

### Prerequisites

Theme requires conky with Lua support and additional Lua packages: 
* `lua-cjson 2.1.0`
* `luasocket`

For **Ubuntu** installation paste the following commands into terminal:
```
sudo apt update;
sudo apt instal lua5.1
sudo apt install luarocks
sudo luarocks install lua-cjson 2.1.0
sudo luarocks install luasocket
```

### Configuration

To see proper weather information, register a free API-key at
[openweathermap.org](https://openweathermap.org/) and paste it into
`openweathermap-api-key` file.

Change device and interface names in `*.conkyrc` files for your needs.

### Run

To display all the widgets, execute `start.sh` or add it to your startup scripts.

Script contains multiple `sleep` commands so don't worry if you can not see the widgets immediately.

## Screenshots

![Screenshot](screenshots/desktop.png)

