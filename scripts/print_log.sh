#! /bin/bash

stdin=$(</dev/stdin)
log_file_command="$(echo $stdin | grep -oP 'nix log /nix/store(.*)0.drv')"

eval $log_file_command
