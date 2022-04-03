# conky-theme
A simple text-only conky configuration

## Installation

### Prerequisites

This theme requires [conky](https://github.com/brndnmtthws/conky)
with [Lua](https://www.lua.org/) support and [curl](https://curl.se/)
(to fetch weather data, location and public ip).

You can install font by either executing `install.sh` or by manualy
installing it any way you prefer.

### Configuration

To enable weather forecasts, register a free API-key at
[openweathermap.org](https://openweathermap.org/) and paste it into
`WEATHER_OPENWEATHERMAP_API_KEY` in `configuration.env` file.

You can also specify your primary network interface
and an URL to fetch public IP address from as a variables in `configuration.env`.

### Run

To display all the widgets, run `start.sh` or add it to your startup scripts.

Script first executes `sleep` command to make sure that everything is initialized
before widgets appear, so don't worry if you don't see the widgets immediately.
This delay can be controlled with an optional argument, so you can run it as follows:

`start.sh <time in>`

## Screenshots

![Screenshot](screenshots/desktop.png)

