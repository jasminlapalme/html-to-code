html_to_code.rb
============

Minimize html and css included code into a static c array. This piece of code is useful to include html code directly into program. It has a special feature to create an Arduino friendly array to include html code into the program memory (`prog_mem`).

You must use my own version of `html_compressor` (https://github.com/jasminlapalme/html_compressor).

##Usage
    html_to_code.rb [options] file
      -c, --cars_per_line N            Number of characters to write on one line
      -n, --name NAME                  name of the array
      -a, --arduino                    Create an arduino friendly array (PROGMEM)
      -o, --output FILE                Write the output to FILE
      -h, --help                       Display this screen

##Example
    ruby html_to_code.rb --name config_mini_html -a -c 20 < config.html > config_mini_html.h

This create a static char array with the content `config.html` minimized into the header file `config_mini_html.h`. The name of the array is `config_mini_html` and due to the `-a` option it create a PROGMEM char array for Arduino.

